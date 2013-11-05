
{exec} = require 'child_process'
should = require 'should'
metrics = require '../lib/metrics'

describe "metrics", () ->

  it "get a metric", (next) ->
    metrics.get 'metric_1', (err, metrics) ->
      return next err if err
      metrics.length.should.eql 2
      [m1, m2] = metrics
      m1.timestamp.should.eql (new Date '2013-11-04 14:00 UTC').getTime()
      m1.value.should.eql 1234
      m2.timestamp.should.eql m1.timestamp + 10*60*1000
      next()

