class UsersController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def brand_ambassadors
    @brand_ambassador = User.joins(:role).where("roles.name = 'Brand ambassador'")
  end

  def update_email
    @user = current_user
    if params[:current_email] == @user.email
      @user.email = params[:new_email]
      if @user.save
        flash[:notice] = "Email successfully updated!"
        redirect_to acc_settings_path
      else
        flash[:alert] = @user.errors.full_messages
        redirect_to acc_settings_path
      end
    else
      flash[:alert] = "Current email doesn't match with the profile you are currently logged in!"
      redirect_to acc_settings_path
    end
  end

  def update_password
    @user = current_user
    if @user.valid_password?(params[:current_password])
      if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
        flash[:notice] = "Password successfully updated!"
        redirect_to acc_settings_path
      else
        flash[:alert] = @user.errors.full_messages
        redirect_to acc_settings_path
      end
    else
      flash[:alert] = "Current password doesn't match!"
      redirect_to acc_settings_path
    end
  end

  def index
    if (params[:active].present? && params[:active] != "All")
      @users = User.where(role_id: ambassador_role_id, is_activated: params[:active])
    else
      @users = User.where(role_id: ambassador_role_id)
    end
    if (params[:payment].present? && params[:payment] != "All")
      @activeStatus = params[:payment]
    else
      @activeStatus = "All"
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.referral = Devise.friendly_token
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'User was successfully created.' }
        format.json { render :index, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
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

  # DELETE /users/1
  # DELETE /users/1.json
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

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role_id, :referral,
                                 :commission, :social_login, :phone_number, :shop_no, :money)
  end

  def edit_user_params
    params.require(:user).permit(:name, :email, :role_id, :referral, :commission, :social_login, :phone_number,
                                 :shop_no, :money)
  end

end
