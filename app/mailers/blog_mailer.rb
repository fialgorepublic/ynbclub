class BlogMailer < ApplicationMailer
  default from: 'info.saintlbeau@gmail.com'

  def rejected(blog)
    attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/images/email-logo.png")
    @user = blog.user
    @blog = blog

    mail(to: @user.email, subject: "Blog Rejected")
  end
end
