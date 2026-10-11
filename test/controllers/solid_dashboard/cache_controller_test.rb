require "test_helper"

class SolidDashboard::CacheControllerTest < ActionDispatch::IntegrationTest
  test "renders the cache analytics page" do
    get "/solid-dashboard/cache"

    assert_response :success
    assert_select "h1", "Cache analytics"
  end
end
