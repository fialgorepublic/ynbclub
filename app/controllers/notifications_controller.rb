class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @source_type = 'CommissionHistory'
    notifications = current_user.is_admin? ? Notification.where(source_type: @source_type) : current_user.notifications.where(source_type: @source_type)
    @notifications = notifications.paginate(page: params[:page])
  end
end
