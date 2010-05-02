class SegmentHeal < ActiveRecord::Base
	belongs_to :report
	belongs_to :encounter
	belongs_to :segment
	belongs_to :source, :class_name => "Unit"
	belongs_to :dest, :class_name => "Unit"
	belongs_to :spell

	#def after_initialize
	#	self.is_periodic ||= false
	#	self.amount_total, self.amount_hits, self.amount_crits, self.amount_absorbs = 0
	#	self.num_total, self.num_hits, self.num_crits, self.num_absorbs = 0
	#end

	def SegmentHeal.done(attr = {})

		source_t = "units"

    attr[:conditions] ||= {}
    attr[:conditions]['units.is_player'] = attr[:is_player] if attr[:is_player]
    
		self.find(:all, {
							:select => "DISTINCT(source_id) AS source_id, #{source_t}.name AS source_name, #{source_t}.class_id AS source_class_id, SUM(amount_total) AS amount_total, SUM(amount_overheal) AS amount_overheal, SUM(num_total) AS num_total",
							:conditions => attr[:conditions],
							:joins => [ :source ],
							:order => "amount_total desc",
							:group => :source_id })
	end

	def SegmentHeal.done_spells(attr = {})

		source_t = "units"

    attr[:conditions] ||= {}
    attr[:conditions]['units.is_player'] = attr[:player] if attr[:player]
    
		self.find(:all, {
							:select => "DISTINCT(source_id) AS source_id, #{source_t}.name AS source_name, #{source_t}.class_id AS source_class_id, spell_id, spells.name AS spell_name, spells.school AS spell_school, SUM(amount_total) AS amount_total, SUM(amount_overheal) AS amount_overheal, SUM(num_total) AS num_total", #, (#{scope}s.finished_at - #{scope}s.started_at) AS duration",
							:conditions => attr[:conditions],
							:joins => [ :source, :spell ],
							:order => "source_name ASC, amount_total DESC",
							:group => "source_id, spell_id" })
	end

	def SegmentHeal.taken(attr = {})

		dest_t = "units"

    attr[:conditions] ||= {}
    attr[:conditions]['units.is_player'] = attr[:player] if attr[:player]
    
		self.find(:all, {
							:select => "DISTINCT(dest_id) AS dest_id, #{dest_t}.name as dest_name, #{dest_t}.class_id AS dest_class_id, SUM(amount_total) AS amount_total, SUM(amount_overheal) AS amount_overheal, SUM(num_total) AS num_total", #, (#{scope}s.finished_at - #{scope}s.started_at) AS duration",
							:conditions => attr[:conditions],
							:joins => [ :dest ],
							:order => "amount_total desc",
							:group => :dest_id })
	end

	def before_save
		self.amount_total = self.amount_hits + self.amount_crits
		self.num_total = self.num_hits + self.num_crits
	end
	
end
