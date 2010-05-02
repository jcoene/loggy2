class CreateSegments < ActiveRecord::Migration
  def self.up
    create_table :segments do |t|
      t.integer :phase, :default => 0
      t.string :group, :limit => 64
      t.string :label, :null => false, :limit => 128
      t.integer :report_id
			t.integer :encounter_id
			t.datetime :started_at
			t.datetime :finished_at
      t.timestamps
		end
  end

  def self.down
    drop_table :segments
  end
end
