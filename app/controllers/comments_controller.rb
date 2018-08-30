class CommentsController < ApplicationController
  before_action :authenticate_user!
  require 'time_ago_in_words'

  def add_comment
    comment = Comment.new(user_id: params[:user_id], blog_id: params[:id], message: params[:message])
    comment.save
    @comments = Blog.find(params[:id]).comments
    render partial: 'blogs/comments'
  end

end
