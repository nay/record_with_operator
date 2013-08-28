require 'test_helper'

class User < ActiveRecord::Base
end

class NoteWithUserWithDependency < ActiveRecord::Base
  set_table_name "notes"
  has_many :memos, :class_name => "MemoWithUserWithDependency", :foreign_key => "note_id", :dependent => :destroy

  before_destroy :check_operator

  private
  def check_operator
    raise "can't destroy without operator" unless operator
  end
end

class MemoWithUserWithDependency < ActiveRecord::Base
  set_table_name "memos"

  before_destroy :check_operator

  private
  def check_operator
    raise "can't destroy without operator" unless operator
  end
end


class RecordWithOperatorHasManyDependentTest < ActiveSupport::TestCase
  def setup
    RecordWithOperator.config[:operator_class_name] = "User"
    @user1 = User.create!(:name => "user1")
    raise "@user1.id is nil" unless @user1.id
    @user2 = User.create!(:name => "user2")
    raise "@user2.id is nil" unless @user2.id
    @note_created_by_user1 = NoteWithUserWithDependency.create!(:body => "test", :operator => @user1)
    @note_created_by_user1.memos.create!
    @note_created_by_user1.memos.create!
    @note_created_by_user1.reload
  end

  def test_memos_should_be_destroyed_when_note_is_destroyed
    @note_created_by_user1.destroy
    assert_nil NoteWithUserWithDependency.find_by_id(@note_created_by_user1.id)
    assert MemoWithUserWithDependency.find_all_by_note_id(@note_created_by_user1.id).empty?
  end

end
