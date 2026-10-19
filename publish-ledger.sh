#!/bin/bash
# Publish the swap pool's ledger: copy the pool's state and snapshot into this
# repo, commit when something changed, and mark + announce the commit.
# The ledger agent's key is this repo's own (git config nostr.privkey); the
# pool key never touches this repo.
set -e
cd "$(dirname "$0")"
STATE=${POOL_STATE:-$HOME/.gitmark/swap-pool.state.json}
UI=${POOL_UI:-http://127.0.0.1:3480}
python3 - "$STATE" <<'PY'
import json, sys
d = json.load(open(sys.argv[1]))
# the ledger: every swap paid, every deposit refused, and the pool's own change
# coins; the per-key daily counters are operational and stay out
json.dump({k: d.get(k, {}) for k in ('paid', 'refused', 'reserve', 'paidFrom', 'own')}, open('ledger.json', 'w'), indent=1, sort_keys=True)
PY
curl -sf "$UI/pool.json" > pool.json || echo '{}' > pool.json
git add ledger.json pool.json README.md publish-ledger.sh
if git diff --cached --quiet; then echo "ledger unchanged; nothing to mark"; exit 0; fi
n=$(python3 -c "import json;print(len(json.load(open('ledger.json'))['paid']))")
git commit -q -m "ledger: $n swaps paid"
# mark the ledger commit, commit the trail file that records it, then announce:
# the state event then names a commit whose trail file lists the mark
git mark
git add blocktrails.json && git commit -q -m "trail: mark $(python3 -c "import json;print(len(json.load(open('blocktrails.json'))['states']))")"
git mark announce
