require 'rubygems'
require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML(open('http://football.fantasysports.yahoo.com/f1/cheatsheet'))

players = []

doc = doc.css('div#cheatsheet-all')

doc.css('li.My-med').each do |element|
	i = ""
	i << element.text
	i = i.scan(/\w+/)
	if i.length == 4
	  players << {"rank" => "#{i[0]}", 
	  "name" => "#{i[1]} #{i[2]}", 
	  "team" => "#{i[3]}"}
	else 
		players << {"rank" => "#{i[0]}", 
		"name" => "#{i[1]} #{i[2]} #{i[3]}", 
		"team" => "#{i[4]}"}
	end
end
puts players
