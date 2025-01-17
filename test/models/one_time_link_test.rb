require "test_helper"

class OneTimeLinkTest < ActiveSupport::TestCase
  test "assert fixtures" do
    assert OneTimeLink.count, 2
  end

  test "create otl" do
    link = OneTimeLink.create(
      token: "j37dga69c3096e28f493",
      used: false,
      expires_at: 1.day.from_now
    )

    assert link.save
    link.reload
    assert_equal link.token, "j37dga69c3096e28f493"
    assert_not link.used
  end

  test "update otl" do
    link = one_time_links(:one_time_link1)
    link.update(used: true)

    link.reload
    assert link.used
  end

  test "delete otl" do
    assert_difference("OneTimeLink.count", -1) do
      one_time_links(:one_time_link1).destroy
    end

    assert_raises ActiveRecord::RecordNotFound do
      OneTimeLink.find(one_time_links(:one_time_link1).id)
    end
  end

  test "validates required fields" do
    link = OneTimeLink.new

    assert_not link.valid?

    assert_includes link.errors.messages.keys, :token
    assert_includes link.errors.messages.keys, :used
    assert_includes link.errors.messages.keys, :expires_at
  end

  test "duplicate token" do
    assert_raises(ActiveRecord::RecordInvalid) {
      link = OneTimeLink.create!(
        token: "ac964a69c3096e28f493",
        used: false,
        expires_at: 1.day.from_now
      )
    }
  end
end
