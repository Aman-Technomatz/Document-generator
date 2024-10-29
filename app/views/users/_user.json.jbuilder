json.extract! user, :id, :name, :email, :position, :mobile_no, :created_at, :updated_at
json.url user_url(user, format: :json)
