module SolidDashboard
  class Job < (defined?(SolidQueue::Job) ? SolidQueue::Job : ApplicationRecord)
    include Preventable

    self.table_name = "solid_queue_jobs"

    # Constants
    # ===============================

    STATUSES = %w[pending scheduled running finished failed retried].freeze

    # Attributes
    # ===============================

    attribute :dashboard_now, ActiveRecord::Type::DateTime.new

    prevent :dispatch,
      :dispatch_bypassing_concurrency_limits,
      :prepare_for_execution,
      :discard,
      :retry,
      :failed_with,
      :finished!,
      :reset_execution_counters,
      :unblock_next_blocked_job,
      :delete,
      :destroy,
      :destroy!

    # Scopes
    # ===============================

    scope :running, -> { where(id: SolidQueue::ClaimedExecution.select(:job_id)) }
    scope :failed, -> { where.not(id: SolidQueue::ClaimedExecution.select(:job_id)).where(id: SolidQueue::FailedExecution.select(:job_id)) }
    scope :unclaimed, -> { where.not(id: SolidQueue::ClaimedExecution.select(:job_id)).where.not(id: SolidQueue::FailedExecution.select(:job_id)) }
    scope :completed, -> { unclaimed.where.not(finished_at: nil) }
    scope :unfinished, -> { unclaimed.where(finished_at: nil) }
    scope :pending, ->(now = Time.current) { unfinished.where("scheduled_at <= ? OR scheduled_at IS NULL", now) }
    scope :scheduled, ->(now = Time.current) { unfinished.where("scheduled_at > ?", now) }
    scope :finished, -> {
      completed.where.not(id: unscoped.with_newer_attempts.select(:id))
    }
    scope :retried, -> {
      completed.where(id: unscoped.with_newer_attempts.select(:id))
    }
    scope :with_retry_status, ->(now = Time.current) {
      timestamp = connection_pool.with_connection { |connection| connection.quote(now) }
      newer_ids = unscoped.with_newer_attempts.select(:id)
      retry_flag = arel_table[:id].in(newer_ids.arel)

      select("solid_queue_jobs.*", retry_flag.as("dashboard_retried"), "#{timestamp} AS dashboard_now")
    }

    # Associations
    # ===============================

    has_many :related_attempts, class_name: name, primary_key: :active_job_id, foreign_key: :active_job_id

    def self.with_newer_attempts
      related = arel_table.alias("related_attempts")
      active_job_id = Arel::Nodes::NamedFunction.new("TRIM", [arel_table[:active_job_id]])

      joins(:related_attempts)
        .where.not(related_attempts: {id: nil})
        .where(related[:id].gt(arel_table[:id]))
        .where(active_job_id.not_eq(""))
        .distinct
    end

    def readonly?
      true
    end

    def status
      if claimed_execution.present?
        "running"
      elsif failed_execution.present?
        "failed"
      elsif finished_at.present?
        retried? ? "retried" : "finished"
      elsif scheduled_at && scheduled_at > (dashboard_now || Time.current)
        "scheduled"
      else
        "pending"
      end
    end

    def attempts
      active_job_id.present? ? related_attempts : self.class.where(id: id)
    end

    private

    def retried?
      return false unless finished_at.present? && active_job_id.present?
      return ActiveModel::Type::Boolean.new.cast(self[:dashboard_retried]) if has_attribute?(:dashboard_retried)

      attempts.where("id > ?", id).exists?
    end
  end
end
