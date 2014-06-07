class CreateGameOwners < ActiveRecord::Migration
  def change
    create_table :game_owners do |t|
      t.references :game, index: true

      t.timestamps
    end
  end
end
