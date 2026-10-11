require "test_helper"

class SolidDashboardTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert SolidDashboard::VERSION
  end

  test "the host application initializes integration availability" do
    assert SolidDashboard.solid_cache?
    assert SolidDashboard.solid_queue?
  end
end
