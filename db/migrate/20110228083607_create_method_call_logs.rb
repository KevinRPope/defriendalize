class CreateMethodCallLogs < ActiveRecord::Migration
  def self.up
    create_table :method_call_logs do |t|
      t.references :user
      t.string :action
      t.string :name
      t.string :notes

      t.timestamps
    end
    remove_column :users, :birthdate
    remove_column :users, :relationship_status
    add_index :method_call_logs, :user_id
  end

  def self.down
    drop_table :method_call_logs
  end
end
