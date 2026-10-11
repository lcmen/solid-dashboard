# Solid Dashboard

A mountable Rails dashboard for Solid Queue and Solid Cache. The dashboard is in early development and currently provides its layout and navigation. Rails 8 is required.

## Installation

Add the gem to your application's Gemfile:

```ruby
gem "solid_dashboard", "0.1.0.alpha1"
```

Run `bundle install`. The host application must use Propshaft or Sprockets. Add `gem "propshaft"` if it has no asset pipeline.

## Usage

Mount the engine in `config/routes.rb`:

```ruby
mount SolidDashboard::Engine, at: "/solid_dashboard"
```

The current pages show headings only. Configure authentication and authorization before exposing the dashboard. The gem includes compiled CSS; the host needs no Tailwind or Node.js build step. Use the host's normal `assets:precompile` command during deployment.

## Build

```sh
SECRET_KEY_BASE_DUMMY=1 RAILS_ENV=production bundle exec rake solid_dashboard:assets:build
gem build solid_dashboard.gemspec
```

## Development

Install the development tools and dependencies:

```sh
mise install
```

The setup installs Ruby and npm dependencies, then installs the commit hook.

Start Rails and the CSS watcher:

```sh
mise run development
```

Open `http://localhost:3000/solid-dashboard`. To change the bind address or port, set `BINDING` and `PORT`.

Run tests with both asset pipelines:

```sh
bundle exec rake test
ASSET_PIPELINE=sprockets bundle exec rake test
```

Use the version-specific Gemfiles to test Rails 8.0 and 8.1. Run `BUNDLE_GEMFILE=gemfiles/rails_8.0.gemfile bundle install`, then `BUNDLE_GEMFILE=gemfiles/rails_8.0.gemfile bundle exec rake test`. Use `rails_8.1.gemfile` for Rails 8.1. The version-specific lockfiles are generated locally and are not committed.

Run lint or format the code:

```sh
mise run lint
mise run fix
```

## Release

Set the version in `lib/solid_dashboard/version.rb`, push the release commit, and confirm CI passes. Authenticate the GitHub CLI and RubyGems, then run:

```sh
mise run release
```

Pass optional text to prepend to the generated release notes:

```sh
mise run release "Your release notes"
```

## License

MIT. See [LICENSE](LICENSE).
