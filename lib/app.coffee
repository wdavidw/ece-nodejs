
http = require 'http'
stylus = require 'stylus'
nib = require 'nib'
express = require 'express'
bodyParser = require 'body-parser'
cookieParser = require 'cookie-parser'
methodOverride = require 'method-override'
session = require 'express-session'
errorhandler = require 'errorhandler'
dojo = require 'connect-dojo'
coffee = require 'connect-coffee-script'
serve_favicon = require 'serve-favicon'
serve_index = require 'serve-index'
serve_static = require 'serve-static'
# config = require '../conf/hdfs'

app = express()
server = http.Server(app)
io = require('socket.io')(server)

sockets = []

io.on 'connection', (socket) ->
  sockets.push socket

app.set 'views', __dirname + '/../views'
app.set 'view engine', 'jade'
app.use serve_favicon "#{__dirname}/../public/favicon.ico"
app.use bodyParser.json()
app.use bodyParser.urlencoded()
app.use cookieParser 'toto'
app.use methodOverride '_method'
app.use session secret: 'toto', resave: true, saveUninitialized: true

app.use (req, res, next) ->
  req.session.count ?=  0
  req.session.count++
  req.session.history ?= []
  req.session.history.push req.url
  for socket, i in sockets
    console.log 'emit logs'
    socket.emit 'logs',
      username: req.session.username or 'anonymous'
      count: req.session.count
      url: req.url
  next()

app.use coffee
  src: "#{__dirname}/../views"
  dest: "#{__dirname}/../public"
  bare: true
app.use stylus.middleware
  src: "#{__dirname}/../views"
  dest: "#{__dirname}/../public"
  compile: (str, path) ->
    stylus(str)
    .set('filename', path)
    .set('compress', config?.css?.compress)
    .use nib()
app.use serve_static "#{__dirname}/../public"

app.get '/', (req, res, next) ->
  res.render 'index', title: 'Express'

app.get '/admin', (req, res, next) ->
  res.render 'admin', title: 'Express'
  
app.post '/user/login', (req, res, next) ->
  for socket, i in sockets
    socket.emit 'login', username: 'wdavidw', crdate: Date.now()
  req.session.username = 'wdavidw'
  res.json
    username: 'wdavidw'
    lastname: 'Worms'
    Firstname: 'David'
    email: 'david@adaltas.com'

app.use serve_index "#{__dirname}/../public"
if process.env.NODE_ENV is 'development'
  app.use errorhandler()


module.exports = server
