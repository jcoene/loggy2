class EncounterController < ApplicationController

  def index
		
  end

	# /e/:id
	def show
		@encounter = Encounter.find(:first, :conditions => { :id => params[:id] })
		@segments = @encounter.segments.all

		@title = "Encounter: %s" % @encounter.boss_name
		@duration = Timespan.new(@encounter.started_at, @encounter.finished_at)

    @players_damage_done = @encounter.damages.done(:friendlyfire => false, :player => true)
    @players_damage_done_by_spell = @encounter.damages.done_spells(:friendlyfire => false, :player => true)
    @players_damage_taken = @encounter.damages.taken(:friendlyfire => false, :player => true)
    
    @players_healing_done = @encounter.heals.done(:player => true)
    @players_healing_done_by_spell = @encounter.heals.done_spells(:player => true)
    @players_healing_taken = @encounter.heals.taken(:player => true)

		@players_auras = @encounter.auras.gained(:player => true)
		@players_dispels = @encounter.dispels.done(:player => true)
		@players_steals = @encounter.steals.done(:player => true)
		@players_interrupts = @encounter.interrupts.done(:player => true)
		
	end

	private

	def uri_conditions
		h = %w[source_id dest_id spell_id report_id encounter_id segment_id]
		c = {}
		params.each { |k,v| c[k] = v if h.include?(k) }
		c
	end

end
