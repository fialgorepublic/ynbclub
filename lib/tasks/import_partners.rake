desc "Import Partners"

task import_partners: :environment do
  role = Role.find_by_name("Brand ambassador")
  CSV.parse(File.read('./db/partners.csv'), headers: true).each do |row|
    is_activated = row[13] == "Đã kích hoạt"
    user = User.find_or_create_by(name: row[0], address: row[1], email: row[2], phone_number: row[3], referral: row[4], commision: row[5],
                          identity_card: row[6], surplus: row[10], paid: row[11], total_income: row[12], is_activated: is_activated, role: role)

    user.profile.find_or_create_by(phone_number: user.phone_number, address_line_1: user.address, account_number: row[9], acc_holder_name: row[8],
                                  bank_name: row[7])
  end
end

#Need to fix these
#first_name, #last_name, :address(city, state, zip_code), #password
