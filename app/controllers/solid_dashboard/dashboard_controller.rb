module SolidDashboard
  class DashboardController < ApplicationController
    layout "solid_dashboard/application"

    NAVIGATION = {
      "Workspace" => {"overview" => "Overview"},
      "Solid Queue" => {"jobs" => "Jobs", "processes" => "Processes", "recurring" => "Recurring tasks"},
      "Solid Cache" => {"cache" => "Cache analytics", "entries" => "Cache entries", "events" => "Cache events"}
    }.freeze

    def show
      section = request.path_parameters.fetch(:section)
      @page_title = NAVIGATION.values.flat_map(&:to_a).to_h.fetch(section)
      @sidebar_navigation = NAVIGATION.map do |title, links|
        {title: title, links: links.map { |key, label| {label: label, path: public_send((key == "overview") ? :root_path : "#{key}_path"), active: key == section} }}
      end
    end
  end
end
