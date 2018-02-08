class CreateIssues < ActiveRecord::Migration[5.1]
  def change
    create_table :issues do |t|
      t.string :name
      t.string :description
      t.integer :status
      t.belongs_to :parent, class_name: 'Issue'
      t.belongs_to :project

      t.timestamps
    end
  end
end
