require "test_helper"

class UsersRegistrationControllerTest < ActionDispatch::IntegrationTest
    test "should get new" do
        get new_user_registration_path(token: one_time_links(:one_time_link1).token)
        assert_response :success
    end

    test "should not get new invalid token" do
        get new_user_registration_path
        assert_redirected_to root_path
    end

    test "should get one time link form" do
        sign_in users(:user_staff)

        get one_time_link_form_path
        assert_response :success
    end

    test "should get edit_password" do
        sign_in users(:user_alice)

        get edit_password_path
        assert_response :success
    end

    test "should get edit_email" do
        sign_in users(:user_alice)

        get edit_email_path
        assert_response :success
    end

    test "should create user" do
        assert_difference("User.count") do
            post user_registration_path, params: { user: {
              email: "daniel@testinger.de",
              password: "2Secret!",
              password_confirmation: "2Secret!",
              token: one_time_links(:one_time_link1).token
            } }
            end

        assert_redirected_to new_expert_path
    end

    test "should update password" do
        @user = users(:user_alice)
        sign_in @user
        patch user_registration_path, params: { user: { password: "newPass", password_confirmation: "newPass", current_password: "2Secret!" } }
        assert @user.reload.valid_password?("newPass"), "Passwort Änderung fehlgeschlagen"
    end

    test "should update email" do
        @user = users(:user_alice)
        sign_in @user
        patch user_registration_path, params: { user: { email: "new@mail.de", current_password: "2Secret!" } }
        assert_equal "new@mail.de", @user.reload.email
    end

    test "should delete user" do
        sign_in users(:user_alice)
        assert_difference("User.count", -1) do
            delete user_registration_path(users(:user_alice))
        end
    end

    test "should send one time link" do
        post one_time_link_path

        assert_match "Einmallink wurde erfolgreich versendet.", flash[:notice]
    end

    test "expert should not create one time link" do
        sign_in users(:user_alice)

        post one_time_link_path

        assert_redirected_to expert_profile_path(users(:user_alice).expert.id)
        assert_equal "Sie haben nicht die benötigten Berechtigungen, um diese Aktion auszuführen.", flash[:notice]
    end

    test "intern should not create one time link" do
        sign_in users(:user_intern)

        post one_time_link_path

        assert_redirected_to root_path
        assert_equal "Sie haben nicht die benötigten Berechtigungen, um diese Aktion auszuführen.", flash[:notice]
    end

    test "intern cant delete user" do
        sign_in users(:user_intern)

        assert_no_difference("User.count") do
            delete user_registration_path(users(:user_bob))
        end
        assert_equal "Sie haben nicht die benötigten Berechtigungen, um diese Aktion auszuführen.", flash[:notice]
    end

    test "staff cant delete user" do
        sign_in users(:user_staff)

        assert_no_difference("User.count") do
            delete user_registration_path(users(:user_bob))
        end
        assert_equal "Sie haben nicht die benötigten Berechtigungen, um diese Aktion auszuführen.", flash[:notice]
    end
end
