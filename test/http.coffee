
should = require 'should'
request = require 'request'

describe 'HTTP REST API', ->

  it 'post and get a metric', (next) ->
    request.post 'http://localhost:1234/metrics/2.json', [
      timestamp:(new Date '2013-11-04 14:00 UTC').getTime(), value:3
    ,
      timestamp:(new Date '2013-11-04 14:10 UTC').getTime(), value:4 
    ], (err, res, body) ->
      return next err if err
      return new Error "Invalid response code: #{res.statusCode}" unless res.statusCode is 200
      request.get 'http://localhost:1234/metrics/2.json', (err, res, body) ->
        return next err if err or res.statusCode isnt 200
        metrics = JSON.parse(body).metrics
        metrics.length.should.equal 2
        next()

  it 'remove a metric', (next) ->
    request.post 'http://localhost:1234/metrics/2.json', [
      timestamp:(new Date '2013-11-04 14:00 UTC').getTime(), value:3
    ,
      timestamp:(new Date '2013-11-04 14:10 UTC').getTime(), value:4 
    ], (err, res, body) ->
      return next err if err
      return new Error "Invalid response code: #{res.statusCode}" unless res.statusCode is 200
      request.delete 'http://localhost:1234/metrics/2.json', (err, res, body) ->
        return next err if err
        return new Error "Invalid response code: #{res.statusCode}" unless res.statusCode is 200
        request.get 'http://localhost:1234/metrics/2.json', (err, res, body) ->
          return next err if err
          res.statusCode.should.eql 404
          next()
