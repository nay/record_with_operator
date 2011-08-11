require 'record_with_operator/utility'

module RecordWithOperator
  module Associations
    module Extension
      include RecordWithOperator::Utility

      def find(*args)
        set_operator_to_records(super, @owner.operator)
      end

      def method_missing(method, *args)
        set_operator_to_records(super, @owner.operator)
      end

      protected
        def construct_scope
          scoping = super
          scoping[:find][:for] = @owner.operator
          scoping
        end
    end
  end
end
