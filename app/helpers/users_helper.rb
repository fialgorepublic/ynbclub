module UsersHelper
  def image_url user
    user.avatar.url == "/images/original/missing.png" ? "/assets/user-img-2.png" : user.avatar.url
  end
end
