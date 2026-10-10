require_relative "lib/solid_dashboard/version"

Gem::Specification.new do |spec|
  spec.name = "solid_dashboard"
  spec.version = SolidDashboard::VERSION
  spec.authors = ["Lucas Mendelowski"]
  spec.license = "MIT"
  spec.summary = "A Rails dashboard for Solid Queue and Solid Cache."
  spec.description = "A dashboard for the Solid trifecta, starting with Solid Queue and Solid Cache."
  spec.files = Dir["lib/**/*.rb", "README.md", "LICENSE"]
  spec.require_paths = ["lib"]
end
