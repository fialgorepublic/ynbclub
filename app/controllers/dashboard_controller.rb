class DashboardController < ApplicationController
  before_action :authenticate_user!, except: [:videos]
  before_action :authorize_user!, except: [:index ,:update_user_role, :videos]
  skip_before_action :check_role, only: [:index, :update_user_role]

  require 'link_thumbnailer'
  include ApplicationHelper

  def index
    @role_selection = true if current_user.role.blank?
    current_user.set_profile
    @profile = true if current_user.is_ambassador? && current_user.incomplete_profile?
    @your_groups   = current_user.admin_groups.paginate(page: params[:your_page], per_page: 6)
    @joined_groups = current_user.groups.paginate(page: params[:joined_page], per_page: 6)
  end

  def update_user_role
    current_user.update_attributes(role_id: params[:role_id])
    flash[:notice] = I18n.t(:update_role_success_label)
    if current_user.role.name == "Buyer"
      buyer = "true"
    else
      referral = Devise.friendly_token
      current_user.update_attributes(referral: referral, commission: 8.0, is_activated: true)
      buyer = "false"
    end
    render json: {success: true, :buyer => buyer}
  end

  def change_profile_picture
    user = current_user.update(avatar: params[:user][:avatar])
    respond_to do |format|
      if user
        format.html { redirect_to root_path, notice: I18n.t(:image_success_message) }
        format.js {  flash.now[:notice] = I18n.t(:image_success_message) }
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
    return redirect_to step_one_path, alert: I18n.t(:post_duplicate_sare) if current_user.share_urls.find_by_url(@url).present?
    return redirect_to step_one_path, alert: I18n.t(:post_shared_by_someone) if ShareUrl.find_by_url(@url).present?

    begin
      @object = LinkThumbnailer.generate(@url)

      redirect_to step_one_path, alert: I18n.t(:invalid_url) if @object.images.blank?
      @saintlbeau_post = has_hashtag? @object
    rescue => ex
      redirect_to step_one_path, alert: I18n.t(:url_make_sure)
    end
  end

  def step_three
    url, @point_id, user_shared_urls = params[:url], 1, current_user.share_urls
    return redirect_to step_one_path if user_shared_urls.find_by_url(url).present?

    share_url = user_shared_urls.create(url: url)
    insert_points(current_user.id, 1, "", share_url.id) if params[:saintlbeau_post].to_s == "true"
  end

  def share_with_friends
    get_share_with_friend
  end

  def page_design
    get_share_with_friend
  end

  def acc_settings
    city_name = current_user&.profile&.city
    state = City.find_by(name: city_name)&.state
    if state.present?
      @cities = City.where(state: state).pluck(:name, :name)
    else
      @cities = []
    end
  end

  def cities
    @cities = State.find_by_name(params[:state])&.cities.pluck(:name, :name)
  end

  def videos
    @videos = YoutubeService.get_channel_videos
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
