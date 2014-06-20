
bcdstream = require './bcdstream'
{opcodes} = require './opcodes'
{Rational} = require './rational'
{constants} = require './constants'
{match_script} = require './oputil'
{hash160_to_bc_address,pubkey_to_bc_address} = require './pubkey'

##============================================
#
# A note on bitcoin 'version' prefix bytes:
#
#   For base58-encoding pubkey addresses, the main bitcoin
#   pool as a '\x00' byte, and the test pool as a '\x6f' byte.
#   
#   These constants are encoded in constants.iced in the 
#   bitcoin.version_byte lookup.
#
# More: https://en.bitcoin.it/wiki/Base58Check_encoding
#
##============================================

exports.Transaction = class Transaction
  constructor : ({@id, @version, @tx_in, @tx_out, @lock_time, @block_id}) ->

  toString : () ->
    d = {}
    for k in [ "id", "version", "lock_time", "block_id" ]
      d[k] = @[k]
    d.tx_in = ( t.to_obj() for t in @tx_in )
    d.tx_out = ( t.to_obj() for t in @tx_out )
    JSON.stringify d

  merge : (smalltx) ->
    @time = smalltx.time
    @timereceived = smalltx.timereceived
    @block_id = smalltx.blockhash
    @confirmations = smalltx.confirmations

##============================================

exports.TransactionIn = class TransactionIn

  constructor : ({@prevout_hash, @prevout_index, @script_sig_raw, @sequence, 
        @from_address, @script_sig, @version}) ->

  #----------------------

  to_obj: () -> {
    @prevout_index, @sequence, @from_address, 
    script_sig : @script_sig.to_obj()
    prevout_hash : @prevout_hash.inspect()
    script_sig_raw : @script_sig_raw.inspect()
  }

  #----------------------

  prevout_hash_hex : () -> (new Buffer @prevout_hash, 'binary').toString 'hex'

  #----------------------

  extract_from_address : () ->
    s = @script_sig
    desired = [
      opcodes.OP_PUSHDATA1
      opcodes.OP_PUSHDATA1
    ]
    ok = false
    if s.match desired
      @from_address = pubkey_to_bc_address s.command(1).data, @version
      ok = true
    return ok

##============================================

exports.TransactionOut = class TransactionOut

  constructor : ({@value, @script_pubkey_raw, @script_pubkey, @to_address, @version}) ->

  #----------------------

  to_obj: () -> {
    script_pubkey : @script_pubkey.to_obj()
    @to_address
    value : @value.inspect()
    script_pubkey_raw : @script_pubkey_raw.inspect()
  }

  #----------------------

  extract_to_address : () ->
    s = @script_pubkey
    desired = [ 
      opcodes.OP_DUP
      opcodes.OP_HASH160
      opcodes.OP_PUSHDATA1
      opcodes.OP_EQUALVERIFY
      opcodes.OP_CHECKSIG
    ]

    ok = false
    if s.match desired
      @to_address = hash160_to_bc_address s.command(2).data, @version
      ok = true
    return ok

  #----------------------


##============================================

exports.Script = class Script

  constructor : (@script) ->
  match : (ops) -> match_script @script, ops
  to_obj : () -> ( [p[0], p[1]?.inspect()] for p in @script)
  command : (n) ->
    if (c = @script[n])? then { op : c[0], data : c[1] }
    else {}

##============================================

exports.Parser = class Parser

  #-----------------------------

  constructor : (@_buffer, @version) -> 
    @_s = new bcdstream.Stream @_buffer

  #-----------------------------

  parse : () ->
    version = @_s.read_int32()
    n_tx_in = @_s.read_compact_size()
    tx_in = (@parse_tx_in() for i in [0...n_tx_in])
    n_tx_out = @_s.read_compact_size()
    tx_out = (@parse_tx_out() for i in [0...n_tx_out])
    lock_time = @_s.read_uint32()
    new Transaction { version, tx_in, tx_out, lock_time }

  #-----------------------------

  parse_tx_in : () ->
    t = new TransactionIn 
      prevout_hash : @_s.read_bytes 32
      prevout_index : @_s.read_uint32()
      script_sig_raw : @_s.read_string()
      sequence : @_s.read_uint32()
      version : @version
    sp = new ScriptParser(new Buffer(t.script_sig_raw, 'binary'))
    t.extract_from_address() if (t.script_sig = sp.parse())?
    t

  #-----------------------------

  parse_tx_out : () ->
    t = new TransactionOut
      value : new Rational(@_s.read_int64()).idiv(constants.scale)
      script_pubkey_raw : @_s.read_string()
      version : @version
    sp = new ScriptParser(new Buffer(t.script_pubkey_raw, 'binary'))
    t.extract_to_address() if (t.script_pubkey = sp.parse())?
    t

##============================================

exports.ScriptParser = class ScriptParser

  constructor : (@_buffer) ->
    @_i = 0
    @_ops = []

  parse : () ->
    commands = (@parse_op() while @_i < @_buffer.length)
    new Script commands

  parse_op : () ->
    opcode = @_buffer[@_i]
    @_i++
    n_bytes = null
    script = null
    if opcode is opcodes.OP_PUSHDATA4
      n_bytes = @_buffer.readUInt32LE @_i
      @_i += 4
    else if opcode is opcodes.OP_PUSHDATA2
      n_bytes = @_buffer.readUInt16LE @_i
      @_i += 2
    else if opcode is opcodes.OP_PUSHDATA1
      n_bytes = @_buffer[@_i]
      @_i++
    else if opcode < opcodes.OP_PUSHDATA1
      n_bytes = opcode

    if n_bytes?
      end = @_i + n_bytes
      end = @_buffer.length if end > @_buffer.length
      script = @_buffer[@_i...end]
      @_i = end

    [opcode, script]

##============================================

exports.parse_raw_transaction = parse_raw_transaction = (txid, obj, version) ->
  b = new Buffer obj.hex, 'hex'
  p = new Parser b, version
  tx = p.parse()
  tx.blockid = obj.blockhash
  tx.confirmations = obj.confirmations
  tx.id = txid
  return tx

##============================================

if true
  txid = 'd49a2ed7b03a441e2a91070111457a91717034827fca5d020700e3ef9cd88df8'
  hex = '0100000001695be69fefcb43ddbed7be404c9865533c344126140042d05cea013727277ad2000000006b483045022100e9471068a564ac23a625a98765ae3f09b9cc20b2f7b19af751f9a93368e6565a02202063edaa0d894be4b3ebd7ac8c0853a416383df9dc2b0c5df6a19e91065db5050121038972c357ee6c7f5db6136b608f24c7a6ffa2f34db396badd12e98027c542f0f7ffffffff02c0c62d00000000001976a914688d5a5f664da2142553afaf9b4d5cbb200ef53f88ac40aefd7c000000001976a914180c7b82410db0f1471583433f7b3b3c65b7eb2988ac00000000'
  hex = '010000000196a5f90ff8ca5a91a11310ad0d8ae3ccdcdb98a9c903d099aff4391b132a9195080000006b483045022100f87592fc7b204675768a0e0480cb77cbe4426391cfdb7700ce6f6a801c3460860220268d5491e240a93e63c58bbde9f3a287e2ea203f1f0d4c8aa290d3ef7c46d9d30121033a2e08b2293d44d1f14abd91ab59320ef661f6bd30a82df531d3acb7c090ff2bffffffff0100000000000000001976a91452960e1b213813097f3ae22632e31de195bee86e88ac00000000'
  obj = { hex }
  console.log "ZDZZ"
  tx = parse_raw_transaction txid, obj
  console.log tx
  for i in tx.tx_in
    console.log i.script_sig
  for i in tx.tx_out
    console.log i.script_pubkey


