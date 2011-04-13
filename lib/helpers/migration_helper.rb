ActiveRecord::ConnectionAdapters::TableDefinition.class_eval do
  def operator_stamps
    column(:created_by, :integer)
    column(:updated_by, :integer)
    column(:deleted_by, :integer)
  end
end