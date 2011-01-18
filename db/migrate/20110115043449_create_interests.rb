class CreateInterests < ActiveRecord::Migration
  def self.up
    create_table :interests do |t|
      t.string :user_facebook_id
      t.string :name
      t.string :category
      t.string :category_facebook_id
      t.boolean :current

      t.timestamps
    end
  end

  def self.down
    drop_table :interests
  end
end
