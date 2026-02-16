#!/usr/bin/env node
// OAuth Helper - Provider Detection
// Detects available OAuth options on login pages

const providers = {
    google: {
        domains: ['accounts.google.com', 'googleapis.com'],
        selectors: [
            'button[data-provider="google"]',
            'a[href*="accounts.google.com"]',
            'button:has(svg[aria-label*="Google"])',
            '.google-signin-button',
            'button:contains("Sign in with Google")',
            'button:contains("Continue with Google")'
        ],
        text_patterns: ['sign.*google', 'continue.*google', 'google.*sign']
    },
    github: {
        domains: ['github.com'],
        selectors: [
            'button[data-provider="github"]',
            'a[href*="github.com/login/oauth"]',
            'button:has(svg[aria-label*="GitHub"])',
            '.github-signin-button'
        ],
        text_patterns: ['sign.*github', 'continue.*github', 'github.*sign']
    },
    apple: {
        domains: ['appleid.apple.com'],
        selectors: [
            'button[data-provider="apple"]',
            'a[href*="appleid.apple.com"]',
            'button:has(svg[aria-label*="Apple"])',
            '.apple-signin-button'
        ],
        text_patterns: ['sign.*apple', 'continue.*apple', 'apple.*sign']
    },
    microsoft: {
        domains: ['login.microsoftonline.com', 'login.live.com'],
        selectors: [
            'button[data-provider="microsoft"]',
            'a[href*="login.microsoftonline.com"]',
            'a[href*="login.live.com"]',
            'button:has(svg[aria-label*="Microsoft"])',
            '.microsoft-signin-button'
        ],
        text_patterns: ['sign.*microsoft', 'continue.*microsoft', 'microsoft.*sign']
    },
    discord: {
        domains: ['discord.com'],
        selectors: [
            'button[data-provider="discord"]',
            'a[href*="discord.com/oauth2"]',
            'button:has(svg[aria-label*="Discord"])',
            '.discord-signin-button'
        ],
        text_patterns: ['sign.*discord', 'continue.*discord', 'discord.*sign']
    }
};

// Browser automation detection script
const detectScript = `
(function() {
    const providers = ${JSON.stringify(providers)};
    const detected = [];
    
    for (const [name, config] of Object.entries(providers)) {
        let found = false;
        
        // Check selectors
        for (const selector of config.selectors) {
            try {
                const element = document.querySelector(selector);
                if (element && element.offsetParent !== null) {
                    detected.push({
                        provider: name,
                        element: selector,
                        text: element.textContent?.trim() || '',
                        method: 'selector'
                    });
                    found = true;
                    break;
                }
            } catch (e) {
                // Ignore selector errors
            }
        }
        
        // Check text patterns if not found by selector
        if (!found) {
            const buttons = document.querySelectorAll('button, a, [role="button"]');
            for (const button of buttons) {
                const text = button.textContent?.toLowerCase() || '';
                for (const pattern of config.text_patterns) {
                    if (new RegExp(pattern, 'i').test(text)) {
                        detected.push({
                            provider: name,
                            element: button.outerHTML.substring(0, 100) + '...',
                            text: button.textContent?.trim() || '',
                            method: 'text_pattern'
                        });
                        found = true;
                        break;
                    }
                }
                if (found) break;
            }
        }
    }
    
    return {
        url: window.location.href,
        title: document.title,
        providers: detected,
        timestamp: new Date().toISOString()
    };
})();
`;

if (require.main === module) {
    console.log('OAuth Provider Detection Script');
    console.log('Usage: Execute this in browser console or via automation tool');
    console.log('');
    console.log('Browser console code:');
    console.log(detectScript);
    
    // For CLI usage, output the detection script
    if (process.argv[2] === '--script') {
        console.log(detectScript);
    }
    
    if (process.argv[2] === '--providers') {
        console.log('Supported providers:');
        for (const [name, config] of Object.entries(providers)) {
            console.log(`• ${name}: ${config.domains.join(', ')}`);
        }
    }
}

module.exports = { providers, detectScript };