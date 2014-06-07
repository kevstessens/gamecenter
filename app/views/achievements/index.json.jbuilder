json.array!(@achievements) do |achievement|
  json.extract! achievement, :id, :game_id, :points, :image, :name, :description
  json.url achievement_url(achievement, format: :json)
end
