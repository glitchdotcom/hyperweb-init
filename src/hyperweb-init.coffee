# sets up express and file support
# feel free to ignore this and jump to server.js

fs = require "fs"
less = require "less"
LessAutoprefixer = require 'less-plugin-autoprefix'
path = require "path"
randomEmoji = require 'random-emoji'
stylish = require 'stylish'
# stylus = require 'stylus'
stylusAutoprefixer = require 'autoprefixer-stylus'
url = require "url"

module.exports =
  init: ->
    Express = require "express"
    app = Express()

    app.use (req, res, next) ->
      return next() if 'GET' != req.method.toUpperCase() && 'HEAD' != req.method.toUpperCase()

      pathname = url.parse(req.url).pathname

      return next() unless pathname.match /\.css$/
      lessPath = path.join "public", pathname.replace('.css', '.less')

    # CSS preprocessors
      # todo: deprecate LESS specific rendering in favor of something more flexible
      lessAutoprefixer = new LessAutoprefixer()
      fs.readFile lessPath, 'utf8', (err, lessSrc) ->
        if err
          # Ignore ENOENT to fall through as 404.
          if 'ENOENT' == err.code
            next()
          else
            next(err)
        else
          renderOptions =
            filename: lessPath
            paths: []
            plugins: [lessAutoprefixer]

          less.render lessSrc, renderOptions, (err, output) ->
            if err
              next(err)
            else
              res.set('Content-Type', 'text/css')
              res.send output.css

    # todo: verify autoprefixer works for styl
    app.use stylish
      src: __dirname + '/public'
      setup: (renderer) ->
        renderer.use stylusAutoprefixer()
      watchCallback: (error, filename) ->
        if error
          console.log error
        else
          console.log "#{filename} compiled to css"

    # JS preprocessors
    coffeeMiddleware = require('coffee-middleware')
    app.use coffeeMiddleware
      bare: true
      src: "public"
    require('coffee-script/register')

    # Static folder
    app.use(Express.static('public'))

    bodyParser = require('body-parser')
    app.use bodyParser.urlencoded
      extended: false
    app.use bodyParser.json()
    app.use bodyParser.text()

    # template engines
    engines = require('consolidate')
    app.engine('jade', engines.jade)
    app.engine('html', engines.nunjucks)
    app.engine('hbs', engines.handlebars)

    nunjucks = require 'nunjucks'
    nunjucks.configure 'views', { autoescape: true }

    # CSON support
    require 'fs-cson/register'

    # HW projects run on port 3000
    app.set 'port', process.env.PORT or 3000

    # Display success message
    randomEmoji = randomEmoji.random {count: 2}
    emojis = ""
    for emoji in randomEmoji
      emojis += emoji.character

    app.server = app.listen app.get('port'), ->
      console.log("#{emojis} Your app is running")

    return app
