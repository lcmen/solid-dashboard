if Rails.env.development?
  logger = ActiveSupport::BroadcastLogger.new(
    Rails.logger,
    ActiveSupport::Logger.new($stdout)
  )
  Rails.application.config.solid_queue.logger = logger
  SolidQueue.logger = logger
  ActiveJob::Base.logger = logger
end
