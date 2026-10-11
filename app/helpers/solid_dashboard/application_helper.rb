module SolidDashboard
  module ApplicationHelper
    def page_link(label, path, &block)
      content = block ? safe_join([capture(&block), label]) : label
      link_to content, path, aria: {current: current_page?(path) ? "page" : nil}, class: "nav-link"
    end
  end
end
