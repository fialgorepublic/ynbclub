class AddBlogViewsJob < ApplicationJob
  queue_as :default

  def perform(blog_id)
    blog = Blog.find_by(id: blog_id)
    return if blog.blank?

    views_to_add = rand 50..100

    blog_views = []
    (0...views_to_add).each do |count|
      blog_views << blog.blog_views.new
    end

    BlogView.import blog_views
    puts "Added blog views for blog: #{blog.id}: views: #{blog_views.length}"
  end
end
