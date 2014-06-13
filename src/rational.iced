
{nbi,nbv,BigInteger} = require 'bn'
{constants} = require './constants'

##=====================================================

nbs = (s) -> nbi().fromString(s,10)

##=====================================================

js_lim = nbv(1).shiftLeft(constants.log_2_js_float64_ilim)

##=====================================================

exports.gcd = gcd = (a,b) ->
  until b.equals BigInteger.ZERO 
    t = b
    b = a.mod t
    a = t
  return a

#----------------

is_int = (s) -> !! s.match /^-?\d+$/

#----------------

exports.lcm = lcm = (a,b) -> a.mul(b).div(gcd(a,b))

#----------------

log_base_10 = (imul) ->
  ret = 0
  while imul > 1
    imul = imul / 10
    ret++
  ret

##=====================================================

exports.Rational = class Rational

  constructor : (@n = nbv(0), @d = nbv(1), rdc = true) ->
    @reduce() if rdc

  #----------------

  toString : () -> "#{@n.toString()}/#{@d.toString()}"
  inspect : () -> "<Rational #{@n.toString()}/#{@d.toString()} ~#{@estimate()}>"
  abs : () -> new Rational(@n.abs(), @d.abs())

  #----------------

  estimate : () -> 
    bl = Math.max @n.bitLength(), @d.bitLength()
    [n,d] = if (shift = bl - constants.log_2_js_float64_ilim) > 0
      [@n.shiftRight(shift), @d.shiftRight(shift)]
    else [@n,@d]
    [n,d] = [n.toString(),d.toString()]
    if d is 0 then "\u221e"
    else n/d

  #----------------

  copy : () -> new Rational @n, @d, false

  #----------------

  reduce : () ->
    sig = 1
    if @n.compareTo(BigInteger.ZERO) < 0
      sig *= -1 
      @n = @n.abs()
    if @d.compareTo(BigInteger.ZERO) < 0
      sig *= -1
      @d = @d.abs()
    g = gcd @n, @d
    if g > BigInteger.ONE
      @n = @n.divide g
      @d = @d.divide g
    @n = @n.multiply nbv sig
    @

  #----------------

  cmp : (a) ->
    l = @n.mul(a.d)
    r = @d.mul(a.n)
    l.compareTo(r)

  #----------------

  add : (a) ->
    n = @d.multiply(a.n).add(@n.multiply(a.d))
    d = @d.multiply(a.d)
    new Rational(n,d)

  #----------------

  mul : (a) -> new Rational(@n.mul(a.n), @d.mul(a.d))
  div : (a) -> new Rational(@n.mul(a.d), @d.mul(a.n))
  imul : (a) -> new Rational(@n.mul(BigNum(a)), @d)
  idiv : (a) -> new Rational(@n, @d.multiply(nbv(a)))

  #----------------

  sub : (a) ->
    n = @n.mul(a.d).sub(@d.mul(a.n))
    d = @d.mul(a.d)
    new Rational(n,d)

  #----------------

  scale_to_int : (imul = constants.scale) ->
    @mul(new Rational(nbv(imul))).truncated_bignum().intVal()

  scale_to_string : (imul = constants.scale) ->
    @mul(new Rational(nbv(imul))).truncated_bignum().toString()

  #----------------

  to_string : (imul = constants.scale) ->
    s = @scale_to_string imul
    b = log_base_10 imul
    d = s.length - b
    ret = if d <= 0
      "0." + ("0" for i in [d...0]).join('') + s
    else
      s[0...d] + "." + s[d...(d+b)]

    # Just for a sanity check, we shouldn't be too far off of the real
    # value.  If we are, don't Fuck us!
    approx = @estimate()
    if Math.abs(parseFloat(ret) - approx) > .00001
      throw "Massive format_to_double failure in #{@.inspect()} != #{ret}"

    return ret

  #----------------

  is_zero : () -> @n.equals BigInteger.ZERO
  is_positive : () -> @gt new Rational()

  #----------------

  @from_int : (i) -> new Rational(nbv(i))
  @from_db : (i) -> new Rational(nbs(i), nbv(constants.scale))
  @from_bitcoin_tx : (i) -> new Rational(nbs(i), nbv(constants.scale))
  truncated_bignum : () -> @n.div @d

  #----------------

  @from_float : (n) ->
    d = 1
    lim = 8
    while (Math.floor(n) isnt n) and (lim > 0)
      n *= 10
      d *= 10
      lim--
    new Rational(nbv(n), nbv(d))

  #----------------

  @from_string : (s) ->
    return null unless s? and s.length

    idiv = 1
    if s[s.length-1] is "%"
      idiv = 100
      s = s[0...(s.length-1)]

    parts = s.split(".")

    ipart = if parts.length > 2 then null
    else if parts[0].length == 0 then new Rational()
    else if not is_int parts[0] then null
    else Rational.from_int parts[0]

    dpart = if not ipart? then null
    else if parts.length is 1 then new Rational()
    else if not is_int parts[1] then null
    else new Rational(nbs(parts[1]),nbv(10).pow(parts[1].length))

    if not dpart? or not ipart? then null
    else 
      ret = ipart.add dpart
      if idiv isnt 1 then ret.idiv idiv
      else ret

  #----------------

  lt : (a) -> @cmp(a) <  0
  le : (a) -> @cmp(a) <= 0
  eq : (a) -> @cmp(a) == 0
  ge : (a) -> @cmp(a) >= 0
  gt : (a) -> @cmp(a) >  0 
  
##=====================================================

