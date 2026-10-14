module SolidDashboard
  class JobsQuery < ApplicationQuery
    def initialize(scope: Job.all, q: nil, status: nil, queue_name: nil, now: Time.current, **options)
      super(scope: scope, **options)
      @q = q.to_s.strip
      @status = status.to_s
      @queue_name = queue_name.to_s
      @now = now
    end

    private

    def build_scope
      relation = super
      relation = filter_by_search(relation) if @q.present?
      relation = filter_by_queue(relation) if @queue_name.present?
      relation = filter_by_status(relation) if Job::STATUSES.include?(@status)
      relation.with_retry_status(@now).includes(:claimed_execution, :failed_execution).reorder(id: :desc)
    end

    def filter_by_queue(relation)
      relation.where(queue_name: @queue_name)
    end

    def filter_by_search(relation)
      search = "%#{ActiveRecord::Base.sanitize_sql_like(@q, "!")}%"
      if @q.match?(/\A[0-9]+\z/)
        relation.where("class_name LIKE ? ESCAPE '!' OR solid_queue_jobs.id = ?", search, @q.to_i)
      else
        relation.where("class_name LIKE ? ESCAPE '!'", search)
      end
    end

    def filter_by_status(relation)
      case @status
      when "pending", "scheduled"
        relation.public_send(@status, @now)
      else
        relation.public_send(@status)
      end
    end
  end
end
