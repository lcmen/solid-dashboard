module SolidDashboard
  class Backend
    VERSIONS = {queue: "1.7.0", cache: "1.0.10"}.freeze
    TABLES = {
      queue: %w[solid_queue_jobs solid_queue_ready_executions solid_queue_claimed_executions solid_queue_failed_executions solid_queue_scheduled_executions solid_queue_blocked_executions],
      cache: %w[solid_cache_entries]
    }.freeze

    def initialize(name)
      @name = name
    end

    def unavailable_reason
      label = "Solid #{@name.to_s.capitalize}"
      return "#{label} is not loaded." unless SolidDashboard.public_send("solid_#{@name}?")

      version = Gem.loaded_specs["solid_#{@name}"]&.version&.to_s
      return "#{label} version #{version || "unknown"} is not supported. Use #{VERSIONS.fetch(@name)}." unless version == VERSIONS.fetch(@name)

      model = (@name == :queue) ? SolidQueue::Record : SolidCache::Record
      model.connection_pool.with_connection do |connection|
        missing = TABLES.fetch(@name).reject { |table| connection.data_source_exists?(table) }
        return "#{label} tables are missing: #{missing.join(", ")}." if missing.any?
      end
      nil
    rescue ActiveRecord::ActiveRecordError => error
      Rails.logger.warn("solid_dashboard backend=#{@name} outcome=unavailable error=#{error.class.name}")
      "#{label} database is unavailable."
    end
  end
end
