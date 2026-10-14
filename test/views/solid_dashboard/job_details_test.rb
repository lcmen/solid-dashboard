require "test_helper"

class SolidDashboard::JobDetailsTest < ActionView::TestCase
  helper SolidDashboard::Engine.routes.url_helpers
  helper SolidDashboard::JobsHelper

  test "shows escaped job arguments without exception details" do
    job = solid_queue_jobs(:failed)
    job.update!(arguments: job.arguments.merge("arguments" => ["<script>alert(1)</script>", {"recipient" => "customer@example.test"}]))
    jobs = SolidDashboard::Jobs.new
    record = jobs.find(job.id)

    render partial: "solid_dashboard/jobs/details", locals: {job: record, attempts: jobs.attempts(record)}

    assert_select "pre", text: /customer@example.test/
    assert_includes rendered, "&lt;script&gt;alert(1)&lt;/script&gt;"
    assert_select "script", count: 0
    assert_not_includes rendered, "secret-exception-message"
    assert_not_includes rendered, "secret-exception-trace"
    assert_not_includes rendered, "Job arguments, exception messages, and traces are hidden."
  end
end
