module RecordWithOperator
  module Utility
    private
      def set_operator_to_records(records, operator)
        return records unless operator

        unless ActiveRecord::Relation === records
          if records.respond_to?(:operator=)
            records.operator = operator
          elsif Array === records
            records.each do |record|
              record.operator = operator if record.respond_to?(:operator=)
            end
          end
        end
        records
      end
  end
end
