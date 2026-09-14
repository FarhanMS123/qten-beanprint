# Deep Research: Strict Constraints & Rules

> [!CAUTION]
> These rules are ABSOLUTE. Any agent or subagent executing deep research must adhere to these constraints to protect the user's filesystem, preserve context windows, and prevent sandbox errors.

## 1. Context Protection & Fresh Research
- **ABSOLUTE Fresh Context Default:** To prevent dirtying your context window with old data, you MUST free your context and treat every task as a completely fresh research run. **DO NOT acknowledge, DO NOT read, and DO NOT analyze any existing research files** in the project or artifacts. IGNORE THEM ENTIRELY. The ONLY exception is if the user explicitly orders you to build upon them.
- **Agent Chat Response (Context Preservation):** When responding to the user in the chat interface, DO NOT re-tell, copy, or summarize the entire contents of the Draft or Report. You must only provide a very brief summary, answer direct questions briefly, and provide a clear link indicating where the artifacts are located.

## 2. File Safety & Isolation (CRITICAL TOOL RESTRICTIONS)
- **File Naming & Location Constraints:** Your files must be named exactly `{research title}_DRAFT.md` and `{research title}_REPORT.md`. Both files MUST be placed securely in the conversation's `brain/` artifact folder (or a temporary folder). 
- **STRICT File Overwrite Protection (TOOL RESTRICTION):** If the user requests a specific title or exact file name, you must check if it exists. **YOU ARE STRICTLY FORBIDDEN from using `view_file`, `read_file`, `search_files`, or `list_dir` to check existing files.** Using these tools loads the file contents or metadata into your context, which ruins the research isolation! You MUST ONLY use `run_command` with `ls` (e.g. `ls /path/to/file`) to check existence. If the `ls` command confirms the file exists, STOP immediately! Ask the user if you should overwrite it and wait for their reply.
- **NO GIT COMMANDS ALLOWED:** You are STRICTLY FORBIDDEN from using `git` commands (e.g., `git log`, `git status`, `git show`, `git ls-files`) inside the current project directory to check history or files. This is considered an unauthorized bypass of the subagent isolation rules.
- **MANDATORY SUBAGENT ISOLATION:** Subagents are STRICTLY FORBIDDEN from analyzing, reading, or grepping through the contents of the user's project folders, unless EXPLICITLY told otherwise by the user. If a subagent believes they MUST analyze a project folder to complete a task, they MUST STOP and ask the user for explicit permission first.
- **Subagent File Permissions:** Subagents ARE explicitly allowed to write directly to the DRAFT and REPORT artifacts. However, subagents are entirely locked out of reading or writing *any other project files* without direct, explicit permission from the user.

## 3. Python Scripts, SSL, and Sandbox Escapes
If you or your subagents write Python scripts for data processing:
- **MANDATORY `.venv` Usage:** NEVER use the user's global conda or python environment. 
  - If you are running a generic scraping task, use the isolated virtual environment managed by this skill: `~/.gemini/config/skills/deep-research/.venv`.
  - **Project Folders:** If you are working directly inside a user's project folder and need to install dependencies for that project, you MUST create a `.venv` (`python3 -m venv .venv`) inside that specific project folder and activate it before running `pip install`.
- **Bypassing SSL Errors:** ALWAYS use the provided helper script: `~/.gemini/config/skills/deep-research/scripts/pip_install.sh <package_name>` to bypass SSL checks. If doing this in a project folder, manually append the `--trusted-host` flags to your `pip install` command!
- **Running Generic Python Scripts:** Run your scripts using `~/.gemini/config/skills/deep-research/scripts/run_python.sh <your_script.py>`.
- **Subagent Sandbox Escapes:** If a subagent encounters persistent sandbox blocking, they MUST report the error to the Parent Agent. The Parent Agent must then extract the script and run it safely.

## 4. Parent Agent Delegation Rules (MANDATORY)
If you (the Parent Agent) spawn subagents to help with this research, you MUST strictly enforce the boundaries of this skill. 
- **NEVER FORWARD RAW PROMPTS:** Do NOT just blindly pass the user's raw prompt to the subagent. You MUST wrap the user's prompt with strict rules.
- **Strict Prompting:** When invoking a subagent, your `Prompt` payload MUST explicitly contain this exact string: 
  *"CRITICAL RESTRICTION: DO NOT read, view, grep, or analyze any existing project files. You are strictly forbidden from using view_file or list_dir on the project folder, and strictly forbidden from using git commands. Use 'run_command' with 'ls' ONLY to check if a file exists."*
- **Rules Injection:** You MUST command the subagent in its initial prompt to read this exact file (`~/.gemini/config/skills/deep-research/references/RULES.md`) before taking any action.
