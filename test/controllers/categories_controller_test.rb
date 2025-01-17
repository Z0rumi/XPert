require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in users(:user_staff)
    get categories_url
    assert_response :success
  end

  test "should get new" do
    sign_in users(:user_staff)
    get new_category_url
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:user_staff)
    get edit_category_url(categories(:industrie_4_0))
    assert_response :success
  end

  test "should create category" do
    sign_in users(:user_staff)
    assert_difference("Category.count") do
      post categories_url, params: { category: { name: "Aus- und Weiterbildung" } }
    end

    assert_redirected_to categories_url
  end

  test "should update category" do
    sign_in users(:user_staff)
    patch category_url(categories(:industrie_4_0)), params: { category: { name: "Aus- und Weiterbildung" } }
    assert_redirected_to categories_url
  end

  test "should destroy category" do
    sign_in users(:user_staff)
    assert_difference("Category.count", -1) do
      delete category_url(categories(:industrie_4_0))
    end

    assert_redirected_to categories_url
  end

  test "expert should not visit" do
    sign_in users(:user_alice)
    [
      categories_url,
      new_category_url,
      edit_category_url(categories(:industrie_4_0))
    ].each do |page|
      get page
      assert_redirected_to expert_profile_path(experts(:alice))
      assert_equal "Sie haben nicht die benötigten Berechtigungen, um auf diese Seite zuzugreifen.", flash[:notice]
    end
  end

  test "intern should not visit" do
    sign_in users(:user_intern)
    [
      new_category_url,
      edit_category_url(categories(:industrie_4_0))
    ].each do |page|
      get page
      assert_redirected_to categories_path
      assert_equal "Sie haben nicht die benötigten Berechtigungen, um auf diese Seite zuzugreifen.", flash[:notice]
    end
  end

  test "unauthenticated should not visit" do
    [
      categories_url,
      new_category_url,
      edit_category_url(categories(:industrie_4_0))
    ].each do |page|
      get page
      assert_redirected_to new_user_session_path
      assert_equal "Sie müssen sich anmelden, um fortzufahren.", flash[:alert]
    end
  end
end
