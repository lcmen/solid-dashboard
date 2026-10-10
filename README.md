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

TBD

## Build

```sh
gem build solid_dashboard.gemspec
```

## Development

Install the tools and dependencies:

```sh
mise install
```

`mise install` runs `bundle install` and installs the pre-commit hook in a Git clone. The commands below assume that mise is activated in your shell.

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
