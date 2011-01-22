class CreateEducations < ActiveRecord::Migration
  def self.up
    create_table :educations do |t|
      t.references :user
      t.string :level
      t.string :name

      t.timestamps
    end
    add_index :educations, :user_id
  end

  def self.down
    drop_table :educations
  end
end
