spawn = require('child_process').spawn
express = require 'express'
app = express()
env = app.get 'env'
app.use require('morgan')('dev')
app.use express.static(__dirname + '/output')
app.post '/', (req, res, next) ->
  command = spawn 'bash', ['-s']
  req.pipe command.stdin
  command.stdout.on 'data', (data) -> res.write data
  command.stderr.on 'data', (data) -> res.write data
  command.on 'close', (code) -> res.end "exited with code: #{code}\n"
app.use require('errorhandler')() if env == 'development'
app.listen process.env.PORT or 3000
