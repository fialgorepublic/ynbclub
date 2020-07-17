every 1.days, at: '11:00 pm' do
  runner "p UpdateOrderStatusJob.perform_now", output: { error: 'update_status.log', standard: 'update_status_standard.log'}
end

every :sunday, at: '5:00 am' do
  rake "-s sitemap:refresh"
end

every :day, at: '10pm' do
  rake "get_youtube_video:youtube_video", output: { error: 'youtube_task_error.log', standard: 'youtube_task.log' }
end

every :sunday, at: '12pm' do
  rake "log:clear LOGS=production", output: { error: 'log_delete_error.log', standard: 'log_delete.log'}
end
