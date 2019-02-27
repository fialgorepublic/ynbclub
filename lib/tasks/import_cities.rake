desc "Insert Cities"

task import_cities: :environment do
  csv_text = File.read(Dir.glob("#{Rails.root}/cities.csv").first)
  csv = CSV.parse(csv_text, headers: false) do |row|
    City.create(name: row[0], state_id: row[1])
  end
end
