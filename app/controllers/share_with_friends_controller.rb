class ShareWithFriendsController < ApplicationController
  before_action :authorize_user!
  before_action :set_share_with_friend

  def edit
  end

  def update
    if @share_with_friend.update(share_with_friends_params)
      redirect_to share_with_friends_path, notice: I18n.t(:changes_update_success)
    else
      flash[:alert] = @share_with_friend.errors.full_messages
      render :edit
    end
  end

  private
    def share_with_friends_params
      params.require(:share_with_friend).permit(:image, :reward_text, :earn_coins_text)
    end

    def set_share_with_friend
      @share_with_friend = ShareWithFriend.first
    end
end
