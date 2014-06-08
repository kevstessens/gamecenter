class Achievement < ActiveRecord::Base

  belongs_to :game
  has_and_belongs_to_many :users

  mount_uploader :image, ImageUploader
  validates_presence_of :name, :points


end
