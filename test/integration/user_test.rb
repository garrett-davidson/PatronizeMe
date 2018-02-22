require 'test_helper'

class UserTestIntegration < ActionDispatch::IntegrationTest
  setup do
    @user = users(:garrett)
  end

  test "should get user page" do
    get user_url(@user)
    assert_response :success
  end

  test "should get user login page" do
    get new_user_session_url
    assert_response :success
  end

  test "should get user logout" do
    delete destroy_user_session_path
    assert_response :redirect
  end

  

end
