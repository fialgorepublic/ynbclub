module ExchangeCoinHelper
  def format_amount_to_vnd amount
    formatted_value = number_to_currency amount, precision: 0, delimiter: '.'
    "#{formatted_value.remove('$')}₫"
  end
end
