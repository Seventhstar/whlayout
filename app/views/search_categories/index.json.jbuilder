json.array!(@search_categories) do |search_category|
  json.extract! search_category, :id, :name
  json.url search_category_url(search_category, format: :json)
end
