class ReferralSalesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_referral_sale, only: [:show, :edit, :update, :destroy]

  # GET /referral_sales
  # GET /referral_sales.json
  def index
    @referral_sales = ReferralSale.where(user_id: current_user.id)
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
    if params[:search].present?
      if (params[:search][:start_date].present? && params[:search][:end_date].present? && (params[:search][:partner].present? && params[:search][:partner] != "null"))
        date_range = (Date.parse(params[:search][:start_date])..Date.parse(params[:search][:end_date]))
        @referral_sales = ReferralSale.where("created_at::date IN (?) AND user_id = (?)", date_range, params[:search][:partner].split(','))
      elsif(params[:search][:start_date].present? && params[:search][:end_date].present?)
        date_range = (Date.parse(params[:search][:start_date])..Date.parse(params[:search][:end_date]))
        @referral_sales = ReferralSale.where("created_at::date IN (?)", date_range)
      elsif (params[:search][:partner].present?)
        @referral_sales = ReferralSale.where(user_id: params[:search][:partner].split(','))
      else
        @referral_sales = ReferralSale.all
      end
    else
      @referral_sales = ReferralSale.all
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
