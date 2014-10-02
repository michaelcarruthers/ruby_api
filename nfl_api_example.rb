require 'net/http'
require 'rexml/document'

# hit nfl rankings api
url = 'http://api.fantasy.nfl.com/players/userdraftranks?count=100'

# get the XML data as a string
xml_data = Net::HTTP.get_response(URI.parse(url)).body

# extract event information
doc = REXML::Document.new(xml_data)

players = []

doc.elements.each('players/player') do |ele|
  firstName = ele.attributes["firstName"]
  lastName = ele.attributes["lastName"]
  rank = ele.attributes["rank"]
  player = {"firstname" => firstName, "lastname" => lastName, "rank" => rank}
  players.push(player)
end

players.each {|i| puts "#{i['firstname']} #{i['lastname']}, rank:#{i['rank']}\n"}
