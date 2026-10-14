module SolidDashboard
  class PaginatedList
    include Enumerable

    # Attributes
    # ===============================

    attr_reader :page, :per_page

    def initialize(scope:, page: 1, per_page: 25)
      @scope = scope
      @page = positive_integer(page, 1)
      @per_page = [positive_integer(per_page, 25), 100].min
    end

    def each(&block)
      return enum_for(:each) unless block

      records.each(&block)
    end

    def empty?
      records.empty?
    end

    def total
      @total ||= @scope.except(:order, :select).count
    end

    def pages
      (total + per_page - 1) / per_page
    end

    private

    def records
      @records ||= begin
        offset = (page - 1) * per_page
        (offset > 2**63 - 1) ? [] : @scope.limit(per_page).offset(offset).to_a
      end
    end

    def positive_integer(value, default)
      number = Integer(value.to_s, 10, exception: false)
      number&.positive? ? number : default
    end
  end
end
