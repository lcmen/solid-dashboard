class SlowJob < ApplicationJob
  queue_as :slow

  def perform
    sleep 10
  end
end
