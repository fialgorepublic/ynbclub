module SimpleDiscussion::ForumPostsHelper
  # Override this to use avatars from other places than Gravatar
  def avatar_tag(email)
    user = User.find_by_email(email)
    image = user.present? && user.avatar.attached? ? user.avatar.variant(combine_options: { resize: '60x60^', gravity: 'Center', extent: '60x60^', background: "grey", quality: 95 }) : 'user-img.png'
    image_tag image, class: "rounded"
  end

  def category_link(category)
    link_to category.name, simple_discussion.forum_category_forum_threads_path(category),
      style: "color: #{category.color}"
  end

  # Override this method to provide your own content formatting like Markdown
  def formatted_content(text)
    simple_format(text)
  end

  def forum_post_classes(forum_post)
    klasses = ["forum-post", "card", "mb-3"]
    klasses << "solved" if forum_post.solved?
    klasses << "original-poster" if forum_post.user == @forum_thread.user
    klasses
  end

  def forum_user_badge(user)
    if user.respond_to?(:moderator) && user.moderator?
      content_tag :span, "Mod", class: "badge badge-default"
    end
  end
end
