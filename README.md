# Solid Dashboard

A mountable Rails engine for Solid Queue and Solid Cache. The current release provides a responsive layout and navigation for the planned dashboard pages. The page content is still in development. Solid Dashboard supports Rails 8.0 and 8.1.

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

The engine provides Overview, Jobs, Processes, Recurring tasks, Cache analytics, Cache entries, and Cache events navigation. These pages currently show their headings only; they do not read or change Solid Queue or Solid Cache data. Protect the mounted engine with the host application's authentication and authorization. The gem includes compiled CSS and JavaScript, so the host does not need Tailwind or Node.js to run it. Use the host's normal `assets:precompile` command during deployment.

## Build

```sh
npm ci
npm run build
gem build solid_dashboard.gemspec
```

The build command compiles Tailwind v4 with the forms plugin and Bootboat, then bundles Alpine with esbuild. Node.js and npm are required only for gem development and release builds.

## Development

Install the development tools and dependencies:

```sh
mise install
```

The setup installs Ruby and npm dependencies, then installs the commit hook.

Start Rails and the CSS and JavaScript watchers:

```sh
mise run development
```

Open `http://localhost:3000/solid-dashboard`. To change the bind address or port, set `BINDING` and `PORT`.

Build the assets, then run tests with both asset pipelines:

```sh
npm run build
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
