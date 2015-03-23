json.array!(@companies) do |company|
  json.extract! company, :id, :name, :address, :code
  json.url company_url(company, format: :json)
end
