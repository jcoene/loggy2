class GuildController < ApplicationController
  def index
		@guilds = Guild.all(:order => :name)
  end

  def show
		@guild = Guild.find(:first, :conditions => {:id => params['id']})
		@title = "Guild: %s" % @guild.name
  end

end
