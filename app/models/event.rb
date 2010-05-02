class Event < ActiveRecord::Base
	belongs_to :report
	belongs_to :encounter
	belongs_to :segment
	has_one :source, :class_name => "Unit", :foreign_key => "source_id"
	has_one :dest, :class_name => "Unit", :foreign_key => "dest_id"
	has_one :spell
	has_one :extra_spell, :class_name => "Spell", :foreign_key => "extra_spell_id"
	
end
