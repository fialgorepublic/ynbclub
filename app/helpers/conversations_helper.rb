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
      local_date(conversation.created_at, 'Today %I:%M %P')
    elsif conversation.created_at.to_date == Date.yesterday
      local_date(conversation.created_at, 'Yesterday %I:%M %P')
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

  def add_main_div_column
    current_user.present? ? 'col-md-6' : 'col-md-8'
  end

  def add_stats_column
    current_user.present? ? 'col-md-3' : 'col-md-4'
  end

  def like_dislike_path(conversation_like_exists, conversation_id)
    conversation_like_exists ? dislike_conversation_path(conversation_id) : like_conversation_path(conversation_id)
  end

  def like_dislike_link(conversation)
    if current_user.blank?
      link_to 'javascript:void(0);', data: { toggle: 'modal', target: '#signIn' } do
        "<i class='fa fa-thumbs-up' ></i>".html_safe
      end
    else
      conversation_like_exists = conversation.conversation_like_exists?(current_user.id)
      link_to like_dislike_path(conversation_like_exists, conversation.id), remote: true, class: 'like-dislike-convo click btn btn-default like-button', data: { conversation_id: conversation.id } do
        "<i class='fa fa-thumbs-up #{conversation_like_exists ? 'red-color' : ''}'></i><span id='like-dislike-id'>#{conversation_like_exists ? ' Unlike' : ' Like'}</span>".html_safe
      end
    end
  end

  def user_profile_link(user)
    link_to user_name(user), user, class: 'user-profile-link'
  end

  def conversation_attributes conversation
    { id: conversation.id, subject: conversation.subject, body: conversation.body }.to_json
  end

end
