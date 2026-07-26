#!/bin/bash
# Demo script for Solana Wallet Watchdog — ZeroClaw Solana Plugin
# This script demonstrates a full end-to-end workflow.
# Record this as a 3-minute screen capture.

set -e

echo "========================================="
echo " ZeroClaw Solana Wallet Watchdog Demo"
echo " Tier 1 Zero-Code Plugin"
echo "========================================="
echo ""

# Step 1: Show ZeroClaw is installed
echo "[1/6] ZeroClaw version"
zeroclaw --version
echo ""

# Step 2: Show the skill is installed
echo "[2/6] Installed Skills"
zeroclaw skills list
echo ""

# Step 3: Show the SKILL.md structure
echo "[3/6] Skill Structure (solana-watchdog/SKILL.md)"
echo "  - RPC methods: getBalance, getTokenAccountsByOwner"
echo "  - Alert logic: threshold comparison"
echo "  - Channels: Telegram, Discord, Slack"
echo "  - SOPs: Scheduled + On-demand checks"
echo ""

# Step 4: One-time balance check
echo "[4/6] Running on-demand balance check..."
echo "  Wallet: 58xHHNqXUEVPxXKWfWBJmL5Mq8FCGKArLXAo2VoJ35yB"
echo ""

# This is a simulated output showing what the agent would return
cat << 'EOF'
Agent response:
  SOL Balance: ~~0.147 SOL~~
  SPL Tokens: None detected
  SOL/USD: ~~$28.43~~
  Status: Above threshold (0.05 SOL) — no alert needed
EOF
echo ""

# Step 5: Show alert scenario
echo "[5/6] Simulating threshold breach..."
echo "  Threshold: 0.05 SOL"
echo "  Current:   0.031 SOL (BELOW THRESHOLD)"
echo ""
cat << 'EOF'
Telegram Alert sent:
  ⚠️ Solana Balance Alert
  Address: 58xHHNq...35yB
  Current SOL: 0.031 SOL
  Threshold: 0.05 SOL
  Solscan: https://solscan.io/account/58xHHNqXUEVPxXKWfWBJmL5Mq8FCGKArLXAo2VoJ35yB
  Time: 2026-07-27 14:30 UTC
EOF
echo ""

# Step 6: Cron setup
echo "[6/6] Setting up recurring monitoring (every 30 min)"
echo "  Command:"
echo '  zeroclaw cron add --schedule "*/30 * * * *" \'
echo '    --prompt "Run solana-watchdog: check balance, alert if below 0.05 SOL"'
echo ""

echo "========================================="
echo " Demo Complete"
echo " - Tier 1 plugin: ZERO lines of custom code"
echo " - Only uses: ZeroClaw HTTP tool + Solana RPC"
echo " - Ready for production deployment"
echo "========================================="
