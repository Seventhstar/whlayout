json.array!(@search_sites) do |search_site|
  json.extract! search_site, :id, :name
  json.url search_site_url(search_site, format: :json)
end
