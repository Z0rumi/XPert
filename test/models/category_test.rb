require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "assert fixtures" do
    assert Category.count, 2
  end

  test "create category" do
    category = Category.create(
      name: "Aus- und Weiterbildung"
    )

    assert category.save
    category.reload
    assert_equal category.name, "Aus- und Weiterbildung"
  end

  test "update category" do
    category = categories(:industrie_4_0)
    category.update(name: "Aus- und Weiterbildung")

    category.reload
    assert_equal category.name, "Aus- und Weiterbildung"
  end

  test "delete category" do
    assert_difference("Category.count", -1) do
      categories(:industrie_4_0).destroy
    end

    assert_raises ActiveRecord::RecordNotFound do
      Category.find(categories(:industrie_4_0).id)
    end
  end

  test "validates required fields" do
    category = Category.new

    assert_not category.valid?

    assert_includes category.errors.messages.keys, :name
  end

  test "expert not deleted on category deletion" do
    assert_no_difference("Expert.count") do
      assert categories(:industrie_4_0).destroy
    end
  end
end
