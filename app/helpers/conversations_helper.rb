module ConversationsHelper
  def conversation_banner_url page
    page.conversation_banner.attached? ? page.conversation_banner : "/assets/user-img-2.png"
  end

  def conversation_banner_name page
    page.conversation_banner.attached? ? page.conversation_banner.filename : "No file Chosen"
  end

  def groups
    Group.pluck(:name, :id)
  end

  def posted_date(conversation)
    conversation.created_at.strftime('%d.%m.%y')
  end

  def reply?
    controller_name == 'conversations' && action_name == 'reply'
  end
end
