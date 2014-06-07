json.array!(@game_owners) do |game_owner|
  json.extract! game_owner, :id, :email, :password, :game_id
  json.url game_owner_url(game_owner, format: :json)
end
