class User < ActiveRecord::Base

  has_and_belongs_to_many :achievements
  has_and_belongs_to_many :users



  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.image = auth.info.image
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  def points
    points = 0
    self.achievements.each do |ach|
      points = points+ ach.points
    end
    return points
  end

end
