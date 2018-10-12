# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if Role.first.blank?
  Role.create(name: "Buyer")
  Role.create(name: "Brand ambassador")
  role = Role.create(name: "Admin")
  User.create(name: "Admin", email: 'admin@saintlbeau.com', password: 'admin123', role_id: role.id)
end
if PointType.first.blank?
  PointType.create(name: "Post the blog", point: 10)
  PointType.create(name: "Take and share a snapshot", point: 5)
  PointType.create(name: "Order product in the blog post", point: 15)
  PointType.create(name: "Invite user to the Soint l beou", point: 20)
  PointType.create(name: "Invited user spent $50", point: 15)
  PointType.create(name: "Your product was ordered ", point: 15)
end

if Setting.first.blank?
  Setting.create(min_payment: 200, cookie_time: 60)
end