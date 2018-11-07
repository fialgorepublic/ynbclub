module DashboardHelper
  def point_name point
    point.point_type_id == 6 ? point.invitee : point.name
  end
end
