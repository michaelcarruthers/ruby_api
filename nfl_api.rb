# Aim: get a list of 300 players ranked in order from NFL fantasy API
# Approach: create function that takes number of records
require 'net/http'
require 'json'

#sets global variable
PLAYERS = []

class Player
	#these player attributes are accessible
	attr_accessor :firstName,:lastName,:rank,:team,:pos

  def initialize(firstname, lastname, rank, team, pos)
    @firstName = firstname; @lastName = lastname; @rank = rank; @team = team; @pos = pos
  end

end

def nfl_api_caller(url)

	uri = URI.parse(url)

	players = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
	  resource = "#{uri.path}?#{uri.query}"
	  JSON.parse(http.get(resource).body)['players']
	end

	players.each do |p|
		PLAYERS.push(Player.new(p['firstName'],p['lastName'],p['rank'],p['teamAbbr'],p['position']))
	end
end

def nfl_api_looper(number_of_records)

  url = 'http://api.fantasy.nfl.com/players/editordraftranks?format=json'

  if number_of_records <=100
    nfl_api_caller(url + "&count=#{number_of_records}")
  else
  	# deal with multiple API queries
    times = number_of_records/100
    offset = 0
    for i in 1..times+1.round do
      nfl_api_caller(url+"&count=100&offset=#{offset}")
      offset += 100
    end

    # delete extra records
    for i in number_of_records..PLAYERS.length do 
      PLAYERS.delete_at(i)
    end
  end
end

nfl_api_looper(290)
PLAYERS.each {|i| puts "#{i.firstName} #{i.lastName}, #{i.team} #{i.pos}, rank:#{i.rank}"}
puts PLAYERS.length
