module SolidDashboard
  class ApplicationQuery
    def initialize(scope:, page: 1, per_page: 25)
      @scope = scope
      @page = page
      @per_page = per_page
    end

    def call
      @result ||= PaginatedList.new(scope: build_scope, page: @page, per_page: @per_page)
    end

    private

    def build_scope
      @scope
    end
  end
end
