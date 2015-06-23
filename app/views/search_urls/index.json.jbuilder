json.array!(@search_urls) do |search_url|
  json.extract! search_url, :id, :url, :search_site_id, :search_category_id
  json.url search_url_url(search_url, format: :json)
end
