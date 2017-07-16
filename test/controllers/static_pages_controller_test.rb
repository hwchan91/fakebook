require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home for root" do
    get root_path
    assert_response :success
    assert_template "static_pages/home"
  end

end
