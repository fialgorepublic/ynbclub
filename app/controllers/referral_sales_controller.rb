class ReferralSalesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_referral_sale, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /referral_sales
  # GET /referral_sales.json
  def index
    @referral_sales = ReferralSale.where(user_id: current_user.id).paginate(page: params[:page])
    @order_status = {}
    Order.where(order_id: @referral_sales.pluck(:order_id)).collect { |order| @order_status[order.order_id] = order.status }
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
        format.html { redirect_to @referral_sale, notice: I18n.t(:referral_sale_create_suces) }
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
        format.html { redirect_to @referral_sale, notice: I18n.t(:referral_sale_update_suces)}
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
      start_date = params["search"]["start_date"].to_date if params["search"]["start_date"]
      end_date = params["search"]["end_date"].to_date if params["search"]["end_date"]
      if (params[:search][:start_date].present? && params[:search][:end_date].present? && partner_ids.present?)
        referral_sales =  ReferralSale.date_filter_with_users(start_date, end_date, partner_ids.split(','))
      elsif(params[:search][:start_date].present? && params[:search][:end_date].present?)
        referral_sales = ReferralSale.date_filter(start_date..end_date)
      elsif (partner_ids.present?)
        referral_sales = ReferralSale.where(user_id: partner_ids.split(','))
      else
        referral_sales = ReferralSale.all
      end
    else
      referral_sales = ReferralSale.all
    end
    if (discount_status.present? && (discount_status.split(',').size == 1))
      referral_sales = referral_sales.where(is_approved: discount_status)
    end
    if (params[:payment].present? && params[:payment] != "null" && params[:payment].split(',').size == 1)
      @payment = params[:payment]
    end
    @referral_sales = referral_sales.includes(:user).paginate(page: params[:page])
    @order_status = {}
    Order.where(order_id: @referral_sales.pluck(:order_id)).collect { |order| @order_status[order.order_id] = order.status }
  end

  def changed_sale_approved_status
    referralSales = ReferralSale.where(id: params[:ids].split(','))
    referralSales.each do |sale|
      sale.update_attributes(is_approved: true)
    end
    @referral_sales = ReferralSale.all.paginate(page: params[:page])
    @order_status = {}
    Order.where(order_id: @referral_sales.pluck(:order_id)).collect { |order| @order_status[order.order_id] = order.status }
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
