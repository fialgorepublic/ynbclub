class Users::BlogsController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    @your_blogs, @liked_blogs =\
      if params[:type] == 'both'
        [@user.user_blogs(params[:sort], params[:category]).paginate(page: params[:your_blogs_page], per_page: 5), @user.liked_blogs(params[:sort], params[:category]).paginate(page: params[:liked_blogs_page], per_page: 5)]
      elsif params[:type] == 'your-blogs'
        [@user.user_blogs(params[:sort], params[:category]).paginate(page: params[:your_blogs_page], per_page: 5), []]
      elsif params[:type] == 'liked-blogs'
        [[], @user.liked_blogs(params[:sort], params[:category]).paginate(page: params[:liked_blogs_page], per_page: 5)]
      end
  end
end
