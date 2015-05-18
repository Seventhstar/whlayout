json.array!(@whouses) do |whouse|
  json.extract! whouse, :id, :name
  json.url whouse_url(whouse, format: :json)
end
