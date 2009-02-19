module RecordWithOperator
  def self.config
    @config ||= {:user_class_name => "User"}
    @config
  end

  attr_accessor :operator

  def self.included(base)
    class << base
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
          else
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
    end

    base.before_create :set_created_by
    base.before_save :set_updated_by
    base.before_destroy :set_deleted_at

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
    child.operator = self.operator
  end

  def method_missing(method, *args)
    return super unless respond_to?(method)
    case method.to_sym
    when :creator
      self.class.belongs_to :creator, :foreign_key => "created_by", :class_name => RecordWithOperator.config[:user_class_name]
      send(method, *args)
    when :updater
      self.class.belongs_to :updater, :foreign_key => "updated_by", :class_name => RecordWithOperator.config[:user_class_name]
      send(method, *args)
    when :deleter
      self.class.belongs_to :deletor, :foreign_key => "deleted_by", :class_name => RecordWithOperator.config[:user_class_name]
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
    return unless respond_to?(:deleted_by=) && operator
    self.updated_by = operator.id
  end

end