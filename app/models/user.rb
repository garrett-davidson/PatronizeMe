# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable, omniauth_providers: [:github]
  has_many :projects, inverse_of: :owner, foreign_key: 'owner_id'
  has_many :issue_transactions, inverse_of: :user
  has_many :feedbacks, inverse_of: :user
  has_many :badges, inverse_of: :user
  has_one :user_setting

  def self.from_omniauth(auth)
    user = User.new
    user.provider = auth.provider
    user.uid = auth.uid
    user.email = auth.info.email
    user.password = Devise.friendly_token[0, 20]
    user.username = auth.info.nickname
    user.name = auth.info.name

    user
  end

  has_attached_file :avatar, styles: { medium: '300x300>', thumb: '100x100#' }, default_url: '/images/:style/missing.png'
  validates_attachment_content_type :avatar, content_type: %r{/\Aimage\/.*\Z}

  def update_badge_progress(badge_name, progress)
    user_level = 0
    $badges[badge_name]['levels'].each do |level|
      if progress > level.to_i
        user_level += 1
      else
        break
      end
    end

    set_badge_level(badge_name, user_level)
  end

  def set_badge_level(badge_name, level)
    badge = Badge.where(user_id: self.id, badge_id: $badges[badge_name]['id']).first_or_create
    badge.level = level
    badge.save!
  end
end
