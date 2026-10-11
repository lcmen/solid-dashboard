class FastJob < ApplicationJob
  queue_as :fast

  def perform
  end
end
