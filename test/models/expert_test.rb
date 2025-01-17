require "test_helper"

class ExpertTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess::FixtureFile
  test "assert fixtures" do
    assert Expert.count, 2
    assert_includes experts(:alice).categories, categories(:industrie_4_0)
    assert_includes experts(:alice).course_modules, course_modules(:course_abc)
  end

  test "create expert" do
    expert = Expert.create(
      salutation: "Herr",
      title: "Prof.",
      first_name: "Daniel",
      last_name: "Testinger",
      nationality: "Deutsch",
      phone_number: "+49123456789",
      email: "daniel.testinger@web.de",
      location: "Stuttgart",
      communication_languages: [ "Englisch, Deutsch" ],
      teaching_languages: [ "Englisch, Deutsch" ],
      hourly_rate: 100,
      daily_rate: 1000,
      travel_willingnesses: [ "online, Deutschland" ],
      remark_travel_willingness: "Keine Reisebereitschaft",
      availability: "2 Wochen vor Termin",
      china_experience: "2 Jahre in Beijing gearbeitet",
      institution: "Hochschule Heilbronn",
      cooperation_opportunity: "Werksführung",
      remarks: "Keine vor Ort Veranstaltungen",
      category_ids: [ categories(:industrie_4_0).id, categories(:digitale_technologie).id ],
      course_module_ids: [ course_modules(:course_abc).id, course_modules(:course_uvw).id ],
      extra_category: "Künstliche Intelligenz",
      institution_association: "true"
    )

    assert expert.save
    expert.reload
    assert_equal expert.first_name, "Daniel"
    assert_includes expert.categories, categories(:industrie_4_0)
    assert_includes expert.course_modules, course_modules(:course_abc)
  end

  test "update expert" do
    expert = experts(:alice)
    expert.update(location: "Mannheim")

    expert.reload
    assert_equal expert.location, "Mannheim"
  end

  test "update experts categories" do
    expert = experts(:alice)
    expert.update(category_ids: [ categories(:industrie_4_0).id, categories(:digitale_technologie).id ])

    expert.reload
    assert_includes expert.categories, categories(:industrie_4_0)
    assert_includes expert.categories, categories(:digitale_technologie)
  end

  test "update experts course modules" do
    expert = experts(:alice)
    expert.update(course_module_ids: [ course_modules(:course_abc).id, course_modules(:course_uvw).id ])

    expert.reload
    assert_includes expert.course_modules, course_modules(:course_abc)
    assert_includes expert.course_modules, course_modules(:course_uvw)
  end

  test "delete expert" do
    assert_difference("Expert.count", -1) do
      experts(:alice).destroy
    end

    assert_raises ActiveRecord::RecordNotFound do
      Expert.find(experts(:alice).id)
    end
  end

  test "category not deleted on expert deletion" do
    assert_no_difference("Category.count") do
      assert experts(:alice).destroy
    end
  end

  test "course module not deleted on expert deletion" do
    assert_no_difference("CourseModule.count") do
      assert experts(:alice).destroy
    end
  end

  test "user not deleted on expert deletion" do
    assert_no_difference("User.count") do
      assert experts(:alice).destroy
    end
  end

  test "user not initiated after expert deletion" do
    assert users(:user_alice).initiated
    assert experts(:alice).destroy
    users(:user_alice).reload
    assert_not users(:user_alice).initiated
  end

  test "valid emails" do
    [
      "1@1.de",
      "Test@Test3.de",
      "test@test.de",
      "test12@test12.de",
      "TEST@1.de",
      "TEST@TEST.DE",
      "test@test.test.de"
    ].each do |email|
      expert = experts(:alice)
      expert.update(email: email)

      expert.reload
      assert_equal email, expert.email
    end
  end

  test "invalid emails" do
    [
      "",
      "1@1.1",
      "Test@",
      "@test.de",
      "test12@test12.de123",
      "Test"
    ].each do |email|
      expert = experts(:alice)
      assert_raises(ActiveRecord::RecordInvalid) {
        expert.update!(email: email)
      }
    end
  end

  test "valid phone number" do
    [
      "+49124321452",
      "+49 2424 2141244",
      "049142461724",
      "00491247624772",
      "+49123",
      "+49234757373728284743"
    ].each do |phone_number|
      expert = experts(:alice)
      expert.update(phone_number: phone_number)

      expert.reload
      assert_equal phone_number, expert.phone_number
    end
  end

  test "invalid phone number" do
    [
      "",
      "+4912", # too short
      "0049", # too short
      "9489&249814982",
      "ab248761248782",
      "+492347573737282847432" # too long
    ].each do |phone_number|
      expert = experts(:alice)
      assert_raises(ActiveRecord::RecordInvalid) {
        expert.update!(phone_number: phone_number)
      }
    end
  end

  test "validates required fields" do
    expert = Expert.new

    assert_not expert.valid?

    assert_includes expert.errors.messages.keys, :salutation
    assert_includes expert.errors.messages.keys, :first_name
    assert_includes expert.errors.messages.keys, :last_name
    assert_includes expert.errors.messages.keys, :nationality
    assert_includes expert.errors.messages.keys, :phone_number
    assert_includes expert.errors.messages.keys, :email
    assert_includes expert.errors.messages.keys, :location
    assert_includes expert.errors.messages.keys, :communication_languages
    assert_includes expert.errors.messages.keys, :teaching_languages
    assert_includes expert.errors.messages.keys, :daily_rate
    assert_includes expert.errors.messages.keys, :hourly_rate
    assert_includes expert.errors.messages.keys, :travel_willingnesses
    assert_includes expert.errors.messages.keys, :availability
    assert_includes expert.errors.messages.keys, :china_experience
    assert_includes expert.errors.messages.keys, :categories
    assert_includes expert.errors.messages.keys, :institution_association
  end

  test "validates institution if association is true" do
    expert = Expert.new(institution_association: true)

    assert_not expert.valid?

    assert_includes expert.errors.messages.keys, :institution
  end

  test "can attach cv" do
    expert = experts(:alice)
    [
      fixture_file_upload(Rails.root.join("test/fixtures/files/test_pdf.pdf"), "application/pdf"),
      fixture_file_upload(Rails.root.join("test/fixtures/files/test_png.png"), "image/png"),
      fixture_file_upload(Rails.root.join("test/fixtures/files/test_jpg.jpg"), "image/jpg")
    ].each do |file|
      expert.cv.attach(file)

      assert expert.valid?
      expert.save
      expert.reload

      assert expert.cv.attached?
    end
  end

  test "validates wrong file format" do
    invalid_file = fixture_file_upload(Rails.root.join("test/fixtures/files/test_txt.txt"), "text/plain")
    expert = experts(:alice)

    expert.cv.attach(invalid_file)

    assert_not expert.valid?, "Experte sollte ungültig sein wegen falschem Dateiformat"
    assert_includes expert.errors[:cv], "hat einen ungültigen Dateityp"
    expert.reload
    assert_not expert.cv.attached?, "Ungültiger Lebenslauf sollte nicht angehängt werden"
  end
end
