json.array!(@tourguides) do |tourguide|
  json.extract! tourguide, :id, :name, :address, :phone, :device_id, :active
  json.url tourguide_url(tourguide, format: :json)
end
