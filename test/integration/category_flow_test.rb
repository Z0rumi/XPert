require "test_helper"

class CategoryFlowTest < ActionDispatch::IntegrationTest
  test "can create category" do
    sign_in users(:user_staff)
    get categories_path
    assert_select "h1", "Themen-/Fachgebiete"

    get new_category_path
    assert_select "h1", "Neues Thema/Fachgebiet"

    post categories_url, params: { category: { name: "Künstliche Intelligenz" } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", "Themen-/Fachgebiete"
    assert_select "div#categories", text: /Künstliche Intelligenz/
  end

  test "can edit category" do
    sign_in users(:user_staff)
    get categories_path
    assert_select "h1", "Themen-/Fachgebiete"

    get edit_category_path(categories(:industrie_4_0))
    assert_select "h1", "Thema/Fachgebiet bearbeiten"

    patch category_path(categories(:industrie_4_0)), params: { category: { name: "Künstliche Intelligenz" } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", "Themen-/Fachgebiete"
    assert_select "div#categories", text: /Künstliche Intelligenz/
  end

  test "can delete category" do
    sign_in users(:user_staff)
    get categories_path
    assert_select "h1", "Themen-/Fachgebiete"

    delete category_path(categories(:industrie_4_0))
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "p#notice", text: "Thema/Fachgebiet wurde erfolgreich gelöscht."
  end

  test "can add category to expert" do
    sign_in users(:user_staff)
    get experts_path
    assert_select "h1", "Expert*innen"

    get expert_path(experts(:alice))
    assert_select "h1", experts(:alice).salutation + " " + experts(:alice).title + " " + experts(:alice).first_name + " " + experts(:alice).last_name

    get edit_expert_path(experts(:alice))
    assert_select "h1", "Expert*in bearbeiten"

    patch expert_path(experts(:alice)), params: { expert: { category_ids: [ categories(:industrie_4_0).id, categories(:digitale_technologie).id ] } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", experts(:alice).salutation + " " + experts(:alice).title + " " + experts(:alice).first_name + " " + experts(:alice).last_name

    get expert_path(experts(:alice))
    assert_select "#expert_categories_container .tag", text: /#{categories(:industrie_4_0).name}/
    assert_select "#expert_categories_container .tag", text: /#{categories(:digitale_technologie).name}/
  end
end
