require "test_helper"

class SolidDashboard::JobsQueryTest < ActiveSupport::TestCase
  test "provides queues independently of list filters" do
    jobs = SolidDashboard::Jobs.new
    jobs.list(status: "failed", queue_name: "fast")

    assert_equal %w[fast slow], jobs.queues
  end

  test "counts each status separately from list filters and pagination" do
    jobs = SolidDashboard::Jobs.new
    list = jobs.list(q: "Fast", status: "failed", queue_name: "fast", per_page: 1)

    assert_equal 2, jobs.pending_count
    assert_equal 1, jobs.scheduled_count
    assert_equal 1, jobs.running_count
    assert_equal 1, jobs.finished_count
    assert_equal 1, jobs.failed_count
    assert_equal 2, jobs.retried_count
    assert_equal 1, list.total
  end

  test "combines class search with status and queue filters" do
    query = SolidDashboard::JobsQuery.new(
      q: "Fast",
      status: "failed",
      queue_name: "fast"
    )

    assert_equal solid_queue_jobs(:failed).id, query.call.first.id
    assert_equal 1, query.call.total
  end

  test "counts all retained attempts before pagination" do
    job = SolidDashboard::Job.find(solid_queue_jobs(:failed).id)
    list = SolidDashboard::JobsQuery.new(scope: job.attempts, per_page: 1).call

    assert_equal [solid_queue_jobs(:failed).id], list.map(&:id)
    assert_equal 3, list.total
    assert_equal 3, list.pages
    assert_equal 1, list.page
    assert_equal 1, list.per_page
  end

  test "returns no records for pages beyond the database integer range" do
    query = SolidDashboard::JobsQuery.new(page: "9" * 100)

    assert_empty query.call.to_a
    assert_equal SolidQueue::Job.count, query.call.total
  end
end
