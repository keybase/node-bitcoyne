
{address} = require '../../lib/main'


exports.check_good = (T, cb) ->
  a = "1PUr4cy6J7hi6GxQa2hX2iuXJkvZvCrKmW"
  [err,ret] = address.check a
  T.no_error err
  T.equal ret.version, 0
  T.equal ret.pkhash, Buffer.from([246,150,244,21,139,4,46,186,33,169,194,102,0,58,161,38,243,1,195,54], "hex")
  cb()

exports.check_good_segwit = (T, cb) ->
  a = "bc1qcerjvfmt8qr8xlp6pv4htjhwlj2wgdjnayc3cc"
  [err,ret] = address.check a
  T.no_error err
  T.equal ret.version, 0
  T.equal ret.pkhash, Buffer.from([198,71,38,39,107,56,6,115,124,58,11,43,117,202,238,252,148,228,54,83], "hex")
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
    [ "zs165czn4y5jfa552kux7yl3y5l8ge4cl6af45y9dh3yzfnkgd68vajyjdlkht54ve958qx693jjak", true, "zcash.s" ]
    [ "zs1x2q4pej08shm9pd5fx8jvl97f8f7t8sej8lsgp08jsczxsucr5gkff0yasc0gc43dtv3wczerv5", true, "zcash.s" ]
    [ "zs1fw4tgx9gccv2f8af6ugu727slx7pq0nc46yflcuqyluruxtcmg20hxh3r4d9ec9yejj6gfrf2hc", true, "zcash.s" ]
    [ "zs1fw4tgx9gccv2f8af6ugu727slx7pq0nc46yflcuqyluruxtcmg20hxh3r4d9ec9yejj6gfrf2hd", false ]
    [ "bc1qcerjvfmt8qr8xlp6pv4htjhwlj2wgdjnayc3cc", true, "bitcoin" ]
    [ "bc1qc7slrfxkknqcq2jevvvkdgvrt8080852dfjewde450xdlk4ugp7szw5tk9", true, "bitcoin" ]
    [ "bc11cerjvfmt8qr8xlp6pv4htjhwlj2wgdjnayc3cc", false ]
    [ "bc20cerjvfmt8qr8xlp6pv4htjhwlj2wgdjnayc3cc", false ]
  ]
  for [a, ok, which], i in tests
    [err, ret] = address.check_btc_or_zcash a
    T.equal ok, (not err?), "got right success/failure"
    unless err?
      T.equal which, ret.type, "right type"
      console.log ret
  cb()
