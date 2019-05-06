task create_slugs_for_blogs: :environment do
  Blog.all.each do |blog|
    slug = blog.title.split(' ').join('-')
    blog.update(slug: slug)
  end
end
