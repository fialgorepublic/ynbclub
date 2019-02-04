module ExchangeCoinHelper
  def format_amount_to_vnd amount
    formatted_value = number_to_currency 100000, precision: 0, delimiter: '.'
    "#{formatted_value.remove('$')}₫"
  end
end
