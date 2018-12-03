module ShareHelper
  def platform shared_url
    shared_url.url_type.present? ? shared_url.url_type.titleize : "---"
  end

  def shared_at shared_url
    if shared_url.created_at.to_date == Date.today
      "Today"
    elsif shared_url.created_at.to_date == Date.yesterday
      "yesterday"
    else
      shared_url.created_at.to_time.strftime("%b %d, %Y")
    end
  end
end
