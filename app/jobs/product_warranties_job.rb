class ProductWarrantiesJob < ApplicationJob
  queue_as :default
  require 'barby'
  require 'barby/barcode/code_128'
  require 'barby/outputter/png_outputter'

  def perform(warranty)

    warranty.times do
      number = SecureRandom.random_number(10**10).to_s
      barcode = Barby::Code128B.new(number)
      blob = Barby::PngOutputter.new(barcode).to_png
      image = Base64.encode64(blob.to_s).gsub(/\s+/, "")

      Warranty.create(number: number, barcode: image)
    end
  end
end
