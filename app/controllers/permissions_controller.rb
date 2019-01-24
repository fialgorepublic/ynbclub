class PermissionsController < ApplicationController
  before_action :authenticate_user!

  def index
    users = params[:q].present? ? User.filter_users(params[:q]) : User.all
    @users = users.paginate(page: params[:page])
  end
end
