
require 'test_helper'

RecordWithOperator.config[:operator_class_name] = "AdminUser"

class NoteWithAdminUser < ActiveRecord::Base
  set_table_name "notes"

  records_with_operator_on :create, :update, :destroy

  def destroy_with_deleted_at
    NoteWithAdminUser.update_all("deleted_at = '#{Time.now.to_s(:db)}'", "id = #{self.id}")
  end
  alias_method_chain :destroy, :deleted_at
  def destory!
    destory_without_deleted_at
  end

  def deleted?
    self.deleted_at <= Time.now
  end
end

class AdminUser < ActiveRecord::Base
  set_table_name "users"
end

class RecordWithOperatorUserClassNameTest < ActiveSupport::TestCase
  def setup
    @user1 = AdminUser.create!(:name => "user1")
    @user2 = AdminUser.create!(:name => "user2")
    @note_created_by_user1 = NoteWithAdminUser.create!(:body => "test", :operator => @user1)
  end

  def test_note_should_be_created_with_operator
    assert_equal @user1, @note_created_by_user1.operator
  end

  def test_note_should_be_created_with_created_by_and_updated_by
    assert_equal @user1.id, @note_created_by_user1.created_by
    assert_equal @user1.id, @note_created_by_user1.updated_by
    @note_created_by_user1.reload
    assert_equal @user1.id, @note_created_by_user1.created_by
    assert_equal @user1.id, @note_created_by_user1.updated_by
    assert @note_created_by_user1.creator.kind_of?(AdminUser)
  end

  def test_note_should_be_found_with_for
    RecordWithOperator.operator = @user2
    note = NoteWithAdminUser.find(@note_created_by_user1.id)
    assert_equal(@user2, note.operator)
  end

  def test_note_should_be_updated_with_updated_by
    RecordWithOperator.operator = @user2
    note = NoteWithAdminUser.find(@note_created_by_user1.id)
    note.body = "changed"
    note.save!
    assert_equal(@user2.id, note.updated_by)
    note.reload
    assert_equal(@user2.id, note.updated_by)
  end

end
