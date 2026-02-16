#!/bin/bash
# OAuth Helper - Setup Script
# Configures Telegram bot and OAuth providers

SKILL_DIR="$(dirname "$0")/.."
CONFIG_DIR="${HOME}/.config/oauth-helper"
CONFIG_FILE="$CONFIG_DIR/config.json"

echo "🔐 OAuth Helper Setup"
echo "===================="

# Create config directory
mkdir -p "$CONFIG_DIR"

# Check if config exists
if [ -f "$CONFIG_FILE" ]; then
    echo "⚠️  Configuration already exists at: $CONFIG_FILE"
    echo "Continue to update? (y/N)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "Setup cancelled."
        exit 0
    fi
fi

# Initialize config if it doesn't exist
if [ ! -f "$CONFIG_FILE" ]; then
    echo '{}' > "$CONFIG_FILE"
fi

echo ""
echo "📱 Telegram Configuration"
echo "========================"
echo ""
echo "To receive OAuth confirmations, you need a Telegram bot."
echo "1. Message @BotFather on Telegram"
echo "2. Send /newbot and follow instructions"
echo "3. Copy the bot token (format: 123456789:ABC...)"
echo ""
echo -n "Enter your Telegram Bot Token: "
read -r BOT_TOKEN

if [ -z "$BOT_TOKEN" ]; then
    echo "❌ Bot token is required"
    exit 1
fi

echo ""
echo "4. Start a chat with your new bot"
echo "5. Send any message to your bot"
echo "6. Visit: https://api.telegram.org/bot$BOT_TOKEN/getUpdates"
echo "7. Find your chat ID in the response (usually a number)"
echo ""
echo -n "Enter your Telegram Chat ID: "
read -r CHAT_ID

if [ -z "$CHAT_ID" ]; then
    echo "❌ Chat ID is required"
    exit 1
fi

# Update config
jq --arg token "$BOT_TOKEN" --arg chat_id "$CHAT_ID" \
   '.telegram = {"bot_token": $token, "chat_id": $chat_id}' \
   "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"

echo ""
echo "✅ Telegram configured successfully!"

# Test Telegram connection
echo "📤 Sending test message..."
curl -s -X POST \
    "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
    -H "Content-Type: application/json" \
    -d "{\"chat_id\":\"$CHAT_ID\",\"text\":\"🔐 OAuth Helper configured successfully! Ready to automate OAuth logins.\"}" >/dev/null

echo "✅ Test message sent to Telegram!"

echo ""
echo "🌐 Browser Configuration"
echo "======================="
echo ""
echo "For OAuth automation to work, you should be logged into OAuth providers"
echo "in your default browser (Google, GitHub, Apple ID, etc.)"
echo ""
echo "Recommended: Log into these providers in your browser:"
echo "• Google (accounts.google.com)"
echo "• GitHub (github.com)"  
echo "• Apple ID (appleid.apple.com)"
echo "• Microsoft (login.live.com)"
echo "• Discord (discord.com)"
echo ""

# Add browser config
jq '.browser = {"providers_logged_in": [], "last_check": null}' \
   "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"

echo "✅ OAuth Helper setup complete!"
echo ""
echo "📋 Configuration saved to: $CONFIG_FILE"
echo "🚀 Ready to use: ./oauth-login.sh <website_url>"
echo ""
echo "💡 Example usage:"
echo "   ./oauth-login.sh https://example.com/login"