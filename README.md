# swap pool ledger

The public record of a one-to-one swap pool between Bitcoin BLAKE2b testnet4 (txbt4) and Bitcoin testnet4 (tbtc4).
The pool holds one key, so one address, on both chains; whoever sends to it on one chain is paid the same amount,
less a 1,000 sat fee, at the sending address on the other.

- Pool address, both chains: `tb1p0xvkh4hf4zksppggeh7kvxndh08k03cadpmjgcuxz0d42vzfx4kscpjz0x`
- Limits: fee 1,000 sats, at most 1,000,000 sats per swap, 10 swaps per key per day
- To swap: `npx fund-agent@latest swap <sats> --to <chain> --pool tb1p0xvkh4hf4zksppggeh7kvxndh08k03cadpmjgcuxz0d42vzfx4kscpjz0x`
- Software: [fund-agent](https://github.com/blocktrails/fund-agent) 0.0.12, `swap-pool`

## Page

`index.html` is the pool's page. Log in at the bottom right with a key you hold (paste a 64-character key, or take a
guest key the page makes); it spells one address on both chains. The page shows your coins on each chain, and Swap signs
the deposit in the browser (`lib/bitcoin.js` and `lib/unified.js`, from blaketest), broadcasts it, announces it to the
pool on Nostr, and shows the pool's answer with the payout. The Pool tab reads `pool.json` from this repo, so it shows
the pool as of the last publish, each one marked on txbt4. No server behind it.

One limit: the public txbt4 explorer answers browsers with a header they refuse, so the page cannot read or send on
txbt4 until `?api=<esplora base>` points it at one that can. Swaps from tbtc4 work as is.

## Files

- `ledger.json`: every swap paid (`paid`: deposit, sender, payout txid), every deposit refused and why, the pool's
  reserve top-ups, and the coins the pool spent from (`paidFrom`) and received back as change (`own`).
- `pool.json`: the pool page's snapshot at publish time: reserves per chain, recent swaps, refusals.
- `blocktrails.json`: this repo's trail. Each publish is a commit marked on txbt4 by the ledger's own agent key, which
  is not the pool key: the pool key only ever signs swaps.

`publish-ledger.sh` copies the pool's state in, commits when it changed, and runs `git mark --announce`.
