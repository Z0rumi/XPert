require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "assert fixtures" do
    assert User.count, 5
    assert_equal users(:user_alice).expert, experts(:alice)
    assert_equal users(:user_bob).expert, experts(:bob)
  end

  test "create user" do
    user = User.create(
      email: "daniel@testinger.de",
      password: "2Secret!",
      password_confirmation: "2Secret!"
    )

    assert user.save
    user.reload
    assert_equal user.email, "daniel@testinger.de"
  end

  test "update user" do
    user = users(:user_alice)
    user.update(email: "daniel@testinger2.de")

    user.reload
    assert_equal user.email, "daniel@testinger2.de"
  end

  test "update user expert" do
    user = users(:user_maurice)
    user.update(expert: experts(:maurice))

    user.reload
    assert_equal user.expert, experts(:maurice)
  end

  test "delete user" do
    assert_difference("User.count", -1) do
      users(:user_alice).destroy
    end

    assert_raises ActiveRecord::RecordNotFound do
      User.find(users(:user_alice).id)
    end
  end

  test "invalid email" do
    [
      "",
      "1@1.1",
      "Test@",
      "@test.de",
      "test12@test12.de123",
      "Test"
    ].each do |email|
      user = users(:user_alice)
      assert_raises(ActiveRecord::RecordInvalid) {
        user.update!(email: email)
      }
    end
  end

  test "duplicate email" do
    assert_raises(ActiveRecord::RecordInvalid) {
      User.create!(
        email: "alice@test.com",
        password: "2Secret!",
        password_confirmation: "2Secret!"
      )
    }
  end

  test "invalid password" do
    [
      "",
      "12345" # too short
    ].each do |password|
      assert_raises(ActiveRecord::RecordInvalid) {
        User.create!(
          email: "new@test.com",
          password: password,
          password_confirmation: password
        )
      }
    end
  end

  test "default role is expert" do
    user = User.create(
      email: "daniel@testinger.de",
      password: "2Secret!",
      password_confirmation: "2Secret!"
    )

    assert user.save
    user.reload
    assert_equal user.role, "expert"
  end

  test "default initiated is false" do
    user = User.create(
      email: "daniel@testinger.de",
      password: "2Secret!",
      password_confirmation: "2Secret!"
    )

    assert user.save
    user.reload
    assert_not user.initiated
  end

  test "cant update last admin role" do
    user = users(:user_admin)
    user.update(role: "staff")

    user.reload
    assert_equal user.role, "admin"
  end

  test "cant update last staff role" do
    user = users(:user_staff)
    user.update(role: "admin")

    user.reload
    assert_equal user.role, "staff"
  end

  test "cant update last intern role" do
    user = users(:user_intern)
    user.update(role: "staff")

    user.reload
    assert_equal user.role, "intern"
  end

  test "cant delete last admin" do
    admin = users(:user_admin)

    assert_no_difference("User.count") do
      admin.destroy
    end

    assert_includes admin.errors.full_messages, "Es muss mindestens ein Benutzer mit der Rolle Admin existieren."
  end

  test "cant delete last staff" do
    staff = users(:user_staff)

    assert_no_difference("User.count") do
      staff.destroy
    end

    assert_includes staff.errors.full_messages, "Es muss mindestens ein Benutzer mit der Rolle Mitarbeiter existieren."
  end

  test "cant delete last intern" do
  intern = users(:user_intern)

    assert_no_difference("User.count") do
      intern.destroy
    end

    assert_includes intern.errors.full_messages, "Es muss mindestens ein Benutzer mit der Rolle Praktikant existieren."
  end
end
