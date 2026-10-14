module SolidDashboard
  class JobsController < ApplicationController
    before_action :check_backend

    def index
      @jobs = app.jobs.list(**query_parameters)
    end

    def show
      @job = app.jobs.find(params[:id])
      @attempts = app.jobs.attempts(@job, page: params[:page], per_page: params[:per_page])
    end

    def retry
      perform_operation(:retry)
    end

    def destroy
      perform_operation(:discard)
    end

    private

    def query_parameters
      params.permit(:q, :status, :queue_name, :page, :per_page).to_h.symbolize_keys
    end

    def check_backend
      @unavailable_reason = Backend.new(:queue).unavailable_reason
      render :unavailable, status: :service_unavailable if @unavailable_reason
    end

    def perform_operation(operation)
      unless params[:confirmed] == "1"
        Rails.logger.info("solid_dashboard operation=#{operation} job_id=#{params[:id].to_i} outcome=unconfirmed")
        return redirect_to job_path(params[:id]), alert: "Confirm the job operation first.", status: :see_other
      end

      outcome = JobOperation.new(id: params[:id].to_i).call(operation)
      message = case outcome
      when :success then (operation == :retry) ? "Job retry requested." : "Job discarded."
      when :missing then "The job is no longer available."
      else "The job state changed. Only failed jobs can be retried or discarded."
      end
      redirect_to jobs_path, status: :see_other, notice: message
    end
  end
end
