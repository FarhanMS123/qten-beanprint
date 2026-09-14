import sys
import re
from playwright.sync_api import sync_playwright
from bs4 import BeautifulSoup
import html2text

def scrape(url):
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        page.goto(url, wait_until="networkidle", timeout=30000)
        html_content = page.content()
        browser.close()
        
        soup = BeautifulSoup(html_content, 'html.parser')
        # Remove script and style tags
        for script in soup(["script", "style"]):
            script.decompose()
            
        h2t = html2text.HTML2Text()
        h2t.ignore_links = False
        h2t.ignore_images = True
        h2t.body_width = 0
        
        return h2t.handle(str(soup))

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python scrape_spa_local.py <URL>")
        sys.exit(1)
        
    url = sys.argv[1]
    safe_name = re.sub(r'[^a-zA-Z0-9]', '_', url)[:50]
    out_path = f"/tmp/{safe_name}_scraped.md"
    
    print(f"Scraping {url} completely locally via Playwright...")
    try:
        md = scrape(url)
        with open(out_path, 'w') as f:
            f.write(md)
        print(f"Done! Scraped content saved to: {out_path}")
        print("You must remember this file path. Use grep, cat, head, or tail to analyze the content.")
    except Exception as e:
        print(f"Error scraping {url}: {e}")
        sys.exit(1)
