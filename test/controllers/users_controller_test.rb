require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in users(:user_admin)
    get admin_users_path
    assert_response :success
  end

  test "should get new" do
    sign_in users(:user_admin)
    get new_admin_user_path
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:user_admin)
    get edit_admin_user_path(users(:user_intern))
    assert_response :success
  end

  test "should create user" do
    sign_in users(:user_admin)
    assert_difference("User.count") do
      post admin_users_path, params: { user: { email: "test@case.de", password: "password123", password_confirmation: "password123", role: "expert" } }
    end

    assert_redirected_to admin_users_path
  end

  test "should update user" do
    sign_in users(:user_admin)
    patch admin_user_path(users(:user_staff)), params: { user: { email: "newStaff@test.com" } }
    assert_redirected_to admin_users_path
  end

  test "should destroy user" do
    sign_in users(:user_admin)
    assert_difference("User.count", -1) do
      delete admin_user_path(users(:user_alice))
    end

    assert_redirected_to admin_users_path
  end

  test "expert should not visit" do
    sign_in users(:user_alice)
    [
      admin_users_path,
      new_admin_user_path,
      edit_admin_user_path(users(:user_staff))
    ].each do |page|
      get page
      assert_redirected_to expert_profile_path(experts(:alice))
      assert_equal "Sie haben nicht die benötigten Berechtigungen, um auf diese Seite zuzugreifen.", flash[:notice]
    end
  end

  test "intern should not visit" do
    sign_in users(:user_intern)
    [
      admin_users_path,
      new_admin_user_path,
      edit_admin_user_path(users(:user_staff))
    ].each do |page|
      get page
      assert_redirected_to root_path
      assert_equal "Sie haben nicht die benötigten Berechtigungen, um auf diese Seite zuzugreifen.", flash[:notice]
    end
  end

  test "staff should not visit" do
    sign_in users(:user_staff)
    [
      admin_users_path,
      new_admin_user_path,
      edit_admin_user_path(users(:user_staff))
    ].each do |page|
      get page
      assert_redirected_to root_path
      assert_equal "Sie haben nicht die benötigten Berechtigungen, um auf diese Seite zuzugreifen.", flash[:notice]
    end
  end

  test "unauthenticated should not visit" do
    [
      admin_users_path,
      new_admin_user_path,
      edit_admin_user_path(users(:user_staff))
    ].each do |page|
      get page
      assert_redirected_to new_user_session_path
      assert_equal "Sie müssen sich anmelden, um fortzufahren.", flash[:alert]
    end
  end
end
