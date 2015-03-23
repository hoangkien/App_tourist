json.array!(@tours) do |tour|
  json.extract! tour, :id, :name, :number_of_member, :information
  json.url tour_url(tour, format: :json)
end
