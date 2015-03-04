require 'test_helper'

class PicdumpsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get categories" do
    get :categories
    assert_response :success
  end

  test "should get view" do
    get :view
    assert_response :success
  end

end
