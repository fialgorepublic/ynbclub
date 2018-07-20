class SettingsController < ApplicationController
  before_action :authenticate_user!

  def set_commission
    user = User.find(params[:id])
    user.update_attributes(commission: params[:user][:commission])
  end

  def changed_account_approved_status
    id = params[:id]
    value = params[:value]
    ReferralSale.find(id).update_attributes(:is_approved => value )
    respond_to do |format|
      format.html { redirect_to approve_sales_url, notice: 'Approved status Successfully changed.' }
      format.json { head :no_content }
    end
  end

end
