# Discord Submission Template
# Post in: ZeroClaw Discord → #solana-bounty

---

**Submission: Solana Wallet Watchdog — Tier 1 Zero-Code Plugin**

**GitHub:** https://github.com/mumuzhong3/zeroclaw-solana-watchdog

**Demo Video:** [attach or link]

---

**What it does:**
A read-only Solana monitoring agent that tracks wallet SOL/SPL balances via ZeroClaw's built-in HTTP tool and sends Telegram/Discord alerts when balances drop below configurable thresholds.

**Tier:** 1 (Zero-Code)
- No custom code, no npm/pip dependencies
- Uses only ZeroClaw native `http_request` tool + Solana JSON-RPC
- All logic in a single `SKILL.md`
- Read-only: no transaction signing

**Use Cases:**
- DeFi vault collateral ratio alerts
- DAO treasury balance monitoring
- Airdrop eligibility auto-check
- Payment/USDC deposit confirmation

**ZeroClaw Config:**
```toml
[http_request]
enabled = true
allowed_domains = ["api.mainnet-beta.solana.com", "api.coingecko.com"]

[cron]
enabled = true
```

**Install:**
```bash
zeroclaw skills install https://github.com/mumuzhong3/zeroclaw-solana-watchdog
```

**Cron Alert Setup:**
```bash
zeroclaw cron add --schedule "*/30 * * * *" \
  --prompt "Run solana-watchdog: check balance, alert if below 0.05 SOL"
```
