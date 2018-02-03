# frozen_string_literal: true

module ApplicationHelper
  def profile_picture_path(user)
    prefix = 'users/'
    profile_picture_name = '/profile.png'

    path = prefix + user.id.to_s + profile_picture_name

    asset_path path
  rescue Sprockets::Rails::Helper::AssetNotFound
    asset_path('users/default/profile.png')
  end
end
