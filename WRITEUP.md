# Solana Wallet Watchdog — ZeroClaw Plugin Write-Up

## Problem Statement

Solana users and DeFi operators need to monitor wallet balances continuously —
whether it's a personal wallet, a DAO treasury, or a trading bot vault. Existing
solutions require either:
- Manually checking block explorers
- Building custom scripts with web3 libraries
- Paying for third-party monitoring services

## Solution

**Solana Wallet Watchdog** is a Tier 1 zero-code plugin for ZeroClaw that turns
the AI agent runtime into a 24/7 on-chain monitoring sentinel. It uses
ZeroClaw's built-in HTTP tool to query the Solana JSON-RPC endpoint, compares
balances against user-defined thresholds, and sends alerts through Telegram,
Discord, or Slack when thresholds are breached.

## Why ZeroClaw?

ZeroClaw's architecture is uniquely suited for this use case:

1. **Built-in HTTP tool** — No need to install `@solana/web3.js` or any npm
   package. The agent can make raw JSON-RPC calls natively.
2. **Cron scheduler** — Polling at configurable intervals is a first-class
   feature, not an afterthought.
3. **Channel system** — Telegram/Discord/Slack integrations are built-in.
   Alerts go directly to users' preferred messaging platform.
4. **Skill system** — All logic lives in a single `SKILL.md` file. No code to
   compile, no dependencies to manage.

## Architecture

```
ZeroClaw Cron → Agent Loop → SKILL.md (solana-watchdog)
                                │
                    ┌───────────┼───────────┐
                    ▼           ▼           ▼
              HTTP Tool    Balance      Channel
              (RPC call)   Comparison   (Alert)
```

### Data Flow

1. Cron triggers the agent with a prompt: "Run solana-watchdog"
2. Agent reads `SKILL.md` instructions → calls Solana RPC `getBalance`
3. Agent parses lamports → converts to SOL
4. Agent compares against `SOL_ALERT_THRESHOLD`
5. If below threshold → sends message via configured channel
6. Results logged to ZeroClaw memory for audit trail

## Key Design Decisions

### Read-Only by Design

The plugin never signs transactions or accesses private keys. It only queries
public RPC endpoints with a public address. This is both a security best
practice and a Tier 1 requirement.

### Configuration via Prompt, Not Config Files

All parameters (wallet address, threshold, interval) are passed through the
ZeroClaw prompt or cron command. This keeps the skill fully self-contained —
no separate `.env` files, no config parsers.

### Multi-RPC Fallback

The skill includes a fallback RPC endpoint in case the primary one rate-limits.
This improves reliability without adding complexity.

### SPL Token Support

Beyond SOL balance, the skill can query `getTokenAccountsByOwner` to report
all SPL token holdings — critical for DeFi users who hold USDC, JitoSOL, etc.

## Real-World Use Cases

| Scenario | Setup | Alert Trigger |
|----------|-------|---------------|
| DeFi vault sentinel | Monitor vault address | SOL < gas reserve threshold |
| Airdrop eligibility check | Monitor new wallet | SOL > 0 to confirm funding |
| DAO treasury oversight | Monitor multisig | Any balance change |
| Payment confirmation | Monitor merchant wallet | USDC deposit detected |
| Node operator health | Monitor validator address | SOL < rent-exempt minimum |

## Tier 1 Compliance Checklist

- [x] No custom code (JavaScript, Python, Rust, etc.)
- [x] No external package managers (npm, pip, cargo beyond ZeroClaw itself)
- [x] Uses only ZeroClaw built-in `http_request` tool
- [x] Read-only: no transaction signing
- [x] All logic in `SKILL.md` (declarative prompt)
- [x] No private key or seed phrase exposure
- [x] Works with public Solana RPC endpoints

## Future Extensions (Tier 2/3)

While this submission is Tier 1, the architecture supports natural upgrades:
- **Tier 2**: Add a custom tool binary that batches RPC calls for efficiency
- **Tier 3**: Full TypeScript plugin with Helius webhook integration, SQLite
  state persistence, and multi-wallet dashboard

## Conclusion

Solana Wallet Watchdog demonstrates that ZeroClaw's zero-code plugin
architecture is production-capable for real blockchain use cases. By composing
built-in tools (HTTP + Cron + Channels) with a well-crafted prompt, we built a
functional Solana monitoring agent without writing a single line of code.
