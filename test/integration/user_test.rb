require 'test_helper'

class UserTestIntegration < ActionDispatch::IntegrationTest
  setup do
    @user = users(:garrett)
    @user2 = users(:garrett)
  end

  test "should get user page" do
    get user_url(@user)
    assert_response :success
  end

  test "should get user login page" do
    get new_user_session_url
    assert_response :success
  end

  test "should get user logged in" do
    post new_user_session_url(@user2)
    get profile_url(@user2)
    assert_response :redirect
  end


  test "should get user logout" do
    delete destroy_user_session_path
    assert_response :redirect
  end



end
