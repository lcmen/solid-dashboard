require "test_helper"

class SolidDashboard::JobsControllerTest < ActionDispatch::IntegrationTest
  test "renders the jobs page" do
    get "/solid-dashboard/jobs"

    assert_response :success
  end

  test "serves job details" do
    get "/solid-dashboard/jobs/#{solid_queue_jobs(:failed).id}"

    assert_response :success
  end

  test "retries a confirmed failed job through Solid Queue" do
    assert_difference "SolidQueue::FailedExecution.count", -1 do
      assert_difference "SolidQueue::ReadyExecution.count", 1 do
        post "/solid-dashboard/jobs/#{solid_queue_jobs(:failed).id}/retry", params: {confirmed: "1"}
      end
    end

    assert_response :see_other
    assert_equal 0, solid_queue_jobs(:failed).reload.arguments["executions"]
  end

  test "discards a confirmed failed job through Solid Queue" do
    assert_difference "SolidQueue::Job.count", -1 do
      assert_difference "SolidQueue::FailedExecution.count", -1 do
        delete "/solid-dashboard/jobs/#{solid_queue_jobs(:failed).id}", params: {confirmed: "1"}
      end
    end

    assert_response :see_other
    assert_not SolidQueue::Job.exists?(solid_queue_jobs(:failed).id)
  end
end
