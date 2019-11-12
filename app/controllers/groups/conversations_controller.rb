class Groups::ConversationsController < ApplicationController
  def index
    @group = Group.find(params[:group_id])
    @conversations = @group.post_conversations.paginate(page: params[:page])
    @next_page     = @conversations.next_page
  end
end
