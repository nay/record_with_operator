require 'record_with_operator/utility'

module RecordWithOperator
  module RelationMethods
    extend ActiveSupport::Concern

    included do
      attr_accessor :operator
    end

    module InstanceMethods
      include RecordWithOperator::Utility

      def merge(r)
        merged_relation = super
        merged_relation.operator ||= r.operator
        merged_relation
      end

      def except(*skips)
        result = super
        result.operator ||= operator
        result
      end

      def only(*onlies)
        result = super
        result.operator ||= operator
        result
      end

      def for(operator)
        relation = clone
        relation.operator ||= operator
        relation
      end

      def apply_finder_options(options)
        finders = options.dup
        operator = finders.delete(:for)
        relation = super(finders)
        relation.for(operator)
      end

      def find(*args)
        set_operator_to_records(super, operator)
      end

      def first(*args)
        set_operator_to_records(super, operator)
      end

      def last(*args)
        set_operator_to_records(super, operator)
      end

      def all(*args)
        set_operator_to_records(super, operator)
      end

      def to_a
        set_operator_to_records(super, operator)
      end
    end
  end
end
