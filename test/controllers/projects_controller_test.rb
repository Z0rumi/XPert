require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in users(:user_staff)
    get projects_url
    assert_response :success
  end

  test "should get show" do
    sign_in users(:user_staff)
    get project_url(projects(:china_project))
    assert_response :success
  end

  test "should get new" do
    sign_in users(:user_staff)
    get new_project_url
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:user_staff)
    get edit_project_url(projects(:china_project))
    assert_response :success
  end

  test "should create project" do
    sign_in users(:user_staff)
    assert_difference("Project.count") do
      post projects_url, params: { project: {
        project_name: "Projekt Künstliche Intelligenz",
        main_topics: "KI, Neuronale Netze",
        start_date: 2025-10-16,
        end_date: 2025-12-16,
        project_type: "fachliche Weiterbildung",
        client: "Bosch GmbH",
        location: "Heilbronn",
        city: "Heilbronn",
        expert_ids: [ experts(:alice).id ]
      } }
    end

    assert_redirected_to project_url(Project.last)
  end

  test "should update project" do
    sign_in users(:user_staff)
    patch project_url(projects(:china_project)), params: { project: { project_name: "Unkünstliche Intelligenz" } }
    assert_redirected_to project_url(projects(:china_project))
  end

  test "should destroy project" do
    sign_in users(:user_staff)
    assert_difference("Project.count", -1) do
      delete project_url(projects(:china_project))
    end

    assert_redirected_to projects_url
  end

  test "initiated expert should not visit" do
    sign_in users(:user_alice)
    [
      projects_url,
      project_url(projects(:china_project)),
      new_project_url,
      edit_project_url(projects(:china_project))
    ].each do |page|
      get page
      assert_redirected_to expert_profile_path(experts(:alice))
      assert_equal "Sie haben nicht die benötigten Berechtigungen, um auf diese Seite zuzugreifen.", flash[:notice]
    end
  end

  test "intern should not visit" do
    sign_in users(:user_intern)
    [
      new_project_url,
      edit_project_url(projects(:china_project))
    ].each do |page|
      get page
      assert_redirected_to projects_path
      assert_equal "Sie haben nicht die benötigten Berechtigungen, um auf diese Seite zuzugreifen.", flash[:notice]
    end
  end

  test "unauthenticated should not visit" do
    [
      projects_url,
      project_url(projects(:china_project)),
      new_project_url,
      edit_project_url(projects(:china_project))
    ].each do |page|
      get page
      assert_redirected_to new_user_session_path
      assert_equal "Sie müssen sich anmelden, um fortzufahren.", flash[:alert]
    end
  end
end
