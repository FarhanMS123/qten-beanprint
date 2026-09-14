#!/bin/bash
if [ -z "$1" ]; then
    echo "Usage: ./scrape_url.sh <URL>"
    exit 1
fi
URL="$1"

# Route GitHub URLs to the gh CLI automatically
if [[ "$URL" == *"github.com"* ]]; then
    echo "GitHub URL detected. You MUST use the 'gh' CLI for GitHub access instead of web scraping!"
    echo "Example: gh repo view <owner>/<repo> or gh pr view <url>"
    exit 1
fi

echo "Running local Playwright scraper..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
"$SCRIPT_DIR/run_python.sh" "$SCRIPT_DIR/scrape_spa_local.py" "$URL"
