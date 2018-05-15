class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.role.blank?
      @role_selection = true
    end
  end

  def update_user_role
    current_user.update_attributes(role_id: params[:role_id])
    flash[:notice] = "Successfully updated role"
    if current_user.role.name == "Buyer"
      buyer = "true"
    else
      buyer = "false"
    end
    render json: {success: true, :buyer => buyer}
  end

end
