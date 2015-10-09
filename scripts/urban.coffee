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
#   hubot define[num] <term>   - Searches Urban Dictionary and returns [num]th definition
#   hubot example[num] <term>  - Searches Urban Dictionary and returns [num]th example 
#
# Author:
#   Derek Chen

module.exports = (robot) ->

  robot.respond /what ?is ([^\?]*)[\?]*/i, (msg) ->
    urbanDict msg, msg.match[1], 0, (found, entry) ->
      if !found
        msg.send "I don't know what \"#{msg.match[1]}\" is"
        return
      msg.send "#{entry.definition}"

  robot.respond /define([0-9])* (.*)/i, (msg) ->
    defnum = 0
    if msg.match[1]
        defnum = msg.match[1]-1
    urbanDict msg, msg.match[2], defnum, (found, entry) ->
      if !found
        msg.send "I don't know what \"#{msg.match[2]}\" is"
        return
      msg.send "#{entry.definition}"

  robot.respond /example([0-9])* (.*)/i, (msg) ->
    defnum = 0
    if msg.match[1]
        defnum = msg.match[1]-1
    urbanDict msg, msg.match[2], defnum, (found, entry) ->
      if !found
        msg.send "I don't know about an example of \"#{msg.match[2]}\""
        return
      msg.send "#{entry.example}"

urbanDict = (msg, query, defnum = 0, callback) ->
  msg.http("http://api.urbandictionary.com/v0/define?term=#{escape(query)}")
    .get() (err, res, body) ->
      result = JSON.parse(body)
      if result.list.length-1 >= defnum
        callback(true, result.list[defnum])
      else
        callback(false)
