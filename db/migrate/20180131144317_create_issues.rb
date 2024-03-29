class CreateIssues < ActiveRecord::Migration[5.1]
  def change
    create_table :issues do |t|
      t.string :name
      t.string :description
      t.integer :status
      t.integer :github_id
      t.belongs_to :project

      t.timestamps
    end
  end
end
