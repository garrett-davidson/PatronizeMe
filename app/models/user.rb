class User < ApplicationRecord
  has_many :projects, inverse_of: :owner
  has_many :issue_transactions, inverse_of: :user
end
