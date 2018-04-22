class Badge < ApplicationRecord
  belongs_to :user, inverse_of: :badges
end
