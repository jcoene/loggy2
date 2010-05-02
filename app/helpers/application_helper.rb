# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	
	def data_path(action, format=nil, attr={})
		query = attr.map { |k,v| "#{k}=#{v}"}.join("&")
		path = "/d/%s" % action
		path << ".#{format}" if format
		path << "?#{query}" if attr.length > 0
		path
	end
	
	def spell_link(id, name, school_id)
		return "<span class=\"school %s\">%s</span>" % [Spell.html_class(school_id), name] if id < 1
		link_to(name, "http://www.wowhead.com/spell=#{id}", :class => Spell.html_class(school_id))
	end

	def unit_link(id, name, class_id)
		link_to(name, "##{id}", :class => Unit.html_class(class_id))
	end

end
