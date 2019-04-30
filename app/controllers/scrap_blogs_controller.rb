class ScrapBlogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_blog, except: [:index]

  def index
    @next_page, @previous_page = 0, 0
    if params[:blog_name]
      page = params[:page].presence || 1
      blogs, @next_page, @previous_page = MediumBlogsService.new(params[:blog_name], page).get_blogs
    end
    @blogs = blogs.presence || []
  end

  def translate_and_edit
    translate_to_vi = GoogleTranslateService.new(@blog.description).translate_text
    @blog.update(description: translate_to_vi)
    redirect_to edit_blog_path(@blog)
  end

  def destroy
    @blog_id = params[:id]
    @blog.destroy

    respond_to do |format|
      format.js
    end
  end

  private

  def set_blog
    @blog = Blog.find(params[:id])
  end
end
