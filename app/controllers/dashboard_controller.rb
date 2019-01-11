class DashboardController < ApplicationController
  before_action :authenticate_user!
  require 'link_thumbnailer'
  include ApplicationHelper
  def index
    return redirect_to referral_sales_path if current_user.is_admin?

    return redirect_to buyerDashboard_path if current_user.is_buyer?

    @user = current_user
    @role_selection = true if current_user.role.blank?

    @profile = true if current_user.role.present? && !current_user.is_admin? && current_user.phone_number.blank?
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

  def step_one
    @shared_urls = current_user.share_urls.shared_media_urls
  end

  def step_two
    @url = params[:url].include?('www.facebook.com') ? params[:url].split('&').first : params[:url].split('?').first
    return redirect_to step_one_path, alert: "You already have added this post." if current_user.share_urls.find_by_url(@url).present?
    return redirect_to step_one_path, alert: "Someone has already added this post" if ShareUrl.find_by_url(@url).present?

    begin
      @object = LinkThumbnailer.generate(@url)

      redirect_to step_one_path, alert: "Invalid Url." if @object.images.blank?
      @saintlbeau_post = has_hashtag? @object
    rescue => ex
      redirect_to step_one_path, alert:  "Please Make sure Url is correct."
    end
  end

  def step_three
    url, @point_id, user_shared_urls = params[:url], 1, current_user.share_urls
    return redirect_to step_one_path if user_shared_urls.find_by_url(url).present?

    share_url = user_shared_urls.create(url: url)
    insert_points(current_user.id, 1, "", share_url.id) if params[:saintlbeau_post].to_s == "true"
  end

  def buyerDashboard
    @points = current_user.last_four_points
    @user = current_user
  end

  def share_with_friends
    get_share_with_friend
  end

  def page_design
    get_share_with_friend
  end

  private

    def get_share_with_friend
      @share_with_friends = ShareWithFriend.first || create_new
    end

    def create_new
      ShareWithFriend.create(reward_text: "You'll receive #{get_point(6)} coins on the saint l' Beau web site for every registered friend by your invitation link. your friend will receive #{get_point(6)}  coins too",
                            earn_coins_text: "How can I earn and spend coins?", fb_btn_text: "Share on facebook", twitter_btn_text: "Share on Twitter", email_btn_text: "Share on Mail")
    end

    def has_hashtag? object
      found = false
      found = object.title.include?("#saintlbeau") if object.title.present?
      found = object.description.include?("#saintlbeau") if object.description.present? && !found
      found
    end
end
