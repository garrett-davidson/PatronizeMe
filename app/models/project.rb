class Project < ApplicationRecord
  belongs_to :owner, inverse_of: :projects
  has_many :issues, inverse_of: :project
end
