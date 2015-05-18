json.array!(@elements) do |element|
  json.extract! element, :id, :name
  json.url element_url(element, format: :json)
end
