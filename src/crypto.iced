
{createHash} = require 'crypto'

exports.hash160 = hash160 = (x) ->
  sha256 = createHash 'sha256'
  rmd160 = createHash 'rmd160'
  t = sha256.update(x).digest()
  return rmd160.update(t).digest()

