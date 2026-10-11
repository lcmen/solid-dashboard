require "test_helper"

class SolidDashboard::RecurringTasksControllerTest < ActionDispatch::IntegrationTest
  test "renders the recurring tasks page" do
    get "/solid-dashboard/recurring"

    assert_response :success
    assert_select "h1", "Recurring tasks"
  end
end
