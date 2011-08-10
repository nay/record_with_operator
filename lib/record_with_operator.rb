require 'record_with_operator/relation_methods'
require 'record_with_operator/associations/extension'
require 'record_with_operator/extension'

ActiveRecord::Base.send :include, RecordWithOperator::Extension unless ActiveRecord::Base.include?(RecordWithOperator::Extension)
ActiveRecord::Relation.send :include, RecordWithOperator::RelationMethods unless ActiveRecord::Relation.include?(RecordWithOperator::RelationMethods)
