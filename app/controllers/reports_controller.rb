class ReportsController < ApplicationController
	navigation :reports
	
	# /r
	def index
		@title = "Reports"
		@reports = Report.find(:all, :include => [:encounters, :segments], :order => :id)
	end

	# /r/:id
	def show
		@report = Report.find(:first, :conditions => { :id => params[:id] } )
		@title = "Report: %s" % @report.label
		@encounters = Encounter.find(:all, :conditions => { :report_id => params[:id] }, :order => :id)
	end

	# /ru/:id
	def units
		@report = Report.find(:first, :conditions => { :id => params[:id] } )
		@title = "Units for report: %s" % @report.label
		@units = Unit.find(:all, :conditions => { :report_id => params[:id] }, :order => :guid)
	end
	
  def d
		@title = "Damage"
		#@table = SegmentDamage.find(:all, :select => "source_id, dest_id, spell_id, SUM(amount_total) AS amount_total, SUM(num_total) AS num_total, report_id, encounter_id, segment_id", :conditions => uri_conditions, :include => [ :source, :dest, :spell, :segment ], :order => "amount_total desc", :group => "source_id" )
		@table = SegmentDamage.find_overview(:conditions => uri_conditions)
		p @table
		render :action => "overview"
  end

  def h
		@title = "Healing"
		@table = SegmentHeal.find(:all, :conditions => uri_conditions, :include => [ :source, :dest, :spell ], :order => "amount_total desc")
		render :action => "table"
  end

end
