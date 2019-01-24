class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!
  require 'time_ago_in_words'

  def add_comment
    comment = Comment.new(user_id: params[:user_id], blog_id: params[:id], message: params[:message], parent_id: params[:parent_id])
    comment.save
    @comments = Blog.find(params[:id]).comments
    render partial: 'blogs/comments'
  end

  def comment_like_unlike
    commentAction = CommentAction.where(user_id: current_user.id, comment_id: params[:id]).first
    like = params[:comment_action]
    if commentAction.present?
      if (like.to_s == commentAction.like.to_s)
        commentAction.destroy
      else
        commentAction.update_attributes(like: like)
      end
    else
      CommentAction.create(user_id: current_user.id, comment_id: params[:id], like: like)
    end
    render json: {success: true}
  end

end
