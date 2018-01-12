require 'test_helper'

class PhonebuzzControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get phonebuzz_index_url
    assert_response :success
  end

end
