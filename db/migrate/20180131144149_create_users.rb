class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.float :balance
      t.string :provider
      t.string :uid
      t.string :username

      t.timestamps
    end
  end
end
