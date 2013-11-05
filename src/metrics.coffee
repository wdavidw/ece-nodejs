
db = require('./db') "#{__dirname}/../db/test"

module.exports =
  ###
  `get(id, [options], callback)`
  ----------------------------
  Return an array of metrics.

  Parameters
  `id`        Metric id as integer
  `callback`  Contains an err as first argument 
              if any

  Options
  `start`     Timestamp
  `end`       Timestamp
  `timestamp` Step between each metrics 
              in milliseconds
  ###
  get: (id, options, callback) ->
    callback = options if arguments.length is 2
    setImmediate ->
      callback null, [
        timestamp: (new Date '2013-11-04 14:00 UTC').getTime(),
        value: 1234
      ,
        timestamp: (new Date '2013-11-04 14:10 UTC').getTime(),
        value: 5678
      ]
  ###
  `save(id, metrics, callback)`
  ----------------------------

  Parameters
  `id`       Metric id as integer
  `metrics`  Array with timestamp as keys 
             and integer as values
  `callback` Contains an err as first argument 
             if any
  ###
  save: (id, metrics, callback) ->
    ws = db.createWriteStream()
    ws.on 'error', (err) ->
      callback err
    ws.on 'close', ->
      callback()
    for metric in metrics
      
      {timestamp, value} = metric
      ws.write key: "metric:#{id}:#{timestamp}", value: value
    ws.end()
















