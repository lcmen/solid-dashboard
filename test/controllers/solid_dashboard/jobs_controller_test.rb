require "test_helper"

class SolidDashboard::JobsControllerTest < ActionDispatch::IntegrationTest
  test "renders the jobs page" do
    get "/solid-dashboard/jobs"

    assert_response :success
    assert_select "h1", "Jobs"
  end
end
