class SegmentInterrupt < ActiveRecord::Base
	belongs_to :report
	belongs_to :encounter
	belongs_to :segment
	belongs_to :source, :class_name => "Unit"
	belongs_to :dest, :class_name => "Unit"
	belongs_to :spell
	belongs_to :extra_spell, :class_name => "Spell"

	def SegmentInterrupt.done(attr = {})

		source_t = "units"
		dest_d = "dests_segment_interrupts"
		spell_t = "spells"
		extra_spell_t = "extra_spells_segment_interrupts"
    
    attr[:conditions] ||= {}
    attr[:conditions]['units.is_player'] = attr[:is_player] if attr[:is_player]

		self.find(:all, {
							:select => "DISTINCT(source_id) AS source_id, #{source_t}.name AS source_name, #{source_t}.class_id AS source_class_id, dest_id, #{dest_d}.name AS dest_name, #{dest_d}.class_id AS dest_class_id, spell_id, #{spell_t}.name AS spell_name, #{spell_t}.school AS spell_school, extra_spell_id, #{extra_spell_t}.name AS extra_spell_name, #{extra_spell_t}.school AS extra_spell_school, SUM(num_total) AS num_total",
							:conditions => attr[:conditions],
							:joins => [ :source, :dest, :spell, :extra_spell ],
							:order => "source_name ASC, extra_spell_name ASC, num_total DESC",
							:group => "source_id, dest_id, spell_id, extra_spell_id" })

	end
end
