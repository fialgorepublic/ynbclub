class UsersController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!, except: [:find_user_by_email, :find_user, :show]
  before_action :authorize_user!, except: [:find_user_by_email, :find_user, :show]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :ban]
  skip_before_action :check_role, only: [:find_user_by_email, :find_user, :add_user_info, :show, :ban]

  require 'csv'
  require 'roo'

  def index
    @activeStatus = params[:payment].present? && params[:payment] != "All" ? params[:payment] : "All"

    @users = User.includes(:profile).search_ambassadors(params).paginate(page: params[:page], per_page: 500)
  end

  def clear_search
    @users = User.includes(:profile).where(role_id: ambassador_role_id).paginate(page: params[:page], per_page: 500).order(created_at: :desc)
  end

  def show
    @your_groups   = @user.admin_groups.paginate(page: params[:your_page], per_page: 6)
    @joined_groups = @user.groups.paginate(page: params[:joined_page], per_page: 6)
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    @user.referral = Devise.friendly_token
    respond_to do |format|
      if @user.save
        @user.create_profile(phone_number: @user.phone_number)
        format.html { redirect_to users_path, notice: I18n.t(:user_create_success) }
        format.json { render :index, status: :created, location: @user }
      else
        flash[:alert] = @user.errors.full_messages.first
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(params[:user][:password].present? ? user_params : edit_user_params)
        format.html { redirect_to users_path, notice: I18n.t(:user_update_success) }
        format.json { render :index, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: I18n.t(:user_destroy_success) }
      format.json { head :no_content }
    end
  end

  def update_share_link_count
    current_user.update_attributes(share_link_count: current_user.share_link_count + 1)
    respond_to do |format|
      format.js { head :ok }
    end
  end

  def brand_ambassadors
    @brand_ambassador = User.joins(:role).where("roles.name = 'Brand ambassador'")
  end

  def update_email
    @user = current_user
    message = nil
    if params[:current_email] == @user.email
      @user.email = params[:new_email]
      if @user.save
        flash[:notice] = I18n.t(:user_email_update)
        sign_out(@user)
        redirect_to root_path
      else
        message = @user.errors.full_messages
      end
    else
      message = I18n.t(:email_not_matched)
      redirect_to acc_settings_path(current_email: params[:current_email], new_email: params[:new_email]), alert: message
    end
  end

  def update_password
    @user = current_user
    if @user.valid_password?(params[:current_password])
      if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
        flash[:notice] = I18n.t(:password_update_success)
        sign_out(@user)
        redirect_to root_path
      else
        flash[:alert] = @user.errors.full_messages.first
        redirect_to acc_settings_path
      end
    else
      flash[:alert] = I18n.t(:password_mismatch)
      redirect_to acc_settings_path
    end
  end

  def change_activeStatus
    user = User.find(params[:id])
    user.update_attributes(is_activated: params[:value])
    respond_to do |format|
      format.js
      format.json { head :no_content }
    end
  end

  def user_show
    @user = User.find(params[:id])
  end

  def update_profile
    user = User.find(params[:user_id])
    params[:user][:password].present? ? user.update(user_params) : user.update(edit_user_params)
    user.profile.update(profile_params)
    redirect_to users_path, success: I18n.t(:profile_update)
  end

  def import_partner

  end

  def import_ambassador
    role_id = Role.find_by_name("Brand ambassador").id
    password = Devise.friendly_token
    file = params[:file]
    spreadsheet = Roo::Spreadsheet.open(file.path)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      user = User.create(name: row["Họ và tên"], email: row["Email"], phone_number: row["Số điện thoại"],
                         referral: row["Mã giới thiệu"], commission: row["Chiết khấu (%)"], identity_card: row["Chứng minh nhân dân"],
                         surplus: row["Số dư"], paid: row["Đã chi trả"], total_income: row["Tổng thu nhập"],
                         status: row["Trạng thái"], password: password, role_id: role_id)
      Profile.create(address_line_1: row["Địa chỉ"], phone_number: row["Số điện thoại"], user_id: user.id,
                     bank_name: row["Tên ngân hàng"], acc_holder_name: row["Tên tài khoản"], account_number: row["Số tài khoản"])
    end
    flash[:notice] = "Successfully Imported ."
    redirect_to import_partner_path
  end

  def add_user_info
    @user = User.find(params[:user][:id])
    if @user.update(user_update_params)
      @user.profile.update(user_update_params[:profile_attributes])
      flash[:notice] = I18n.t(:partner_info_success)
      redirect_to dashboard_path
    else
      @error_messages =[]
      @user.errors.full_messages.map { |msg|      # Show Error messages while sign_up user
        @error_messages << msg
      }
      flash[:alert] = @error_messages
      redirect_to dashboard_path(user_update_params)
    end
  end

  def points
    user = params[:user_id].present? ? User.find(params[:user_id]) : current_user
    @points = user.points.includes(:share_url).order(created_at: :desc)
  end

  def find_user_by_email
    user = User.find_by_email(params[:email]) || find_user_from_shopify
    profile = set_profile(user)
    user_email = user.email if user.present?
    render json: { user: user_email, profile: profile}
  end

  def find_user
    user = User.find_by_email(params[:email])
    profile = user&.profile
    render json: { user: user, profile: profile }
  end

  def all_users
    filter_type = params[:filter_type].presence || ''
    users = filter_type == "filter" ? User.with_points : User.all_users(params)
    @users = users.includes(:points, :profile).paginate(page: params[:page])
  end

  def ban
    if @user.update_attributes(banned: params[:value])
      message = @user.banned ? I18n.t(:banned_user_message) : I18n.t(:resume_user_message)
    else
      message = I18n.t('general.error')
    end

    render json: { success: @user.valid?, message: message }
  end

  def deduct_points
    user = User.find_by_id(params[:id])
    return render json: { success: false, message: 'User not found' } if user.blank?

    if user.total_points < params[:point_value].to_i
      render json: { success: false, message: I18n.t(:invalid_points) }
    else
      point = user.points.create(point_value: (-1 * params[:point_value].to_i), invitee: "Admin Deducted #{params[:point_value]} points")
      user.add_points!(point.point_value) unless point.errors.any?
      render json: { success: true, message: I18n.t(:admin_update_points)}
    end
  end

  def exchange_coins
    @exchange_history = current_user.exchange_histories.paginate(page: params[:page])
  end

  def generate_discount_code
    return redirect_to exchange_coins_users_path(coins: params[:coins]), alert: I18n.t(:enough_coins_message)  if current_user.total_points < params[:coins].to_i
    initiate_shopify_session
    success, message = ShopifyService.new(current_user, params[:coins]).call
    if success
      flash[:notice] = I18n.t(:exchange_success)
    else
      flash[:alert] = I18n.t(:exchange_error)
    end
    url_params = { coins: params[:coins] } unless success

    redirect_to exchange_coins_users_path(url_params)
  end

  def share_link_count
    @q = User.includes(:profile).ransack(params[:q])
    @users = @q.result(distinct: true).paginate(page: params[:page])
  end

  def earnings
    @points = current_user.last_four_points
    user_role = current_user.is_ambassador? ? 'ambassador' : 'buyer'
    render "#{user_role}_earnings"
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role_id, :referral,
                                 :commission, :social_login, :phone_number, :shop_no, :money)
  end

  def edit_user_params
    params.require(:user).permit(:name, :email, :role_id, :referral, :commission, :social_login, :phone_number,
                                 :shop_no, :money)
  end

  def profile_params
    params.require(:profile).permit(:first_name, :surname, :date_of_birth, :phone_number, :gender, :address_line_1, :address_line_2, :state, :city, :zip_code, :security_number, :account_number, :acc_holder_name, :bank_name)
  end

  def user_update_params
    params.require(:user).permit(:phone_number, profile_attributes: [:bank_name, :acc_holder_name, :account_number])
  end

  def find_user_from_shopify
    initiate_shopify_session
    customers = ShopifyAPI::Customer.search(query:"email:#{params[:email]}")
    customers.first
  end

  def set_profile(user)
    return nil if user.blank?
    return user.default_address if user.kind_of?(ShopifyAPI::Customer) && defined?(user.default_address)
    return user.profile unless user.kind_of?(ShopifyAPI::Customer)
    nil
  end
end
