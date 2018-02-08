class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.integer :status
      t.belongs_to :owner, class_name: 'User'

      t.timestamps
    end
  end
end
