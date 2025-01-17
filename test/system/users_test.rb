require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  test "should login expert" do
    visit new_user_session_path
    fill_in "E-Mail", with: users(:user_alice).email
    fill_in "Passwort", with: "2Secret!"
    click_on "Anmelden"
    assert_selector "h1", text: experts(:alice).salutation + " " + experts(:alice).title + " " + experts(:alice).first_name + " " + experts(:alice).last_name
  end

  test "should login intern" do
    visit new_user_session_path
    fill_in "E-Mail", with: users(:user_intern).email
    fill_in "Passwort", with: "2Secret!"
    click_on "Anmelden"
    assert_selector "h1", text: "Herzlich Willkommen, " + users(:user_intern).email + "!"
  end

  test "should login staff" do
    visit new_user_session_path
    fill_in "E-Mail", with: users(:user_staff).email
    fill_in "Passwort", with: "2Secret!"
    click_on "Anmelden"
    assert_selector "h1", text: "Herzlich Willkommen, " + users(:user_staff).email + "!"
  end

  test "create new expert user account" do
    visit new_user_registration_path(token: one_time_links(:one_time_link1).token)
    assert_selector "h2", text: "Registrierung"
    fill_in "E-Mail", with: "newtest@case.de"
    fill_in "Passwort", with: "2Secret!"
    fill_in "Passwort wiederholen", with: "2Secret!"
    click_on "Registrieren"
    assert_selector "h1", text: "Expert*in Erstellung"
    assert_text "Willkommen! Sie haben sich erfolgreich registriert."
  end

  test "show profile after expert login" do
    sign_in users(:user_alice)
    visit expert_url(experts(:alice))
    assert_selector "h1", text: experts(:alice).salutation + " " + experts(:alice).title + " " + experts(:alice).first_name + " " + experts(:alice).last_name
    assert_text "Profil bearbeiten"
  end

  test "show experts after staff login" do
    sign_in users(:user_staff)
    visit experts_url
    assert_selector "h1", text: "Expert*innen"
    assert_text "Expert*in anlegen"
  end

  test "delete user session" do
    sign_in users(:user_staff)
    visit root_path
    click_on "Profil"
    click_on "Abmelden"
    assert_selector "h2", text: "Login"
  end
end
