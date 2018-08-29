json.extract! blog, :id, :title, :promote_post, :description, :category_id, :created_at, :updated_at
json.url blog_url(blog, format: :json)
