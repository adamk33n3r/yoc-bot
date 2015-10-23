glob = require 'glob'

getFiles = (dir) ->
  return new Promise (fulfill, reject) ->
    glob "#{dir}/*.coffee", (err, files) ->
      return reject err if err
      fulfill files

load = (dir) ->
  return new Promise (fulfill, reject) ->
    getFiles dir
    .then (files) ->
      bots = []
      for file in files
        try
          bots.push require file
        catch e
          console.error e
      fulfill bots

module.exports =
  load: load
