class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :block_buyers

  def index
    set_up_ambassadors
    @source_type   = params[:source_type].present? ? params[:source_type] : 'CommissionHistory'
    notifications  = set_up_notifications
    @notifications = notifications.paginate(page: params[:page])
  end

  private

  def block_buyers
    if current_user.is_buyer?
      flash[:alert] = I18n.t(:blocked_buyer_message)
      redirect_to root_path and return
    end
  end

  def set_up_ambassadors
    @ambassadors = User.includes(:profile).ambassadors.map{|user| [user.name, user.id] }
  end

  def set_up_notifications
    notifications = \
              if current_user.is_admin?
                notifications = Notification.filter_by_source_type(@source_type)
                params[:partner_id].present? ? notifications.filter_by_target(params[:partner_id]) : notifications
              else
                current_user.notifications.filter_by_source_type(@source_type)
              end
  end
end
