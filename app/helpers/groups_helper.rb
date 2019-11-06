module GroupsHelper
  def groups_page_title
    return "Edit Group" if action_name == 'edit'
    'Create New Group'
  end

  def group_button_text
    return "Update" if action_name == 'edit'
    'CREATE'
  end

  def group_banner_url page
    page.group_banner.attached? ? page.group_banner : "/assets/user-img-2.png"
  end

  def group_banner_name page
    page.group_banner.attached? ? page.group_banner.filename : "No file Chosen"
  end

  def join_button_text(group_id)
    current_user.joined_group?(group_id) ? 'Leave Group' : 'Join Group'
  end

  def join_link_path(group_id)
    current_user.joined_group?(group_id) ? leave_user_group_path(current_user, group_id) : join_user_group_path(current_user, group_id)
  end

  def group_user_name(user)
    user.full_name.presence || user.name.presence || "SainLBeau User"
  end

  def user_joined_date(user)
    user.created_at.strftime('%d.%m.%y')
  end
end
