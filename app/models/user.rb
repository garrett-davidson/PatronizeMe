class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :projects, inverse_of: :owner
  has_many :issue_transactions, inverse_of: :user

  def profile_picture_path
    prefix = 'users/'
    profile_picture_name = '/profile.png'

    path = prefix + id.to_s + profile_picture_name

    ActionController::Base.helpers.asset_path path
  rescue Sprockets::Rails::Helper::AssetNotFound
    ActionController::Base.helpers.asset_path('users/default/profile.png')
  end
end
