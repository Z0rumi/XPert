require "application_system_test_case"

class CourseModulesTest < ApplicationSystemTestCase
  test "visiting the index" do
    sign_in users(:user_staff)
    visit course_modules_url
    assert_selector "h1", text: "Kursmodule"
  end

  test "should create course module" do
    sign_in users(:user_staff)
    visit course_modules_url
    click_on "Neues Kursmodul"

    fill_in "Beschreibung", with: course_modules(:course_abc).description
    fill_in "Name", with: "Kurs HIJ"
    click_on "Kursmodul erstellen"

    assert_text "Kursmodul wurde erfolgreich erstellt."
    assert_selector "div#course_modules", text: /Kurs HIJ/
  end

  test "should update course module" do
    sign_in users(:user_staff)
    visit course_modules_url
    assert_selector "div#course_modules", text: /Kurs ABC/
    click_on "Bearbeiten", match: :first

    fill_in "Name", with: "Kurs KLM"
    fill_in "Beschreibung", with: "Neue Beschreibung"
    click_on "Kursmodul speichern"

    assert_text "Kursmodul wurde erfolgreich aktualisiert."
    assert_selector "div#course_modules", text: /Kurs KLM/
    assert_no_text "Kurs ABC"
  end

  test "should destroy course module" do
    sign_in users(:user_staff)
    visit course_modules_url
    assert_selector "div#course_modules", text: /Kurs ABC/
    click_on "Löschen", match: :first
    assert_selector "h2", text: "Sind Sie sicher, dass Sie dieses Kursmodul löschen möchten?"
    click_on "Bestätigen"

    assert_text "Kursmodul wurde erfolgreich gelöscht."
    assert_no_text "Kurs ABC"
  end

  test "should create course module tag in expert form" do
    sign_in users(:user_staff)
    visit experts_url
    click_on "Expert*in anlegen"

    select course_modules(:course_abc).name, from: "course_module_select"
    assert_selector "span", text: course_modules(:course_abc).name
  end

  test "should show modal dialog with description" do
    sign_in users(:user_staff)
    visit experts_url
    click_on "Expert*in anlegen"

    select course_modules(:course_abc).name, from: "course_module_select"
    click_on "Info icon"
    assert_selector "p", text: course_modules(:course_abc).description
  end

  test "should delete course module tag" do
    sign_in users(:user_staff)
    visit experts_url
    click_on "Expert*in anlegen"

    select course_modules(:course_abc).name, from: "course_module_select"
    assert_selector "span", text: course_modules(:course_abc).name
    find("span", text: course_modules(:course_abc).name).find(".remove-tag").click
    assert_no_selector "span", text: course_modules(:course_abc).name
  end
end
