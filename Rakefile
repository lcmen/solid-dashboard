require "bundler/setup"

APP_RAKEFILE = File.expand_path("test/dummy/Rakefile", __dir__)
load "rails/tasks/engine.rake"

require "rake/testtask"
require_relative "lib/solid_dashboard/assets"

namespace :solid_dashboard do
  namespace :assets do
    desc "Remove compiled dashboard CSS"
    task clean: :environment do
      SolidDashboard::Assets.clean
    end

    desc "Build minified dashboard CSS"
    task build: :environment do
      Rake::Task["solid_dashboard:assets:clean"].invoke unless Rails.env.development? || Rails.env.test?
      SolidDashboard::Assets.build
    end

    desc "Watch dashboard CSS sources"
    task watch: :environment do
      SolidDashboard::Assets.watch
    end
  end
end

Rake::TestTask.new(:test) do |test|
  test.libs << "test"
  test.pattern = "test/**/*_test.rb"
end

task default: :test
task test: "solid_dashboard:assets:build"
