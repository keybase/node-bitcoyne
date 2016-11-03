
{address} = require '../../lib/main'


exports.check_good = (T, cb) ->
  a = "1PUr4cy6J7hi6GxQa2hX2iuXJkvZvCrKmW"
  [err,ret] = address.check a
  T.no_error err
  T.equal ret.version, 0
  cb()

exports.check_bad_address_1 = (T,cb) ->
  b = "1PUr4cy6J7hi6GxQa2hX2iuXJkvZvCrKmi"
  [err,ret] = address.check b
  T.assert err?, "an error"
  T.equal err.message, "Checksum mismatch"
  cb()

exports.check_bad_address_2 = (T,cb) ->
  b = "1PUr4cy6J7hi6GxQa2hX2iuXJkvZvCrKm$$$"
  [err,ret] = address.check b
  T.assert err?, "an error"
  T.equal err.message, "Value passed is not a valid BaseX string."
  cb()

exports.check_bad_coin_1 = (T,cb) ->
  # This is a litecoin address
  c = "LdoZadzUUFoazyDLEm3G73b9XKAd8hu8oc"
  [err,ret] = address.check c
  T.assert err?, "an error"
  T.equal err.message, "Bad version found: 48"
  cb()

exports.good_alt_coin_1 = (T,cb) ->
  # This is a litecoin address
  c = "LdoZadzUUFoazyDLEm3G73b9XKAd8hu8oc"
  [err,ret] = address.check c, { versions : [48] }
  T.no_error err
  T.equal ret.version, 48, "version was right"
  cb()

exports.check_btc_or_zcash = (T,cb) ->
  tests = [
    [ "zcCk6rKzynC4tT1Rmg325A5Xw81Ck3S6nD6mtPWCXaMtyFczkyU4kYjEhrcz2QKfF5T2siWGyJNxWo43XWT3qk5YpPhFGj2", true , "zcash.z" ]
    [ "zcCk6rKzynC4tT1Rmg325A5Xw81Ck3S6nD6mtPWCXaMtyFczkyU4kYjEhrcz2QKfF5T2siWGyJNxWo43XWT3qk5YpPhFGj2x", false ]
    [ "zcCk6rKzynC4tT1Rmg325A5Xw81Ck3S6nD6mtPWCXaMtyFczkyU4kYjEhrcz2QKfF5T2siWGyJNxWo43XWT3qk5YpPhFGj3", false ]
    [ "t1c3Ebc6FBbWuirNrjJ6HbS4KHLb6Dbh5xL", true, "zcash.t" ]
    [ "t1c3Ebc6FBbWuirNrjJ6HbS4KHLb6Dbh5xLx", false ]
    [ "t1c3Ebc6FBbWuirNrjJ6HbS4KHLb6Dbh5xx", false ]
    [ "3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy", true, "bitcoin" ]
    [ "3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLyx", false ]
    [ "3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLx",  false ]
  ]
  for [a, ok, which], i in tests
    [err, ret] = address.check_btc_or_zcash a
    T.equal ok, (not err?), "got right success/failure"
    unless err?
      T.equal which, ret.type, "right type"
      console.log ret
  cb()
