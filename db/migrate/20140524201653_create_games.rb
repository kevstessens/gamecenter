class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :game_key
      t.string :secret_key
      t.string :name
      t.string :image
      t.string :description

      t.timestamps
    end
  end
end
