# Aim: get a list of 300 players ranked in order from NFL fantasy API
# Approach: create function that takes number of records

require 'net/http'
require 'rexml/document'

# set global variable (both functions need to use it)
@players = []

# function that calls the nfl api and returns results in array of hashes 
def nfl_api_caller(url)
  # get the XML data as a string
  xml_data = Net::HTTP.get_response(URI.parse(url)).body

  # extract event information
  doc = REXML::Document.new(xml_data)

  doc.elements.each('players/player') do |ele|
    firstName = ele.attributes["firstName"]
    lastName = ele.attributes["lastName"]
    rank = ele.attributes["rank"]
    team = ele.attributes["teamAbbr"]
    position = ele.attributes["position"]
    player = {"firstname" => firstName, "lastname" => lastName, "rank" => rank, "team" => team, "position" => position}
    @players.push(player)
  end

end

def nfl_api_looper(number_of_records)

  # set api string and parameter names
  url = 'http://api.fantasy.nfl.com/players/userdraftranks'

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
    for i in number_of_records..@players.length do
      @players.delete_at(i)
    end
  end
end

# puts the output nicely
nfl_api_looper(250)
@players.each {|i| puts "#{i['firstname']} #{i['lastname']}, #{i['team']} #{i['position']}, rank:#{i['rank']}\n"}
puts @players.length