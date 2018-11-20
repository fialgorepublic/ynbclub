class UsersController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: [:points, :add_user_info, :update_email, :update_password]
  require 'csv'
  require 'roo'

  def brand_ambassadors
    @brand_ambassador = User.joins(:role).where("roles.name = 'Brand ambassador'")
  end

  def update_email
    @user = current_user
    message = nil
    if params[:current_email] == @user.email
      @user.email = params[:new_email]
      if @user.save
        flash[:notice] = "Email successfully updated!. You need to login again to continue"
        sign_out(@user)
        redirect_to root_path
      else
        message = @user.errors.full_messages
      end
    else
      message = "Current email doesn't match with the profile you are currently logged in!"
      redirect_to acc_settings_path(current_email: params[:current_email], new_email: params[:new_email]), alert: message
    end
  end

  def update_password
    @user = current_user
    if @user.valid_password?(params[:current_password])
      if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
        flash[:notice] = "Password is updated!. You need to login again to continue"
        sign_out(@user)
        redirect_to root_path
      else
        flash[:alert] = @user.errors.full_messages.first
        redirect_to acc_settings_path
      end
    else
      flash[:alert] = "Current password doesn't match!"
      redirect_to acc_settings_path
    end
  end

  def index
    @activeStatus = params[:payment].present? && params[:payment] != "All" ? params[:payment] : "All"

    @users = User.search_ambassadors(params).paginate(page: params[:page])
  end

  def clear_search
    @users = User.where(role_id: ambassador_role_id).paginate(page: params[:page]).order(created_at: :desc)
  end

  def show
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
        format.html { redirect_to users_path, notice: 'User was successfully created.' }
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
        format.html { redirect_to users_path, notice: 'User was successfully updated.' }
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
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def change_activeStatus
    user = User.find(params[:id])
    user.update_attributes(is_activated: params[:value])
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'Active status Successfully changed.' }
      format.json { head :no_content }
    end
  end

  def user_show
    @user = User.find(params[:id])
  end

  def update_profile
    user = User.find(params[:user_id])
    params[:user][:password].present? ? user.update(user_params) : user.update(edit_user_params)

    user.create_profile if user.profile.blank?

    user.profile.update(profile_params)
    redirect_to users_path, success: "Successfully update"
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
      @user.profile.update(phone_number: @user.phone_number)
      flash[:notice] = "Partner information saved successfully"
      redirect_to dashboard_path
    else
      @error_messages =[]
      @user.errors.full_messages.map { |msg|      # Show Error messages while sign_up user
        @error_messages << msg
      }
      flash[:alert] = @error_messages[0]
      redirect_to dashboard_path
    end
  end

  def points
    @points = current_user.points.order(created_at: :desc)
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
    params.require(:user).permit(:phone_number, :email, profile_attributes: [:id, :bank_name, :acc_holder_name, :account_number, :_destroy])
  end

end
