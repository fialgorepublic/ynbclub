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

  def active_language(language)
    current_language = params[:locale] || I18n.default_locale.to_s
    'active' if current_language == language
  end

  def compare_payment
    Setting.first ? Setting.first.min_payment : 0
  end

  def insert_points(user_id, point_id, invitee="", share_url_id=nil, order_id="")
    point_type = PointType.find_by_id(point_id)
    return if point_type.blank? && point_type.zero_points?

    Point.create(
      user_id: user_id,
      point_type_id: point_type.id,
      point_value: point_type.point,
      invitee: invitee,
      share_url_id: share_url_id,
      order_id: order_id
    )
  end

  def get_point(id)
    PointType.find_by_id(id).point
  end

  def get_status status
    case status
      when "-1"
        "Cancel order"
      when "1"
        "Not received"
      when "2"
        "Received"
      when "3"
        "Merchandise / Warehoused"
      when "4"
        "Coordinated delivery / Delivering"
      when "5"
        "Delivered / Uncontrolled"
      when "6"
        "Checked"
      when "7"
        "Can not get the goods"
      when "8"
        "Delayed taking the goods"
      when "9"
        "Not delivered"
      when "10"
        "Delay delivery"
      when "11"
        "Controlled repayment of goods"
      when "12"
        "Coordinated loading / unloading"
      when "20"
        "Returned goods (COD carrying goods to pay)"
      when "21"
        "Returned goods (COD paid)"
      when "123"
        "Shipper reportedly took the goods"
      when "127"
        "Shipper can not pick up the item"
      when "128"
        "Shipper reportedly took the goods"
      when "45"
        "Shipper reportedly delivered"
      when "49"
        "	Shipper not delivered delivery"
      when "410"
        "Shipper Report Delay Delivery"
    end
  end

  def buyer
    Role.find_by_name("Buyer")
  end

  def ambassador
    Role.find_by_name("Brand ambassador")
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

  def active_class path
    "active" if current_page?(path)
  end

  def active_class_deduct_point params
    "active" if params[:deduct_points].present?
  end

  def active_class_ban_user params
    "active" if action_name == "all_users" && !params[:deduct_points].present?
  end

  def dashboard_class
    return 'snapshot-dashboard-holder' if action_name == "edit" && controller_name == "take_snapshot"
    return 'ambassador-dashboard' if blog_resource?
    ''
  end

  def blog_resource?
    (action_name == "edit" || action_name == "new") && controller_name == "blogs"
  end

  def blog_screen_size
    current_user.present? ? 'col-md-9' : 'col-md-12'
  end

  def add_container
    current_user.present? ? 'container-fluid' : 'container'
  end

  def format_created_at(created_at)
    created_at_date = created_at.to_date
    created_at_time = created_at.to_time

    return created_at_time.strftime("%H:%M %P") if  created_at_date == Date.today
    return created_at_time.strftime("yesterday %H:%M %P") if created_at_date == Date.yesterday

    created_at_time.strftime("%b %d, %H:%M %P")
  end
end
