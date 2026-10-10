require "fileutils"

module SolidDashboard
  module Assets
    ROOT = File.expand_path("../..", __dir__)
    DIRECTORY = File.join(ROOT, "app/assets/stylesheets/solid_dashboard")
    OUTPUT = File.join(DIRECTORY, "application.css")
    SOURCE = File.join(DIRECTORY, "tailwind.css")

    def self.build
      FileUtils.mkdir_p(DIRECTORY)
      raise "Tailwind compilation failed" unless system(*command, chdir: ROOT)
    end

    def self.clean
      FileUtils.rm_f(OUTPUT)
    end

    def self.watch
      FileUtils.mkdir_p(DIRECTORY)
      exec(*command, "--watch=always", chdir: ROOT)
    end

    def self.command
      require "tailwindcss/ruby"
      [Tailwindcss::Ruby.executable.to_s, "--input", SOURCE, "--output", OUTPUT, "--minify"]
    end

    private_class_method :command
  end
end
