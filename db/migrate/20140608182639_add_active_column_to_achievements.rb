class AddActiveColumnToAchievements < ActiveRecord::Migration
  def change
    add_column :achievements, :active, :boolean
  end
end
