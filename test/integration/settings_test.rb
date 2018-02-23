require 'test_helper'

class SettingsTestIntegration < ActionDispatch::IntegrationTest
  setup do
    @user = users(:garrett)
  end

  test "should get settings page redirect" do
    get profile_settings_url(@user)
    assert_response :redirect
  end

  test "should get settings page after login" do
    post new_user_session_url(@user)
    get profile_settings_url(@user)
    assert_response :redirect
  end


end
