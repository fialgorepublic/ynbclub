module DashboardHelper
  def point_name point
    share_url = ShareUrl.find_by(id: point.share_url_id)
    case point.point_type_id
      when 6
        return point.invitee
      when 3
        return share_url.present? ? "Shared Blog '#{share_url.blog_title}' on #{share_url.url_type.titleize}" : point.name
      when 1
        return if share_url.blank?
        return share_url.url_type.present? ? "Shared Post from #{share_url.url_type.titleize}" : point.name
      else
        point.name
      end
  end

  def current_user_points user
    user.points.count
  end
end
