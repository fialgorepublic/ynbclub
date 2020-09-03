class UserMailer < ApplicationMailer
  default from: 'info.ynbclub@gmail.com'

  def referral_sale(user, cust_name, shop_domain)
    attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/images/email-logo.png")
    @user = user
    @customer_name = cust_name
    @shop_domain = shop_domain
    mail(to: user.email, subject: 'Referral Sale Added from '+cust_name)
  end

  def user_sign_up(user)
    attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/images/email-logo.png")
    @user = user
    mail(to: user.email, subject: 'Welcome to YnbClub')
  end

  def send_discount_code(user)
    attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/images/email-logo.png")
    @user = user
    mail(to: user.email, subject: 'Discount Code for Free Shipping')
  end

  def referral_sign_up(user, referral)
    attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/images/email-logo.png")
    @user = user
    @referral = referral
    mail(to: user.email, subject: referral.name + ' has just registered at YnbClub from your invite')
  end
end
