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
    @referral_sales = ReferralSale.all
  end

  def changed_sale_approved_status
    puts "===================================",params.inspect
    referralSales = ReferralSale.where(id: params[:ids].split(','))
    referralSales.update_all(is_approved: true)
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
