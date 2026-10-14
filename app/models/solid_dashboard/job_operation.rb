module SolidDashboard
  class JobOperation
    def initialize(id:)
      @id = id
    end

    def call(operation)
      raise ArgumentError, "Unknown job operation" unless %i[retry discard].include?(operation)

      outcome = SolidQueue::FailedExecution.transaction do
        failed = SolidQueue::FailedExecution.lock.find_by(job_id: @id)
        if failed.nil?
          SolidQueue::Job.exists?(@id) ? :changed : :missing
        else
          job = SolidQueue::Job.lock.find_by(id: @id)
          if job.nil?
            :missing
          elsif job.claimed_execution.present? || job.finished_at.present?
            :changed
          else
            (operation == :retry) ? failed.retry : failed.discard
            :success
          end
        end
      end
      log(operation, outcome)
      outcome
    rescue ActiveRecord::Deadlocked, ActiveRecord::LockWaitTimeout, ActiveRecord::RecordNotFound
      log(operation, :changed)
      :changed
    end

    private

    def log(operation, outcome)
      Rails.logger.info("solid_dashboard operation=#{operation} job_id=#{@id} outcome=#{outcome}")
    end
  end
end
