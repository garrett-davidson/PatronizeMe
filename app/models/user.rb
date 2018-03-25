# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable, omniauth_providers: [:github]
  has_many :projects, inverse_of: :owner, foreign_key: 'owner_id'
  has_many :issue_transactions, inverse_of: :user
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
end
