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
    @points = current_user.last_four_points
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

      redirect_to step_one_path, alert: "Invalid Url." if @object.images.blank?

      @saintlbeau_post = @object.description.present? ? @object.description.include?("#saintlbeau") : false
    rescue => ex
      redirect_to step_one_path, alert:  "Please Make sure Url is correct."
    end
  end

  def step_three
    url = params[:url]
    @point_id = 1

    share_url = ShareUrl.create(url: url, user_id: current_user.id)

    insert_points(current_user.id, 1, "", share_url.id) if params[:saintlbeau_post].to_s == "true"
  end

  def buyerDashboard
    @points = current_user.last_four_points
    @user = current_user
  end

  def share_with_friends
    @share_with_friends = ShareWithFriend.first || create_new
  end

  private
    def create_new
      ShareWithFriend.create(reward_text: "You'll receive #{get_point(6)} coins on the saint l' Beau web site for every registered friend by your invitation link. your friend will receive #{get_point(6)}  coins too",
                            earn_coins_text: "How can I earn and spend coins?", fb_btn_text: "Share on facebook", twitter_btn_text: "Share on Twitter", email_btn_text: "Share on Mail")
    end
end
