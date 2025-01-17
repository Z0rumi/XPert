require "test_helper"

class AdminUserFlowTest < ActionDispatch::IntegrationTest
  test "can create user account" do
    sign_in users(:user_admin)
    get admin_users_path
    assert_select "h1", "Benutzerverwaltung"

    get new_admin_user_path
    assert_select "h1", "Benutzer*in Erstellung"

    post admin_users_path, params: { user: { email: "test@case.de", password: "password123", password_confirmation: "password123", role: "expert" } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", "Benutzerverwaltung"
    assert_select "div#users", text: /test@case.de/
  end

  test "can edit user account" do
    sign_in users(:user_admin)
    get admin_users_path
    assert_select "h1", "Benutzerverwaltung"

    get edit_admin_user_path(users(:user_alice))
    assert_select "h1", "Benutzer*in bearbeiten"

    patch admin_user_path(users(:user_alice)), params: { user: { email: "alice@case.de" } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", "Benutzerverwaltung"
    assert_select "div#users", text: /alice@case.de/
  end

  test "can delete user account" do
    sign_in users(:user_admin)
    get admin_users_path
    assert_select "h1", "Benutzerverwaltung"

    delete admin_user_path(users(:user_alice))
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "p#notice", text: "Benutzer*in wurde erfolgreich gelöscht."
  end
end
