require "test_helper"

class UsersSessionControllerTest < ActionDispatch::IntegrationTest
    test "should get new" do
        get new_user_session_path
        assert_response :success
    end

    test "should create session expert" do
        post user_session_path, params: { user: { email: users(:user_alice).email, password: "2Secret!" } }

        assert_redirected_to expert_profile_path(users(:user_alice).expert_id)
        assert_equal "Erfolgreich angemeldet.", flash[:notice]
    end

    test "should create session staff/intern" do
        post user_session_path, params: { user: { email: users(:user_staff).email, password: "2Secret!" } }

        assert_redirected_to root_path
        assert_equal "Erfolgreich angemeldet.", flash[:notice]
    end

    test "should delete session" do
        delete destroy_user_session_path

        assert_redirected_to root_path
    end
end
