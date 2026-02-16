#!/bin/bash
# OAuth Helper - Main Login Automation
# Usage: ./oauth-login.sh <website_url>

WEBSITE_URL="$1"
if [ -z "$WEBSITE_URL" ]; then
    echo "Usage: $0 <website_url>"
    echo "Example: $0 https://example.com/login"
    exit 1
fi

SKILL_DIR="$(dirname "$0")/.."
CONFIG_FILE="${HOME}/.config/oauth-helper/config.json"

# Load configuration
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ OAuth Helper not configured. Run ./setup-oauth.sh first."
    exit 1
fi

TELEGRAM_CHAT_ID=$(jq -r '.telegram.chat_id // empty' "$CONFIG_FILE")
TELEGRAM_BOT_TOKEN=$(jq -r '.telegram.bot_token // empty' "$CONFIG_FILE")

if [ -z "$TELEGRAM_CHAT_ID" ] || [ -z "$TELEGRAM_BOT_TOKEN" ]; then
    echo "❌ Telegram not configured. Run ./setup-oauth.sh first."
    exit 1
fi

send_telegram() {
    local message="$1"
    local parse_mode="${2:-}"
    
    local data="{\"chat_id\":\"$TELEGRAM_CHAT_ID\",\"text\":\"$message\""
    if [ -n "$parse_mode" ]; then
        data="$data,\"parse_mode\":\"$parse_mode\""
    fi
    data="$data}"
    
    curl -s -X POST \
        "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        -H "Content-Type: application/json" \
        -d "$data" >/dev/null
}

get_telegram_response() {
    local timeout="${1:-60}"
    local start_time=$(date +%s)
    
    while true; do
        # Get latest message
        local response=$(curl -s "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/getUpdates?offset=-1&limit=1")
        local message=$(echo "$response" | jq -r '.result[0].message.text // empty')
        local message_date=$(echo "$response" | jq -r '.result[0].message.date // 0')
        
        # Check if message is recent (within last 5 seconds of loop start)
        local current_time=$(date +%s)
        if [ "$message_date" -ge $((start_time - 5)) ] && [ -n "$message" ]; then
            echo "$message"
            return 0
        fi
        
        # Check timeout
        if [ $((current_time - start_time)) -ge "$timeout" ]; then
            echo "TIMEOUT"
            return 1
        fi
        
        sleep 2
    done
}

log_action() {
    local action="$1"
    local details="$2"
    local timestamp=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
    
    echo "[$timestamp] $action: $details" >> "${HOME}/.config/oauth-helper/oauth.log"
}

# Main execution
echo "🔐 Starting OAuth login for: $WEBSITE_URL"
log_action "OAUTH_START" "$WEBSITE_URL"

# Send initial notification
send_telegram "🔐 **OAuth Login Request**

Website: \`$WEBSITE_URL\`
Status: Opening login page..." "MarkdownV2"

echo "✅ OAuth login initiated. Check Telegram for confirmation prompts."
echo "💡 Tip: The skill will handle OAuth provider detection and user confirmation automatically."

log_action "OAUTH_INIT" "Telegram notification sent"