class ReferralSalesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_referral_sale, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /referral_sales
  # GET /referral_sales.json
  def index
    @referral_sales = ReferralSale.where(user_id: current_user.id).order(id: :desc)
  end

  # GET /referral_sales/1
  # GET /referral_sales/1.json
  def show
  end

  # GET /referral_sales/new
  def new
    @referral_sale = ReferralSale.new
  end

  # GET /referral_sales/1/edit
  def edit
  end

  # POST /referral_sales
  # POST /referral_sales.json
  def create
    @referral_sale = ReferralSale.new(referral_sale_params)

    respond_to do |format|
      if @referral_sale.save
        format.html { redirect_to @referral_sale, notice: 'Referral sale was successfully created.' }
        format.json { render :show, status: :created, location: @referral_sale }
      else
        format.html { render :new }
        format.json { render json: @referral_sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /referral_sales/1
  # PATCH/PUT /referral_sales/1.json
  def update
    respond_to do |format|
      if @referral_sale.update(referral_sale_params)
        format.html { redirect_to @referral_sale, notice: 'Referral sale was successfully updated.' }
        format.json { render :show, status: :ok, location: @referral_sale }
      else
        format.html { render :edit }
        format.json { render json: @referral_sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /referral_sales/1
  # DELETE /referral_sales/1.json
  def destroy
    @referral_sale.destroy
    respond_to do |format|
      format.html { redirect_to referral_sales_url, notice: 'Referral sale was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def approve_sales
    partner_ids = (params[:search].present? && params[:search][:partner] != "null") ? params[:search][:partner] : nil
    discount_status = (params[:search].present? && params[:search][:discountStatus] != "null") ? params[:search][:discountStatus] : ""
    if params[:search].present?
      if (params[:search][:start_date].present? && params[:search][:end_date].present? && partner_ids.present?)
        date_range = (Date.parse(params[:search][:start_date])..Date.parse(params[:search][:end_date]))
        @referral_sales = ReferralSale.where("created_at::date IN (?) AND user_id = (?)", date_range, partner_ids.split(','))
      elsif(params[:search][:start_date].present? && params[:search][:end_date].present?)
        date_range = (Date.parse(params[:search][:start_date])..Date.parse(params[:search][:end_date]))
        @referral_sales = ReferralSale.where("created_at::date IN (?)", date_range)
      elsif (partner_ids.present?)
        @referral_sales = ReferralSale.where(user_id: partner_ids.split(','))
      else
        @referral_sales = ReferralSale.all
      end
    else
      @referral_sales = ReferralSale.all
    end
    if (discount_status.present? && (discount_status.split(',').size == 1))
      @referral_sales = @referral_sales.where(is_approved: discount_status)
    end
    if (params[:payment].present? && params[:payment] != "null" && params[:payment].split(',').size == 1)
      @payment = params[:payment]
    end
  end

  def changed_sale_approved_status
    referralSales = ReferralSale.where(id: params[:ids].split(','))
    referralSales.each do |sale|
      sale.update_attributes(is_approved: true)
    end
    @referral_sales = ReferralSale.all
    render partial: 'referral_sales/table'
  end

  def upate_ghtk_status
    ghtk_order = params[:order]
    if ghtk_order.present?
      sale = ReferralSale.find_by_order_id(ghtk_order[:id])
      sale.update(ghtk_status: ghtk_order[:ghtk_status_id]) if sale.present?
    end
    render json: { success: true }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_referral_sale
      @referral_sale = ReferralSale.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def referral_sale_params
      params.require(:referral_sale).permit(:user_id, :order_id)
    end
end
