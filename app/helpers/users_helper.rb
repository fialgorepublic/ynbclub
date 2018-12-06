module UsersHelper
  def image_url user
    user.avatar.url == "/images/original/missing.png" ? "/assets/user-img-2.png" : user.avatar.url
  end

  def profile_pic_name user
    user.avatar.url == "/images/original/missing.png" ? "No file Chosen" : user.avatar_file_name
  end
end
