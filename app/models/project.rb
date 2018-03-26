class Project < ApplicationRecord
  belongs_to :owner, class_name: :User, inverse_of: :projects
  has_many :issues, inverse_of: :project
  has_many :supporters, through: :issues
  has_many :issue_transactions, through: :issues
  validates_presence_of :name, :status, notive: 'Must have a name'

  def total_funding
    issue_transactions.sum('amount')
  end

  def fetch_issues
    json_issues = JSON.parse(RestClient.get('https://api.github.com/repos/' + link + '/issues'))
    json_issues.map do |issue_json|
      issue = Issue.new_from_json issue_json
      issue.project = self
      issue
    end
  end
end
