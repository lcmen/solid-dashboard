class JobsController < ApplicationController
  def create_slow
    SlowJob.perform_later
    redirect_to root_path, notice: "Slow job enqueued."
  end

  def create_fast
    FastJob.perform_later
    redirect_to root_path, notice: "Fast job enqueued."
  end
end
