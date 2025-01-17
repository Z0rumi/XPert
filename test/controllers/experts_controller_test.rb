require "test_helper"

class ExpertsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in users(:user_staff)
    get experts_url
    assert_response :success
  end

  test "should get show" do
    sign_in users(:user_staff)
    get expert_url(experts(:alice))
    assert_response :success
  end

  test "should get show modal" do
    sign_in users(:user_staff)
    get expert_show_modal_path(experts(:alice))
    assert_response :success
  end

  test "should get new" do
    sign_in users(:user_staff)
    get new_expert_url
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:user_staff)
    get edit_expert_url(experts(:alice))
    assert_response :success
  end

  test "should create expert" do
    sign_in users(:user_staff)

    assert_difference("Expert.count") do
      post experts_url, params: { expert: {
        salutation: "Frau",
        title: "Prof. Dr.",
        first_name: "Alice",
        last_name: "Maier",
        nationality: "Deutsch",
        phone_number: "+49123456789",
        email: "alice@test.com",
        location: "Heilbronn",
        communication_languages: [ "Deutsch" ],
        teaching_languages: [ "Deutsch" ],
        hourly_rate: 100,
        daily_rate: 1000,
        travel_willingnesses: [ "online" ],
        remark_travel_willingness: "Keine Reisebereitschaft",
        availability: "2 Wochen vor Veranstaltung",
        china_experience: "Keine",
        institution: "Hochschule Heilbronn",
        cooperation_opportunity: "-",
        remarks: "-",
        category_ids: [ categories(:industrie_4_0).id ],
        course_module_ids: [ course_modules(:course_abc).id ],
        extra_category: "Künstliche Intelligenz",
        institution_association: "true",
        cv: fixture_file_upload(Rails.root.join("test/fixtures/files/test_pdf.pdf"), "application/pdf")
      } }
    end

    assert_redirected_to expert_url(Expert.last)
  end

  test "should update expert" do
    sign_in users(:user_staff)
    patch expert_url(experts(:alice)), params: { expert: { first_name: "Simone" } }
    assert_redirected_to expert_url(experts(:alice))
  end

  test "should destroy expert" do
    sign_in users(:user_staff)
    assert_difference("Expert.count", -1) do
      delete expert_url(experts(:alice))
    end

    assert_redirected_to experts_url
  end

  test "initiated expert should not visit" do
    sign_in users(:user_alice)
    [
      experts_url,
      expert_url(experts(:bob)), # show of diffrent expert
      expert_show_modal_path(experts(:alice)), # show of diffrent expert
      new_expert_url,
      edit_expert_url(experts(:bob)) # edit of diffrent expert
    ].each do |page|
      get page
      assert_redirected_to expert_profile_path(experts(:alice))
      assert_equal "Sie haben nicht die benötigten Berechtigungen, um auf diese Seite zuzugreifen.", flash[:notice]
    end
  end

  test "intern should not visit" do
    sign_in users(:user_intern)
    [
      new_expert_url,
      edit_expert_url(experts(:alice))
    ].each do |page|
      get page
      assert_redirected_to experts_path
      assert_equal "Sie haben nicht die benötigten Berechtigungen, um auf diese Seite zuzugreifen.", flash[:notice]
    end
  end

  test "unauthenticated should not visit" do
    [
      experts_url,
      expert_url(experts(:alice)),
      expert_show_modal_path(experts(:alice)),
      new_expert_url,
      edit_expert_url(experts(:alice))
    ].each do |page|
      get page
      assert_redirected_to new_user_session_path
      assert_equal "Sie müssen sich anmelden, um fortzufahren.", flash[:alert]
    end
  end
end
