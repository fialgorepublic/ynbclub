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

  def author_avatar(conversation)
    conversation.user_avatar.attached? ? conversation.user_avatar. variant(combine_options: { resize: "100x100", gravity: 'Center', background: "grey", quality: 95 }) : '/assets/user-icon.png'
  end

  def posted_date(conversation)
    if conversation.created_at.to_date == Date.today
      conversation.created_at.to_time.strftime("Today %H:%M %P")
    elsif conversation.created_at.to_date == Date.yesterday
      conversation.created_at.to_time.strftime("Yesterday %H:%M %P")
    else
      conversation.created_at.to_time.strftime('Posted at %d.%m.%y')
    end
  end

  def reply?
    controller_name == 'conversations' && action_name == 'reply'
  end

  def new_reply_link(conversation)
    link_to 'New Reply', reply_conversation_path(conversation), class: 'btn btn-primary new_reply_btn'
  end

  def conversation_sort_types
    [['Newest first', 1], ['Popular First', 2], ['A-Z', 3], ['Unanswered', 4]]
  end
end
