class OrderChannel < ApplicationCable::Channel
  def subscribed
    stream_from "orders"
  end

  def unsubscribed
    puts 'I am unsubscribed'
  end
end
