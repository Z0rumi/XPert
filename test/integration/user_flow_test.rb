require "test_helper"

class UserFlowTest < ActionDispatch::IntegrationTest
  test "can login as staff" do
    get new_user_session_path
    assert_select "h1", "Xpert"

    post user_session_path, params: { user: { email: users(:user_staff).email, password: "2Secret!" } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", "Herzlich Willkommen, staff@test.com!"
  end

  test "can login as intern" do
    get new_user_session_path
    assert_select "h1", "Xpert"

    post user_session_path, params: { user: { email: users(:user_intern).email, password: "2Secret!" } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", "Herzlich Willkommen, intern@test.com!"
  end

  test "can login as expert" do
    get new_user_session_path
    assert_select "h1", "Xpert"

    post user_session_path, params: { user: { email: users(:user_alice).email, password: "2Secret!" } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", experts(:alice).salutation + " " + experts(:alice).title + " " + experts(:alice).first_name + " " + experts(:alice).last_name
  end

  test "user can change email" do
    sign_in users(:user_alice)
    get edit_email_path
    assert_select "h1", "Email ändern"

    patch user_registration_path, params: { user: { email: "new@mail.de", current_password: "2Secret!" } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", experts(:alice).salutation + " " + experts(:alice).title + " " + experts(:alice).first_name + " " + experts(:alice).last_name
  end

  test "user can change password" do
    sign_in users(:user_staff)
    get edit_password_path
    assert_select "h1", "Passwort ändern"

    patch user_registration_path, params: { user: { password: "newPass", password_confirmation: "newPass", current_password: "2Secret!" } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", "Herzlich Willkommen, staff@test.com!"
  end

  test "user can cancel account" do
    sign_in users(:user_alice)
    get edit_user_registration_path
    assert_select "h1", "Benutzerkonto bearbeiten"

    delete user_registration_path
    assert_response :redirect
    follow_redirect!
    assert_select "h1", "Xpert"
  end

  test "authenticated user should be redirected to home page after login" do
    get new_user_session_path
    assert_response :success

    post user_session_path, params: { user: { email: users(:user_staff).email, password: "2Secret!" } }

    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_select "h1", "Herzlich Willkommen, " + users(:user_staff).email + "!"
  end
end
