class Issue < ApplicationRecord
  belongs_to :project, inverse_of: :issues
  belongs_to :parent, class_name: :issue
  has_many :children, class_name: :issue
  has_many :issue_transactions, inverse_of: :issue
end
