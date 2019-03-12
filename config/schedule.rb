every 1.days, at: '11:00 pm' do
  runner "UpdateOrderStatusJob.perform_now"
end
