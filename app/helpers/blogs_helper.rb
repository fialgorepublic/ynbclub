module BlogsHelper
  def file_name blog
    blog.avatar.url == "/images/original/missing.png" ? "No file Chosen" : blog.avatar_file_name
  end
end
