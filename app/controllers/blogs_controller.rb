class BlogsController < ApplicationController
  before_action :authenticate_user!, except: [:blog_detail]
  before_action :load_user_blog, except: [:blog_like_unlike, :index, :new, :create, :show, :change_featured_state, :share_blog, :blog_detail, :destroy, :change_publish_status]
  before_action :set_blog, only: [:show, :destroy, :change_featured_state, :change_publish_status]
  require 'time_ago_in_words'
  require 'will_paginate'
  include ApplicationHelper
  # GET /blogs
  # GET /blogs.json
  def index
    @blogs = current_user.filtered_blogs(params[:sort], params[:category]).paginate(page: params[:page], per_page: 10)
    @next_page = @blogs.next_page
    if request.xhr?
      with_format :html do
        @html_content = render_to_string partial: 'all_blogs'
      end
      render json: { attachmentPartial: @html_content, success: true, next_page: @next_page, total_pages: @blogs.total_pages, current_page: @blogs.current_page }
    end
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
    @comments = @blog.comments if @blog.is_published?
    @selected_products = @blog.products
    BlogView.create(user_id: current_user.id, blog_id: @blog.id)
  end

  # GET /blogs/new
  def new
    @blog = Blog.new
  end

  # GET /blogs/1/edit
  def edit
    selected_product_ids = @blog.products.pluck(:product_id)
    if selected_product_ids.present?
      initiate_shopify_session
      @selected_products = ShopifyAPI::Product.where(ids: selected_product_ids.join(','))
      clear_shopify_session
    end
  end

  # POST /blogs
  # POST /blogs.json
  def create
    @blog = current_user.blogs.new(blog_params)

    respond_to do |format|
      if @blog.save
        @blog.add_products(params[:product])
        format.html { redirect_to @blog, notice: 'Blog was successfully created.' }
        format.json { render :show, status: :created, location: @blog }
      else
        format.html { render :new }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blogs/1
  # PATCH/PUT /blogs/1.json
  def update
    respond_to do |format|
      if @blog.update(blog_params)
        @blog.update_products(params[:product])
        format.html { redirect_to @blog, notice: 'Blog was successfully updated.' }
        format.json { render :show, status: :ok, location: @blog }
      else
        format.html { render :edit }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.json
  def destroy
    @blog.destroy
    respond_to do |format|
      format.html { redirect_to blogs_url, notice: 'Blog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def blog_like_unlike
    if params[:value].to_s == "false"
      Like.create(user_id: current_user.id, blog_id: params[:id])
    else
      Like.where(user_id: current_user.id, blog_id: params[:id]).first.destroy
    end
    respond_to do |format|
      format.html { redirect_to '/blogs/'+params[:id] }
      format.json { head :no_content }
    end
  end

  def change_featured_state
    blog = @blog.update_attributes(is_featured: params[:value], feature_date: DateTime.now)
    render json: {success: true}
  end

  def change_publish_status

    unless @blog.is_published?
      return redirect_to @blog, alert: "You need to add picture before publishing your blog." unless @blog.avatar.present?
    end

    @blog.update_attributes(is_published: params[:status])
    redirect_to @blog
  end

  def change_buyer_show_statusgs
    blog = @blog.update_attributes(buyer_show: params[:status])
    redirect_to '/blogs/'+params[:id]
  end

  def buyer_show
    @comments = @blog.comments
    @selected_products = @blog.products
  end

  def blog_detail
    @blog = Blog.find_by_id(params[:id])
    return redirect_to root_path(blog_not_found: true) if @blog.blank?

    @comments = @blog.comments
    @selected_products = @blog.products
  end

  def share_blog
    share_url = ShareUrl.create(user_id: current_user.id, blog_id: params[:id], url_type: params[:value])
    insert_points(current_user.id, 3, "", share_url.id)
    redirect_to blogs_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def load_user_blog
      @blog = current_user.blogs.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_params
      params.require(:blog).permit(:title, :promote_post, :description, :category_id, :avatar)
    end

    def set_blog
      @blog = Blog.find(params[:id])
    end
end
