class BlogsController < ApplicationController
  before_action :authenticate_user!, except: [:blog_detail, :index, :show, :share_blog, :feed, :show_blog]
  before_action :load_user_blog, only: [:edit, :update, :change_buyer_show_statusgs, :buyer_show]
  before_action :set_blog, only: [:show, :destroy, :change_featured_state, :change_publish_status, :show_blog, :delete_rejected, :reject]
  before_action :set_videos, only: [:index]
  before_action :set_blog_by_id, only: [:blog_like_unlike]

  include ApplicationHelper
  require 'open-uri'

  # GET /blogs
  # GET /blogs.json
  def index
    if params[:blog_show].present?
      current_user.blog_show = params[:blog_show]
      current_user.save(validate: false)
      redirect_to blogs_path
    end

    scope = \
      if current_user.present?
        current_user.is_admin? ? Blog.valid_blogs : Blog.published_and_drafted_blogs(current_user.id)
      else
        Blog.published
      end
    sort_by = params[:sort_by].presence || 0

    @q = scope.ransack(params[:q])
    @blogs = @q.result(distinct: true)
               .eager_load_objects
               .sorted_by(sort_by)
               .paginate(page: params[:page], per_page: 10)

    @next_page = @blogs.next_page

    respond_to do |format|
      format.html
      format.js
    end
  end

  def list
    per_page = params[:per_page].present? ? params[:per_page] : 25
    blogs = current_user.filtered_blogs(params[:sort], params[:category])
    @blogs = blogs.paginate(page: params[:page], per_page: per_page)
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
    # @comments = @blog.comments if @blog.is_published?
    # @selected_products = @blog.products
    # @blog.blog_views.create

    respond_to do |format|
      format.html { redirect_to blogs_path(id: @blog.id) }
      format.js
    end
  end

  def show_blog
    @comments = @blog.comments if @blog.is_published?
    @selected_products = @blog.products
    @blog.blog_views.create

    @belong_to_user = current_user.present? && @blog.user == current_user
  end

  # GET /blogs/new
  def new
    if current_user.is_admin? || !current_user.exceed_blogs_limit?
      @blog = Blog.new
      @blog.attach_default_image
      @category = Category.new
    end

    respond_to do |format|
      format.js
      format.html { redirect_to blogs_path(new: '') }
    end
   end

  # GET /blogs/1/edit
  def edit
    if @blog.present?
      @category = Category.new
      selected_product_ids = @blog.products.pluck(:product_id)
      if selected_product_ids.present?
        initiate_shopify_session
        @selected_products = ShopifyAPI::Product.where(ids: selected_product_ids.join(','))
        clear_shopify_session
      end
      if params[:edit_blog].present?
        render partial: 'blogs/new_form'
      else
        redirect_to blogs_path(blog_id: @blog.id)
      end
    else
      redirect_to blogs_path
      flash[:notice] = "blogs with this name is not available"
    end
  end

  # POST /blogs
  # POST /blogs.json
  def create
    @blog = current_user.blogs.new(blog_params)
    if params[:avatar].present?
      downloaded_image = open(params[:avatar])
      @blog.avatar.attach(io: downloaded_image  , filename: "foo.jpg")
    end
    respond_to do |format|
      if @blog.save
        @blog.attach_default_image unless @blog.avatar.attached?
        @blog.add_products(params[:product])
        AddBlogViewsJob.perform_now(@blog.id)
        format.html { redirect_to @blog, notice: I18n.t('blogs.controller.create_blog_success') }
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
      if @blog.update(blog_params.merge({user: current_user}))
        @blog.update_products(params[:product])
        format.html { redirect_to @blog, notice: I18n.t('blogs.controller.updated_blog') }
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
      format.html { redirect_to blogs_url, notice: I18n.t('blogs.controller.destroy_blog_success') }
      format.json { head :no_content }
    end
  end

  def blog_like_unlike
    like = @blog.likes.find_by(user_id: current_user.id)

    if like.blank? && params[:liked] == 'false'
      current_user.likes.create(blog_id: @blog.id)
    else
      like&.destroy
    end

    render json: { like_count: @blog.likes.length }
  end

  def change_featured_state
    blog = @blog.update_attributes(is_featured: params[:value], feature_date: DateTime.now)
    render json: {success: true}
  end

  def change_publish_status
    @message, @success =
      if !@blog.is_published? && @blog.default_image?
        ['You need to change default picture before publishing your blog.', false]
      else
        if params[:status] == 'true'
          if @blog.description.scan(/img-fluid/).length < 3
            ['Blog required minimun three image to publish.', false]
          else
            @blog.publish!
            @blog.award_coins!
            ["Successfully #{(I18n.t(:publish_label)).downcase}ed the blog.", true]
          end
        else
          @blog.unpublish!
          ["Successfully #{(I18n.t(:unpublish_label)).downcase}ed the blog.", true]
        end
      end

    respond_to do |format|
      format.js
      format.json { render json: { success: @success , message: @message }  }
    end
  end

  def delete_rejected
    @blog.destroy
    BlogMailer.rejected(@blog, params[:reject_reason]).deliver_later
  end

  def search_unsplash_images
    @page = params[:page].to_i
    @search_image = params[:q]
    @images = UnsplashService.new(name: @search_image, page: @page).fetch_image
  end

  def reject
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
    @blog = Blog.eager_load_objects.find_by_id(params[:id])
    return redirect_to root_path(blog_not_found: true) if @blog.blank?

    @comments = @blog.comments
    @selected_products = @blog.products
  end

  def share_blog
    share_url = ShareUrl.create(user_id: current_user&.id, blog_id: params[:id], url_type: params[:value])

    if current_user.present?
      point_type = PointType.find_by(name: 'Share blog on facebook')&.id
      point = insert_points(current_user.id, point_type, "Shared Blog on Facebook", share_url.id)
      current_user.add_points!(point.point_value) unless point.errors.any?
    end

    redirect_to blogs_path
  end

  def feed
    @blogs = Blog.first_three_latest_blogs
  end

  def banner
    @page.update(blog_banner: params[:page][:blog_banner])
    redirect_to blogs_path
  end

  def create_or_update_cateogry
    if category_params[:id].present?
      category = Category.find_by(id: category_params[:id])
      @success = category.update(category_params)
    else
      category = Category.new(category_params)
      @success = category.save
    end

    respond_to do |format|
      format.js
    end
  end

  def shared
    render json: { shared: current_user.already_shared_blog?(params[:blog_id], 'facebook') }
  end

  def exceed_limit
    render json: { limit_exceeded: current_user.blog_sharing_limit_exceed?('facebook') }
  end

  def new_wizard
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def load_user_blog
      if params[:translate_edit].present? && params[:translate_edit] == 'true'
        set_blog
      else
        @blog = current_user.blogs.friendly.find(params[:id]) rescue ''
      end
    end

    def set_blog_by_id
      @blog = Blog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_params
      params.require(:blog).permit(:title, :promote_post, :description, :category_id, :avatar)
    end

    def set_blog
      @blog = Blog.friendly.find(params[:id].split("&")[0]) rescue ''
    end

    def category_params
      params.require(:category).permit(:id, :name)
    end

    def set_videos
      @videos ||= YoutubeVideo.with_attached_thumbnail.all
    end
end
