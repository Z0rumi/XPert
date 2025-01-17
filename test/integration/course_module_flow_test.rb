require "test_helper"

class CourseModuleFlowTest < ActionDispatch::IntegrationTest
  test "can create course module" do
    sign_in users(:user_staff)
    get course_modules_path
    assert_select "h1", "Kursmodule"

    get new_course_module_path
    assert_select "h1", "Neues Kursmodul"

    post course_modules_url, params: { course_module: { name: "Kurs DEF", description: "Kurs DEF is ein Testkurs." } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", "Kursmodule"
    assert_select "div#course_modules", text: /Kurs DEF/
  end

  test "can edit course module" do
    sign_in users(:user_staff)
    get course_modules_path
    assert_select "h1", "Kursmodule"

    get edit_course_module_path(course_modules(:course_abc))
    assert_select "h1", "Kursmodul bearbeiten"

    patch course_module_path(course_modules(:course_abc)), params: { course_module: { name: "Kurs HIJ" } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", "Kursmodule"
    assert_select "div#course_modules", text: /Kurs HIJ/
  end

  test "can delete course module" do
    sign_in users(:user_staff)
    get course_modules_path
    assert_select "h1", "Kursmodule"

    delete course_module_path(course_modules(:course_abc))
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "p#notice", text: "Kursmodul wurde erfolgreich gelöscht."
  end

  test "can add course module to expert" do
    sign_in users(:user_staff)
    get experts_path
    assert_select "h1", "Expert*innen"

    get expert_path(experts(:alice))
    assert_select "h1", experts(:alice).salutation + " " + experts(:alice).title + " " + experts(:alice).first_name + " " + experts(:alice).last_name

    get edit_expert_path(experts(:alice))
    assert_select "h1", "Expert*in bearbeiten"

    patch expert_path(experts(:alice)), params: { expert: { course_module_ids: [ course_modules(:course_abc).id, course_modules(:course_uvw).id ] } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", experts(:alice).salutation + " " + experts(:alice).title + " " + experts(:alice).first_name + " " + experts(:alice).last_name

    get expert_path(experts(:alice))
    assert_select "#expert_categories_container .tag", text: /#{course_modules(:course_abc).name}/
    assert_select "#expert_categories_container .tag", text: /#{course_modules(:course_uvw).name}/
  end
end
