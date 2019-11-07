json.extract! conversation, :id, :subject, :body, :references, :references, :tags, :created_at, :updated_at
json.url conversation_url(conversation, format: :json)
