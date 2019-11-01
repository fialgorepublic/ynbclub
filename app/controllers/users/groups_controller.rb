class Users::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group

  def join
    current_user.joined_groups.find_or_create_by(group_id: params[:id])
  end

  def leave
    current_user.joined_groups.find_by(group_id: params[:id]).destroy
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end
end
