module GroupsHelper
  def groups_page_title
    return "Edit Group" if action_name == 'edit' && controller_name == 'groups'
    'Create New Group'
  end

  def group_button_text
    return "EDIT" if action_name == 'edit' && controller_name == 'groups'
    'CREATE'
  end

  def group_banner_url page
    page.group_banner.attached? ? page.group_banner : "/assets/user-img-2.png"
  end

  def group_banner_name page
    page.group_banner.attached? ? page.group_banner.filename : "No file Chosen"
  end
end
