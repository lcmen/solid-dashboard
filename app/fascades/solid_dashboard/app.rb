module SolidDashboard
  class App
    def jobs
      @jobs ||= Jobs.new
    end
  end
end
