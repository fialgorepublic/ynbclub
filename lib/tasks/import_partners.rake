desc "Import Partners"

task import_partners: :environment do
  role = Role.find_by_name("Brand ambassador")
  CSV.parse(File.read('./db/partners.csv'), headers: true).each do |row|
    is_activated, status = row[13] == "Đã kích hoạt" ? [true, "active"] : [false, "inactive"]
    password = (1..1000000).to_a.sample.to_s
    if User.find_by_email(row[2]).blank?
      user = User.create(name: row[0], email: row[2], phone_number: row[3], referral: row[4], commission: row[5],
                            identity_card: row[6], surplus: row[10], paid: row[11], total_income: row[12], is_activated: is_activated,
                            role: role, password: password, status: status)
      user.create_profile
      user.profile.update(phone_number: user.phone_number, address_line_1: row[1], account_number: row[9], acc_holder_name: row[8],
                                    bank_name: row[7])
    end
  end
end

#Need to fix these
#first_name, #last_name, :address(city, state, zip_code), #password
