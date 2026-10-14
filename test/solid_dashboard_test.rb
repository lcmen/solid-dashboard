require "test_helper"
require "open3"

class SolidDashboardTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert SolidDashboard::VERSION
  end

  test "the host application initializes integration availability" do
    assert SolidDashboard.solid_cache?
    assert SolidDashboard.solid_queue?
  end

  test "loads the read-only Job model when Solid Queue is absent" do
    script = <<~RUBY
      require "bundler/setup"
      require "active_record"
      require "active_support/core_ext/string/filters"
      require_relative "app/models/solid_dashboard/application_record"
      require_relative "app/models/concerns/solid_dashboard/preventable"
      require_relative "app/models/solid_dashboard/job"
    RUBY

    _output, error, status = Open3.capture3(RbConfig.ruby, "-e", script, chdir: SolidDashboard::Engine.root.to_s)

    assert status.success?, error
  end
end
