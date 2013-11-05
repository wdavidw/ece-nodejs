
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
    metrics = []
    rs = db.createReadStream
      start: "metric:#{id}:"
      stop: "metric:#{id};"
    rs.on 'data', (data) ->
      [_, id, timestamp] = data.key.split ':'
      metrics.push id: id, timestamp: timestamp, value: value
    rs.on 'error', callback
    rs.on 'close', ->
      callback null, metrics

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
    ws.on 'error', callback
    ws.on 'close', callback
    for metric in metrics
      {timestamp, value} = metric
      ws.write key: "metric:#{id}:#{timestamp}", value: value
    ws.end()
















