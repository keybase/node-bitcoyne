
{opcodes} = require './opcodes'
{hash160_to_bc_address} = require './pubkey'

##============================================

exports.match1 = match1 = (o1, o2) ->
  (o1 <= opcodes.OP_PUSHDATA4 and o2 <= opcodes.OP_PUSHDATA4) or (o1 == o2)

##============================================

exports.match_script = match_script = (script, ops) ->
  if script.length is ops.length
    ok = true
    for op,i in ops
      ok = false unless match1 script[i][0], op
  else ok = false
  ok

##============================================
