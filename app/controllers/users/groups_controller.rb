class Users::GroupsController < ApplicationController
  before_action :authenticate_user!, expect: [:index]

  def index
    @user  = User.find(params[:user_id])
    groups = params[:type] == 'your-groups' ? @user.admin_groups : @user.groups
    groups = groups.sort_by_title(params[:sort_type]) if params[:sort_type].present?
    groups = groups.filter_by_categories(params[:category_ids]) if params[:category_ids].present?
    if params[:type] == 'your-groups'
      @your_groups = groups.paginate(page: params[:your_group_page], per_page: 6)
    else
      @joined_groups = groups.paginate(page: params[:joined_group_page], per_page: 6)
    end
  end

  def join
    current_user.joined_groups.find_or_create_by(group_id: params[:id])
  end

  def leave
    current_user.joined_groups.find_by(group_id: params[:id]).destroy
  end
end
