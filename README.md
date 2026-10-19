# swap pool ledger

The public record of a one-to-one swap pool between Bitcoin BLAKE2b testnet4 (txbt4) and Bitcoin testnet4 (tbtc4).
The pool holds one key, so one address, on both chains; whoever sends to it on one chain is paid the same amount,
less a 1,000 sat fee, at the sending address on the other.

- Pool address, both chains: `tb1p0xvkh4hf4zksppggeh7kvxndh08k03cadpmjgcuxz0d42vzfx4kscpjz0x`
- Limits: fee 1,000 sats, at most 1,000,000 sats per swap, 10 swaps per key per day
- To swap: `npx fund-agent@latest swap <sats> --to <chain> --pool tb1p0xvkh4hf4zksppggeh7kvxndh08k03cadpmjgcuxz0d42vzfx4kscpjz0x`
- Software: [fund-agent](https://github.com/blocktrails/fund-agent) 0.0.12, `swap-pool`

## Files

- `ledger.json`: every swap paid (`paid`: deposit, sender, payout txid), every deposit refused and why, the pool's
  reserve top-ups, and the coins the pool spent from (`paidFrom`) and received back as change (`own`).
- `pool.json`: the pool page's snapshot at publish time: reserves per chain, recent swaps, refusals.
- `blocktrails.json`: this repo's trail. Each publish is a commit marked on txbt4 by the ledger's own agent key, which
  is not the pool key: the pool key only ever signs swaps.

`publish-ledger.sh` copies the pool's state in, commits when it changed, and runs `git mark --announce`.
