class CreateSegmentDamages < ActiveRecord::Migration
  def self.up
    create_table :segment_damages, :options => "ENGINE=MyISAM" do |t|
			t.integer :unit_id, :null => false
      t.integer :source_id, :null => false
      t.integer :dest_id, :null => false
      t.integer :spell_id, :null => false
      t.boolean :is_periodic, :default => 0
			t.boolean :is_friendlyfire, :default => 0
      t.integer :amount_total, :default => 0
			t.integer :amount_hits, :default => 0, :length => 4
			t.integer :amount_crits, :default => 0, :length => 4
			t.integer :amount_absorbs, :default => 0, :length => 4
			t.integer :amount_blocks, :default => 0, :length => 4
			t.integer :amount_glancings, :default => 0, :length => 4
			t.integer :amount_crushings, :default => 0, :length => 4
			t.integer :amount_min_hit, :default => 0, :length => 4
			t.integer :amount_max_hit, :default => 0, :length => 4
			t.integer :amount_min_crit, :default => 0, :length => 4
			t.integer :amount_max_crit, :default => 0, :length => 4
			t.integer :amount_min_absorb, :default => 0, :length => 4
			t.integer :amount_max_absorb, :default => 0, :length => 4
			t.integer :amount_min_block, :default => 0, :length => 4
			t.integer :amount_max_block, :default => 0, :length => 4
			t.integer :num_total, :default => 0, :length => 4
      t.integer :num_hits, :default => 0, :length => 4
      t.integer :num_crits, :default => 0, :length => 4
      t.integer :num_misses, :default => 0, :length => 4
      t.integer :num_absorbs, :default => 0, :length => 4
      t.integer :num_blocks, :default => 0, :length => 4
      t.integer :num_dodges, :default => 0, :length => 4
      t.integer :num_parries, :default => 0, :length => 4
      t.integer :num_immunes, :default => 0, :length => 4
			t.integer :num_glancings, :default => 0, :length => 4
			t.integer :num_crushings, :default => 0, :length => 4
			t.integer :num_extras, :default => 0, :length => 4
			t.integer :report_id, :null => false
			t.integer :encounter_id, :null => false
			t.integer :segment_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :segment_damages
  end
end
