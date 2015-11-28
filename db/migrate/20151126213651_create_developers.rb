class CreateDevelopers < ActiveRecord::Migration
  def self.up
    create_table :developers do |t|
      t.string :name, null: false
      t.string :email, null: false, index: true
      t.integer :age, null: false
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :developers
  end
end
