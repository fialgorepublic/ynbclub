module DashboardHelper
  def point_name point
    case point.point_type_id
      when 6
        return point.invitee
      when 3
        share_url = ShareUrl.find_by(id: point.share_url_id)
        return "Shared Blog '#{share_url.blog_title}' on #{share_url.url_type.titleize}"
      else
        point.name
      end
  end
end
