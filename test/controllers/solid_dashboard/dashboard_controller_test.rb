require "test_helper"

class SolidDashboard::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "renders the overview page" do
    get "/solid-dashboard"

    assert_response :success
    assert_select "h1", "Overview"
  end
end
