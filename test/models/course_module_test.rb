require "test_helper"

class CourseModuleTest < ActiveSupport::TestCase
  test "assert fixtures" do
    assert CourseModule.count, 2
  end

  test "create course module" do
    course_module = CourseModule.create(
      name: "Kurs XYZ",
      description: "Kurs XYZ ist ein Testkursmodul"
    )

    assert course_module.save
    course_module.reload
    assert_equal course_module.name, "Kurs XYZ"
    assert_equal course_module.description, "Kurs XYZ ist ein Testkursmodul"
  end

  test "update course module" do
    course_module = course_modules(:course_abc)
    course_module.update(name: "Kurs DEF")

    course_module.reload
    assert_equal course_module.name, "Kurs DEF"
  end

  test "delete course module" do
    assert_difference("CourseModule.count", -1) do
      course_modules(:course_abc).destroy
    end

    assert_raises ActiveRecord::RecordNotFound do
      CourseModule.find(course_modules(:course_abc).id)
    end
  end

  test "validates required fields" do
    course_module = CourseModule.new

    assert_not course_module.valid?

    assert_includes course_module.errors.messages.keys, :name
    assert_includes course_module.errors.messages.keys, :description
  end

  test "expert not deleted on course module deletion" do
    assert_no_difference("Expert.count") do
      assert course_modules(:course_abc).destroy
    end
  end
end
