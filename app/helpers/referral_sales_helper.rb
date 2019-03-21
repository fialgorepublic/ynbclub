module ReferralSalesHelper
  def user_commission(referral_sale)
    commission = referral_sale.user_commission.present? ? referral_sale.user_commission : 8.0
    ((referral_sale.price.to_f * commission.to_f)/100).to_i
  end
end
