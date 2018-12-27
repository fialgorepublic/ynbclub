module BlogsHelper
  def file_name blog
    blog.avatar.url == "/images/original/missing.png" ? "No file Chosen" : blog.avatar_file_name
  end

  def blog_attributes blog
    { id: blog.id, title: blog.title, file_name: blog.avatar_file_name }.to_json
  end

  def page_title
    action_name == "new" ? "Create new blog post" : "Edit blog post"
  end

  def button_name blog
    blog.is_published? ? "Save" : "Save as draft"
  end

  def blog_date blog
    blog.created_at.strftime("%y.%m.%d")
  end
end
