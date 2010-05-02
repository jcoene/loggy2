class CreateUnits < ActiveRecord::Migration
  def self.up
    create_table :units, :options => "ENGINE=MyISAM" do |t|
      t.string :name, :null => false, :limit => 128
      t.string :guid, :null => false, :limit => 64
      t.string :source_guid, :null => false, :limit => 64
      t.string :flags
			t.boolean :is_player, :default => 0
			t.boolean :is_pet, :default => 0
			t.boolean :is_npc, :default => 0
			t.integer :class_id, :limit => 4
      t.integer :npc_id, :limit => 4
			t.integer :owner_id
      t.integer :report_id
			t.integer :encounter_id
      t.timestamps
    end

		add_index :units, [:report_id, :guid], :unique => true
  end

  def self.down
    drop_table :units
  end
end
