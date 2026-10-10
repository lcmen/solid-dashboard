# Solid Dashboard

A Rails dashboard for the Solid trifecta. Initial development will focus on Solid Queue and Solid Cache. Solid Cable support is planned for later.

This gem contains a mountable Rails engine. Dashboard features are not available yet. Rails 8.1 is required.

## Installation

After the gem is published, add it to your application's Gemfile:

```ruby
gem "solid_dashboard", "0.1.0.alpha1"
```

Then run `bundle install`. If your host has no asset pipeline, add `gem "propshaft"` to its Gemfile first. Existing Sprockets hosts can keep Sprockets.

## Usage

Mount the engine in your application's `config/routes.rb`:

```ruby
mount SolidDashboard::Engine, at: "/solid_dashboard"
```

The engine provides the main layout and sidebar pages. The pages display headings only. Configure authentication and authorization in the host application before exposing the dashboard. The host must use Propshaft or Sprockets. The gem includes compiled CSS, so the host does not need Tailwind, Node.js, or a dashboard build step.

The engine uses `stylesheet_link_tag "solid_dashboard/application"`. Rails discovers its conventional asset directories. Sprockets receives an `assets.precompile` entry, so the host does not need to add dashboard CSS to its manifest. Propshaft publishes the CSS from its asset paths. Run the host's normal `assets:precompile` command during deployment; the pipeline handles fingerprints, its manifest, and asset URLs.

## Build

```sh
SECRET_KEY_BASE_DUMMY=1 RAILS_ENV=production bundle exec rake solid_dashboard:assets:build
gem build solid_dashboard.gemspec
```

## Development

Install the tools and dependencies:

```sh
mise install
```

`mise install` runs `bundle install` and installs the pre-commit hook in a Git clone. The commands below assume that mise is activated in your shell.

Start Rails and the CSS watcher with `mise run development`. The default port is 3000. To change the binding and port, use `BINDING=0.0.0.0 PORT=3001 mise run development`. Foreman stops both processes when one exits or when you press Ctrl-C.

Open `http://localhost:3000/solid-dashboard` to view the main layout and sidebar. The engine defines the main page and all sidebar routes. These pages display headings without backend data; the dummy host only mounts the engine.

The launcher uses `RAILS_ENV=development`. Foreman starts Rails and the CSS watcher together. The watcher builds CSS when it starts and rebuilds it when source files change. Rails does not wait for the initial CSS build to finish. The watcher updates the same engine CSS file that the host pipeline reads. There is no custom asset mode or temporary development stylesheet.

Tailwind comes from the development Gemfile. `Gemfile.lock` fixes the compiler version. Foreman comes from mise. Neither tool is a runtime gem dependency. The CSS source scans only engine views and helpers. Use complete class names so Tailwind can find them.

After an asset source or compiler change, build and commit the output:

```sh
bundle exec rake solid_dashboard:assets:build
git add app/assets app/views app/helpers Gemfile Gemfile.lock
git commit
```

The build compiles `app/assets/stylesheets/solid_dashboard/tailwind.css` to minified `app/assets/stylesheets/solid_dashboard/application.css`. Source and compiled CSS share the engine stylesheet directory, as in Solid Queue Dashboard. Propshaft publishes both files; the layout loads only compiled CSS. Sprockets precompiles only the registered dashboard output. Outside development and test, the build task first invokes `solid_dashboard:assets:clean`, which removes only the compiled stylesheet. A failed build can leave the compiled stylesheet unavailable. Use the clean task separately when needed. Run the production build before packaging or release, and commit updated compiled CSS when its output changes. Use `bundle exec rake solid_dashboard:assets:watch` to run the watcher separately.

Run the engine tests with both host pipelines:

```sh
bundle exec rake test
ASSET_PIPELINE=sprockets bundle exec rake test
```

The test task builds CSS first. The dummy host uses Propshaft by default. The current test checks the gem version. Asset and layout integration tests are not included yet.

Run the linter or fix formatting:

```sh
mise run lint
mise run fix
```

The pre-commit hook runs Standard Ruby. GitHub CI checks all files with hk, loads the gem, and builds it. Dependabot checks Bundler dependencies and GitHub Actions each week.

## Release

Install the GitHub CLI (`gh`) and authenticate it with `gh auth login`. RubyGems credentials are also required; `gem push` requests authentication if needed.

Set the release version in `lib/solid_dashboard/version.rb`. Commit and push the release code, and confirm that CI passes. Then run:

```sh
mise run release
```

The release task reads the version from the gem, builds the gem, creates an annotated `v` tag for the current commit, and pushes the tag to `origin`. It attaches the gem to a GitHub release, generates release notes, and then pushes the same gem to RubyGems.org. Alpha and other prerelease versions are marked as GitHub prereleases. Tag creation fails if the local tag already exists.

To add text before the generated release notes:

```sh
mise run release "Your release notes"
```

If the RubyGems push fails after the GitHub release is created, retry only the push, using the same version:

```sh
version=$(ruby -Ilib -rsolid_dashboard -e 'print SolidDashboard::VERSION')
gem push "solid_dashboard-$version.gem" --host https://rubygems.org
```

## License

MIT. See [LICENSE](LICENSE).
