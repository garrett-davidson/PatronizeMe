class Feedback < ApplicationRecord
  belongs_to :issue, inverse_of: :feedbacks
  belongs_to :user
end
