json.array!(@layouts) do |layout|
  json.extract! layout, :id, :name
  json.url layout_url(layout, format: :json)
end
