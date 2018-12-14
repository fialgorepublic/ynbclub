module BlogsHelper
  def file_name blog
    blog.avatar.url == "/images/original/missing.png" ? "No file Chosen" : blog.avatar_file_name
  end

  def blog_attributes blog
    { id: blog.id, title: blog.title, file_name: blog.avatar_file_name }.to_json
  end
end
