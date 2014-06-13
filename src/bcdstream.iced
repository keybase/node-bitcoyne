
{nbv} = require 'bn'


##====================================================================
#
# BCDataStream --- a clone of CDataStream in the bitcoind implementation.
#
##====================================================================

exports.Stream = class Stream

  # Give me a nodeJs Buffer! 
  constructor : (b) ->
    @_b = b
    @_c = 0
    @_int64_lim = nbv(2).pow(nbv(61))
    @_uint64_lim = @_int64_lim.mul(nbv(2))
    @_js_float_max = @nbv(1).shiftLeft(54)

  read_byte : ->
    b = @_b[@_c]
    @_c++
    return b

  read_boolean : ->
    return @read_bytes() isnt 0
  read_int16 : -> 
    ret = @_b.readInt16LE @_c
    @_c += 2
    return ret
  read_uint16 : -> 
    ret = @_b.readUInt16LE @_c
    @_c += 2
    return ret
  read_int32 : -> 
    ret = @_b.readInt32LE @_c
    @_c += 4
    return ret
  read_uint32 : -> 
    ret = @_b.readUInt32LE @_c
    @_c += 4
    return ret
  read_int64: -> 
    b = @read_uint64()
    b = @_uint64_lim.sub(b) if b.ge(@_int64_lim)
    return b
  read_uint64 : -> 
    b0 = @read_uint32()
    b1 = @read_uint32()
    # Little-endian representation
    b = nbv(b0).add(nbv(b1).shiftLeft(32))
    @_c += 8
    return b

  read_uint64_number : () ->
    b = @read_uint64()
    if b.ge(@_js_float_max)
      throw new Error "#{b.toString()} > #{@_js_float_max.toString()} and can't be read as a native number"
    b.intValue()

  read_compact_size : ->
    switch (b = @read_byte())
      when 253 then @read_uint16()
      when 254 then @read_uint32()
      when 255 then @read_uint64_number()
      else b

  read_bytes : (n) ->
    ret = @_b.slice @_c, @_c + n
    @_c += n
    return ret

  read_string : -> @read_bytes @read_compact_size()
  
##====================================================================

