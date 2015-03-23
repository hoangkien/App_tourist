json.array!(@users) do |user|
  json.extract! user, :id, :account, :password, :name, :address, :group, :comp_name
  json.url user_url(user, format: :json)
end
