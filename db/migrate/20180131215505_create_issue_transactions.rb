class CreateIssueTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :issue_transactions do |t|
      t.belongs_to :user
      t.belongs_to :issue
      t.integer :amount
      t.boolean :completed
      t.boolean :cancelled

      t.timestamps
    end
  end
end
