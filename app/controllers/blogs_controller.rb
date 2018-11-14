class BlogsController < ApplicationController
  before_action :authenticate_user!, except: [:blog_detail]
  before_action :set_blog, except: [:blog_like_unlike, :index, :new, :create, :show, :change_featured_state, :share_blog, :blog_detail]
  require 'time_ago_in_words'
  require 'will_paginate'
  include ApplicationHelper
  # GET /blogs
  # GET /blogs.json
  def index
    @blogs = current_user.filtered_blogs.paginate(page: params[:page], per_page: 10)
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
    @blog = Blog.find(params[:id])
    @comments = @blog.comments
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
    @blog = Blog.find(params[:id])
    blog = @blog.update_attributes(is_featured: params[:value], feature_date: DateTime.now)
    render json: {success: true}
  end

  def change_publish_status
    blog = @blog.update_attributes(is_published: params[:status])
    redirect_to '/blogs/'+params[:id]
  end

  def change_buyer_show_status
    blog = @blog.update_attributes(buyer_show: params[:status])
    redirect_to '/blogs/'+params[:id]
  end

  def buyer_show
    @comments = @blog.comments
    @selected_products = @blog.products
  end

  def blog_detail
    @blog = Blog.find(params[:id])
    @comments = @blog.comments
    @selected_products = @blog.products
  end

  def share_blog
    share_url = ShareUrl.create(user_id: current_user.id, blog_id: params[:id], url_type: params[:value])
    insert_points(current_user.id, 3, "", share_url.id)
    render json: {success: true}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = current_user.blogs.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_params
      params.require(:blog).permit(:title, :promote_post, :description, :category_id, :avatar)
    end
end
