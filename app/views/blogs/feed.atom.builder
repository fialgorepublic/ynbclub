atom_feed do |feed|
  feed.title   "SaintLBeau Blogs"
  feed.updated @blogs.present? ? @blogs[0].updated_at : Time.now

  @blogs.each do |blog|
    feed.entry blog, published: blog.updated_at do |entry|
      entry.title   blog.title
      entry.content blog.description

      entry.author do |author|
        author.name blog.user_full_name.presence || blog.user_name.presence || blog.user_email
      end
    end
  end
end
