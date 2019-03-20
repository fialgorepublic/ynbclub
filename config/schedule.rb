every 1.days, at: '11:00 pm' do
  runner "p UpdateOrderStatusJob.perform_now", output: { error: 'update_status.log', standard: 'update_status_standard.log'}
end
