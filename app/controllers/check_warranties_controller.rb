class CheckWarrantiesController < ApplicationController
  before_action :authenticate_user!
  
  def index
  end 

  def check
    @warranty = ProductWarranty.find_by(warranty_number:  params[:warranty_number])
    if @warranty && @warranty.item.present?
      @item = Item.find(@warranty.item.id)
      initiate_shopify_session
      @product = ShopifyAPI::Product.find(:all, params: { title: @item.name }).first
      redirect_to check_warranties_path, alert: 'production not found' if @product.nil?
      clear_shopify_session
    else
      redirect_to check_warranties_path, alert: 'production not found'
    end
  end
end
