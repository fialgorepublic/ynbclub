class Users::GroupsController < ApplicationController
  before_action :authenticate_user!

  def join
    current_user.joined_groups.find_or_create_by(group_id: params[:id])
  end

  def leave
    joined_group = current_user.joined_groups.find_by(group_id: params[:id])
    joined_group.delete if joined_group
  end
end
