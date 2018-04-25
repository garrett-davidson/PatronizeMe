class CreateBadges < ActiveRecord::Migration[5.1]
  def change
    create_table :badges do |t|
      t.integer :badge_id
      t.integer :level
      t.belongs_to :user

      t.timestamps
    end
  end
end
