module SolidDashboard
  class Jobs
    def initialize
      @now = Time.current
    end

    def find(id)
      scope.with_retry_status(@now).includes(:claimed_execution, :failed_execution).find(id)
    end

    def list(q: nil, status: nil, queue_name: nil, page: 1, per_page: 25)
      JobsQuery.new(scope: scope, q: q, status: status, queue_name: queue_name, page: page, per_page: per_page, now: @now).call
    end

    def attempts(job, page: 1, per_page: 25)
      JobsQuery.new(scope: job.attempts, page: page, per_page: per_page, now: @now).call
    end

    def queues
      @queues ||= scope.distinct.reorder(:queue_name).pluck(:queue_name)
    end

    def pending_count
      @pending_count ||= scope.pending(@now).count
    end

    def scheduled_count
      @scheduled_count ||= scope.scheduled(@now).count
    end

    def running_count
      @running_count ||= scope.running.count
    end

    def finished_count
      @finished_count ||= scope.finished.count
    end

    def failed_count
      @failed_count ||= scope.failed.count
    end

    def retried_count
      @retried_count ||= scope.retried.count
    end

    private

    def scope
      @scope ||= Job.all
    end
  end
end
