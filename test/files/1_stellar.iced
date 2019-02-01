
kbpgp = require 'kbpgp'
{make_esc} = require 'iced-error'
{StrKey} = require 'stellar-base'
{stellar} = require '../..'
{bufeq_secure} = require('pgp-utils').util
{prng} = require 'crypto'
base32 = require 'base32.js'

gen = (opts, cb) ->
  esc = make_esc cb, "gen"
  await kbpgp.kb.KeyManager.generate {}, esc defer km
  await km.export_public {}, esc defer kid
  await km.export_private {}, esc defer priv
  pub = Buffer.from kid[4...-2], 'hex'
  priv = Buffer.from priv, 'hex'
  cb null, { pub, priv }

gen_fake_eddsa_pub = (cb) ->
  cb null, prng(32)

exports.test_public = (T,cb) ->
  esc = make_esc cb, "test1"
  for i in [0...1000]
    await test_public_1 T, esc defer()
  cb null

test_public_1 = (T,cb) ->
  esc = make_esc cb, "test_public"
  await gen_fake_eddsa_pub esc defer pub
  s1 = stellar.public_key.encode pub
  b2 = StrKey.decodeEd25519PublicKey(s1)
  T.assert bufeq_secure(b2, pub)
  T.assert StrKey.isValidEd25519PublicKey(s1), "valid key"
  s2 = StrKey.encodeEd25519PublicKey(pub)
  T.equal s1, s2, "same encoding from our library and theirs"
  b3 = stellar.public_key.decode s2
  T.assert bufeq_secure(b3, pub), "our decoder works too"
  T.assert stellar.public_key.is_valid(s2), "our is_valid works"
  cb null

assert_fail = (T, msg, fn) ->
  try
    fn()
    T.assert false, "failed to fail"
  catch e
    T.equal e.message, msg, "right message"
    T.waypoint e.toString()

exports.test_bad_public = (T,cb) ->
  esc = make_esc cb, "test_bad_public"
  await gen_fake_eddsa_pub esc defer pub
  assert_fail T, 'cannot encode null data', () -> stellar.public_key.encode null
  s1 = stellar.public_key.encode pub
  d1 = base32.decode s1
  assert_fail T, 'bad encoding', () -> stellar.public_key.decode "X" + s1
  assert_fail T, 'Unexpected version byte', () ->
    version = Buffer.from [3]
    data = d1[1...-2]
    checksum = stellar.checksum(version, data)
    stellar.public_key.decode base32.encode(Buffer.concat([ version, data, checksum ] ))
  assert_fail T, 'Bad checksum', () ->
    tmp = Buffer.concat [d1]
    tmp[tmp.length-1] ^= 0x1
    stellar.public_key.decode base32.encode(tmp)
  assert_fail T, 'need at least 5 bytes of data', () ->
    stellar.public_key.decode base32.encode(d1[0...4])
  assert_fail T, 'Bad value, expected a string', () ->
    stellar.public_key.decode 10

  cb null
