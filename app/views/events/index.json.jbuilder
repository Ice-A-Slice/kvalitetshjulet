json.array!(@events) do |event|
  json.extract! event, :id, :title, :comment, :datetime, :user_id, :school_id, :file
  json.url event_url(event, format: :json)
end
