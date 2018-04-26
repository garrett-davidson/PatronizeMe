class Badge < ApplicationRecord
  belongs_to :user, inverse_of: :badges

  def find(badge_id)
    info = $badges.select {|_, b| b['id'] == badge_id}
    info.first().first().to_s
  end

  def description(badge_name)
    $badges[badge_name]['description']
  end
end
