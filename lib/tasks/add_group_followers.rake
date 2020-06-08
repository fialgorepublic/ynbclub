namespace :groups do
  task add_followers: :environment do
    Group.find_each do |group|
      AddGroupFollowersJob.perform_now(group.id)
    end
  end
end
