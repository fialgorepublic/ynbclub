class BlogMailer < ApplicationMailer
  default from: 'info.saintlbeau@gmail.com'

  def rejected(blog)
    @user = blog.user
    @blog = blog

    mail(to: @user.email, subject: "Blog Rejected")
  end
end
