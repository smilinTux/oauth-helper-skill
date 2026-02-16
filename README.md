# 🔐 OAuth Helper Skill

[![OpenClaw Skill](https://img.shields.io/badge/OpenClaw-Skill-blue)](https://openclaw.ai)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.0.0-green)](https://github.com/smilinTux/oauth-helper-skill/releases)

**Automate OAuth login flows with user confirmation via Telegram. Supports 7 major providers with intelligent detection and confirmation.**

## 🚀 Features

- **7 OAuth Providers:** Google, Apple, Microsoft, GitHub, Discord, WeChat, QQ
- **Auto-Detection:** Scans login pages for available OAuth options
- **Telegram Confirmation:** User approves each login via Telegram bot
- **Safe & Secure:** Always asks permission before authorizing
- **Smart Handling:** Manages account selection and consent pages automatically
- **Professional Logging:** Complete audit trail of OAuth activities

## 🎯 Problem Solved

Manual OAuth flows are tedious and error-prone:
- ❌ Constant context switching between browser and messaging
- ❌ Forgetting which OAuth provider to use on each site  
- ❌ Manual clicking through OAuth consent flows
- ❌ No audit trail of OAuth authorizations

## ✅ Solution

**Intelligent OAuth automation with human oversight:**

```bash
# Start OAuth login for any website
./scripts/oauth-login.sh https://example.com/login

# System detects available providers and asks via Telegram:
# "🔐 Site supports: 1️⃣ Google 2️⃣ GitHub 3️⃣ Apple - Reply with number"

# After selection, confirms authorization:
# "🔐 Authorize Example.com to access your Google account? Reply 'yes'"

# Completes OAuth flow automatically
# "✅ Login successful! You're now signed in to Example.com"
```

## 📦 Quick Install

```bash
# Clone to your OpenClaw skills directory
cd ~/clawd/skills/
git clone https://github.com/smilinTux/oauth-helper-skill.git oauth-helper
cd oauth-helper

# Run setup (configures Telegram bot)
./scripts/setup-oauth.sh

# Test with a website
./scripts/oauth-login.sh https://example.com/login
```

## 🔧 Setup Requirements

### 1. Telegram Bot Setup
1. Message [@BotFather](https://t.me/botfather) on Telegram
2. Send `/newbot` and follow instructions  
3. Copy the bot token
4. Start a chat with your new bot and send any message
5. Get your chat ID from: `https://api.telegram.org/bot<TOKEN>/getUpdates`

### 2. Browser Preparation
**Recommended:** Be logged into OAuth providers in your default browser:
- [Google](https://accounts.google.com)
- [GitHub](https://github.com) 
- [Apple ID](https://appleid.apple.com)
- [Microsoft](https://login.live.com)
- [Discord](https://discord.com)

## 🌐 Supported Providers

| Provider | Domains | Auto-Detection |
|----------|---------|----------------|
| **Google** | accounts.google.com | ✅ Advanced |
| **Apple** | appleid.apple.com | ✅ Advanced |
| **Microsoft** | login.microsoftonline.com, login.live.com | ✅ Advanced |
| **GitHub** | github.com/login/oauth | ✅ Advanced |
| **Discord** | discord.com/oauth2 | ✅ Advanced |
| **WeChat** | open.weixin.qq.com | ✅ Basic |
| **QQ** | graph.qq.com | ✅ Basic |

## 📋 Usage Examples

### Basic OAuth Login
```bash
# Any website with OAuth options
./scripts/oauth-login.sh https://notion.so/login
./scripts/oauth-login.sh https://vercel.com/login  
./scripts/oauth-login.sh https://discord.com/login
```

### Check Provider Detection
```bash
# See what providers are detected on a page
node ./scripts/detect-providers.js --providers

# Output detection script for browser console
node ./scripts/detect-providers.js --script
```

### Review OAuth Activity
```bash
# Check OAuth log
tail -f ~/.config/oauth-helper/oauth.log

# Example log entries:
# [2026-02-16T05:15:30Z] OAUTH_START: https://notion.so/login
# [2026-02-16T05:15:45Z] PROVIDER_DETECTED: google,github,apple
# [2026-02-16T05:16:00Z] USER_SELECTED: google
# [2026-02-16T05:16:15Z] OAUTH_SUCCESS: notion.so
```

## 🔒 Security Features

- **User Confirmation Required:** Every OAuth authorization requires explicit approval
- **Provider Verification:** Validates OAuth provider domains before proceeding
- **Complete Audit Trail:** All OAuth activities logged with timestamps
- **Timeout Protection:** Requests timeout after 60 seconds if no response
- **Safe Defaults:** Never authorizes without explicit user permission

## 🎯 Perfect For

- **Business Agents:** Automating SaaS tool access across multiple platforms
- **Development Workflows:** Quick access to GitHub, Vercel, Netlify, etc.
- **Content Creation:** Streamlined access to Notion, Figma, Canva, etc.
- **Productivity:** Reducing OAuth friction in daily workflows
- **Enterprise:** Secure, auditable OAuth automation

## 🛠️ Advanced Configuration

### Custom Provider Detection
Add detection rules in `scripts/detect-providers.js`:

```javascript
custom_provider: {
    domains: ['auth.example.com'],
    selectors: ['button[data-provider="custom"]'],
    text_patterns: ['sign.*custom', 'login.*custom']
}
```

### Telegram Message Customization
Edit message templates in `scripts/oauth-login.sh`:

```bash
# Custom confirmation message
send_telegram "🔐 **Custom OAuth Request**
Site: $WEBSITE_URL
Provider: $PROVIDER
Authorize? Reply 'yes'"
```

## 📚 Documentation

- [`SKILL.md`](SKILL.md) - Complete OpenClaw skill documentation
- [`scripts/setup-oauth.sh`](scripts/setup-oauth.sh) - Setup and configuration
- [`scripts/oauth-login.sh`](scripts/oauth-login.sh) - Main OAuth automation
- [`scripts/detect-providers.js`](scripts/detect-providers.js) - Provider detection logic

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/new-provider`)
3. Commit your changes (`git commit -m 'Add new OAuth provider'`)
4. Push to the branch (`git push origin feature/new-provider`)
5. Open a Pull Request

**Ideas for contributions:**
- New OAuth provider support
- Better provider detection rules
- Enhanced security features
- Mobile OAuth handling
- Multi-language support

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🌟 Support

- ⭐ **Star this repo** if it saves you OAuth clicking time!
- 🐛 **Report issues** on GitHub Issues
- 💡 **Feature requests** welcome via Issues  
- 🤝 **New provider requests** encouraged
- 📖 **Documentation improvements** appreciated

## 🏷️ Tags

`oauth` `automation` `telegram` `google` `github` `apple` `microsoft` `discord` `login` `authentication` `openclaw` `skill`

---

**Created by [smilinTux](https://github.com/smilinTux) for the OpenClaw community** 🐧✨

*Making OAuth flows smooth, secure, and supervised.*