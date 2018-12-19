module SidebarHelper
  def get_points point_id
    PointType.find(point_id).point
  end
end
