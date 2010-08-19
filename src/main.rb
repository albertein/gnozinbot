module GnozinBot
    require 'weather'
    require 'twitter.rb'
    require 'answer'
    require 'rubygems'
    require 'launchy'
    gem 'oauth'
    require 'oauth/consumer'
    require 'rexml/document'
    
    def GnozinBot.main() 
        config = { }
        config_file = File.expand_path("~/.gnozinbot")
        if not File.exists?(config_file)
            puts "There is no config file at " << config_file
            puts "Expample of file:"
            puts "CONSUMER_KEY YOUR_CONSUMER_KEY"
            puts "CONSUMER_SECRET YOUR_CONSUMER_SECRET"
            return
        end
    
        File.open(config_file, "r") do |file|
            while (line = file.gets)
                sections = line.split(/\s/)
                config[sections[0]] = sections[1]
            end
        end
    
        consumer = OAuth::Consumer.new(config["CONSUMER_KEY"], config["CONSUMER_SECRET"], {
            :site => "https://api.twitter.com",
            :scheme => :header
        })
        request = consumer.get_request_token
        Launchy.open request.authorize_url #launch browser for auth
        puts "Authorize (or not) the access to the application on the browser that i've just launched"
        puts "Did you authorize the app? [Y/N]:"
        if not STDIN.readline.chomp =~ /^[Yy]/
            puts "That's so sad, well, see you around!"
            return
        end
        puts "Type the twitter auth PIN:"
        $session = request.get_access_token(:oauth_verifier => STDIN.readline.chomp)
    
        Twitter.init()
    
        while true do #Main loop
            Answer.do()
            sleep 60
        end
    end
end
$session = nil
$last_processed_id = -1
$username = ""

GnozinBot.main
#print get_weather_description
#print get_full_weather
