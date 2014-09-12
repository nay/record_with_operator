module RecordWithOperator
  module Recorder
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    private

    def set_creator
      send("#{RecordWithOperator.creator_column}=", operator.try(:id))
    end

    def set_updater
      return unless changed? # no use setting updating_by when it's not changed
      return unless operator # avoid changing value to be nil
      send("#{RecordWithOperator.updater_column}=", operator.id)
    end

    def update_deleter
      return if frozen?
      return unless operator
      self.class.update_all("#{RecordWithOperator.deleter_column} = #{operator.id}", ["#{self.class.primary_key} = ?", id])
      send("#{RecordWithOperator.deleter_column}=", operator.id)
    end

    module ClassMethods
      VALID_ACTIONS = %w(create update destroy)

      def records_with_operator_on(*args)
        raise "valid actions are #{VALID_ACTIONS.inspect}." unless args.all?{|arg| VALID_ACTIONS.include?(arg.to_s) }

        @records_on = args.map(&:to_s)

        before_create :set_creator if records_creator?
        before_save :set_updater if records_updater?
        before_destroy :update_deleter if records_deleter?

        if self.table_exists?
          belongs_to :creator, {:foreign_key => "created_by", :class_name => RecordWithOperator.config[:operator_class_name]}.merge(RecordWithOperator.config[:operator_association_options]) if records_creator?
          belongs_to :updater, {:foreign_key => "updated_by", :class_name => RecordWithOperator.config[:operator_class_name]}.merge(RecordWithOperator.config[:operator_association_options]) if records_updater?
          belongs_to :deleter, {:foreign_key => "deleted_by", :class_name => RecordWithOperator.config[:operator_class_name]}.merge(RecordWithOperator.config[:operator_association_options]) if records_deleter?
        end
      end

      def records_creator?
        @records_on && @records_on.include?("create")
      end

      def records_updater?
        @records_on && @records_on.include?("update")
      end

      def records_deleter?
        @records_on && @records_on.include?("destroy")
      end
    end
  end
end
