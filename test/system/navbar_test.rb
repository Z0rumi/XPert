require "application_system_test_case"

class NavbarTest < ApplicationSystemTestCase
  test "should redirect to expert profile" do
    sign_in users(:user_alice)
    visit expert_path(experts(:alice))
    click_on users(:user_alice).email
    assert_text "Expert*in Profil anzeigen"
    click_on "Expert*in Profil anzeigen"
    assert_current_path expert_profile_path(experts(:alice).id)
  end

  test "should redirect to projects webpage" do
    sign_in users(:user_staff)
    visit experts_path
    click_on "Projekte"
    assert_current_path projects_path
  end

  test "should redirect to experts webpage" do
    sign_in users(:user_staff)
    visit projects_path
    click_on "Expert*innen"
    assert_current_path experts_path
  end

  test "should delete user session" do
    sign_in users(:user_staff)
    visit projects_path
    click_on users(:user_staff).email
    assert_text "Abmelden"
    click_on "Abmelden"
    assert_current_path new_user_session_path
    assert_selector "h2", text: "Login"
  end

  test "should redirect to edit user webpage" do
    sign_in users(:user_staff)
    visit experts_path
    click_on users(:user_staff).email
    click_on "Benutzerkonto bearbeiten"
    assert_current_path edit_user_registration_path
  end

  test "should redirect to categories webpage" do
    sign_in users(:user_staff)
    visit experts_path
    click_on "Verwaltung"
    click_on "Themen-/Fachgebiete"
    assert_current_path categories_path
  end

  test "should redirect to course module webpage" do
    sign_in users(:user_staff)
    visit experts_path
    click_on "Verwaltung"
    click_on "Kursmodule"
    assert_current_path course_modules_path
  end
end
