class DashboardController < ApplicationController
  before_action :authenticate_user!
  require 'link_thumbnailer'
  include ApplicationHelper
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
      referral = Devise.friendly_token
      current_user.update_attributes(referral: referral)
      buyer = "false"
    end
    render json: {success: true, :buyer => buyer}
  end

  def change_profile_picture
    puts "----------------------------------",params.inspect
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
    @object = LinkThumbnailer.generate(params[:url])
    if @object.description.present? && @object.description.include?('#SaintLBeau')
      @saintlbeau_post = true
    elsif @object.description.include?('#SaintLBeau')
      @saintlbeau_post = true
    else
      @saintlbeau_post = false
    end
  end

  def step_three
    url = params[:url]
    if params[:saintlbeau_post].to_s == "true"
      insert_points(current_user.id, "Take and share a snapshot")
    end
    ShareUrl.create(url: url, user_id: current_user.id)
  end

end
