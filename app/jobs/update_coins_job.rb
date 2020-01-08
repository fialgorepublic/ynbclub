class UpdateCoinsJob < ApplicationJob
  queue_as :default

  def perform(earn_coin, lang)
    translate_to_main_text = GoogleTranslateService.new(earn_coin.main_text, earn_coin.how_spend_text, earn_coin.how_earn_text, earn_coin.earn_way )
    translated_text = translate_to_main_text.translate.translate earn_coin.main_text, earn_coin.how_spend_text, earn_coin.how_earn_text, earn_coin.earn_way, to: lang
    earn_coin.update(main_text: translated_text.first.text, how_spend_text: translated_text.second.text, how_earn_text: translated_text.third.text, earn_way: translated_text.fourth.text )
    puts "#{earn_coin.main_text}"
  end
end
