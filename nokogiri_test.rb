require 'rubygems'
require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML(open('http://espn.go.com/fantasy/football/story/_/page/TMR140326/matthew-berry-2014-fantasy-football-rankings-top-200'))

players = []

for p in 1..200 do
  # get first line
  i = ""
	i << "#{doc.css('tr')[p].text}"
	# get word values only
	i = i.scan(/\w+/)
	# add player in hash to players array
	if i.length == 6
	  players << {"rank" => "#{i[0]}", 
	  						"name" => "#{i[1]} #{i[2]}", 
	  						"team" => "#{i[3]}", 
	  						"pos_rank" => "#{i[4]}", 
	  						"bye" => "#{i[5]}"}
	else 
		players << {"rank" => "#{i[0]}", 
	  						"name" => "#{i[1]} #{i[2]} #{i[3]}", 
	  						"team" => "#{i[4]}", 
	  						"pos_rank" => "#{i[5]}", 
	  						"bye" => "#{i[6]}"}
	end
end

puts players


