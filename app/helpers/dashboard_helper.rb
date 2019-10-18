module DashboardHelper
  def point_name point
    share_url = ShareUrl.find_by(id: point.share_url_id)
    case point.point_type_id
      when 6
        point.invitee
      when 3
        share_url.present? ? "Shared Blog '#{share_url.blog_title}' on #{share_url.url_type.titleize}" : point.name
      when 1
        return if share_url.blank?
        share_url.url_type.present? ? "Shared Post from #{share_url.url_type.titleize}" : point.name
      when 2
        return "Your product was ordered (Mua sản phẩm)" if point.order_id.blank?
        "Your product was ordered #{point.order_id} (Mua sản phẩm)"
      else
        point.invitee
      end
  end

  def current_user_points user
    user.points.count
  end

  def thumbnail_image(video)
    data = video.snippet.data['thumbnails']['high']
    "<image src=#{data['url']} width=100%></image>".html_safe
  end
end
