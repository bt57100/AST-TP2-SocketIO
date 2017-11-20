# src/app.coffee
express = require 'express'
app = express()
server = require('http').Server(app)
io = require('socket.io')(server)

app.set 'port', 8888
app.set 'views', "#{__dirname}/../views"
app.set 'view engine', 'pug'

app.use '/', express.static "#{__dirname}/../public"

app.get '/', (req, res) ->
  res.render 'index'

io.on 'connection', (socket) ->
  socket.on 'user event', (data) ->
    { user, msg } = data
    if msg == 'JOINED'
      io.emit 'user-joined',
        user: data.user
      console.log "#{data.user} connected !"
    else if msg == 'LEFT'
      io.emit 'user-left',
        user: data.user
      console.log "#{data.user} left !"
    else
      io.emit 'user event',
        user: data.user
        msg: data.msg
      console.log "#{user} said #{msg}."

server.listen app.get('port'), ->
console.log "server listening on #{app.get 'port'}"
