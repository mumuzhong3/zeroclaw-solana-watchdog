# ZeroClaw Solana Wallet Watchdog

Tier 1 Zero-Code Plugin for [ZeroClaw](https://github.com/nicepkg/zeroclaw) — A Solana on-chain monitoring agent that tracks wallet balances and sends alerts via Telegram/Discord/Slack.

Built for the [ZeroClaw Solana Plugin Bounty](https://earn.superteam.fun/) on Superteam Earn.

## Overview

Solana Wallet Watchdog is a **read-only monitoring agent** that:
- Checks SOL balance of any Solana address
- Tracks SPL token holdings
- Alerts when balance drops below a configurable threshold
- Supports Telegram, Discord, and Slack notifications
- Runs on ZeroClaw's built-in cron scheduler

**Zero lines of custom code.** The entire plugin uses ZeroClaw's native HTTP tool + Skill prompt architecture.

## Quick Start

### Prerequisites

```bash
# Install ZeroClaw
curl -fsSL https://sh.rustup.rs | sh
cargo install zeroclaw
```

### 1. Configure ZeroClaw

Edit `~/.zeroclaw/config.toml` and enable:

```toml
[http_request]
enabled = true
allowed_domains = ["api.mainnet-beta.solana.com", "solana-mainnet.core.chainstack.com", "api.helius.xyz", "api.coingecko.com"]
max_response_size = 1000000
timeout_secs = 30

[cron]
enabled = true
max_run_history = 50

[autonomy]
level = "supervised"
```

### 2. Install the Skill

```bash
zeroclaw skills install ./solana-watchdog
```

Or from GitHub:

```bash
zeroclaw skills install https://github.com/YOUR_USER/zeroclaw-solana-watchdog
```

### 3. Configure Your Provider

Set your OpenRouter API key (or any supported provider):

```bash
export OPENROUTER_API_KEY="sk-or-..."
```

### 4. Set Up a Channel (Telegram)

```bash
zeroclaw channel add telegram --token "YOUR_BOT_TOKEN"
```

### 5. Start Monitoring

Run a one-time check:

```bash
zeroclaw agent --prompt "Run solana-watchdog: check SOL balance of 58xHHNqXUEVPxXKWfWBJmL5Mq8FCGKArLXAo2VoJ35yB"
```

Or set up recurring monitoring via cron:

```bash
zeroclaw cron add --schedule "*/30 * * * *" \
  --prompt "Run solana-watchdog: check balance of 58xHHNqXUEVPxXKWfWBJmL5Mq8FCGKArLXAo2VoJ35yB, alert if below 0.05 SOL"
```

## Architecture

```
┌─────────────────────────────────────────────┐
│              ZeroClaw Runtime                 │
│                                               │
│  ┌──────────┐   ┌──────────┐   ┌──────────┐ │
│  │  Cron    │──▶│  Agent   │──▶│ Channel  │ │
│  │ Scheduler│   │  Loop    │   │ (TG/DC)  │ │
│  └──────────┘   └────┬─────┘   └──────────┘ │
│                      │                        │
│              ┌───────▼───────┐                │
│              │  HTTP Tool    │                │
│              └───────┬───────┘                │
└──────────────────────┼────────────────────────┘
                       │
              ┌────────▼────────┐
              │  Solana RPC     │
              │  (Mainnet-Beta) │
              └─────────────────┘
```

## Skill Structure

```
solana-watchdog/
└── SKILL.md          # Complete agent prompt with RPC methods, alert logic, SOPs
```

## Use Cases

| Use Case | Description |
|----------|-------------|
| **DeFi Position Monitor** | Alert when collateral ratio is at risk |
| **Treasury Watchdog** | DAO treasury balance monitoring |
| **Airdrop Eligibility** | Check if wallet meets minimum balance |
| **Payment Received Alert** | Notify when USDC/SOL deposit arrives |
| **Node Operator Health** | Monitor validator vote account balance |

## Tier 1 Compliance

This plugin strictly follows Tier 1 (Zero-Code) guidelines:
- No custom code, npm packages, or external dependencies
- Uses only ZeroClaw built-in `http_request` tool
- Read-only: no transaction signing or key access
- All logic defined declaratively in SKILL.md prompt

## Submission

- **Task**: Build Solana-native plugins for ZeroClaw
- **Platform**: Superteam Earn
- **Bounty**: 5,000 USDG
- **Tier**: 1 (Zero-Code)
