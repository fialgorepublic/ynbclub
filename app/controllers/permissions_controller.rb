class PermissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, except: [:index]

  def index
    users = params[:q].present? ? User.filter_users(params[:q]) : User.all
    @users = users.paginate(page: params[:page])
  end

  def show
    @permissions = @user.permissions
  end

  def create
    User.delete_user_permissions(@user.id) if params[:controllers].present?
    params[:controllers].each do |controller_name|
      @user.permissions.find_or_create_by(controller_name: controller_name)
    end
    flash[:success] = "Permission for #{@user.email} are updated successfully."
    render json: { success: true }
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
end
