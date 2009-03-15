module AssociationWithOperator

  def find(*args)
    results = super
    if results.kind_of? Array
      results.each{|r| r.operator = proxy_owner.operator}
    else
      results.operator = proxy_owner.operator
    end
    results
  end


  def method_missing(method, *args)
    results = super
    if results.respond_to?(:operator=)
      results.operator= proxy_owner.operator
    elsif results.kind_of? Array
      results.each{|r| r.operator = proxy_owner.operator if r.respond_to?(:operator=)}
    end
    results
  end

  def insert_record(record, *args)
    return super unless @reflection.kind_of?(ActiveRecord::Reflection::ThroughReflection)

    if record.new_record?
      if force
        record.save!
      else
        return false unless record.save
      end
    end
    through_reflection = @reflection.through_reflection
    klass = through_reflection.klass
    association = klass.send(:with_scope, :create => construct_join_attributes(record)) { through_reflection.build_association }
    if association.respond_to?(:operator=)
      association.operator ||= @owner.operator
      association.operator ||= record.operator
    end
    @owner.send(@reflection.through_reflection.name).proxy_target << association
  end
end
