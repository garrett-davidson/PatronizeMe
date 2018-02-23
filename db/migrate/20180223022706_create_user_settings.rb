class CreateUserSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :user_settings do |t|
      t.belongs_to :user
      t.boolean :isPublic, null: false, default: true

      t.timestamps
    end
  end
end
