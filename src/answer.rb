module GnozinBot
    module Answer
        def Answer.do()
            updates_resource = "/1/statuses/friends_timeline.xml?count=50"
            if ($last_processed_id != -1)
                updates_resource <<= "&since_id=#{last_id}"
            end
            Twitter.get(updates_resource).elements.each("status") { |node| 
                Answer.analyze_status (node)
            }
        end
        def Answer.analyze_status(status)
            status_id = Integer(status.elements["id"].text)
            screen_name = status.elements["user"].elements["screen_name"].text
            if status_id > $last_processed_id
                $last_processed_id = status_id
            end
            text = status.elements["text"].text.downcase
            answer, message = Answer.try_grammar_nazy(text)
            if answer
                Twitter.twitt("@#{screen_name} #{message}", status_id)
            end
        end
    
        def Answer.try_grammar_nazy(text)
            if (text.include? "tal ves")
                messages = [
                    "Recuerda que existe la Z! #perdonalosnosabenloquehacen",
                    "No sera tal VEZ?"
                ]
                return true, messages[rand(messages.size)]
            end
            return false, ""
        end
    end
end
