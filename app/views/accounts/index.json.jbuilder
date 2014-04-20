json.array!(@accounts) do |account|
  json.extract! account, :id, :username, :corpus
  json.url account_url(account, format: :json)
end
