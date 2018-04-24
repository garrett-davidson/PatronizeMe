class Feedback < ApplicationRecord
  belongs_to :issue, inverse_of: :feedbacks
  belongs_to :user

  def self.daily_check
    puts 'this was just ran'
  end
end
