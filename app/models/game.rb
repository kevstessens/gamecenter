class Game < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_one :game_owner
  has_many :achievements
  mount_uploader :image, ImageUploader

  def used_points
    points=0
    achievements.each do |ac|
      points = ac.points.to_i + points
    end
    points
  end

end
