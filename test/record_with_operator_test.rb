require 'test_helper'

class User < ActiveRecord::Base
end

class NoteWithUser < ActiveRecord::Base
  set_table_name "notes"
  has_many :memos, :class_name => "MemoWithUser", :foreign_key => "note_id"

  named_scope :new_arrivals, {:order => "updated_at desc"}

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

class SimpleNoteWithUser < ActiveRecord::Base
  set_table_name "simple_notes"
end

class MemoWithUser < ActiveRecord::Base
  set_table_name "memos"

  named_scope :new_arrivals, {:order => "updated_at desc"}
end

class UpdaterNoteWithUser < ActiveRecord::Base
  set_table_name "updater_notes"

end

class DeleterNoteWithUser < ActiveRecord::Base
  set_table_name "deleter_notes"

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
    assert_equal false, SimpleNoteWithUser.new.respond_to?(:creator)
  end

  def test_note_should_be_respond_to_updater
    assert NoteWithUser.new.respond_to? :updater
  end

  def test_simple_note_should_not_be_respond_to_updater
    assert_equal false, SimpleNoteWithUser.new.respond_to?(:updater)
  end

  def test_note_should_be_respond_to_deleter
    assert NoteWithUser.new.respond_to? :deleter
  end

  def test_simple_note_should_not_be_respond_to_deleter
    assert_equal false, SimpleNoteWithUser.new.respond_to?(:deleter)
  end

  # test updater without creater, deleter
  def test_updater_note_should_not_be_respond_to_creater
    assert_equal false, UpdaterNoteWithUser.new.respond_to?(:creater)
  end
  def test_updater_note_should_be_respond_to_updater
    assert UpdaterNoteWithUser.new.respond_to? :updater
  end
  def test_updater_note_should_not_be_respond_to_deleter
    assert_equal false, UpdaterNoteWithUser.new.respond_to?(:deleter)
  end

  # test deleter without create, updater
  def test_deleter_note_should_not_be_respond_to_creater
    assert_equal false, DeleterNoteWithUser.new.respond_to?(:creater)
  end
  def test_deleter_note_should_not_be_respond_to_updater
    assert_equal false, DeleterNoteWithUser.new.respond_to?(:updater)
  end
  def test_deleter_note_should_be_respond_to_deleter
    assert DeleterNoteWithUser.new.respond_to?(:deleter)
  end

  # find with :for
  def test_note_should_be_found_with_for
    note = NoteWithUser.find(@note_created_by_user1.id, :for => @user2)
    assert_equal(@user2, note.operator)
  end

  def test_note_should_be_found_with_for_through_named_scope
    note = NoteWithUser.new_arrivals.find(@note_created_by_user1.id, :for => @user2)
    assert_equal(@user2, note.operator)
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

  # reload
  def test_reload_should_not_change_operator
    @note_created_by_user1.reload
    assert_equal @user1, @note_created_by_user1.operator
  end
  

  # has_many Association Test
  def test_builded_memo_should_have_operator
    note = NoteWithUser.find(@note_created_by_user1.id, :for => @user2)
    memo = note.memos.build(:body => "memo")
    assert_equal @user2, memo.operator
  end

  def test_created_memo_should_have_operator_and_created_by
    note = NoteWithUser.find(@note_created_by_user1.id, :for => @user2)
    memo = note.memos.create(:body => "memo")
    assert_equal false, memo.new_record?
    assert_equal @user2, memo.operator
    assert_equal @user2.id, memo.created_by
  end

  def test_auto_found_memo_should_have_operator
    note = NoteWithUser.find(@note_created_by_user1.id, :for => @user2)
    note.memos.create!(:body => "memo")
    assert_equal @user2, note.memos(true).first.operator
  end

  def test_manualy_found_memo_should_have_operator
    note = NoteWithUser.find(@note_created_by_user1.id, :for => @user2)
    note.memos.create!(:body => "memo")
    assert_equal @user2, note.memos.find(:first).operator
  end

  def test_dynamically_found_memo_should_have_operator
    note = NoteWithUser.find(@note_created_by_user1.id, :for => @user2)
    note.memos.create!(:body => "memo")
    assert_equal @user2, note.memos.find_by_body("memo").operator
  end

  def test_dynamically_found_memos_should_have_operator
    note = NoteWithUser.find(@note_created_by_user1.id, :for => @user2)
    note.memos.create!(:body => "memo")
    assert note.memos.find_all_by_body("memo").all?{|m| m.operator == @user2}
  end


  def test_found_memo_through_named_scope_should_have_operator
    note = NoteWithUser.find(@note_created_by_user1.id, :for => @user2)
    note.memos.create!(:body => "memo")
    assert_equal @user2, note.memos.new_arrivals.first.operator
  end


  def test_dynamically_found_memo_through_named_scope_should_have_operator
    note = NoteWithUser.find(@note_created_by_user1.id, :for => @user2)
    note.memos.create!(:body => "memo")
    assert_equal @user2, note.memos.new_arrivals.find_by_body("memo").operator
  end


end