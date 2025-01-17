require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "send_otl" do
    mail = UserMailer.send_otl("to@example.org", "test/url")
    assert_equal "Registrierung bei XPert", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_match "Hallo!", mail.body.encoded
  end
end
