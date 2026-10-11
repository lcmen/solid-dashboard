require "test_helper"

class SolidDashboard::ProcessesControllerTest < ActionDispatch::IntegrationTest
  test "renders the processes page" do
    get "/solid-dashboard/processes"

    assert_response :success
    assert_select "h1", "Processes"
  end
end
