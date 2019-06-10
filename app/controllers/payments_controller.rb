class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  # GET /payments
  # GET /payments.json
  def index
    if params[:text].present?
      @payments = Payment.joins(:user).where("(CAST(payment_code AS TEXT) LIKE '%#{params[:text]}%' OR LOWER(users.email) LIKE '%#{params[:text].downcase}%' OR LOWER(users.name) LIKE '%#{params[:text].downcase}%')")
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
    @payments = @payments.includes(:user).order(created_at: :desc).paginate(page: params[:page])
  end

  def clear_search
    @payments = Payment.all.order(created_at: :desc)
  end

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)
    @payment.payment_code = rand(10...9999999)
    respond_to do |format|
      if @payment.save
        @payments = Payment.all
        format.html { redirect_to @payment, notice: I18n.t(:payment_created_success) }
        format.js {  flash.now[:notice] = I18n.t(:payment_created_success) }
      else
        @payments = Payment.all
        format.html { render :new }
        format.js {  flash.now[:alert] = "Got error" }
      end
    end
  end

  def add_payment
    @payments = Payment.all
    @payment = Payment.new
    render :json => { :success => true, :html => render_to_string(:partial => "payments/new_payment")}.to_json
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.require(:payment).permit(:payment_code, :payment_date, :amount, :recipient_name, :email, :number_math, :status, :note, :user_id)
    end
end
