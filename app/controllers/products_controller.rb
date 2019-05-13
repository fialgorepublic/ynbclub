class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!
  require 'time_ago_in_words'

  def get_products_from_shopify
    @blog = Blog.find_by_id(params[:id])
    initiate_shopify_session
    @products = ShopifyAPI::Product.all
    clear_shopify_session
    render partial: 'blogs/products'
  end

  def get_selected_products
    initiate_shopify_session
    @selected_products = ShopifyAPI::Product.where(ids: params[:ids])
    clear_shopify_session
    render partial: 'blogs/selected_products'
  end

  def search_products
    initiate_shopify_session
    @products = ShopifyAPI::Product.find(:all, params: { title: params[:q] })
    clear_shopify_session
  end
end
