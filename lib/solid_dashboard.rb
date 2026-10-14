require_relative "solid_dashboard/version"
require_relative "solid_dashboard/engine"

module SolidDashboard
  mattr_accessor :solid_queue, :solid_cache, default: false

  def self.app
    App.new
  end

  def self.solid_cache?
    solid_cache
  end

  def self.solid_queue?
    solid_queue
  end
end
