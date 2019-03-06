desc "Import Cities, districts, provinces and wards provided by GHTK."

task import_ghtk_locations: :environment do
  csv_text = File.read(Dir.glob("#{Rails.root}/db/ghtk_locations.csv").first)
  row_number = 0
  csv = CSV.parse(csv_text, headers: true) do |row|
    row_number += 1
    type = row['type'].to_i
    if type == 0
      city = City.find_or_create_by(name: row['name'])
    elsif type == 1
      district = District.find_by(name: row['dia_chi_cha'])
      if district.blank?
        province = Province.find_by(name: row['dia_chi_cha'])
        province.wards.find_or_create_by(name: row['name']) if province.present?
      else
        district.wards.find_or_create_by(name: row['name'])
      end
    elsif type == 3
      city = City.find_by(name: row['dia_chi_cha'])
      city.districts.find_or_create_by(name: row['name']) if city.present?
    elsif type == 7
      city = City.find_by(name: row['dia_chi_cha'])
      city.provinces.find_or_create_by(name: row['name']) if city.present?
    end

    puts "Row Number #{row_number} is imported Successfully."
  end
end
