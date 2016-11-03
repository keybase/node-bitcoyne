kbpgp = require 'kbpgp'
{SHA256} = kbpgp.hash
{base58} = kbpgp
{bufeq_secure} = require('pgp-utils').util

#======================================================================

decode = (s) ->
  try
    buf = base58.decode s
    return [ null, buf]
  catch err
    return [err, null]

#==============================

check_hash = (buf) ->
  if buf.length < 8
    new Error "address too short"
  else
    pkhash = buf[0...-4]
    checksum1 = buf[-4...]
    checksum2 = (SHA256 SHA256 pkhash)[0...4]
    if not bufeq_secure checksum1, checksum2
      new Error "Checksum mismatch"
    else
      null

#==============================

match_prefix = (buf, prefixes) ->
  for prefix in prefixes
    return prefix if bufeq_secure(prefix, buf[0...prefix.length])
  null

#==============================

# Check for BTC in general (either standard or multisig)
exports.check = check = (s, opts = {}) ->
  versions = opts.versions or [0,5]
  [err,buf] = decode s
  return [err,null] if err?
  v = buf.readUInt8 0
  err = if not (v in versions) then new Error "Bad version found: #{v}"
  else check_hash buf
  ret = if err? then null else { version : v, pkhash : buf[1...-4] }
  return [err, ret]

#======================================================================

# Check that the address starts with the given prefixes (can be multi-byte)
# and that it decodes and checksums properly
exports.check_with_prefixes = check_with_prefixes = (s, prefixes) ->
  ret = null
  [err,buf] = decode s
  err = check_hash(buf) unless err?
  unless err?
    ret = match_prefix buf, prefixes
    err = if ret? then null else new Error "Bad address, doesn't match known prefixes"
  [err, ret]

#======================================================================

# check that the given addresss is either a bitcoin or a Zcash address,
# and return a description of which subtype.
exports.check_btc_or_zcash = (s) ->
  types =   {
    "00"   : { family : "bitcoin", type : "bitcoin" } # BTC normal
    "05"   : { family : "bitcoin", type : "bitcoin" } # multisig
    "169a" : { family : "zcash"  , type : "zcash.z" } # z address
    "1cb8" : { family : "zcash"  , type : "zcash.t" } # transparent PK address
    "1cbd" : { family : "zcash"  , type : "zcash.t" } # transparent sig address
  }
  prefixes = ((new Buffer k, 'hex') for k of types)
  [err, prefix] = check_with_prefixes s, prefixes
  return [err] if err?
  ret = types[prefix.toString('hex')]
  ret.prefix = prefix
  [err, ret]

#======================================================================

