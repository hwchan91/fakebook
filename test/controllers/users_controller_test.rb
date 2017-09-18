require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    def setup
        @michael = users(:michael)
        @archer = users(:archer)
    end

    test "signing in" do
        get sign_in_path
        post user_session_path, params: { user: { email: @michael.email,
                                                  password: "password",
                                                  remember_me: 0 } }
        assert_redirected_to root_url
        follow_redirect!
        assert_select "a[href=?]", requests_path
    end
end
