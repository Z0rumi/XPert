require "application_system_test_case"

class ProjectsTest < ApplicationSystemTestCase
  test "visiting the index" do
    sign_in users(:user_staff)
    visit projects_url
    assert_selector "h1", text: "Projekte"
  end

  test "should show details of project" do
    sign_in users(:user_staff)
    visit projects_url
    within find(".project-card", text: projects(:china_project).project_name) do
      click_on "Details"
    end
    assert_current_path project_url(projects(:china_project))
    assert_selector "h1", text: projects(:china_project).project_name
  end

  test "should create project" do
    sign_in users(:user_staff)
    visit projects_url
    click_on "Neues Projekt"

    select projects(:china_project).project_type, from: "Projekttyp"
    fill_in "Auftraggeber", with: projects(:china_project).client
    fill_in "Enddatum", with: projects(:china_project).end_date
    fill_in "Durchführungsort", with: projects(:china_project).location
    fill_in "Projektbezeichnung", with: "Frankreich Projekt"
    fill_in "Themenschwerpunkte", with: projects(:china_project).main_topics
    fill_in "Startdatum", with: projects(:china_project).start_date
    click_on "Projekt erstellen"

    assert_text "Projekt wurde erfolgreich erstellt.", wait: 5
    assert_selector "h1", text: "Frankreich Projekt"
  end

  test "should update Project" do
    sign_in users(:user_staff)
    visit project_url(projects(:china_project))
    click_on "Projekt bearbeiten", match: :first

    fill_in "Projektbezeichnung", with: "England Projekt"
    click_on "Projekt speichern"

    assert_text "Projekt wurde erfolgreich aktualisiert.", wait: 5
    assert_selector "h1", text: "England Projekt"
  end

  test "should destroy Project" do
    sign_in users(:user_staff)
    visit project_url(projects(:china_project))
    assert_selector "h1", text: projects(:china_project).project_name
    click_on "Projekt löschen", match: :first
    assert_selector "h2", text: "Sind Sie sicher, dass Sie dieses Projekt löschen möchten?"
    click_on "Bestätigen"
    assert_text "Projekt wurde erfolgreich gelöscht.", wait: 5
    assert_no_text "China projekt"
  end

  test "should search project name" do
    sign_in users(:user_staff)
    visit projects_url
    fill_in "q[project_name_cont]", with: projects(:china_project).project_name
    click_on "Suchen", match: :first
    assert_text projects(:china_project).project_name
    assert_no_text projects(:deutschland_project).project_name
  end

  test "should search main topic" do
    sign_in users(:user_staff)
    visit projects_url
    fill_in "q[main_topics_cont]", with: projects(:china_project).main_topics
    click_on "Suchen", match: :first
    assert_text projects(:china_project).project_name
    assert_no_text projects(:deutschland_project).project_name
  end

  test "should search project type" do
    sign_in users(:user_staff)
    visit projects_url
    select projects(:deutschland_project).project_type, from: "filter_tag_select"
    click_on "Suchen", match: :first
    assert_text projects(:deutschland_project).project_name
    assert_no_text projects(:china_project).project_name
  end
end
