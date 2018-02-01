class Project < ApplicationRecord
  belongs_to :owner, class_name: :User, inverse_of: :projects
  has_many :issues, inverse_of: :project
end
