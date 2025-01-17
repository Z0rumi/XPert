require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in users(:user_staff)
    get root_path
    assert_response :success
  end
end
