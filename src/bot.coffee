Loader = require './loader'
Client = require './client'

class Bot
  constructor: (apiKey, botDir) ->
    @client = new Client apiKey

    if botDir
      console.log "Loading bots from #{botDir}"
      @bots = []
      Loader.load botDir
      .then (bots) =>
        for bot in bots
          console.log "Loading bot: #{bot.name}"
          @bots.push new bot @
        @client.login()
      .catch (err) ->
        console.error err
    else
      console.log "No botDir provided. Loading echo bot"
      @client.on 'message', (message) ->
        console.log message.toString()
        channel = @bot.client.slack.getChannelGroupOrDMByID message.channel
        unless channel.is_channel?
          @bot.send "Echo: " + msg.text, channel

  register: (events) ->
    for evnt, cb of events
      console.log "Registering event '#{evnt}'"
      @client.on evnt, (message) ->
        try
          cb(message)
        catch e
          console.error "Error:", e

  send: (msg, recipient) ->
    recipient.send msg

module.exports = Bot
