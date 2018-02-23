class CreateUserSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :user_settings do |t|
      t.integer :userid
      t.boolean :isPublic

      t.timestamps
    end
  end
end
