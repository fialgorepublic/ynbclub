class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  # GET /payments
  # GET /payments.json
  def index
    if params[:text].present?
      @payments = Payment.where("(LOWER(payment_code) LIKE '%#{params[:text]}%' OR LOWER(email) LIKE '%#{params[:text]}%' OR LOWER(recipient_name) LIKE '%#{params[:text]}%')")
    else
      if params[:search].present?
        if (params[:search][:start_date].present? && params[:search][:end_date].present? && (params[:search][:partner].present? && params[:search][:partner] != "null"))
          date_range = (Date.parse(params[:search][:start_date])..Date.parse(params[:search][:end_date]))
          @payments = Payment.where("created_at::date IN (?) AND user_id = (?)", date_range, params[:search][:partner].split(','))
        elsif(params[:search][:start_date].present? && params[:search][:end_date].present?)
          date_range = (Date.parse(params[:search][:start_date])..Date.parse(params[:search][:end_date]))
          @payments = Payment.where("created_at::date IN (?)", date_range)
        elsif (params[:search][:partner].present?)
          @payments = Payment.where(user_id: params[:search][:partner].split(','))
        else
          @payments = Payment.all
        end
      else
        @payments = Payment.all
      end
    end
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)
    @payment.payment_code = rand(10...9999999)
    respond_to do |format|
      if @payment.save
        @payments = Payment.all
        format.html { redirect_to @payment, notice: 'Payment was successfully created.' }
        format.js {  flash.now[:notice] = "Payment was successfully created." }
      else
        @error_messages =[]
        @payment.errors.full_messages.map { |msg| # Show Error messages while creating new system
          @error_messages << msg
        }
        @payments = Payment.all
        format.html { render :new }
        format.js {  flash.now[:alert] = @error_messages[0] }
      end
    end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url, notice: 'Payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def add_payment
    @payments = Payment.all
    @payment = Payment.new
    render :json => { :success => true, :html => render_to_string(:partial => "payments/new_payment")}.to_json
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.require(:payment).permit(:payment_code, :payment_date, :amount, :recipient_name, :email, :number_math, :status, :note, :user_id)
    end
end
