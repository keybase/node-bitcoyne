
{bufeq_secure} = require('pgp-utils').util
base32 = require 'base32.js'

crc16_xmodem = (x) ->
  crc = 0
  for byte in x
    code = crc >>> 8 & 0xFF
    code ^= byte & 0xFF
    code ^= code >>> 4
    crc = crc << 8 & 0xFFFF
    crc ^= code
    code = code << 5 & 0xFFFF
    crc ^= code
    code = code << 7 & 0xFFFF
    crc ^= code
  crc

exports.checksum = checksum = (version, data) ->
  ret = new Buffer [0,0]
  b = Buffer.concat [ version, data ]
  crc = crc16_xmodem b
  ret.writeUInt16LE crc, 0
  ret

version_bytes =
  ed25519PublicKey:  6  << 3 # G
  ed25519SecretSeed: 18 << 3 # S
  preAuthTx:         19 << 3 # T
  sha256Hash:        23 << 3 # X

version_byte = (typ) ->
  if (b = version_bytes[typ]) then new Buffer [b]
  else null

encode_check = (typ, data) ->
  unless data?.length
    throw new Error "cannot encode null data"
  unless (version = version_byte(typ))?
    throw new Error """#{versionByteName} is not a valid version byte name. Expected one of "ed25519PublicKey", "ed25519SecretSeed", "preAuthTx", "sha256Hash" """
  buf = Buffer.concat [ version, data, checksum(version, data) ]
  base32.encode(buf).toUpperCase()

decode_check = (typ, s) ->
  unless typeof(s) is 'string'
    throw new Error "Bad value, expected a string"
  b = base32.decode s.toLowerCase()
  unless (version = version_byte(typ))?
    throw new Error """#{versionByteName} is not a valid version byte name. Expected one of "ed25519PublicKey", "ed25519SecretSeed", "preAuthTx", "sha256Hash" """
  if b.length < 5
    throw new Error "need at least 5 bytes of data"
  version = b[0...1]
  data = b[1...-2]
  crc = b[-2...]
  unless base32.encode(b) is s
    throw new Error "bad encoding"
  unless bufeq_secure crc, checksum(version, data)
    throw new Error "Bad checksum"
  unless bufeq_secure version_byte(typ), version
    throw new Error "Unexpected version byte"
  unless encode_check(typ,data) is s
    throw new Error "failed encode/decode round-trip check"
  data

is_valid = (typ, s) ->
  return false unless s?.length is 56
  try
    decoded = decode_check(typ, s)
    return decoded.length is 32
  catch e
    return false

exports.public_key =
  encode   : (d) -> encode_check 'ed25519PublicKey', d
  decode   : (s) -> decode_check 'ed25519PublicKey', s
  is_valid : (s) -> is_valid     'ed25519PublicKey', s
exports.secret_key =
  encode   : (d) -> encode_check 'ed25519SecretSeed', d
  decode   : (s) -> decode_check 'ed25519SecretSeed', s
  is_valid : (s) -> is_valid     'ed25519SecretSeed', s
exports.pre_tx_auth =
  encode   : (d) -> encode_check 'preAuthTx', d
  decode   : (s) -> decode_check 'preAuthTx', s
  is_valid : (s) -> is_valid     'preAuthTx', s
exports.hash =
  encode   : (d) -> encode_check 'sha256Hash', d
  decode   : (s) -> decode_check 'sha256Hash', s
  is_valid : (s) -> is_valid     'sha256Hash', s
