require "application_system_test_case"

class CategoriesTest < ApplicationSystemTestCase
  test "visiting the index" do
    sign_in users(:user_staff)
    visit categories_url
    assert_selector "h1", text: "Themen-/Fachgebiete"
  end

  test "should create category" do
    sign_in users(:user_staff)
    visit categories_url
    click_on "Neues Thema/Fachgebiet"

    fill_in "Name", with: "Softwareentwicklung"
    click_on "Thema/Fachgebiet erstellen"

    assert_text "Thema/Fachgebiet wurde erfolgreich erstellt.", wait: 5
    assert_selector "div#categories", text: /Softwareentwicklung/
  end

  test "should update category" do
    sign_in users(:user_staff)
    visit categories_url
    assert_selector "div#categories", text: /Industrie 4.0/
    click_on "Bearbeiten", match: :first

    fill_in "Name", with: "Industrie 5.0"
    click_on "Thema/Fachgebiet speichern"

    assert_text "Thema/Fachgebiet wurde erfolgreich aktualisiert.", wait: 5
    assert_selector "div#categories", text: /Industrie 5.0/
    assert_no_text "Industrie 4.0"
  end

  test "should destroy category" do
    sign_in users(:user_staff)
    visit categories_url
    assert_selector "div#categories", text: /Industrie 4.0/
    click_on "Löschen", match: :first
    assert_selector "h2", text: "Sind Sie sicher, dass Sie dieses Thema/Fachgebiet löschen möchten?"
    click_on "Bestätigen"

    assert_text "Thema/Fachgebiet wurde erfolgreich gelöscht.", wait: 5
    assert_no_text "Industrie 4.0"
  end

  test "should create category tag in expert form" do
    sign_in users(:user_staff)
    visit experts_url
    click_on "Expert*in anlegen"

    select categories(:industrie_4_0).name, from: "category_select"
    assert_selector "span", text: categories(:industrie_4_0).name
  end

  test "should delete category tag" do
    sign_in users(:user_staff)
    visit experts_url
    click_on "Expert*in anlegen"

    select categories(:industrie_4_0).name, from: "category_select"
    assert_selector "span", text: categories(:industrie_4_0).name
    find("span", text: categories(:industrie_4_0).name).find(".remove-tag").click
    assert_no_selector "span", text: categories(:industrie_4_0).name
  end
end
