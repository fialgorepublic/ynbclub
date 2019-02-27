desc "Insert States"

task import_states: :environment do
  csv_text = File.read(Dir.glob("#{Rails.root}/states.csv").first)
  csv = CSV.parse(csv_text, headers: false) do |row|
    State.create(id: row[0], name: row[1])
  end
end
