module BlogsHelper
  def file_name blog
    blog.avatar.attached? ?  blog.avatar.filename : "No file Chosen"
  end

  def blog_attributes blog
    { id: blog.id, title: blog.title, file_name: rails_blob_url(blog.avatar) }.to_json
  end

  def blog_page_title
    action_name == "new" ? I18n.t('blogs.new.create_blog_title') : I18n.t('blogs.new.edit_blog_title')
  end

  def blog_date blog
    blog.created_at.strftime("%y.%m.%d")
  end

  def blog_description blog
    return if blog.description.blank?
    blog.description.html_safe
  end

  def blog_title blog
    blog.title.truncate(40)
  end

  def blog_author_avatar(blog)
    blog.user.avatar.attached? ? blog.user.avatar : 'user-img.png'
  end

  def blog_user_name(blog)
    blog.user_full_name.present? ? blog.user_full_name : blog.user_name
  end

  def liked_class(blog)
    return 'fa fa-heart liked' if current_user.present? && blog.likes.find_by_user_id(current_user.id)
    'fa fa-heart'
  end

  def blog_screen_size
    current_user.present? ? 'col-md-9' : 'col-md-12'
  end

  def render_row_class(blog_type)
    return 'pl-4' if blog_type == 'expanded'
    'row pl-5'
  end

  def render_padding_class(blog_type)
    return 'pl-0' if blog_type == 'expanded'
  end

  def render_blog_count_class(blog_type)
    return 'col-md-3' if blog_type == 'expanded'
    'col-md-2 text-right'
  end

  def add_container
    current_user.present? ? '' : 'container-fluid'
  end

  def render_image(blog)
    return 'https://beta.saintlbeau.com/blogPlaceholder.jpeg' unless blog.avatar.attached?
    blog.avatar.variant(combine_options: { resize: '800x400^', gravity: 'Center', extent: '1050x400^', background: "grey", quality: 95 })
  end

  def banner_url page
    page.blog_banner.attached? ? page.blog_banner : "/assets/user-img-2.png"
  end

  def banner_name page
    page.blog_banner.attached? ? page.blog_banner.filename : "No file Chosen"
  end

  def share_button_classes
    action_name == 'index' ? 'share-on-facebook' :  'share-on-facebook btn btn-primary'
  end

  def share_button_text
    action_name == 'index' ? '' :  I18n.t('blogs.share_on_facebook_label')
  end

  def banner_size
    current_user.present? ? '1000x350^' :  '1200x350^'
  end

  def product_image_size
    current_user.present? ? '180x130^' :  '270x200^'
  end
end
