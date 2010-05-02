class CreateSegmentSteals < ActiveRecord::Migration
  def self.up
    create_table :segment_steals, :options => "ENGINE=MyISAM" do |t|
      t.integer :source_id, :null => false
      t.integer :dest_id, :null => false
      t.integer :spell_id, :null => false
      t.integer :extra_spell_id
      t.integer :aura_type, :default => 0, :length => 2
      t.integer :num_total, :default => 0, :length => 4
      t.integer :report_id, :null => false
      t.integer :encounter_id, :null => false
      t.integer :segment_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :segment_steals
  end
end
