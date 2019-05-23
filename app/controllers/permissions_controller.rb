class PermissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!
  before_action :set_user, except: [:index]

  def index
    users = params[:q].present? ? User.filter_users(params[:q]) : User.all
    @users = users.includes(:profile).paginate(page: params[:page])
  end

  def show
    @permissions = @user.permissions
  end

  def create
    @user.add_new_permissions(params[:controllers]) if params[:controllers].present?
    @user.delete_old_permissions(params[:old_permissions]) if params[:old_permissions].present?
    flash[:success] = "Permission for #{@user.email} are updated successfully."
    render json: { success: true }
  end

  private
    def set_user
      @user = User.includes(:profile).find(params[:id])
    end
end
