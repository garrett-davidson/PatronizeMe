class Project < ApplicationRecord
  belongs_to :owner, class_name: :User, inverse_of: :projects
  has_many :issues, inverse_of: :project
  has_many :supporters, through: :issues
  has_many :issue_transactions, through: :issues
  validates_presence_of :name,:status , :notive => 'Must have a name'

  def total_funding
    issue_transactions.sum('amount')
  end
end
