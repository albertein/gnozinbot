def get_weather()
    require 'net/http'
    require 'rexml/document'

    weather_host = "weather.yahooapis.com"
    weather_resource = "/forecastrss?w=117994&u=c"
    resource = Net::HTTP.new(weather_host, 80)
    headers, raw_data = resource.get(weather_resource)
    document = REXML::Document.new(raw_data)
    node = document.root.elements["channel"].elements["item"]
    node = node.elements["yweather:condition"]
    return node.attributes["code"], Integer(node.attributes["temp"]), 
           node.attributes["text"]
end

def get_full_weather()
    code, temp, condition = get_weather
    return String(temp) << "C " << condition
end

def get_weather_description()
    condition, temp = get_weather
    #    TODO: Implement bitching about weather condition
    #          ej: Cloudy, raining, etc.
    print temp
    if temp < 26 and temp > 20
        return "Esta el clima agradable, fresqueson"
    elsif temp < 20
        return "A cabron, ahora si hace frio"
    elsif temp > 26 and temp < 31
        return "Calorsito agradable"
    elsif temp > 30 and temp < 40
        return "Pinche calor que nos aventamos"
    else
        return "Se desata el infierno en culiacan"
    end
end

print get_weather_description
print get_full_weather
