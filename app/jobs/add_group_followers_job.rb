class AddGroupFollowersJob < ApplicationJob
  queue_as :default

  def perform(group_id)
    group = Group.find_by(id: group_id)
    return if group.blank?

    user_ids = User.order('id').ids

    (0...1000).each do |count|
      user_id = rand user_ids.first..user_ids.last
      group.joined_groups.find_or_create_by(user_id: user_id)
      puts "Group Followers: #{group.users_count}"
    end
  end
end
