require "test_helper"

class SolidDashboard::JobOperationTest < ActiveSupport::TestCase
  test "uses Solid Queue lock order for concurrent failed job operations" do
    job_id = solid_queue_jobs(:failed).id
    reads = []
    subscriber = ->(_name, _start, _finish, _id, payload) do
      reads << payload[:sql] if payload[:sql].start_with?("SELECT") && payload[:sql].match?(/solid_queue_(jobs|failed_executions)/)
    end

    ActiveSupport::Notifications.subscribed(subscriber, "sql.active_record") do
      assert_equal :success, SolidDashboard::JobOperation.new(id: job_id).call(:retry)
    end

    assert_match(/FROM "solid_queue_failed_executions"/, reads.first)
    assert_match(/FROM "solid_queue_jobs"/, reads.second)
  end
end
