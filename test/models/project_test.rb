require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess::FixtureFile
  test "assert fixtures" do
    assert Project.count, 2
    assert_includes projects(:china_project).experts, experts(:alice)
  end

  test "create project" do
    project = Project.create(
      project_name: "Meet IT",
      main_topics: "gdsg",
      start_date: "2024-10-16",
      end_date: "2024-12-16",
      project_type: "Delegationsbesuch",
      client: "Samsung",
      location: "Heilbronn",
      city: "Heilbronn",
      expert_ids: [ experts(:alice).id, experts(:bob).id ]
    )

    assert project.save
    project.reload
    assert_equal project.project_name, "Meet IT"
    assert_includes project.experts, experts(:alice)
  end

  test "update project" do
    project = projects(:china_project)
    project.update(project_name: "Shanghai Project")

    project.reload
    assert_equal project.project_name, "Shanghai Project"
  end

  test "update project experts" do
    project = projects(:china_project)
    project.update(expert_ids: [ experts(:alice).id, experts(:bob).id ])

    project.reload
    assert_includes project.experts, experts(:alice)
    assert_includes project.experts, experts(:bob)
  end

  test "delete project" do
    assert_difference("Project.count", -1) do
      projects(:china_project).destroy
    end

    assert_raises ActiveRecord::RecordNotFound do
      Project.find(projects(:china_project).id)
    end
  end

  test "expert not deleted on project deletion" do
    assert_no_difference("Expert.count") do
      assert projects(:china_project).destroy
    end
  end

  test "validates required fields" do
    project = Project.new

    assert_not project.valid?

    assert_includes project.errors.messages.keys, :project_name
  end

  test "can attach documents" do
    project = projects(:china_project)
    [
      fixture_file_upload(Rails.root.join("test/fixtures/files/test_pdf.pdf"), "application/pdf"),
      fixture_file_upload(Rails.root.join("test/fixtures/files/test_docx.docx"), "application/vnd.openxmlformats-officedocument.wordprocessingml.document"),
      fixture_file_upload(Rails.root.join("test/fixtures/files/test_xlsx.xlsx"), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
    ].each do |file|
      project.documents.attach(file)

      assert project.valid?
      project.save
      project.reload
    end
    assert_equal 3, project.documents.size
  end

  test "validates wrong file format" do
    project = projects(:china_project)
    [
      fixture_file_upload(Rails.root.join("test/fixtures/files/test_txt.txt"), "text/plain"),
      fixture_file_upload(Rails.root.join("test/fixtures/files/test_png.png"), "image/png"),
      fixture_file_upload(Rails.root.join("test/fixtures/files/test_jpg.jpg"), "image/jpg")
    ].each do |file|
      project.documents.attach(file)

      assert_not project.valid?, "Projekt sollte ungültig sein wegen falschem Dateiformat"
      assert_includes project.errors[:documents], "hat einen ungültigen Dateityp"
      project.reload
      assert_not project.documents.attached?, "Ungültiges Dokument sollte nicht angehängt werden"
    end
  end
end
