class UpdatePhoneNoStatusChannel < ApplicationCable::Channel
  def subscribed
   stream_from "update_status"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
