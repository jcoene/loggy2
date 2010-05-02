class DataController < ApplicationController
	before_filter :parse_data_params
	
  def damage_done; respond_with_data @scope.damages.done(@attr); end
  def damage_done_spells; respond_with_data @scope.damages.done_spells(@attr); end
  def damage_taken; respond_with_data @scope.damages.taken(@attr); end
  def healing_done; respond_with_data @scope.heals.done(@attr); end
 	def healing_done_spells; respond_with_data @scope.heals.done_spells(@attr); end
 	def healing_taken; respond_with_data @scope.heals.taken(@attr); end
 	def auras_gained; respond_with_data @scope.auras.gained(@attr); end
 	def dispels_done; respond_with_data @scope.dispels.done(@attr); end
 	def steals_done; respond_with_data @scope.steals.done(@attr); end
 	def interrupts_done; respond_with_data @scope.interrupts.done(@attr); end
 	
 	private

	def parse_data_params
		@attr = {}
		@attr[:encounter_id] = params[:encounter_id].to_i if is_integer(params[:encounter_id])
		@attr[:segment_id] = params[:segment_id].to_i if is_integer(params[:segment_id])
		@attr[:source_id] = params[:source_id].to_i if is_integer(params[:source_id])
		@attr[:dest_id] = params[:dest_id].to_i if is_integer(params[:dest_id])
		@attr[:unit_id] = params[:unit_id].to_i if is_integer(params[:unit_id])
		@attr[:is_player] = to_boolean(params[:is_player]) if is_boolean(params[:is_player])
		@attr[:is_pet] = to_boolean(params[:is_pet]) if is_boolean(params[:is_pet])
		@attr[:is_npc] = to_boolean(params[:is_npc]) if is_boolean(params[:is_npc])
		@attr[:is_friendlyfire] = to_boolean(params[:is_friendlyfire]) if is_boolean(params[:is_friendlyfire])
		
		if @attr[:segment_id] then
			@segment = Segment.find(:first, :conditions => { :id => @attr[:segment_id] })
			@encounter = @segment.encounter_id if not @segment.blank?
			
			if @segment.blank? or @encounter.blank? then
				render :text => "Invalid segment.", :status => 500
			else
				@scope = @segment
				@duration = Timespan.new(@segment.started_at, @segment.finished_at)
			end
			
		elsif @attr[:encounter_id] then
			@encounter ||= Encounter.find(:first, :conditions => { :id => @attr[:encounter_id] })
			
			if @encounter.blank? then
				render :text => "Invalid encounter.", :status => 500
			else
				@scope = @encounter
				@duration = Timespan.new(@encounter.started_at, @encounter.finished_at)
			end
			
		else
			render :text => "Invalid parameters.", :status => 500
			
		end
	end
	
	def respond_with_data(data=nil)
		@data = data if data
		respond_to do |format|
			format.xml { render :xml => @data.to_xml }
			format.json { render :json => @data.to_json }
			format.html { render :layout => false }
		end
	end
	
 

end
