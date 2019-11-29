class FollowsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    user  = User.find(params[:id])
    @users = \
      if params[:type] == 'followers'
        user.followers
      else
        user.followings
      end
  end

  def follow
    Follow.find_or_create_by(follower_id: current_user.id, following_id: params[:id])
  end

  def unfollow
    Follow.find_by(follower_id: current_user.id, following_id: params[:id]).destroy
  end
end
