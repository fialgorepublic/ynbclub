class WarrantiesController < ApplicationController
  
  def index
  end 

  def check
    @item = Item.find_by(warranty_number: params[:warranty_number])
    if @item.present?
      initiate_shopify_session
      @product = ShopifyAPI::Product.find(:all, params: { title: @item.name }).first
      clear_shopify_session
    else
      redirect_to warranties_path, flash: { error: "product Not Found" }
    end
  end

  def update
    item = Item.find(params[:id])
    warrenty_year =  params[:year].to_i
    item.update(warranty_valid_for_years: warrenty_year, warranty_expiry_date: warrenty_year.years.from_now.end_of_day)
  end
end
