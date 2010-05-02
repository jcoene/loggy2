class CreateEvents < ActiveRecord::Migration
	def self.up
		create_table :events, :options => "ENGINE=MyISAM" do |t|
			t.string :event, :null => false, :limit => 64
			t.integer :source_id
			t.integer :dest_id
			t.integer :spell_id
			t.integer :extra_spell_id
			t.integer :amount
			t.integer :overkill
			t.integer :resisted
			t.integer :blocked
			t.integer :absorbed
			t.boolean :critical
			t.boolean :glancing
			t.boolean :crushing
			t.string :type, :limit => 32
			t.integer :report_id
			t.integer :encounter_id
			t.integer :segment_id
			t.datetime :occured_at
			t.timestamps
		end
		add_index :events, :report_id
		add_index :events, [:report_id, :encounter_id, :source_id]
		add_index :events, [:report_id, :encounter_id, :dest_id]
		add_index :events, [:report_id, :encounter_id, :spell_id]
	end

	def self.down
		drop_table :events
	end
end
