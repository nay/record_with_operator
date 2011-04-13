ActiveRecord::Base.instance_eval{include RecordWithOperator} unless ActiveRecord::Base.include?(RecordWithOperator)
ActiveRecord::ConnectionAdapters::TableDefinition.class_eval do
  def operatorstamps
    column(:created_by, :integer)
    column(:updated_by, :integer)
    column(:deleted_by, :integer)
  end
end