class CreateSegmentHeals < ActiveRecord::Migration
  def self.up
    create_table :segment_heals, :options => "ENGINE=MyISAM" do |t|
			t.integer :unit_id, :null => false
      t.integer :source_id, :null => false
      t.integer :dest_id, :null => false
      t.integer :spell_id, :null => false
      t.boolean :is_periodic, :default => 0
      t.integer :amount_total, :default => 0
      t.integer :amount_hits, :default => 0
      t.integer :amount_crits, :default => 0
			t.integer :amount_overheal, :default => 0
      t.integer :amount_absorbs, :default => 0
			t.integer :amount_min_hit, :default => 0, :length => 4
			t.integer :amount_max_hit, :default => 0, :length => 4
			t.integer :amount_min_crit, :default => 0, :length => 4
			t.integer :amount_max_crit, :default => 0, :length => 4
			t.integer :amount_min_overheal, :default => 0, :length => 4
			t.integer :amount_max_overheal, :default => 0, :length => 4
			t.integer :amount_min_absorb, :default => 0, :length => 4
			t.integer :amount_max_absorb, :default => 0, :length => 4
      t.integer :num_total, :default => 0, :length => 4
      t.integer :num_hits, :default => 0, :length => 4
      t.integer :num_crits, :default => 0, :length => 4
      t.integer :num_overheals, :default => 0, :length => 4
      t.integer :num_absorbs, :default => 0, :length => 4
      t.integer :report_id, :null => false
      t.integer :encounter_id, :null => false
      t.integer :segment_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :segment_heals
  end
end
