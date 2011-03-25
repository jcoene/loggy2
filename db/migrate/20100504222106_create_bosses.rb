class CreateBosses < ActiveRecord::Migration
  def self.up
    create_table :bosses do |t|
      t.integer :zone_id
      t.integer :seq
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :bosses
  end
end
