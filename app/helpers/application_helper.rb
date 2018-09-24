module ApplicationHelper
  def link_to_login_with(provider, url, html_options = {})
    add_default_class(html_options)
    convert_popup_attributes(html_options)

    link_to t('.login_with_link', provider: provider), url, html_options
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def ambassador_role_id
    Role.find_by_name("Brand ambassador").id
  end

  def get_class user_id, comment_id
    comment = CommentAction.where(user_id: user_id, comment_id: comment_id).first
    if comment.present?
      comment.like ? 'cLiked' : ''
    end
  end
  def get_class_for_dislike user_id, comment_id
    comment = CommentAction.where(user_id: user_id, comment_id: comment_id).first
    if comment.present?
      comment.like ? '' : 'cLiked'
    end
  end
  def get_class_for_disabled user_id, comment_id
    comment = CommentAction.where(user_id: user_id, comment_id: comment_id).first
    if comment.present?
      action = comment.like ? 'disabled' : ''
    else
      return ""
    end
  end
  def get_class_for_disabled_comment user_id, comment_id
    comment = CommentAction.where(user_id: user_id, comment_id: comment_id).first
    if comment.present?
      action = comment.like ? '' : 'disabled'
    else
      return ""
    end
  end

  def compare_payment
    Setting.first ? Setting.first.min_payment : 0
  end

  private

  def add_default_class(html_options)
    default_class = "js-popup"

    if html_options.has_key?(:class)
      html_options[:class] << " " << default_class
    else
      html_options[:class] = default_class
    end
  end

  def convert_popup_attributes(html_options)
    width = html_options.delete(:width)
    height = html_options.delete(:height)

    if width && height
      html_options[:data] ||= {}
      html_options[:data].merge!({width: width, height: height})
    end
  end
end
