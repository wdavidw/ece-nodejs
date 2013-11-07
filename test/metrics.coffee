
{exec} = require 'child_process'
should = require 'should'

describe "metrics", () ->

  metrics = null
  before (next) ->
    # "remove -item #{__dirname}/../db/test -recurse -force"
    dir = "#{__dirname}/../db/test"
    exec "rm -rf #{dir} && mkdir #{dir}", (err, stdout) ->
      metrics = require '../lib/metrics'
      next err

  it "get a metric", (next) ->
    metrics.save 'metric_1', [
      timestamp: (new Date '2013-11-04 14:00 UTC').getTime(), value: 1234
    ,
      timestamp: (new Date '2013-11-04 14:10 UTC').getTime(), value: 2345
    ], (err) ->
      return next err if err
      metrics.get 'metric_1', (err, metrics) ->
        return next err if err
        metrics.length.should.eql 2
        [m1, m2] = metrics
        m1.timestamp.should.eql (new Date '2013-11-04 14:00 UTC').getTime()
        m1.value.should.eql 1234
        m2.timestamp.should.eql m1.timestamp + 10*60*1000
        next()

