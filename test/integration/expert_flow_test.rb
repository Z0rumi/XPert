require "test_helper"

class ExpertFlowTest < ActionDispatch::IntegrationTest
  include ActionDispatch::TestProcess::FixtureFile
  test "can create new expert" do
    sign_in users(:user_staff)
    get experts_path
    assert_select "h1", "Expert*innen"

    get new_expert_path
    assert_select "h1", "Expert*in Erstellung"

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
      horly_rate: 100,
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
      institution_association: "true"
    } }

    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", "Frau Prof. Dr. Alice Maier"
  end

  test "can show and edit expert" do
    sign_in users(:user_staff)
    get experts_path
    assert_select "h1", "Expert*innen"

    get expert_path(experts(:alice))
    assert_select "h1", experts(:alice).salutation + " " + experts(:alice).title + " " + experts(:alice).first_name + " " + experts(:alice).last_name

    get edit_expert_path(experts(:alice))
    assert_select "h1", "Expert*in bearbeiten"

    patch expert_path(experts(:alice)), params: { expert: { first_name: "Alina" } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", experts(:alice).salutation + " " + experts(:alice).title + " Alina " + experts(:alice).last_name
  end

  test "can show and delete expert" do
    sign_in users(:user_staff)
    get experts_path
    assert_select "h1", "Expert*innen"

    get expert_path(experts(:alice))
    assert_select "h1", experts(:alice).salutation + " " + experts(:alice).title + " " + experts(:alice).first_name + " " + experts(:alice).last_name

    delete expert_path(experts(:alice))
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", "Expert*innen"
  end

  test "can upload cv" do
    sign_in users(:user_staff)
    get experts_path
    assert_select "h1", "Expert*innen"

    get expert_path(experts(:alice))
    assert_select "h1", experts(:alice).salutation + " " + experts(:alice).title + " " + experts(:alice).first_name + " " + experts(:alice).last_name

    file = fixture_file_upload(Rails.root.join("test/fixtures/files/test_pdf.pdf"), "application/pdf")

    patch expert_url(experts(:alice)), params: { expert: { cv: file } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "span", "test_pdf.pdf"
  end
end
