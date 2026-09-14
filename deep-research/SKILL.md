---
name: deep-research
description: Conducts deep, iterative, multi-hop research on complex topics (similar to Gemini Deep Research), automatically formulating queries, reading long-form web content, and synthesizing comprehensive cited reports.
---

# Deep Research Skill

This skill transforms the agent into an autonomous, deep-research engine. 

> [!CAUTION]
> **MANDATORY PREREQUISITE:** Before starting ANY research task, you MUST read `~/.gemini/config/skills/deep-research/references/RULES.md`. It contains absolute constraints regarding file overwrites, context preservation, and sandbox escapes. If you spawn any subagents, you MUST command them to read that `RULES.md` file as their very first action.

## 1. Core Research Mindset & Directives
- **Clarification Phase:** Assess if you need to ask a clarifying question before starting. If unstated dimensions are critical, ask. 
- **Project Context Awareness:** Before doing anything, if you are working within a project directory, you MUST acknowledge and read `AGENTS.md`, `CLAUDE.md`, or any related documentation files mentioned in the project for further constraints and directions.
- **Problem Formulation & Evidentiary Rigor:** Treat all questions in the user's prompt purely as initial "user formulations". Do not just answer them passively. You must actively rephrase them, add your OWN advanced questions and arguments, and ruthlessly hunt for hard evidence to support or refute them.
- **Argument over Authority:** Value robust logical arguments and data over mere domain authority.
- **Source Prioritization:** Prioritize primary sources (official brand sites, primary academic papers) over SEO-heavy blogs. 

## 2. System Architecture & Native Tool Mapping
- **Triage / Supervisor (via `@modelcontextprotocol/server-sequentialthinking`):** Break down the main query into 3-5 independent subtopics.
- **Persistent Memory (via `@modelcontextprotocol/server-memory`):** Build a local knowledge graph. Persist entities, facts, and relationships across long iterations.
- **Web Surfer (via `search_web` & `read_url_content`):** ALWAYS use `search_web` to discover URLs. 
- **GitHub Researcher (via `gh` cli):** NEVER use web scraping for GitHub URLs. ALWAYS use the natively installed `gh` CLI in the terminal to read repositories, pull requests, and issues.
- **Data Parser (via `pdf`, `docx`, `xlsx` skills):** Parse unstructured web pages and downloaded local files into clean formats.

## 3. Web Scraping & API Data Extraction (100% Local)
When you need to extract data from websites, you must use local tools. You are strictly forbidden from writing scraping scripts from scratch or using paid 3rd-party APIs.

- **Simple Websites & APIs (Use Native CLI):** If you are just simply getting a static website, downloading a file, or hitting a REST API, **DEFAULT to using native CLI tools.** Use `curl` to fetch the data. If parsing structured data, pipe it through `jq` (for JSON) or `yq` (for YAML). This is the fastest, most context-efficient method.
- **Complex SPA Sites (Use Local Scraper):** If (and only if) the website is a complex Single Page Application that requires JavaScript rendering, you MUST use the pre-built local Playwright scraping script: `~/.gemini/config/skills/deep-research/scripts/scrape_url.sh <URL>`. 
  - *How It Works:* It runs 100% locally on your machine, launches headless Chromium, executes JavaScript, converts the DOM into Markdown, and stores it in `/tmp/<name>_scraped.md`.
  - *Post-Scraping:* Once the script outputs the temporary file path, remember it! You must then use native terminal commands like `grep`, `cat`, `head`, and `tail` on that temporary markdown file to extract the exact quotes and evidence.

## 4. The Deep Research Loop & Note-Taking

> [!CAUTION]
> **MANDATORY DRAFT REQUIREMENT:** You are STRICTLY FORBIDDEN from generating the final report directly. You MUST create a draft artifact IMMEDIATELY when the task begins. You must spend minutes populating this draft before you are allowed to create the final report artifact.

Research must be iterative and strictly planned:
- **Atomic Deconstruction (The Very First Step):** Before starting any web searches, open your `{research title}_DRAFT.md` and completely deconstruct the user's prompt/request into simple, consecutive statements, questions, and directions at the **molecular, atomic, and subatomic** levels. Treat their questions as a starting point, rephrase them, and add your own expanded questions to explore.
- **Continuous Note-Taking:** During your research loops, you MUST continuously dump your raw research notes, mental notes, formulated questions, drafted arguments, todo lists, reminders, and keywords into your DRAFT file. This is an external, persistent scratchpad.
- **Fact Survey & Planning:** Start by listing (1) Facts given, (2) Facts to look up, (3) Facts to derive inside your draft artifact. Then create a step-by-step plan based on your atomic deconstruction.
- **Action / Observation Loop:** Execute a tool call, wait for the result, and use it as input for the next action. Do not repeat identical tool calls.
- **Reflect Before & After:** Always use a "think" or "reflection" step before initiating a tool call, and after each observation. Formulate *new* multi-hop queries to fill gaps.

## 5. Synthesis & Output Formatting
Only AFTER your `{research title}_DRAFT.md` is fully populated with raw notes, begin drafting the final report. Generate a NEW comprehensive artifact (`{research title}_REPORT.md` in the `brain/` directory).

- **Fact-Checking (via `discernment-nudge`):** BEFORE finalizing your reply, invoke the `discernment-nudge` skill.
- **Detailed Outcomes:** Provide an Executive Summary followed by an extremely detailed Findings section broken down by sub-topics, explicitly presenting the problems/questions formulated, arguments, and evidence inside the REPORT artifact.
- **Strict Citation Rules:** Every substantive claim, argument, figure, or quote MUST carry an inline citation. Format as `[[1]](URL)`. 
