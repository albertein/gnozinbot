module GnozinBot
    module Twitter
        def Twitter.init()
            $username = Twitter.get("/1/account/verify_credentials.xml")
                .elements["screen_name"].text
            puts "Welcome #{$username}"
        end
    
        def Twitter.get(resource)
            response = $session.get (resource)
            return REXML::Document.new(response.body).root
        end
    
        def Twitter.twitt(message, in_reply_to)
            resource = "/1/statuses/update.xml"
            parameters = {:status => message}
            if in_reply_to != -1
                parameters["in_reply_to_status_id"] = in_reply_to
            end
            puts resource
            puts parameters
            $session.post(resource, parameters)
        end
    end
end
