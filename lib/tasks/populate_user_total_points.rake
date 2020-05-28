desc "populate total_points column in users table"

task populate_total_points: :environment do
  User.find_each do |user|
    begin
      points = user.points ? user.points.sum(:point_value) : 0
      user.update!(total_points: points)

      puts "Updated points for user: #{user.email} to\t #{user.total_points}."
    rescue => ex
      "Unable to update points for user: #{user.email}."
    end
  end
end
