module UsersHelper
  def image_url user
    user.avatar.attached? ? user.avatar : "/assets/user-img-2.png"
  end

  def profile_pic_name user
    user.avatar.attached? ? user.avatar.filename : "No file Chosen"
  end

  def show_if_already_searched search_text
    search_text.present? ? 'show' : 'hide'
  end

  def page_title deduct_points
    deduct_points.present? ? I18n.t('all_users.deduct_label') : I18n.t('all_users.ban_label')
  end

  def icon_class deduct_points
    deduct_points.present? ? "fa-minus-circle" : "fa-ban"
  end

  def table_id(params)
    params[:deduct_points].blank? ? 'ban_users_table' : 'deduct_points_table'
  end

  def not_paid_amount(user)
    not_paid = user.total_income.to_i - user.paid.to_i
    return 0 if not_paid <= 0
    not_paid
  end

  def user_avatar(user)
    user.avatar.attached? ? user.avatar : '/assets/1user-icon.png'
  end

  def follow_button_text(user)
    return ['Unfollow', unfollow_follows_path(id: user.id, current_user_id: current_user.id)]  if current_user&.following?(user)
    return ['Follow Back', follow_follows_path(id: user.id, current_user_id: current_user.id)] if user.following?(current_user)
    ['Follow', follow_follows_path(id: user.id, current_user_id: current_user.id)]
  end

  def follow_unfollow_link(user)
    return if user == current_user
    if current_user.blank?
      link_to 'Follow', 'javascript:void(0);', data: { toggle: 'modal', target: '#signIn' }, class: 'btn profile-tag-btn-ad btn-default'
    else
      text, url = follow_button_text(user)
      link_to text, url, class: 'btn profile-tag-btn-ad  btn-default', remote: true, type: 'button'
    end
  end

  def follow_unfollow_link_blog(user)
    return if user == current_user
    if current_user.blank?
      link_to 'Follow', 'javascript:void(0);', data: { toggle: 'modal', target: '#signIn' }, class: 'btn btn-default follow-button', type: 'button'
    else
      text, url = follow_button_text(user)
      link_to text, url, class: 'btn btn-default follow-button profile-tag-btn-ad btn-default', remote: true, type: 'button'
    end
  end

  def social_links(link)
   if link.include?("https://")
    link
   else
    link.insert(0, "https://")
    link
   end
  end
end


