require 'weather'
require 'rubygems'
require 'launchy'
gem 'oauth'
require 'oauth/consumer'

def main() 
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
    puts "Launching browser"
    Launchy.open request.authorize_url
    puts "Please check out your browser and aothorize the app"
    puts "Did you authorize the app? Yes or No?"
    if not STDIN.gets =~ /^[Yy]/
        puts "Thats so sad, well, see you around then!"
        return
    end
end

main
print get_weather_description
print get_full_weather
