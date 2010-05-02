class CreateSegmentGains < ActiveRecord::Migration
  def self.up
    create_table :segment_gains, :options => "ENGINE=MyISAM" do |t|
      t.integer :source_id, :null => false
      t.integer :dest_id, :null => false
      t.integer :spell_id, :null => false
      t.integer :gain_type, :default => 0, :length => 2
      t.integer :amount_total, :default => 0
      t.integer :amount_min, :default => 0, :length => 4
      t.integer :amount_max, :default => 0, :length => 4
      t.integer :num_total, :default => 0, :length => 4
      t.integer :report_id, :null => false
      t.integer :encounter_id, :null => false
      t.integer :segment_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :segment_gains
  end
end
