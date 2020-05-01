every 1.days, at: '11:00 pm' do
  runner "p UpdateOrderStatusJob.perform_now", output: { error: 'update_status.log', standard: 'update_status_standard.log'}
end

every 1.day, :at => '5:00 am' do
  rake "-s sitemap:refresh"
end

every 7.days, :at => '5:00 pm' do
  rake "get_youtube_video:youtube_video", :output => {:error => 'task_reminder_error.log', :standard => 'task_reminder.log'}
end
