json.extract! document, :id, :title, :content, :user_id, :document_type, :remark, :created_at, :updated_at
json.url document_url(document, format: :json)
