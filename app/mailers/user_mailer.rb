class UserMailer < ApplicationMailer
  default from: 'info.saintlbeau@gmail.com'

  def referral_sale(user, cust_name, shop_domain)
    @user = user
    @customer_name = cust_name
    @shop_domain = shop_domain
    mail(to: user.email, subject: 'Referral Sale Added from '+cust_name)
  end

  def user_sign_up(user)
    @user = user
    mail(to: user.email, subject: 'Welcome to SaintLBeau')
  end

  def send_discount_code(user)
    @user = user
    mail(to: user.email, subject: 'Discount Code for Free Shipping')
  end

  def referral_sign_up(user, referral)
    @user = user
    @referral = referral
    mail(to: user.email, subject: referral.name + ' has just registered at saintLBeau from your invite')
  end

  def reject_blog(blog)
    @user = blog.user
    @blog = blog
    mail(to: @user.email, subject: "Blog Rejected")
  end

end
