
http = require 'http'
stylus = require 'stylus'
express = require 'express'
metrics = require './metrics'

app = express()

app.set 'views', __dirname + '/../views'
app.set 'view engine', 'jade'
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser 'your secret here'
app.use express.session()
app.use app.router
app.use stylus.middleware "#{__dirname}/../public"
app.use express.static "#{__dirname}/../public"
app.use express.errorHandler
  showStack: true
  dumpExceptions: true

app.get '/', (req, res) ->
  res.render 'index', title: 'toto'

app.get '/metric/:id.json', (req, res, next) ->
  metrics.get req.params.id, (err, values) ->
    return next err if err
    res.json
      id: req.params.id
      values: values

app.post '/metric/:id.json', (req, res, next) ->
  values = JSON.parse req.body
  metrics.save req.params.id, values, (err) ->
    return next err if err
    res.json status: 'OK'

app.delete '/metric/:id.json', (req, res, next) ->
  metrics.remove req.params.id, (err) ->
    return next err if err
    res.json status: 'OK'

http.createServer(app).listen 1234, ->
  console.log 'http://localhost:1234'

