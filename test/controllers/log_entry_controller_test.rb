require 'test_helper'

class LogEntryControllerTest < ActionDispatch::IntegrationTest
  test "should get replay" do
    get log_entry_replay_url
    assert_response :success
  end

end
