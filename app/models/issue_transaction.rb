class IssueTransaction < ApplicationRecord
  belongs_to :user, inverse_of: :issue_transactions
  belongs_to :issue, inverse_of: :issue_transactions
end
