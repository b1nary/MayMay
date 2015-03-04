require 'test_helper'

class UserActionsControllerTest < ActionController::TestCase
  test "should get change_name" do
    get :change_name
    assert_response :success
  end

end
