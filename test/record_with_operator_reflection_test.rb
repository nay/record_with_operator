require 'test_helper'

class User < ActiveRecord::Base
end

class NoteForReflectionTest < ActiveRecord::Base
  self.table_name = "notes"

  records_with_operator_on :create, :update, :destroy
end

class CreatorNoteForReflectionTest < ActiveRecord::Base
  self.table_name = "creator_notes"

  records_with_operator_on :create
end

class RecordWithOperatorReflectionTest < ActiveSupport::TestCase
  def setup
    RecordWithOperator.config[:operator_class_name] = "User"
    @user1 = User.create!(:name => "user1")
    raise "@user1.id is nil" unless @user1.id
    @note = NoteForReflectionTest.create!(:body => "test", :operator => @user1)

    @creator_note = CreatorNoteForReflectionTest.create!(:body => "test", :operator => @user1)
  end

  def test_include
    assert NoteForReflectionTest.includes(:creator, :updater).all.to_a
  end

  def test_joins
    assert NoteForReflectionTest.joins(:creator, :updater).all.to_a
  end

  def test_include_missing_association
    assert_raise(ActiveRecord::ConfigurationError) { CreatorNoteForReflectionTest.includes(:updater).all.to_a }
  end

  def test_joins_missing_association
    assert_raise(ActiveRecord::ConfigurationError) { CreatorNoteForReflectionTest.joins(:updater).all.to_a }
  end
end
