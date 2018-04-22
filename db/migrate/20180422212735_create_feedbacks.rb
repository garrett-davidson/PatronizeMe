class CreateFeedbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :feedbacks do |t|
      t.belongs_to :issue
      t.boolean :accepted
      t.text :comment
      t.float :weight
      t.belongs_to :user

      t.timestamps
    end
  end
end
