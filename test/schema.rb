ActiveRecord::Schema.define(:version => 1) do

  create_table :simple_notes, :force => true do |t|
    t.column :body, :text
  end

  create_table :creator_notes, :force => true do |t|
    t.column :body, :text
    t.column :created_by, :integer
    t.column :created_at, :datetime
  end

  create_table :updater_notes, :force => true do |t|
    t.column :body, :text
    t.column :updated_by, :integer
    t.column :updated_at, :datetime
  end

  create_table :deleter_notes, :force => true do |t|
    t.column :body, :text
    t.column :deleted_by, :integer
    t.column :deleted_at, :datetime
  end

  create_table :notes, :force => true do |t|
    t.column :memo_id, :integer
    t.column :body, :text
    t.column :created_by, :integer
    t.column :created_at, :datetime
    t.column :updated_by, :integer
    t.column :updated_at, :datetime
    t.column :deleted_by, :integer
    t.column :deleted_at, :datetime
  end

  create_table :memos, :force => true do |t|
    t.column :note_id, :integer
    t.column :body, :text
    t.column :created_by, :integer
    t.column :created_at, :datetime
    t.column :updated_by, :integer
    t.column :updated_at, :datetime
    t.column :deleted_by, :integer
    t.column :deleted_at, :datetime
  end

  create_table :users, :force => true do |t|
    t.column :name, :string
  end
end
