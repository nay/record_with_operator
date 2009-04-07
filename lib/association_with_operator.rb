module AssociationWithOperator

  def find(*args)
    results = super
    if results.kind_of? Array
      results.each{|r| r.operator = proxy_owner.operator}
    else
      results.operator = proxy_owner.operator if results
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

  def construct_join_attributes(associate)
    join_attributes = super
    if @owner.operator || associate.operator
      join_attributes[:operator] ||= @owner.operator
      join_attributes[:operator] ||= associate.operator
    end
    join_attributes
  end
end
