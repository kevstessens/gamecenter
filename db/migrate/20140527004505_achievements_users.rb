class AchievementsUsers < ActiveRecord::Migration
  def change

    create_table :achievements_users do |t|
      t.belongs_to :achievement
      t.belongs_to :user

    end

  end
end
