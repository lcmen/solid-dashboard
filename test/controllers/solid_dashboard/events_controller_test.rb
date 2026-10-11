require "test_helper"

class SolidDashboard::EventsControllerTest < ActionDispatch::IntegrationTest
  test "renders the cache events page" do
    get "/solid-dashboard/events"

    assert_response :success
    assert_select "h1", "Cache events"
  end
end
