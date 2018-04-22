class Issue < ApplicationRecord
  belongs_to :project, inverse_of: :issues
  has_many :children, class_name: :issue
  has_many :issue_transactions, inverse_of: :issue
  has_many :supporters, source: :user, through: :issue_transactions

  def total_funding
    money = issue_transactions.sum('amount')
    money/100
  end

  def self.new_from_json(json)
    Issue.new(name: json['title'],
              description: json['body'],
              status: json['state'] == 'open' ? 1 : 0,
              github_id: json['number'],
              created_at: json['created_at'],
              updated_at: json['updated_at'])
  end

  def feedback_url
    'Implement me'
  end
end
