class BossesController < ApplicationController
	navigation :bosses
	
  # GET /bosses
  # GET /bosses.xml
  def index
    @bosses = Boss.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bosses }
    end
  end

  # GET /bosses/1
  # GET /bosses/1.xml
  def show
    @boss = Boss.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @boss }
    end
  end

  # GET /bosses/new
  # GET /bosses/new.xml
  def new
    @boss = Boss.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @boss }
    end
  end

  # GET /bosses/1/edit
  def edit
    @boss = Boss.find(params[:id])
  end

  # POST /bosses
  # POST /bosses.xml
  def create
    @boss = Boss.new(params[:boss])

    respond_to do |format|
      if @boss.save
        flash[:notice] = 'Boss was successfully created.'
        format.html { redirect_to(@boss) }
        format.xml  { render :xml => @boss, :status => :created, :location => @boss }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @boss.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bosses/1
  # PUT /bosses/1.xml
  def update
    @boss = Boss.find(params[:id])

    respond_to do |format|
      if @boss.update_attributes(params[:boss])
        flash[:notice] = 'Boss was successfully updated.'
        format.html { redirect_to(@boss) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @boss.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bosses/1
  # DELETE /bosses/1.xml
  def destroy
    @boss = Boss.find(params[:id])
    @boss.destroy

    respond_to do |format|
      format.html { redirect_to(bosses_url) }
      format.xml  { head :ok }
    end
  end
end
