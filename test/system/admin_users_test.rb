require "application_system_test_case"

class AdminUsersTest < ApplicationSystemTestCase
  test "visiting the index" do
    sign_in users(:user_admin)
    visit admin_users_path
    assert_selector "h1", text: "Benutzerverwaltung"
  end

  test "should create user" do
    sign_in users(:user_admin)
    visit admin_users_path
    click_on "Benutzer*in anlegen"

    fill_in "E-Mail", with: "testuser@case.de"
    fill_in "Passwort *", with: "password123"
    fill_in "Passwort wiederholen", with: "password123"
    select "Experte", from: "Rolle"
    click_on "Benutzer*in erstellen"

    assert_text "Benutzer*in wurde erfolgreich erstellt.", wait: 5
    assert_selector "div#users", text: /testuser@case.de/
  end

  test "should update user" do
    sign_in users(:user_admin)
    visit admin_users_path
    assert_selector "div#users", text: /alice@test.com/
    click_on "Bearbeiten", match: :first

    fill_in "E-Mail", with: "alicenew@test.com"
    click_on "Benutzer*in speichern"

    assert_text "Benutzer*in wurde erfolgreich aktualisiert.", wait: 5
    assert_selector "div#users", text: /alicenew@test.com/
    assert_no_text "alice@test.com"
  end

  test "should destroy user" do
    sign_in users(:user_admin)
    visit admin_users_path
    assert_selector "div#users", text: /alice@test.com/
    click_on "Löschen", match: :first
    assert_selector "h2", text: "Sind Sie sicher, dass Sie diesen Benutzer löschen möchten?"
    click_on "Bestätigen"

    assert_text "Benutzer*in wurde erfolgreich gelöscht.", wait: 5
    assert_no_text "alice@test.com"
  end
end
