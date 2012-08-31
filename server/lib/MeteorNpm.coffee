meteorNpm = do() ->
  require = __meteor_bootstrap__.require

  path    = require 'path'
  fs      = require 'fs'

  base = path.resolve '.'
  if base is '/'
    base = path.dirname global.require.main.filename

  meteorNpm =
    # requires npm modules placed in `public/node_modules`
    require: (moduleName) ->
      modulePath = 'node_modules/' + moduleName

      publicPath = path.resolve(base + '/public/' + modulePath)
      staticPath = path.resolve(base + '/bundle/static/' + modulePath)

      if path.existsSync(publicPath)
        module = require publicPath
      else if path.existsSync(staticPath)
        module = require staticPath
      else
        module = null

      return module