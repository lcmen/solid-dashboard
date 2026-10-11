require_relative "lib/solid_dashboard/version"

Gem::Specification.new do |spec|
  spec.name = "solid_dashboard"
  spec.version = SolidDashboard::VERSION
  spec.authors = ["Lucas Mendelowski"]
  spec.license = "MIT"
  spec.summary = "A Rails dashboard for Solid Queue and Solid Cache."
  spec.description = "A Rails dashboard for Solid Queue and Solid Cache."
  spec.files = Dir["app/**/*", "config/**/*", "lib/**/*", "README.md", "LICENSE"].select { |path| File.file?(path) }
  spec.require_paths = ["lib"]
  spec.add_dependency "rails", ">= 8.0", "< 9.0"
end
