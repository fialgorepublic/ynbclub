class Groups::ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @group = Group.find(params[:group_id])
    @conversations = @group.post_conversations.paginate(page: params[:page], per_page: 10)
    @next_page     = @conversations.next_page
  end
end
