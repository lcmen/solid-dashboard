require "test_helper"

class SolidDashboard::JobsTest < ActiveSupport::TestCase
  setup do
    @jobs = SolidDashboard::Jobs.new
  end

  test "classifies multiple retained attempts without duplicating jobs" do
    first_page = @jobs.list(status: "retried", per_page: 1)
    second_page = @jobs.list(status: "retried", page: 2, per_page: 1)

    assert_equal [solid_queue_jobs(:retried).id], first_page.map(&:id)
    assert_equal [solid_queue_jobs(:oldest_attempt).id], second_page.map(&:id)
    assert_equal ["retried"], second_page.map(&:status)
    assert_equal 2, first_page.total
    assert_equal 2, first_page.pages
    assert_equal 2, @jobs.retried_count
    assert_equal [solid_queue_jobs(:completed).id], @jobs.list(status: "finished").map(&:id)
    assert_equal 1, @jobs.finished_count

    attempts = @jobs.attempts(@jobs.find(solid_queue_jobs(:failed).id))

    assert_equal [solid_queue_jobs(:failed).id, solid_queue_jobs(:retried).id, solid_queue_jobs(:oldest_attempt).id], attempts.map(&:id)
    assert_equal 3, attempts.total
  end

  test "returns a filtered paginated collection of read-only jobs" do
    list = @jobs.list(q: "Fast", status: "failed", queue_name: "fast", page: "1", per_page: "1")

    assert_instance_of SolidDashboard::PaginatedList, list
    assert_equal [solid_queue_jobs(:failed).id], list.map(&:id)
    assert_instance_of SolidDashboard::Job, list.first
    assert list.first.readonly?
    assert_equal "failed", list.first.status
    assert_equal 1, list.page
    assert_equal 1, list.pages
    assert_equal 1, list.total
    assert_equal 1, list.per_page
    assert_not list.empty?
  end

  test "finds a read-only job and paginates its retained attempts through the facade" do
    job = @jobs.find(solid_queue_jobs(:failed).id)
    attempts = @jobs.attempts(job, page: "2", per_page: "1")

    assert_instance_of SolidDashboard::Job, job
    assert job.readonly?
    assert_equal solid_queue_jobs(:failed).id, job.id
    assert_equal solid_queue_jobs(:failed).to_param, job.to_param
    assert_equal "failed", job.status
    assert_instance_of SolidDashboard::PaginatedList, attempts
    assert_equal [solid_queue_jobs(:retried).id], attempts.map(&:id)
    assert_instance_of SolidDashboard::Job, attempts.first
    assert attempts.first.readonly?
    assert_equal ["retried"], attempts.map(&:status)
    assert_equal 2, attempts.page
    assert_equal 3, attempts.pages
    assert_equal 3, attempts.total
    assert_equal 1, attempts.per_page
  end

  test "provides status counts and queue choices independently of list filters" do
    list = @jobs.list(q: "Fast", status: "failed", queue_name: "fast", per_page: 1)

    assert_equal 1, list.total
    assert_equal 2, @jobs.pending_count
    assert_equal 1, @jobs.scheduled_count
    assert_equal 1, @jobs.running_count
    assert_equal 1, @jobs.finished_count
    assert_equal 1, @jobs.failed_count
    assert_equal 2, @jobs.retried_count
    assert_equal %w[fast slow], @jobs.queues
  end

  test "uses the same time for status filters counts and display" do
    scheduled = solid_queue_jobs(:scheduled)
    list = @jobs.list(status: "scheduled")

    assert_equal 1, @jobs.scheduled_count

    travel_to(scheduled.scheduled_at + 1.second) do
      assert_equal [scheduled.id], list.map(&:id)
      assert_equal ["scheduled"], list.map(&:status)
      assert_equal 1, @jobs.scheduled_count
      assert_equal "scheduled", @jobs.find(scheduled.id).status
    end
  end
end
