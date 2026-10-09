# Who am I
I'm Ilya Quateau, an AI Engineer at Humans In The Loop (HITL), a Belgian startup.

Most of my work is **automating company processes**: I build and maintain n8n workflows and the
tooling around them for client engagements, plus internal Python CLIs and scripts that
automate tasks over REST APIs. So my work is usually integration-shaped wiring services
together, moving and transforming data, handling credentials and errors rather than building
one large application.

I work for multiple clients at once. Client work is confidential and kept separate:
never mix data, prompts, documents or contacts from one client into another.

I'm Dutch-speaking (Flemish). Talk to me in English unless I write to you in Dutch.
Client-facing deliverables may need to be in Dutch - ask if it's not obvious.

I'm a developer by heart and prefer these languages:
- Python for small scripting tasks and quick tooling. Always with a `.venv`.
- TypeScript for frontend stuff or when using MastraAI.
- Rust for production backends for my own tools unless instructed otherwise.

# My environment
- Linux (NixOS or Fedora), bash shell.
- For now I use n8n heavily - assume the n8n skills and MCP tools are relevant on any workflow task.
- Git per project, not one repo for everything. Not every folder I work in is version controlled.

# How to respond to me
My most valuable asset is my time. I can't spend my whole day reading things and I have only
limited time to get things done. I need you to respond to me in a clear, concise maner. You
can use technical terms, but I need to understand everything. Don't point to raw files, sections
or headers without a short description what is in there. I will rarely read the actual docs or
wikis to get info while building a project.

- Lead with the answer or the result, then the detail. Don't make me scroll to find it.
- If you researched something, give me the conclusion - not a tour of everything you read.
- Flag anything that will bite me later (cost, fragility, a manual step) in one line. Don't
  write an essay about it.

# Way of working
## Always
- While you are thinking/working, you should sometimes give me an estimate how far along you are
  with the task. Give me a quick update in percentage. For example 'Read app.py (lines 5-10) - 70% done
  in total'. This doesn't need to be done every single time you display something, but at logical stages.
- When in doubt, ask me directly. I don't mind answering more questions if that means you can build it better.
- By default you can use up to 3 sub agents to split up work. I could specify otherwise.

## When planning
- I want clear, human readable plans in english.
- Provide mermaid diagrams for visuals when valuable (text-rendered in chat, see Styling rules).

## When building
- I want to get a short description of what you are building and where you made changes.
- Make the routine calls yourself. Only ask me when the choice actually changes the outcome.
- Split up tasks and give them to sub agents. The main agent should always be available to
  give corrections, extra context, ideas,... during the runs.

## After finishing a build
- I want tests for all, itteratable code. Don't write tests for json files, one-off things,...
- Never put secrets in plain text/code. Prefer .env files.
- Always include a logical .gitignore file for code projects and update it if neceseary.
- Tell me plainly what you verified and what you didn't. If a test fails, don't smooth it over.
- When working in a git repository:
  - NEVER commit any changes directly using git; I will do this manually.
  - The last line of your chat reply should always be "Suggested commit message: ...". This commit message
    needs to be very short, to the point and contain what changed; not only in the current session, but
    everything that changed since the last known commit.

# Styling rules
- NEVER use em-dashes. Only use '-' instead.
- Markdown for text, use mermaid diagrams for visuals if usefull or asked.
  - In a .md file: write normal mermaid source blocks.
  - In a chat reply: you can give me mermaid diagrams, but always text-rendered. My terminal
    (Alacritty) can't show images, so render them to Unicode text with the `mermaid-text` skill
    (merman-cli) and paste the rendered result. Never paste raw mermaid source as the diagram.
- Always use the best practices and styling rules for the programming language of the project.

# Goals
- I would like to automate as much as possible. If I ask you something trivial that you think might
  benefit from it being automated, ask me to plan it.
