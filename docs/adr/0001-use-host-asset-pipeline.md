# Use the host asset pipeline

Solid Dashboard includes compiled CSS in the gem and uses the host application's Propshaft or Sprockets pipeline to publish assets, create fingerprints and manifests, and resolve asset URLs. We selected this approach to use Rails conventions and remove custom asset routes, serving code, and fingerprint management. This replaces the earlier requirement to work without a host asset pipeline; the host now needs a pipeline, but it does not need Tailwind or a dashboard frontend build system.

Rails discovers conventional engine asset directories through the pipeline's asset paths. The engine registers standalone CSS in `assets.precompile` for Sprockets so the host does not need a dashboard entry in its manifest. Propshaft publishes files from its asset paths without a selection list. Tailwind source is stored at `app/assets/stylesheets/solid_dashboard/tailwind.css`, alongside compiled CSS, without host asset path changes. Propshaft publishes both files; the layout loads only compiled CSS. The development build produces browser-ready CSS at `app/assets/stylesheets/solid_dashboard/application.css`, which is the standalone stylesheet registered for Sprockets.

See the [README](../../README.md) for development, build, and release commands.
