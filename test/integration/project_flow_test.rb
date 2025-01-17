require "test_helper"

class ProjectFlowTest < ActionDispatch::IntegrationTest
  include ActionDispatch::TestProcess::FixtureFile
  test "can create new project" do
    sign_in users(:user_staff)
    get projects_path
    assert_select "h1", "Projekte"

    get new_project_path
    assert_select "h1", "Projekterstellung"

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
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", "Projekt Künstliche Intelligenz"
  end

  test "can show and edit project" do
    sign_in users(:user_staff)
    get projects_path
    assert_select "h1", "Projekte"

    get project_path(projects(:china_project))
    assert_select "h1", "China projekt"

    get edit_project_path(projects(:china_project))
    assert_select "h1", "Projektbearbeitung"

    patch project_path(projects(:china_project)), params: { project: { project_name: "Unkünstliche Intelligenz" } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", "Unkünstliche Intelligenz"
  end

  test "can show and delete project" do
    sign_in users(:user_staff)
    get projects_path
    assert_select "h1", "Projekte"

    get project_path(projects(:china_project))
    assert_select "h1", "China projekt"

    delete project_path(projects(:china_project))
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", "Projekte"
  end

  test "can upload multiple documents and delete one" do
    sign_in users(:user_staff)
    get projects_path
    assert_select "h1", "Projekte"

    get project_path(projects(:china_project))
    assert_select "h1", "China projekt"

    file_one = fixture_file_upload(Rails.root.join("test/fixtures/files/test_pdf.pdf"), "application/pdf")
    file_two = fixture_file_upload(Rails.root.join("test/fixtures/files/test_docx.docx"), "application/vnd.openxmlformats-officedocument.wordprocessingml.document")

    patch add_documents_project_path(projects(:china_project)), params: { project: { documents: [ file_one, file_two ] } }

    assert_equal 2, projects(:china_project).documents.count

    follow_redirect!

    assert_select "li a", text: "test_pdf.pdf"
    assert_select "li a", text: "test_docx.docx"

    document_to_delete = projects(:china_project).documents.find { |doc| doc.filename.to_s == "test_docx.docx" }

    delete remove_document_project_path(projects(:china_project)), params: { document_id: document_to_delete.id }

    assert_equal 1, projects(:china_project).documents.count

    follow_redirect!

    assert_select "li a", text: "test_pdf.pdf"
    assert_select "li a", text: "test_docx.docx", count: 0
  end
end
