task move_province_to_district: :environment do
  Province.all.each do |province|
    city = province.city
    p 'province name', province.name
    district = city.districts.find_or_create_by(name: province.name)
    p 'district', district
    wards = province.wards.update_all(district_id: district.id)
    p wards
  end
end
