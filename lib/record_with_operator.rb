module RecordWithOperator
  def self.config
    @config ||= {:user_class_name => "User"}
    @config
  end

  attr_accessor :operator

  def self.included(base)
    class << base
      def reflections_with_operator
        create_operator_associations
        reflections_without_operator
      end
      alias_method_chain :reflections, :operator

      def operator_associations_created?
        @operator_associations_created
      end

      def create_operator_associations
        return if operator_associations_created?
        @operator_associations_created = true

        if self.table_exists?
          belongs_to :creator, :foreign_key => "created_by", :class_name => RecordWithOperator.config[:user_class_name] if column_names.include?('created_by')
          belongs_to :updater, :foreign_key => "updated_by", :class_name => RecordWithOperator.config[:user_class_name] if column_names.include?('updated_by')
          belongs_to :deleter, :foreign_key => "deleted_by", :class_name => RecordWithOperator.config[:user_class_name] if column_names.include?('deleted_by')
        end
      end

      def has_many_with_operator(*args, &extension)
        options = args.extract_options!
        # add AssociationWithOprator to :extend
        if options[:extend]
          options[:extend] = [options[:extend]] unless options[:extend].kind_of? Array
          options[:extend] << AssociationWithOperator
        else
          options[:extend] = AssociationWithOperator
        end
        # add :set_operator to :before_add
        if options[:before_add]
          options[:before_add] = [options[:before_add]] unless options[:before_add].kind_of? Array
          options[:before_add] << :set_operator
        else
          options[:before_add] = :set_operator
        end
        args << options
        has_many_without_operator(*args, &extension)
      end
      alias_method_chain :has_many, :operator

      def find_with_for(*args)
        options = args.extract_options!
        operator = options.delete(:for)
        args << options
        results = find_without_for(*args)
        if operator
          if results.kind_of? Array
            results.each{|r| r.operator = operator}
          elsif results
            results.operator = operator
          end
        end
        results
      end

      alias_method_chain :find, :for

      def validate_find_options_with_for(options)
        if options
          options = options.dup
          options.delete(:for)
        end
        validate_find_options_without_for(options)
      end

      alias_method_chain :validate_find_options, :for

      private
      # define_method association, association= ...
      def association_accessor_methods_with_operator(reflection, association_proxy_class)
        association_accessor_methods_without_operator(reflection, association_proxy_class)
        define_method("#{reflection.name}_with_operator") do |*params|
          r = send("#{reflection.name}_without_operator", *params)
          r.operator ||= self.operator if r && r.respond_to?(:operator=)
          r
        end
        alias_method_chain "#{reflection.name}".to_sym, :operator

        define_method("#{reflection.name}_with_operator=") do |new_value|
          new_value.operator ||= self.operator if new_value.respond_to?(:operator=)
          send("#{reflection.name}_without_operator=", new_value)
        end
        alias_method_chain "#{reflection.name}=".to_sym, :operator
      end
      alias_method_chain :association_accessor_methods, :operator

      # define_method build_association, create_association ...
      def association_constructor_method_with_operator(constructor, reflection, association_proxy_class)
        association_constructor_method_without_operator(constructor, reflection, association_proxy_class)
        define_method("#{constructor}_#{reflection.name}_with_operator") do |*params|
          options = { :operator => self.operator }
          params.empty? ? params[0] = options : params.first.merge!(options)
          self.send("#{constructor}_#{reflection.name}_without_operator", *params)
        end
        alias_method_chain "#{constructor}_#{reflection.name}".to_sym, :operator
      end
      alias_method_chain :association_constructor_method, :operator
    end

    base.before_create :set_created_by
    base.before_save :set_updated_by
    base.before_destroy :set_deleted_by

  end

  def respond_to?(name, priv=false)
    case name.to_sym
    when :creator
      respond_to? :created_by
    when :updater
      respond_to? :updated_by
    when :deleter
      respond_to? :deleted_by
    else
      super
    end
  end

  private
  def set_operator(child)
    child.operator ||= self.operator
  end

  def method_missing(method, *args)
    return super unless respond_to?(method)
    case method.to_sym
    when :creator, :updater, :deleter
      self.class.create_operator_associations
      send(method, *args)
    else
      super
    end
  end

  def set_created_by
    return unless respond_to?(:created_by=) && operator
    self.created_by = operator.id
  end

  def set_updated_by
    return unless respond_to?(:updated_by=) && operator
    self.updated_by = operator.id
  end

  def set_deleted_by
    return unless self.class.column_names.include?("deleted_by") && operator
    self.class.update_all("deleted_by = #{operator.id}", ["#{self.class.primary_key} = ?", id])
    self.deleted_by = operator.id
  end

end
