module UsersHelper
  def image_url user
    user.avatar.url == "/images/original/missing.png" ? "/assets/user-img-2.png" : user.avatar.url
  end

  def profile_pic_name user
    user.avatar.url == "/images/original/missing.png" ? "No file Chosen" : user.avatar_file_name
  end

  def show_if_already_searched search_text
    search_text.present? ? 'show' : 'hide'
  end

  def page_title deduct_points
    deduct_points.present? ? "Deduct Points" : "Ban Users"
  end

  def icon_class deduct_points
    deduct_points.present? ? "fa-minus-circle" : "fa-ban"
  end

  def table_id(params)
    params[:deduct_points].blank? ? 'ban_users_table' : 'deduct_points_table'
  end
end
