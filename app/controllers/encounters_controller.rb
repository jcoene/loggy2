class EncountersController < ApplicationController
	navigation :reports

  def index
		
  end

	# /e/:id
	def show
		@encounter = Encounter.find(:first, :include => [:guild], :conditions => { :id => params[:id] })
		@title = @encounter.boss_name
		@duration = Timespan.new(@encounter.started_at, @encounter.finished_at)
		@segments_list = @encounter.segments.collect{ |s| [s.label, s.id] }
		@segments_selected = params[:segments].map {|s| s.to_i} unless not params[:segments]
		@segments_selected ||= @encounter.segments.map {|s| s.id.to_i }
		
	end

	private

	def uri_conditions
		h = %w[source_id dest_id spell_id report_id encounter_id segment_id]
		c = {}
		params.each { |k,v| c[k] = v if h.include?(k) }
		c
	end

end
