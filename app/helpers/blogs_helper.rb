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

  def blog_description blog
    return if blog.description.blank?
    blog.description.truncate(1000).html_safe
  end

  def blog_title blog
    blog.title.truncate(40)
  end

  def blog_author_avatar(blog)
    blog.user.avatar.present? ? blog.user.avatar.url : 'user-img.png'
  end

  def blog_user_name(blog)
    blog.user_full_name.present? ? blog.user_full_name : blog.user_name
  end
end
