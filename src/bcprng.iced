
crypto = require 'crypto'

##==============================================================================

zbuf = (n) ->
  b = new Buffer n
  b.fill 0, 0, n
  b

log_base_2_mask = (n) ->
  m = 1
  while m < n
    m = (m << 1)
  (m-1)

log_base_256 = (n) ->
  r = 0
  while n > 1
    n = (n >> 8)
    r++
  return r

##==============================================================================

exports.PRNG = class PRNG

  @AES_KEY_LEN : 32
  @AES_INPUT_LEN : 16

  constructor : () ->
    @_seed = zbuf PRNG.AES_KEY_LEN
    @_i = 1
    @_pool = new Buffer 0
    @_lim_refresh = Math.pow(2,32) - 1

  # Add a seed in hex-encoded form (like Bitcoin BlockIDs)
  seed : (s) ->
    b = new Buffer s, 'hex'
    @_seed[i] ^= c for c,i in b
    true

  get_bytes : (n) ->
    throw "Can only get #{PRNG.AES_INPUT_LEN} bytes" if n > PRNG.AES_INPUT_LEN
    @refresh_pool() if n > @_pool.length
    b = @_pool[0...n]
    @_pool = @_pool[n...n.length]
    b

  refresh_pool : () ->
    throw "Wrapped around" if @_i >= @_lim_refresh
    zb = zbuf PRNG.AES_INPUT_LEN
    zb.writeUInt32BE @_i++, 0
    aes = crypto.createCipher 'aes256', @_seed
    @_pool = new Buffer (aes.update zb), 'binary'

  get_mod_n : (n) ->
    loop
      r = @attempt_mod_n n
      return r if r < n

  attempt_mod_n : (n) ->
    nbytes = log_base_256 n
    b = @get_bytes nbytes
    tmp = 0
    shift = 0
    for i in [(nbytes-1)..0]
      tmp += (b[i] << shift)
      shift += 8
    mask = log_base_2_mask n
    (tmp & mask)

  shuffle : (v) ->
    n = v.length
    if n > 1
      for i in [(n-1)..1]
        j = @get_mod_n (i+1)
        tmp = v[j]
        v[j] = v[i]
        v[i] = tmp

##==============================================================================

