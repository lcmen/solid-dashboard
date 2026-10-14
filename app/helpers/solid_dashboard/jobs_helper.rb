module SolidDashboard
  module JobsHelper
    def job_status_label(job)
      job.status.capitalize
    end

    def job_status_class(job)
      (job.status == "failed") ? "badge-danger" : "badge-gray"
    end

    def formatted_job_arguments(job)
      JSON.pretty_generate(job.arguments&.fetch("arguments", []) || [])
    end
  end
end
