# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	
	def data_path(action, format=nil, attr={})
		query = attr.map { |k,v| "#{k}=#{v}"}.join("&")
		path = "/d/#{action}"
		path << ".#{format}" if format
		path << "?#{query}" if attr.length > 0
		path
	end

	def data_path_merge(attr = {})
		x = params.merge(attr)
		x.delete('controller')
		x.delete('action')
		x.delete('format')
		x
	end
	
	def spell_link(id, name, school_id)
		return "<span class=\"school %s\">%s</span>" % [Spell.html_class(school_id), name] if id < 1
		link_to(name, "http://www.wowhead.com/spell=#{id}", :class => Spell.html_class(school_id))
	end

	def unit_link(id, name, class_id=0, npc_id=0)
		if npc_id and npc_id.to_i > 0
			return link_to(name, "##{id}", :class => "unit npc n_#{npc_id}")
		end
		if class_id and class_id.to_i > 0
			return link_to(name, "##{id}", :class => Unit.html_class(class_id))
		end
		link_to(name, "##{id}", :class => "unit")
	end

	def unit_pet_link(id, name)
		return link_to(name, "##{id}", :class => "unit pet p_#{name.slug}")
	end

	def guild_link(guild)
		link_to(guild.name, guild)
	end

	def report_link(report)
		label = report.started_at.strftime("%a %b %d")
		link_to(label, report)
	end

end
