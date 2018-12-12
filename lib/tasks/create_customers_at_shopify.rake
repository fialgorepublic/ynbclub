desc "Create customers at shopify"

task create_customers_at_shopify: :environment do
  customer_files = Dir.glob("#{Rails.root}/db/customers/**")
  @session = ShopifyAPI::Session.new("saintlbeau.myshopify.com", "65f08aa2bc5386c55298ed566ad18ccd")
  ShopifyAPI::Base.activate_session(@session)

  customer_files.each do |file_path|
    puts "Importting Users from File-------------#{file_path}"
    begin
      role = Role.find_by_name("Buyer")
      CSV.parse(File.read(file_path), headers: true).each do |row|
        password = (1..1000000).to_a.sample.to_s
        first_name, last_name, email, phone_number, address_line_1, address_line_2, city, state, country, zip = row[0], row[1], row[2], row[15], row[4], row[5], row[10], row[8], row[12], row[14]
        country = ISO3166::Country.new("VN")
        phone_number = Phony.normalize(phone_number)

        phone_number = "+#{country.country_code}#{phone_number}" unless phone_number.starts_with?(country.country_code)
        if User.find_by_email(row[2]).blank?
          user = User.create(name: [first_name, last_name].join(' '), email: email, phone_number: phone_number, password: password, role: role, referral: Devise.friendly_token,
                            is_shopify_user: row[20].present? ? row[20] == "No" ? false : true : false)
          user.create_profile
          user.profile.update(first_name: first_name, surname: last_name, phone_number: user.phone_number, address_line_1: address_line_1, address_line_2: address_line_2, 
                              city: city, state: state, zip_code: zip)

          customer = ShopifyAPI::Customer.new({ first_name: first_name, last_name: last_name, email: email, note: row[20], tag: row[19], orders_count: row[18], phone: phone_number,
                                  total_spent: row[17], addresses: [{ address1: address_line_1, address2: address_line_2, city: city, province: state,
                                  zip: zip, first_name: first_name, last_name: last_name, country: country.unofficial_names[0], phone: phone_number }] })

          response = customer.save

          puts "Unable to create the customer on shopify" unless response
          puts "Successfull created customer on beta and shopify."
        else
          puts "User with email: #{email} already exists."
        end
      end
    rescue => ex
      puts "Unable to create customer: #{ex}"
    end
  end
  ShopifyAPI::Base.clear_session
end
