json.extract! post, :id, :user_id, :blog_category_id, :title, :content, :status, :comment_count, :view_count, :created_at, :updated_at
json.url post_url(post, format: :json)
