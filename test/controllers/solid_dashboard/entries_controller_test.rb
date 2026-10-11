require "test_helper"

class SolidDashboard::EntriesControllerTest < ActionDispatch::IntegrationTest
  test "renders the cache entries page" do
    get "/solid-dashboard/entries"

    assert_response :success
    assert_select "h1", "Cache entries"
  end
end
