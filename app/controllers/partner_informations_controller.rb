class PartnerInformationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!

  def add_partner_information
    @partner_information = PartnerInformation.new(partner_information_params)

    if @partner_information.save
      flash[:notice] = I18n.t(:partner_info_success)
      redirect_to dashboard_path
    else
      @error_messages =[]
      @partner_information.errors.full_messages.map { |msg|      # Show Error messages while sign_up user
        @error_messages << msg
      }
      flash[:alert] = @error_messages[0]
      redirect_to dashboard_path
    end

  end

  private

  def partner_information_params
    params.require(:partner_information).permit(:store_name, :phone_no, :address, :id_number, :bank_name, :account_number,
                                                :account_name)
  end
end
