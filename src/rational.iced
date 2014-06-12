
BigNum = require 'bignum'
{constants} = require '../constants'

##=====================================================

exports.gcd = gcd = (a,b) ->
  until b.eq 0
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

  constructor : (@n = BigNum(0), @d = BigNum(1), rdc = true) ->
    @reduce() if rdc

  #----------------

  toString : () -> "#{@n.toString()}/#{@d.toString()}"
  inspect : () -> "<Rational #{@n.toString()}/#{@d.toString()} ~#{@estimate()}>"
  estimate : () -> (@n.toNumber()/@d.toNumber())
  abs : () -> new Rational(@n.abs(), @d.abs())

  #----------------

  copy : () -> new Rational @n, @d, false

  #----------------

  reduce : () ->
    sig = 1
    if @n.lt 0
      sig *= -1 
      @n = @n.abs()
    if @d.lt 0
      @sig *= -1
      @d = @d.abs()
    g = gcd @n, @d
    if g > 1
      @n = @n.div g
      @d = @d.div g
    @n = @n.mul sig
    @

  #----------------

  cmp : (a) ->
    l = @n.mul(a.d)
    r = @d.mul(a.n)
    if      l.eq r then 0
    else if l.lt r then -1
    else                1

  #----------------

  add : (a) ->
    n = @d.mul(a.n).add(@n.mul(a.d))
    d = @d.mul(a.d)
    new Rational(n,d)

  #----------------

  mul : (a) -> new Rational(@n.mul(a.n), @d.mul(a.d))
  div : (a) -> new Rational(@n.mul(a.d), @d.mul(a.n))
  imul : (a) -> new Rational(@n.mul(BigNum(a)), @d)
  idiv : (a) -> new Rational(@n, @d.mul(BigNum(a)))

  #----------------

  sub : (a) ->
    n = @n.mul(a.d).sub(@d.mul(a.n))
    d = @d.mul(a.d)
    new Rational(n,d)

  #----------------

  scale_to_int : (imul = constants.scale) ->
    @mul(new Rational(BigNum(imul))).truncated_bignum().toNumber()

  scale_to_string : (imul = constants.scale) ->
    @mul(new Rational(BigNum(imul))).truncated_bignum().tostring()

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

  is_zero : () -> @n.eq BigNum(0)
  is_positive : () -> @gt new Rational()

  #----------------

  @from_int : (i) -> new Rational(BigNum(i))
  @from_db : (i) -> new Rational(BigNum(i), BigNum(constants.scale))
  @from_bitcoin_tx : (i) -> new Rational(BigNum(i), BigNum(constants.scale))
  truncated_bignum : () -> @n.div @d

  #----------------

  @from_float : (n) ->
    d = 1
    lim = 8
    while (Math.floor(n) isnt n) and (lim > 0)
      n *= 10
      d *= 10
      lim--
    new Rational(BigNum(n), BigNum(d))

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
    else new Rational(BigNum(parts[1]),BigNum(10).pow(parts[1].length))

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

