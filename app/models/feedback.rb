class Feedback < ApplicationRecord
  belongs_to :Issue
  belongs_to :User
end
