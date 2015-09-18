# Description:
#   Define terms via Urban Dictionary
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot what is <term>  - Searches Urban Dictionary and returns definition
#   hubot define <term>   - Searches Urban Dictionary and returns definition
#   hubot example <term>  - Searches Urban Dictionary and returns example 
#
# Author:
#   Derek Chen

module.exports = (robot) ->

  robot.respond /what ?is ([^\?]*)[\?]*/i, (msg) ->
    urbanDict msg, msg.match[1], (found, entry, sounds) ->
      if !found
        msg.send "I don't know what \"#{msg.match[1]}\" is"
        return
      msg.send "#{entry.definition}"

  robot.respond /define (.*)/i, (msg) ->
    urbanDict msg, msg.match[1], (found, entry, sounds) ->
      if !found
        msg.send "\"#{msg.match[1]}\" not found"
        return
      msg.send "#{entry.definition}"

  robot.respond /example (.*)/i, (msg) ->
    urbanDict msg, msg.match[1], (found, entry, sounds) ->
      if !found
        msg.send "\"#{msg.match[1]}\" not found"
        return
      msg.send "#{entry.example}"

urbanDict = (msg, query, callback) ->
  msg.http("http://api.urbandictionary.com/v0/define?term=#{escape(query)}")
    .get() (err, res, body) ->
      result = JSON.parse(body)
      if result.list.length
        callback(true, result.list[0], result.sounds)
      else
        callback(false)
