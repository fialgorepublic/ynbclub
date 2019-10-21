module GroupsHelper
  def groups_page_title
    return "Edit Group" if action_name == 'edit' && controller_name == 'groups'
    'Create New Group'
  end

  def group_button_text
    return "EDIT" if action_name == 'edit' && controller_name == 'groups'
    'CREATE'
  end
end
