class SegmentsController < ApplicationController
	navigation :reports
	
	# /s/:segment_id/:what.:format
	def data
		@segment = Segment.find(:first, :conditions => { :id => params[:segment_id] })
		@duration = Timespan.new(@segment.started_at, @segment.finished_at)
		html_template = "segment/%s" % params[:node]
		
		case params[:node]
			when "player_damage_done"
				@data = @segment.damages.done(:friendlyfire => false, :player => true)
			else
				return render :text => "Not Found", :status => 404
		end
		
		respond_to do |format|
			format.xml { render :xml => @data.to_xml }
			format.json { render :json => @data.to_json }
			format.html { render :template => html_template, :layout => false }
		end
	end
	
	# /s/:id
	def show
		@segment = Segment.find(:first, :conditions => { :id => params[:id] })
		@encounter = Encounter.find(:first, :conditions => { :id => @segment.encounter_id })
		@report = Report.find(:first, :conditions => { :id => @segment.report_id })
		
		@title = "%s: %s" % [@encounter.boss_name, @segment.label]
		@duration = Timespan.new(@segment.started_at, @segment.finished_at)
		
		if params[:filter]
			render(:text => @segment.to_json, :content_type => :text)
		end
		
		@players_damage_done = @segment.damages.done(:friendlyfire => false, :player => true)
		@players_damage_done_by_spell = @segment.damages.done_spells(:friendlyfire => false, :player => true)
		@players_damage_taken = @segment.damages.taken(:friendlyfire => false, :player => true)
		
		@players_healing_done = @segment.heals.done(:player => true)
		@players_healing_done_by_spell = @segment.heals.done_spells(:player => true)
		@players_healing_taken = @segment.heals.taken(:player => true)
		
		@players_auras = @segment.auras.gained(:player => true)
		@players_dispels = @segment.dispels.done(:player => true)
		@players_steals = @segment.steals.done(:player => true)
		@players_interrupts = @segment.interrupts.done(:player => true)
	end
	
end
