json.array!(@games) do |game|
  json.extract! game, :id, :game_key, :secret_key, :name, :image, :description
  json.url game_url(game, format: :json)
end
