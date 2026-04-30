# FusionAI

<p align="center">
  <img src="./Logo.png" alt="FusionAI logo" width="220" />
</p>

<p align="center">
  AI assistance for Embarcadero RAD Studio 10.x and 11.x, directly inside the IDE.
</p>

<p align="center">
  <img src="https://img.shields.io/github/license/AliDehbansiahkarbon/ChatGPTWizard.svg" alt="License" />
  <img src="https://img.shields.io/github/stars/AliDehbansiahkarbon/ChatGPTWizard.svg" alt="Stars" />
  <img src="https://img.shields.io/github/forks/AliDehbansiahkarbon/ChatGPTWizard.svg" alt="Forks" />
  <img src="https://img.shields.io/github/last-commit/AliDehbansiahkarbon/ChatGPTWizard.svg" alt="Last commit" />
</p>

<p align="center">
  <a href="https://www.buymeacoffee.com/adehbanr" target="_blank">
    <img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174" />
  </a>
</p>

> FusionAI is the current evolution of the original `ChatGPTWizard` project.

## What It Is

FusionAI is a Delphi plug-in for RAD Studio that brings AI-assisted workflows into the IDE:

- Ask free-form questions in a chat window
- Run inline questions directly from the editor
- Use predefined right-click actions such as explain, optimize, add comments, add tests, and find bugs
- Work with class/type-based prompts from a dedicated Class View
- Compare answers across multiple AI providers
- Keep a searchable local history database
- Use local file logging for diagnostics when needed

The project is intended for RAD Studio versions that do not have the newer built-in AI workflow as the primary path.

## Supported IDE Versions

This repository currently targets:

- RAD Studio 10.x
  - 10.1 Berlin
  - 10.2 Tokyo
  - 10.3 Rio
  - 10.4 Sydney
- RAD Studio 11.x
  - 11 Alexandria

This repository is **not** the main target for RAD Studio 12.2+.

For older IDEs, use the separate branch/repository:

- [ChatGPTWizard-XE2-to-XE8](https://github.com/AliDehbansiahkarbon/ChatGPTWizard-XE2-to-XE8)

## Supported AI Providers

FusionAI currently supports:

- OpenAI ChatGPT
- Google Gemini
- Anthropic Claude
- Ollama

### Notes

- ChatGPT, Gemini, and Claude require valid API credentials.
- Ollama can be used locally without a cloud API key.
- You can choose a default AI service in the settings.
- Available models can be refreshed and cached per provider.

## Main Features

- Unified FusionAI chat window
- Dockable assistant UI when the IDE version supports it
- Inline editor prompts with the `cpt: ... :cpt` format
- Right-click editor actions for selected code
- Class View with prompt actions and code conversion helpers
- Provider-aware answer tabs
- Provider-aware SQLite history
- History filtering by provider and model
- Proxy configuration
- File-based diagnostic logging
- Configurable timeouts and provider-specific parameters

## Installation

### Option 1: Delphinus

Install through [Delphinus](https://github.com/Memnarch/Delphinus).

### Option 2: Direct package install

1. Open [FusionAI.dproj](./FusionAI.dproj) in RAD Studio.
2. Build the package.
3. Install the generated package from the IDE.

## Quick Start

1. Open `FusionAI Settings`.
2. Go to `AI Services`.
3. Enable at least one provider.
4. Fill in the provider settings:
   - Base URL
   - Access key if required
   - Default model
   - Optional provider-specific parameters
5. Save and reopen the assistant if needed.

## How To Use

### Chat Window

Open `FusionAI` from the IDE menu and ask a normal question.

Use this for:

- code explanation
- refactoring ideas
- architecture questions
- debugging help
- ad hoc snippets

<div style="display:inline">
<img width="350" height="500" src="https://user-images.githubusercontent.com/5601608/220568940-7eba2b94-f091-4400-a031-49b35d1f0d5e.png" alt="FusionAI main form"/>
<img width="350" height="500" src="https://user-images.githubusercontent.com/5601608/220568742-8ec94dec-ca44-4331-b245-202d64181fa5.png" alt="FusionAI answer view"/>
</div>

### Inline Questions

There are two main inline workflows:

1. Use direct inline prompt markers:

```delphi
cpt: Explain what this method does. :cpt
```

Then run the `Ask` action from the editor popup menu or use its shortcut.

2. Select code and use a predefined action from the popup menu:

- Ask
- Add Test
- Find Bugs
- Optimize
- Add Comments
- Complete Code
- Explain Code
- Refactor Code
- Convert to Assembly

The response is inserted back into the editor as a multiline comment after the selected code.

### Context Menu

For selected text or a code block, FusionAI can insert the result after the selection as a multiline Delphi comment block.

Available actions include:

- Ask
- Add Test
- Find Bugs
- Optimize
- Add Comments
- Complete Code
- Explain Code
- Refactor Code
- Convert to Assembly

![Context menu](https://github.com/AliDehbansiahkarbon/ChatGPTWizard/assets/5601608/51bf3bd9-ab79-4a3c-be18-9e3f7b0cdc06)

![Context menu actions](https://user-images.githubusercontent.com/24512608/236584029-c3982eb3-1824-4146-a611-7c861b034e28.png)

### Selected Code Without Inline Markers

If you select code and trigger the first `Ask` action without the `cpt: ... :cpt` format, FusionAI opens the chat window and prepares a draft question for you.

### Class View

The Class View tab lets you work with types parsed from the current Delphi unit.

Typical uses:

- explain a type
- optimize a type
- add tests for a type
- run custom prompts against the selected type
- convert a type to another language

The parser has been improved to better tolerate newer Delphi syntax, but Class View is still best treated as a practical helper rather than a full compiler-grade parser.

![Class View](https://user-images.githubusercontent.com/5601608/220570745-1720a8eb-026f-42b0-b6d3-c578874a3c9c.png)

## Provider Configuration

Each provider has its own configuration tab under `AI Services`.

Depending on the provider, you can configure:

- enable/disable state
- base URL
- access key
- model
- timeout
- max tokens
- temperature
- top-p
- top-k
- API version fields when required by the provider

### ChatGPT

- Uses the OpenAI Chat Completions API
- Works with current GPT-4 and GPT-5 style models

### Gemini

- Uses the Google Generative Language API

### Claude

- Uses the Anthropic API

### Ollama

- Uses a local or remote Ollama endpoint
- Suitable for offline or private workflows

### Settings UI

Provider settings are managed from the `AI Services` page.
<img width="445" height="620" alt="image" src="https://github.com/user-attachments/assets/45e85309-a335-47a5-9318-8f860126930f" />
<img width="445" height="622" alt="image" src="https://github.com/user-attachments/assets/630ce34d-d626-47ae-a750-44f5a53c5664" />

## Ollama Setup

1. Install Ollama from [ollama.com](https://ollama.com).
2. Make sure the server is running.
3. Pull at least one model, for example:

```bash
ollama run llama3.2
```

4. In FusionAI settings, enable `Ollama`.
5. Set the base URL, usually:

```text
http://localhost:11434
```

6. Choose or enter the model name.

Legacy setup screenshot:

![Ollama local server](https://github.com/AliDehbansiahkarbon/ChatGPTWizard/assets/5601608/72eb4b84-7971-4354-bcc8-dd8c3818d3ad)

## History

FusionAI can store requests and responses in a local SQLite database.

History includes provider-aware metadata such as:

- provider
- model
- status
- timestamps
- duration

You can filter the history by provider and model, and use text or fuzzy search to find older conversations.

![History grid](https://user-images.githubusercontent.com/5601608/222926278-9978259a-9ac4-4ba7-bfbb-9675b123756c.png)

![History detail](https://user-images.githubusercontent.com/5601608/222926296-3cdaeb05-bfcd-4e5c-8959-e06ee6945c6f.png)

### Search In History

History supports text and fuzzy filtering with extra search options.

![History search 1](https://user-images.githubusercontent.com/5601608/223150719-40e9169e-e4ea-4bdd-96b5-94830418c9d4.png)

![History search 2](https://user-images.githubusercontent.com/5601608/223151111-d376cc1f-3688-4eae-82ea-dcf57f877046.png)

![History search 3](https://user-images.githubusercontent.com/5601608/223151270-0355edbe-80db-43da-a5a0-266e1be8d339.png)

## Logging

FusionAI supports optional file-based logging for troubleshooting.

When enabled, logs can include:

- request URL
- request JSON
- response JSON
- provider status transitions
- timeout and inline-flow diagnostics

API keys are not written to the log file.

## Notes And Limitations

- Some providers are paid services or have usage limits.
- Generated content is sent directly to the configured AI provider.
- You are responsible for reviewing generated code and text before using it.
- Class View parsing is best-effort and may not perfectly represent every source shape.
- Very large prompts or very large type bodies may still hit provider-side token limits.

## Troubleshooting

### SSL / HTTP issues

If HTTPS requests fail inside the IDE, make sure the required SSL libraries are available in the environment used by `bds.exe`.

### Empty or invalid provider results

Check:

- provider is enabled
- base URL is correct
- access key is valid
- model is available for that provider
- timeout is high enough for the selected model

### Class View issues

If Class View looks stale after switching units or reopening the assistant:

- switch away from `Class View` and back again
- reopen the assistant window
- verify the current unit is the one you expect

## Demo Videos

<details>
<summary>Short 1 (all features)</summary>
<a href="https://www.youtube.com/watch?v=jHFmmmrk3BU" target="_blank"><img src="https://img.youtube.com/vi/vUgHg3ZPvXI/0.jpg" /></a>
</details>

<details>
<summary>Short 2 (multi-provider demo)</summary>
<a href="https://youtu.be/tEiKmalzZo8" target="_blank"><img src="https://img.youtube.com/vi/vUgHg3ZPvXI/0.jpg" /></a>
</details>

<details>
<summary>Long demo</summary>
<a href="https://www.youtube.com/watch?v=qHqEGfxAhIM" target="_blank"><img src="https://img.youtube.com/vi/qHqEGfxAhIM/0.jpg" /></a>
</details>

## Legacy Name

This repository still uses the historical GitHub repository name `ChatGPTWizard`, but the current plug-in and package name is **FusionAI**.

## Contributing

Issues, pull requests, and discussions are welcome.

Please include:

- RAD Studio version
- provider name
- active model
- exact steps to reproduce
- log output if file logging is enabled

## License

MIT. See [LICENSE](./LICENSE).

## Support

If you find the project useful, starring the repository helps a lot.

<hr>
<p align="center">
<img src="https://i0.wp.com/blogs.embarcadero.com/wp-content/uploads/2022/11/dlogonew-5582740.png?resize=254%2C242&ssl=1" alt="Delphi">
</p>
<h5 align="center">
Made with :heart: on Delphi
</h5>
