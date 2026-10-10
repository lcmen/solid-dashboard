# Solid Dashboard

A Rails dashboard for the Solid trifecta. Initial development will focus on Solid Queue and Solid Cache. Solid Cable support is planned for later.

This release contains the gem version only. Dashboard features are not available yet.

## Installation

After the gem is published, add it to your application's Gemfile:

```ruby
gem "solid_dashboard", "0.1.0.alpha1"
```

Then run `bundle install`.

## Usage

```ruby
require "solid_dashboard"

SolidDashboard::VERSION
```

## Build

```sh
gem build solid_dashboard.gemspec
```

## Development

Install the tools and dependencies:

```sh
mise install
mise exec -- bundle install
```

In a Git clone, `mise install` also installs the pre-commit hook.

Run the linter or fix formatting:

```sh
mise run lint
mise run fix
```

The pre-commit hook runs Standard Ruby. Dependabot checks Bundler dependencies and GitHub Actions each week.
