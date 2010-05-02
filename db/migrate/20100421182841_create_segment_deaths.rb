class CreateSegmentDeaths < ActiveRecord::Migration
  def self.up
    create_table :segment_deaths, :options => "ENGINE=MyISAM" do |t|
      t.integer :unit_id, :null => false
      t.integer :report_id, :null => false
      t.integer :encounter_id, :null => false
      t.integer :segment_id, :null => false
      t.datetime :occured_at
      t.timestamps
    end
  end

  def self.down
    drop_table :segment_deaths
  end
end
