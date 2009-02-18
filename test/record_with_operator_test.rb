require 'test_helper'

class User < ActiveRecord::Base
end

class NoteWithUser < ActiveRecord::Base
  set_table_name "notes"

  def destroy_with_deleted_at
    NoteWithUser.update_all("deleted_at = '#{Time.now.to_s(:db)}'", "id = #{self.id}")
  end
  alias_method_chain :destroy, :deleted_at
  def destory!
    destory_without_deleted_at
  end

  def deleted?
    self.deleted_at <= Time.now
  end
end

class RecordWithOperatorTest < ActiveSupport::TestCase
  def setup
    RecordWithOperator.config[:user_class_name] = "User"
    @user1 = User.create!(:name => "user1")
    @user2 = User.create!(:name => "user2")
    @note_created_by_user1 = NoteWithUser.create!(:body => "test", :operator => @user1)
  end

  # creator/updater/deleter association operation

  def test_note_should_be_respond_to_creator
    assert NoteWithUser.new.respond_to? :creator
  end

  def test_simple_note_should_not_be_respond_to_creator
    assert_equal false, SimpleNote.new.respond_to?(:creator)
  end

  def test_note_should_be_respond_to_updater
    assert NoteWithUser.new.respond_to? :updater
  end

  def test_simple_note_should_not_be_respond_to_updater
    assert_equal false, SimpleNote.new.respond_to?(:updater)
  end

  def test_note_should_be_respond_to_deleter
    assert NoteWithUser.new.respond_to? :deleter
  end

  def test_simple_note_should_not_be_respond_to_deleter
    assert_equal false, SimpleNote.new.respond_to?(:deleter)
  end

  # save or destory with xxxx_by and can get as a creator/updator/deleter

  def test_note_should_be_created_with_operator
    assert_equal @user1, @note_created_by_user1.operator
  end

  def test_note_should_be_created_with_created_by_and_updated_by
    assert_equal @user1.id, @note_created_by_user1.created_by
    assert_equal @user1.id, @note_created_by_user1.updated_by
    @note_created_by_user1.reload
    assert_equal @user1.id, @note_created_by_user1.created_by
    assert_equal @user1.id, @note_created_by_user1.updated_by
    assert_equal @user1, @note_created_by_user1.creator
    assert_equal @user1, @note_created_by_user1.updater
  end

  def test_note_should_be_found_with_for
    note = NoteWithUser.find(@note_created_by_user1.id, :for => @user2)
    assert_equal(@user2, note.operator)
  end

  def test_note_should_be_updated_with_updated_by
    note = NoteWithUser.find(@note_created_by_user1.id, :for => @user2)
    note.body = "changed"
    note.save!
    assert_equal(@user2.id, note.updated_by)
    note.reload
    assert_equal(@user2.id, note.updated_by)
  end

  def test_note_should_be_destroyed_with_deleted_by
    note = NoteWithUser.find(@note_created_by_user1.id, :for => @user2)
    note.destroy # logically
    note.reload
    raise "not deleted" unless note.deleted?
    assert @user2.id, note.deleted_by
  end

end