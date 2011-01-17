class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :uid
      t.string :email
      t.string :name
      t.string :gender
      t.string :birthdate
      t.string :profile_picture
      t.string :access_token

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
