class Game < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_one :game_owner
  has_many :achievements
  mount_uploader :image, ImageUploader

end
