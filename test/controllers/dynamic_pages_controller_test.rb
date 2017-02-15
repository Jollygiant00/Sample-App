require 'test_helper'

class DynamicPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get browse" do
    get dynamic_pages_browse_url
    assert_response :success
  end

  test "should get item" do
    get dynamic_pages_item_url
    assert_response :success
  end

end
