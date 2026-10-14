require "test_helper"

class SolidDashboard::JobTest < ActiveSupport::TestCase
  test "shares status scopes and retry flags for dashboard reads" do
    expected = {
      "pending" => [solid_queue_jobs(:pending).id, solid_queue_jobs(:blocked).id],
      "scheduled" => [solid_queue_jobs(:scheduled).id],
      "running" => [solid_queue_jobs(:running).id],
      "finished" => [solid_queue_jobs(:completed).id],
      "failed" => [solid_queue_jobs(:failed).id],
      "retried" => [solid_queue_jobs(:oldest_attempt).id, solid_queue_jobs(:retried).id]
    }

    expected.each do |status, ids|
      records = SolidDashboard::Job.public_send(status).with_retry_status.includes(:claimed_execution, :failed_execution)

      assert_equal ids.sort, records.map(&:id).sort
      records.each do |record|
        assert_equal status, record.status
      end
    end
  end
end
