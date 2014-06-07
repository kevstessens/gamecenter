class CreateAchievements < ActiveRecord::Migration
  def change
    create_table :achievements do |t|
      t.references :game, index: true
      t.integer :points
      t.string :image
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
