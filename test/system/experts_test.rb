require "application_system_test_case"

class ExpertsTest < ApplicationSystemTestCase
  test "visiting the index" do
    sign_in users(:user_staff)
    visit experts_url
    assert_selector "h1", text: "Expert*innen"
  end

  test "should show details of expert" do
    sign_in users(:user_staff)
    visit experts_url
    within find(".expert-card", text: experts(:alice).first_name) do
      click_on "Details"
    end
    assert_current_path expert_url(experts(:alice))
    assert_selector "h1", text: experts(:alice).salutation + " " + experts(:alice).title + " " + experts(:alice).first_name + " " + experts(:alice).last_name
  end

  test "should create expert" do
    sign_in users(:user_staff)
    visit experts_url
    click_on "Expert*in anlegen"

    fill_in "Verfügbarkeit - Wie kurzfristig dürfen wir Sie für ein Projekt kontaktieren?", with: experts(:alice).availability
    fill_in "Chinabezug/Chinaerfahrung – Welchen beruflichen / privaten Chinabezug haben Sie? Welche Chinaerfahrung haben Sie bisher gesammelt?", with: experts(:alice).china_experience
    fill_in "E-Mail", with: experts(:alice).email
    fill_in "Vorname", with: "Lea"
    fill_in "Honorarvorstellung: Stundensatz", with: experts(:alice).daily_rate
    fill_in "Honorarvorstellung: Tagessatz", with: experts(:alice).hourly_rate
    select "Deutsch", from: "communication_languages_select"
    select "Deutsch", from: "teaching_languages_select"
    select "online", from: "travel_willingnesses_select"
    choose("Nein")
    fill_in "Nachname", with: experts(:alice).last_name
    fill_in "Ihr Standort", with: experts(:alice).location
    fill_in "Staatsangehörigkeit", with: experts(:alice).nationality
    fill_in "Telefonnummer", with: experts(:alice).phone_number
    fill_in "Sonstige Anmerkungen", with: experts(:alice).remarks
    select experts(:alice).salutation, from: "salutation_select"
    select experts(:alice).categories.first.name, from: "category_select"
    fill_in "Titel", with: experts(:alice).title
    fill_in "Anmerkungen zur Reisebereitschaft – Haben Sie noch Anmerkungen zu Ihrer Reisebereitschaft?", with: experts(:alice).remark_travel_willingness
    fill_in "Expertise: Weitere Themen-/Fachgebiete (Stichworte)", with: experts(:alice).extra_category
    click_on "Expert*in erstellen"

    assert_text "Expert*in wurde erfolgreich erstellt.", wait: 5
    assert_selector "h1", text: experts(:alice).salutation + " " + experts(:alice).title + " Lea " + experts(:alice).last_name
  end

  test "should update Expert" do
    sign_in users(:user_staff)
    visit expert_url(experts(:alice))
    click_on "Profil bearbeiten", match: :first

    fill_in "Vorname", with: "Lena"

    click_on "Expert*in speichern"

    assert_text "Expert*in wurde erfolgreich aktualisiert.", wait: 5
    assert_selector "h1", text: experts(:alice).salutation + " " + experts(:alice).title + " Lena " + experts(:alice).last_name
  end

  test "should destroy Expert" do
    sign_in users(:user_staff)
    visit expert_url(experts(:alice))
    assert_selector "h1", text: experts(:alice).salutation + " " + experts(:alice).title + " " + experts(:alice).first_name + " " + experts(:alice).last_name
    click_on "Expert*in löschen", match: :first
    assert_selector "h2", text: "Sind Sie sicher, dass Sie diese/n Expert*in löschen möchten?"
    click_on "Bestätigen"
    assert_text "Expert*in wurde erfolgreich gelöscht.", wait: 5
    assert_no_text experts(:alice).first_name
  end

  test "should search for an expert by first name" do
    sign_in users(:user_staff)
    visit experts_url
    fill_in "q[full_name_cont]", with: experts(:alice).first_name
    click_on "Suchen", match: :first
    assert_text experts(:alice).first_name
    assert_text experts(:alice).last_name
    assert_no_text experts(:bob).first_name
    assert_no_text experts(:bob).last_name
  end

  test "should search for an expert by last name" do
    sign_in users(:user_staff)
    visit experts_url
    fill_in "q[full_name_cont]", with: experts(:alice).last_name
    click_on "Suchen", match: :first
    assert_text experts(:alice).first_name
    assert_text experts(:alice).last_name
    assert_no_text experts(:bob).first_name
    assert_no_text experts(:bob).last_name
  end

  test "should search for an expert by first name and last name" do
    sign_in users(:user_staff)
    visit experts_url
    fill_in "q[full_name_cont]", with: experts(:alice).first_name + " " + experts(:alice).last_name
    click_on "Suchen", match: :first
    assert_text experts(:alice).first_name
    assert_text experts(:alice).last_name
    assert_no_text experts(:bob).first_name
    assert_no_text experts(:bob).last_name
  end

  test "should search category" do
    sign_in users(:user_staff)
    visit experts_url
    within(".categories-filter-tag-container") do
      select experts(:alice).categories.first.name, from: "filter_tag_select"
    end
    click_on "Suchen", match: :first
    assert_text experts(:alice).first_name
    assert_text experts(:alice).last_name
    assert_no_text experts(:bob).first_name
    assert_no_text experts(:bob).last_name
  end

  test "should search course module" do
    sign_in users(:user_staff)
    visit experts_url
    within(".course-module-filter-tag-container") do
      select experts(:alice).course_modules.first.name, from: "filter_tag_select"
    end
    click_on "Suchen", match: :first
    assert_text experts(:alice).first_name
    assert_text experts(:alice).last_name
    assert_no_text experts(:bob).first_name
    assert_no_text experts(:bob).last_name
  end
end
