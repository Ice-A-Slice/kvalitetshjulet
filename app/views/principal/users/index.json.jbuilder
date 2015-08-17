json.array!(@users) do |principal|
  json.extract! user, :id, :name, :email, :user_type
  json.url user_url(user, format: :json)
end