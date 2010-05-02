class CreateGuilds < ActiveRecord::Migration
  def self.up
    create_table :guilds do |t|
      t.string :region, :null => false, :limit => 8
      t.string :realm, :null => false, :limit => 32
      t.string :name, :null => false, :limit => 128
      t.integer :user_id

      t.timestamps
    end

		Guild.create :region => "US", :realm => "Illidan", :name => "Blood Legion"
  end

  def self.down
    drop_table :guilds
  end
end
