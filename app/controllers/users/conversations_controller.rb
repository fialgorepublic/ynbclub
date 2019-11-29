class Users::ConversationsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @your_conversations, @liked_conversations =\
      if params[:type] == 'both'
        [@user.post_conversations(params[:sort]).paginate(page: params[:your_conversations_page], per_page: 3), @user.liked_conversations(params[:sort]).paginate(page: params[:liked_conversations_page], per_page: 3)]
      elsif params[:type] == 'your-conversations'
        [@user.post_conversations(params[:sort]).paginate(page: params[:your_conversations_page], per_page: 3), []]
      elsif params[:type] == 'liked-conversations'
        [[], @user.liked_conversations(params[:sort]).paginate(page: params[:liked_conversations_page], per_page: 3)]
      end
  end
end
