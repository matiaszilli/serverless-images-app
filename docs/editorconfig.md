#  [EditorConfig](https://editorconfig.org/) for VS Code

This plugin attempts to override user/workspace settings with
settings found in `.editorconfig` files. No additional or vscode-specific files
are required. 

## Installation

Press: `ctrl + shift + p` on Windows and then:

```bash
ext install EditorConfig
```

Or install it from VSCode Marketplace [here.](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig)

## How it works

This extension is activated whenever you open a new text editor, switch tabs
into an existing one or focus into the editor you already have open. When
activated, it uses [`editorconfig`](https://www.npmjs.com/package/editorconfig)
to resolve the configuration for that particular file and applies any relevant
editor settings.  
As with any EditorConfig plugin, if `root=true` is not specified,
EditorConfig [will continue to look](https://editorconfig.org/#file-location)
for an `.editorconfig` file outside of the project.

## See also:

- [EditorConfig Site](https://editorconfig.org)
- [EditorConfig Issue Tracker](https://github.com/editorconfig/editorconfig/issues)
- [EditorConfig Wiki](https://github.com/editorconfig/editorconfig/wiki)
