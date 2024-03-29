class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :balance, null: false, default: 0
      t.string :provider
      t.string :uid
      t.string :username
      t.string :github_username

      t.timestamps
    end
  end
end
