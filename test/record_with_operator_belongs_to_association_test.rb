require 'test_helper'

class User < ActiveRecord::Base
end

class NoteBelongsToMemo < ActiveRecord::Base
  self.table_name = "notes"
  belongs_to :memo

  records_with_operator_on :create, :update, :destroy
end

class Memo < ActiveRecord::Base
  self.table_name = "memos"

  records_with_operator_on :create, :update, :destroy
end

class RecordWithOperatorBelongsTo < ActiveSupport::TestCase
  def setup
    RecordWithOperator.config[:operator_class_name] = "User"
    @user1 = User.create!(:name => "user1")
    @user2 = User.create!(:name => "user2")
    @note_created_by_user1 = NoteBelongsToMemo.create!(:body => "test", :operator => @user1)
  end

  # belongs_to Association Test
  # build_association
  def test_build_memo_should_have_operator
    RecordWithOperator.operator = @user2
    note = NoteBelongsToMemo.find(@note_created_by_user1.id)
    memo = note.build_memo(:body => "memo")
    assert_equal @user2, memo.operator
  end

  # create_association
  def test_create_memo_should_have_operator_and_created_by
    RecordWithOperator.operator = @user2
    note = NoteBelongsToMemo.find(@note_created_by_user1.id)
    memo = note.create_memo(:body => "memo")
    assert_equal false, memo.new_record?
    assert_equal @user2, memo.operator
    assert_equal @user2.id, memo.created_by
  end

  # association=
  def test_memo_eql_should_have_operator_and_created_by
    RecordWithOperator.operator = @user2
    note = NoteBelongsToMemo.find(@note_created_by_user1.id)
    memo = Memo.new(:body => "memo")
    note.memo = memo # not save
    assert_equal @user2, memo.operator
  end

  # association
  def test_auto_found_memo_should_have_operator
    RecordWithOperator.operator = @user2
    note = NoteBelongsToMemo.find(@note_created_by_user1.id)
    note.create_memo(:body => "memo")
    assert_equal @user2, note.memo(true).operator
  end

  # association.nil?
  def test_memo_nil_should_be_false_if_note_belongs_to_memo
    note = NoteBelongsToMemo.find(@note_created_by_user1.id)
    note.create_memo(:body => "memo")
    assert !note.memo.nil?
  end

  # association.nil?
  def test_memo_nil_should_be_true_if_note_is_independent
    note = NoteBelongsToMemo.find(@note_created_by_user1.id)
    assert note.memo.nil?
  end
end
