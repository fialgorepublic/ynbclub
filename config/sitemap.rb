# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://ambassador.saintlbeau.com"
SitemapGenerator::Sitemap.compress = false

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/blogs'
  #
  add videos_path, priority: 0.6
  add users_path, priority: 0.7
  add groups_path, priority: 0.8
  add conversations_path, priority: 0.9
  add blogs_path, priority: 1, changefreq: 'daily'

  #
  # Add Blogs:
  Blog.where(is_published: true).find_each do |blog|
    add blog_path(blog), lastmod: blog.updated_at
  end

  User.all.each do |user|
    add user_path(user), lastmod: user.updated_at
  end

  Group.all.each do |group|
    add group_path(group), lastmod: group.updated_at
  end

  Conversation.all.each do |conversation|
    add conversation_path(conversation), lastmod: conversation.updated_at
  end
end
