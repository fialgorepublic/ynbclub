class WarrantiesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @warranties = Warranty.group('date(created_at)').count
  end

  def show
    @warranties = Warranty.where('Date(created_at) = ?', params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Invoice No. #{@warranties.first}",
        page_size: 'A4',
        template: "warranties/show.html.erb",
        layout: "pdf.html",
        orientation: "Landscape",
        lowquality: true,
        zoom: 1,
        dpi: 75
      end
    end
  end

  def new
    @warranty = Warranty.new
  end

  def create
    ProductWarrantiesJob.perform_later(params[:no_of_warranties].to_i)
    redirect_to warranties_path, notice: 'warranties are creating.'
  end


  def update_product
    @warranty = Warranty.find_by(number:params["number"])
    if @warranty.present?
      @warranty.update_attributes(warranty_params.merge(expiry_date: params["warranty"]["start_date"].to_date + params["warranty"]["valid_for_years"].to_i.year))
    end
  end

  def search_warranty
    @warranties    = Warranty.get_warranties(params[:q])

    respond_to do |format|
      format.html {}
      format.json {
        @warranties  = @warranties.limit(5)
      }
    end
  end

  private

  def warranty_params
    params.require(:warranty).permit(:item_id, :assigned, :valid_for_years, :start_date)
  end
end
