Slack = require 'slack-client'

class Client
  constructor: (@apiKey) ->
    throw new Error('Must provide api key') unless @apiKey?
    @channels = []
    @groups = []

    @slack = new Slack @apiKey, true, true

    @slack.on 'open', =>
      @_init()

    @slack.on 'error', (error) =>
      console.error "Error: #{error}"

    @slack.on 'message', (message) =>
      # console.log message

  login: ->
    @slack.login()

  logout: ->
    @slack.disconnect()

  on: (evnt, cb) ->
    @slack.on evnt, cb

  getUnreadMessages: (channel) ->
    return unless channel
    new Promise (fulfill, reject) =>
      @slack._apiCall 'channels.history',
        channel: channel.id
        count: channel.unread_count
      , (response) ->
        if response.ok
          fulfill response.messages
        else
          reject response

  _init: ->
    @unreads = @slack.getUnreadCount()

    # Get all the channels that bot is a member of
    @channels = ("##{channel.name}" for id, channel of @slack.channels when channel.is_member)

    # Get all groups that are open and not archived
    @groups = (group.name for id, group of @slack.groups when group.is_open and not group.is_archived)

    # console.log "Welcome to Slack. You are @#{@slack.self.name} of #{@slack.team.name}"
    # console.log 'You are in: ' + channels.join(', ')
    # console.log 'As well as: ' + groups.join(', ')

    # messages = if unreads is 1 then 'message' else 'messages'

    # console.log "You have #{unreads} unread #{messages}"

    # unreadChannels = @slack.getChannelsWithUnreads()
    # for channel in unreadChannels
    #   @getUnreadMessages(channel).then (messages) ->
    #     for message in messages
    #       console.log message.text

module.exports = Client
