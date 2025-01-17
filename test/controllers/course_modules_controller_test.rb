require "test_helper"

class CourseModulesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in users(:user_staff)
    get course_modules_url
    assert_response :success
  end

  test "should get show" do
    sign_in users(:user_staff)
    get course_module_url(course_modules(:course_abc))
    assert_response :success
  end

  test "should get new" do
    sign_in users(:user_staff)
    get new_course_module_url
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:user_staff)
    get edit_course_module_url(course_modules(:course_abc))
    assert_response :success
  end

  test "should create course_module" do
    sign_in users(:user_staff)
    assert_difference("CourseModule.count") do
      post course_modules_url, params: { course_module: { name: "Kurs DEF", description: "Kurs DEF is ein Testkurs." } }
    end

    assert_redirected_to course_modules_url
  end

  test "should update course_module" do
    sign_in users(:user_staff)
    patch course_module_url(course_modules(:course_abc)), params: { course_module: { name: "Kurs DEF", description: "Kurs DEF is ein Testkurs." } }
    assert_redirected_to course_modules_url
  end

  test "should destroy course_module" do
    sign_in users(:user_staff)
    assert_difference("CourseModule.count", -1) do
      delete course_module_url(course_modules(:course_abc))
    end

    assert_redirected_to course_modules_url
  end

  test "expert should not visit" do
    sign_in users(:user_alice)
    [
      course_modules_url,
      new_course_module_url,
      edit_course_module_url(course_modules(:course_abc))
    ].each do |page|
      get page
      assert_redirected_to expert_profile_path(experts(:alice))
      assert_equal "Sie haben nicht die benötigten Berechtigungen, um auf diese Seite zuzugreifen.", flash[:notice]
    end
  end

  test "intern should not visit" do
    sign_in users(:user_intern)
    [
      new_course_module_url,
      edit_course_module_url(course_modules(:course_abc))
    ].each do |page|
      get page
      assert_redirected_to course_modules_path
      assert_equal "Sie haben nicht die benötigten Berechtigungen, um auf diese Seite zuzugreifen.", flash[:notice]
    end
  end

  test "unauthenticated should not visit" do
    [
      course_modules_url,
      course_module_url(course_modules(:course_abc)),
      new_course_module_url,
      edit_course_module_url(course_modules(:course_abc))
    ].each do |page|
      get page
      assert_redirected_to new_user_session_path
      assert_equal "Sie müssen sich anmelden, um fortzufahren.", flash[:alert]
    end
  end
end
