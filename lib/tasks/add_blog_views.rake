namespace :blogs do
  task add_views: :environment do
    Blog.published.latest.each do |blog|
      AddBlogViewsJob.perform_now(blog.id)
    end
  end
end
