class BlogMailer < ApplicationMailer
  default from: 'info.ynbclub@gmail.com'

  def rejected(blog, reject_reason)
    attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/images/email-logo.png")
    @user = blog.user
    @blog = blog
    @reject_reason = reject_reason

    mail(to: @user.email, subject: "Blog Rejected")
  end
end
