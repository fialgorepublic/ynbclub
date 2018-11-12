class DashboardController < ApplicationController
  before_action :authenticate_user!
  require 'link_thumbnailer'
  include ApplicationHelper
  def index
    if current_user.role.present? && current_user.is_buyer?
      redirect_to buyerDashboard_path
    else
      @user = current_user
      if current_user.role.blank?
        @role_selection = true
      end
      if current_user.role.present? && !current_user.is_admin? && current_user.phone_number.blank?
        @profile = true
      end
    end
  end

  def update_user_role
    current_user.update_attributes(role_id: params[:role_id])
    flash[:notice] = "Successfully updated role"
    if current_user.role.name == "Buyer"
      buyer = "true"
    else
      referral = Devise.friendly_token
      current_user.update_attributes(referral: referral)
      buyer = "false"
    end
    render json: {success: true, :buyer => buyer}
  end

  def change_profile_picture
    user = current_user.update(avatar: params[:user][:avatar])
    respond_to do |format|
      if user
        format.html { redirect_to root_path, notice: 'Successfully Updated user image' }
        format.js {  flash.now[:notice] = "Successfully Updated user image." }
      else
        @error_messages =[]
        user.errors.full_messages.map { |msg| # Show Error messages while creating new system
          @error_messages << msg
        }
        format.html { render :new }
        format.js {  flash.now[:alert] = @error_messages[0] }
      end
    end
  end

  def get_user_object
    @user = User.new
    render :partial => "shared/change_profile_Image"
  end

  def step_two
    return redirect_to step_one_path, alert: "You already have added this post." if ShareUrl.find_by(url: params[:url]).present?

    begin
      @object = LinkThumbnailer.generate(params[:url])

      @saintlbeau_post = @object.description.present? ? @object.description.include?("#saintlbeau") : false
    rescue => ex
      redirect_to step_one_path, alert:  "Please Make sure Url is correct."
    end
  end

  def step_three
    url = params[:url]
    if params[:saintlbeau_post].to_s == "true"
      insert_points(current_user.id, 1)
    end
    @point_id = 1
    ShareUrl.create(url: url, user_id: current_user.id)
  end

  def buyerDashboard
    @last_four_points = current_user.points.last(4)
  end
end
