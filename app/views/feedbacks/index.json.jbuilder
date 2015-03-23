json.array!(@feedbacks) do |feedback|
  json.extract! feedback, :id, :quantiy_service, :comment, :traveller_id
  json.url feedback_url(feedback, format: :json)
end
