class SegmentDamage < ActiveRecord::Base
	belongs_to :report
	belongs_to :encounter
	belongs_to :segment
	belongs_to :source, :class_name => "Unit"
	belongs_to :dest, :class_name => "Unit"
	belongs_to :unit
	belongs_to :spell
	
	#def SegmentDamage.get_scope_of_conditions(conditions)
	#	return :encounter if conditions[:encounter_id] and conditions[:encounter_id] > 0
	#	return :segment if conditions[:segment_id] and conditions[:segment_id] > 0
	#	:report
	#end

	def SegmentDamage.done(attr = {})

		unit_t = "units"
		source_t = "sources_segment_damages"

    attr[:conditions] ||= {}
    attr[:conditions]['is_friendlyfire'] = attr[:is_friendlyfire] if attr.has_key?(:is_friendlyfire)
    attr[:conditions]['units.is_player'] = attr[:is_player] if attr.has_key?(:is_player)
    attr[:conditions]['sources_segment_damages.is_pet'] = attr[:is_pet] if attr.has_key?(:is_pet)
    attr[:conditions]['units.is_npc'] = attr[:is_npc] if attr.has_key?(:is_npc)
		attr[:conditions]['segment_id'] = attr[:segments] if attr.has_key?(:segments)

		self.find(:all, {
							:select =>
									"DISTINCT(unit_id) AS unit_id, #{unit_t}.name AS unit_name, #{unit_t}.npc_id AS unit_npc_id, #{unit_t}.class_id AS unit_class_id, " +
									"source_id, #{source_t}.name AS source_name, #{source_t}.npc_id AS source_npc_id, #{source_t}.class_id AS source_class_id, " +
									"SUM(amount_total) AS amount_total, SUM(amount_hits) AS amount_hits, SUM(amount_crits) AS amount_crits, SUM(amount_absorbs) AS amount_absorbs, SUM(amount_blocks) AS amount_blocks, " +
									"SUM(num_total) AS num_total, SUM(num_hits) AS num_hits, SUM(num_crits) AS num_crits, SUM(num_absorbs) AS num_absorbs, SUM(num_blocks) AS num_blocks, " +
									"SUM(num_misses) AS num_misses, SUM(num_dodges) AS num_dodges, SUM(num_parries) AS num_parries, SUM(num_glancings) AS num_glancings",
							:conditions => attr[:conditions],
							:joins => [ :unit, :source ],
							:order => "amount_total DESC",
							:group => :unit_id })
	end

	def SegmentDamage.done_spells(attr = {})

		unit_t = "units"
		source_t = "sources_segment_damages"

    attr[:conditions] ||= {}
    attr[:conditions]['unit_id'] = attr[:unit_id] if attr.has_key?(:unit_id)
    attr[:conditions]['source_id'] = attr[:source_id] if attr.has_key?(:source_id)
    attr[:conditions]['is_friendlyfire'] = attr[:is_friendlyfire] if attr.has_key?(:is_friendlyfire)
    attr[:conditions]['units.is_player'] = attr[:is_player] if attr.has_key?(:is_player)
    attr[:conditions]['sources_segment_damages.is_pet'] = attr[:is_pet] if attr.has_key?(:is_pet)
    attr[:conditions]['units.is_npc'] = attr[:is_npc] if attr.has_key?(:is_npc)
		attr[:conditions]['segment_id'] = attr[:segments] if attr.has_key?(:segments)
    
		self.find(:all, {
							:select =>
									"DISTINCT(source_id) AS source_id, #{source_t}.name AS source_name, #{source_t}.npc_id AS source_npc_id, #{source_t}.class_id AS source_class_id, " +
									"unit_id, #{unit_t}.name AS unit_name, #{unit_t}.npc_id AS unit_npc_id, #{unit_t}.class_id AS unit_class_id, " +
									"spell_id, spells.name AS spell_name, spells.school AS spell_school, " +
									"SUM(amount_total) AS amount_total, SUM(amount_hits) AS amount_hits, SUM(amount_crits) AS amount_crits, SUM(amount_absorbs) AS amount_absorbs, SUM(amount_blocks) AS amount_blocks, " +
									"SUM(num_total) AS num_total, SUM(num_hits) AS num_hits, SUM(num_crits) AS num_crits, SUM(num_absorbs) AS num_absorbs, SUM(num_blocks) AS num_blocks, " +
									"SUM(num_misses) AS num_misses, SUM(num_dodges) AS num_dodges, SUM(num_parries) AS num_parries, SUM(num_glancings) AS num_glancings",
							:conditions => attr[:conditions],
							:joins => [ :unit, :source, :spell ],
							:order => "amount_total DESC",
							:group => "source_id, spell_id" })
	end

	def SegmentDamage.done_targets(attr = {})

		unit_t = "units"
		source_t = "sources_segment_damages"
		dest_t = "dests_segment_damages"

    attr[:conditions] ||= {}
    attr[:conditions]['unit_id'] = attr[:unit_id] if attr.has_key?(:unit_id)
    attr[:conditions]['source_id'] = attr[:source_id] if attr.has_key?(:source_id)
    attr[:conditions]['is_friendlyfire'] = attr[:is_friendlyfire] if attr.has_key?(:is_friendlyfire)
    attr[:conditions]['units.is_player'] = attr[:is_player] if attr.has_key?(:is_player)
    attr[:conditions]['sources_segment_damages.is_pet'] = attr[:is_pet] if attr.has_key?(:is_pet)
    attr[:conditions]['units.is_npc'] = attr[:is_npc] if attr.has_key?(:is_npc)
		attr[:conditions]['segment_id'] = attr[:segments] if attr.has_key?(:segments)

		self.find(:all, {
							:select =>
									"DISTINCT(unit_id) AS unit_id, #{unit_t}.name AS unit_name, #{unit_t}.npc_id AS unit_npc_id, #{unit_t}.class_id AS unit_class_id, " +
									"source_id, #{source_t}.name AS source_name, #{source_t}.npc_id AS source_npc_id, #{source_t}.class_id AS source_class_id, " +
									"dest_id, #{dest_t}.name AS dest_name, #{dest_t}.npc_id AS dest_npc_id, #{dest_t}.class_id AS dest_class_id, " +
									"SUM(amount_total) AS amount_total, SUM(amount_hits) AS amount_hits, SUM(amount_crits) AS amount_crits, SUM(amount_absorbs) AS amount_absorbs, SUM(amount_blocks) AS amount_blocks, " +
									"SUM(num_total) AS num_total, SUM(num_hits) AS num_hits, SUM(num_crits) AS num_crits, SUM(num_absorbs) AS num_absorbs, SUM(num_blocks) AS num_blocks, " +
									"SUM(num_misses) AS num_misses, SUM(num_dodges) AS num_dodges, SUM(num_parries) AS num_parries, SUM(num_glancings) AS num_glancings",
							:conditions => attr[:conditions],
							:joins => [ :unit, :source, :dest ],
							:order => "amount_total DESC",
							:group => "unit_id, dest_id" })
	end

	def SegmentDamage.taken(attr = {})

		dest_t = "units"

    attr[:conditions] ||= {}
    attr[:conditions]['dest_id'] = attr[:dest_id] if attr.has_key?(:dest_id)
    attr[:conditions]['is_friendlyfire'] = attr[:friendlyfire] if attr[:friendlyfire]
    attr[:conditions]['units.is_player'] = attr[:is_player] if attr[:is_player]
    attr[:conditions]['units.is_pet'] = attr[:is_pet] if attr.has_key?(:is_pet)
    attr[:conditions]['units.is_npc'] = attr[:is_npc] if attr.has_key?(:is_npc)
    
		self.find(:all, {
							:select => "DISTINCT(dest_id) AS dest_id, #{dest_t}.name as dest_name, #{dest_t}.npc_id AS dest_npc_id, #{dest_t}.class_id AS dest_class_id, SUM(amount_total) AS amount_total, SUM(num_total) AS num_total", #, (#{scope}s.finished_at - #{scope}s.started_at) AS duration",
							:conditions => attr[:conditions],
							:joins => [ :dest ],
							:order => "amount_total desc",
							:group => :dest_id })
	end

	def before_save
		self.amount_total = self.amount_hits + self.amount_crits
		self.num_total = self.num_hits + self.num_crits + self.num_misses + self.num_absorbs + self.num_blocks + self.num_dodges + self.num_parries + self.num_immunes + self.num_glancings + self.num_crushings
	end
end
