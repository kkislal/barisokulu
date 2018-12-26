json.extract! event, :id, :user_id, :event_category_id, :event_type_id, :title, :content, :status, :comment_count, :view_count, :start_date, :end_date, :event_time, :created_at, :updated_at
json.url event_url(event, format: :json)
