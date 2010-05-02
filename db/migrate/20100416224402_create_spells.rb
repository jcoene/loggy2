class CreateSpells < ActiveRecord::Migration
  def self.up
    create_table :spells, :options => "ENGINE=MyISAM" do |t|
      t.string :name, :null => false, :limit => 128
      t.integer :school, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :spells
  end
end
