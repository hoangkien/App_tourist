json.array!(@devices) do |device|
  json.extract! device, :id, :name, :status, :lat, :lng
  json.url device_url(device, format: :json)
end
