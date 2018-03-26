class Issue < ApplicationRecord
  belongs_to :project, inverse_of: :issues
  belongs_to :parent, class_name: :issue
  has_many :children, class_name: :issue
  has_many :issue_transactions, inverse_of: :issue
  has_many :supporters, source: :user, through: :issue_transactions

  def total_funding
    issue_transactions.sum('amount')
  end

  def self.new_from_json(json)
    Issue.new(name: json['title'],
              description: json['body'],
              status: json['state'] == 'open' ? 1 : 0,
              created_at: json['created_at'],
              updated_at: json['updated_at'])
  end
end
