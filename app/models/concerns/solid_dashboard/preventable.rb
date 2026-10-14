module SolidDashboard
  module Preventable
    extend ActiveSupport::Concern

    class_methods do
      def prevent(*methods)
        methods.each do |method|
          define_method(method) do |*|
            raise ActiveRecord::ReadOnlyRecord, "Dashboard records are read-only."
          end
        end
      end
    end
  end
end
