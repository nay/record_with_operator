require 'record_with_operator/associations/extension'
require 'record_with_operator/extension'

ActiveRecord::Base.send :include, RecordWithOperator::Extension unless ActiveRecord::Base.include?(RecordWithOperator::Extension)
