# Aim: get a list of 300 players ranked in order from NFL fantasy API
# Approach: create function that takes number of records

require 'net/http'
require 'rexml/document'

# set global variable (both functions need to use it)
PLAYERS = []

# create players class
class Player

  def initialize(firstname, lastname, rank, team, pos)
    @stats = {'firstname'=>firstname, 'lastname'=>lastname, 'rank'=>rank,
      'team'=>team, 'pos'=>pos}
  end

  def all_stats(s)
    s = @stats
    puts "#{s['firstname']} #{s['lastname']}, #{s['team']} #{s['pos']}, rank: #{s['rank']}" 
  end

end

# function that calls the nfl api and returns results in array of hashes 
def nfl_api_caller(url)
  # get the XML data as a string
  xml_data = Net::HTTP.get_response(URI.parse(url)).body
  # extract event information
  doc = REXML::Document.new(xml_data)

  doc.elements.each('players/player') do |ele|
    new_player = Player.new(ele.attributes["firstName"], ele.attributes["lastName"], 
      ele.attributes["rank"], ele.attributes["teamAbbr"], ele.attributes["position"])
    PLAYERS.push(new_player)
  end

end

def nfl_api_looper(number_of_records)

  # set api string and parameter names
  url = 'http://api.fantasy.nfl.com/players/editordraftranks'

  if number_of_records <=100
    # call api and get one load of xml data
    nfl_api_caller(url + "?count=#{number_of_records}")
  else
    # find the number of times we need to loop
    times = number_of_records/100
    offset = 0
    # call the api and loop, incrementally increasing the offset until total 
    for i in 1..times+1.round do
      nfl_api_caller(url+"?count=100&offset=#{offset}")
      offset += 100
    end

    # only return the amount of records that was asked for
    for i in number_of_records..PLAYERS.length do
      PLAYERS.delete_at(i)
    end
  end
end

# puts the output nicely
nfl_api_looper(275)
PLAYERS.each {|i| i.all_stats "\n"}
puts PLAYERS.length