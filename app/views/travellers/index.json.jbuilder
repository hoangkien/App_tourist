json.array!(@travellers) do |traveller|
  json.extract! traveller, :id, :name, :address, :phone, :device_id
  json.url traveller_url(traveller, format: :json)
end
