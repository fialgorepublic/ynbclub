if Role.first.blank?
  Role.create(name: "Buyer")
  Role.create(name: "Brand ambassador")
  role = Role.create(name: "Admin")
  User.create(name: "Admin", email: 'admin@saintlbeau.com', password: 'admin123', role_id: role.id)
end

user = User.find_by(role_id: Role.find_by(name: "Admin").id)

user.create_profile if user.profile.blank?

earn_coin = EarnCoin.first || EarnCoin.create(main_text: "Earn coins and exchange them to discount", how_earn_text: "How can you earn coins?",
                                             how_spend_text: "How can you spend coins?", earn_way: "You'll be able to exchange coins during the product order",
                                             coins: "100", price: "10")

if PointType.first.blank?
  PointType.create(id: 1, name: "Take and share a snapshot (Chụp ảnh review)", point: 20, earn_coin: earn_coin)
  PointType.create(id: 2, name: "Your product was ordered (Mua sản phẩm)", point: 10, earn_coin: earn_coin)
  PointType.create(id: 3, name: "Post the blog (Ghi bài Blog)", point: 10, earn_coin: earn_coin)
  PointType.create(id: 4, name: "Invited user spent 500k (Bạn bè mời tiêu hơn 500k)", point: 20, earn_coin: earn_coin)
  PointType.create(id: 5, name: "Order product in the blog post (Mua từ blog)", point: 15, earn_coin: earn_coin)
  PointType.create(id: 6, name: "Invite user to the Saint l'beau (Mời bạn bè gia nhập tạo tài khoản với SLB)", point: 5, earn_coin: earn_coin)
end

if Setting.first.blank?
  Setting.create(min_payment: 200, cookie_time: 60)
end