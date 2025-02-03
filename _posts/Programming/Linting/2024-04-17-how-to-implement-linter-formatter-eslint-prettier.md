---
title: How to implement a linter and code formatter in a web project (ESLint and Prettier)
description: Guide explaining how to implement ESLint linter and Prettier code formatter on a web project.
# author:
# authors:
date: 2025-01-26 20:13:16 +0100
# last_modified_at: 2025-01-26 20:13:22 +0100
categories: [Programming]
tags: [how to, linter, style, javascript, typescript, web]  # TAG names should always be lowercase
toc: true  # (Table of Contents) The default value is on _config.yml
pin: false
math: false
mermaid: false
comments: false
image:
  path: /assets/img/others/how-to-setup-eslint-prettier.svg
  # lqip:
  alt: How to setup ESLint and Prettier
---

In this article you will know how to use a linter and formatter in a web project, rather for a JavaScript or TypeScript environment. You are going to:

  1. Install the **linter (ESLint)** and the **formatter (Prettier)**.
  2. Learn how to use them.
  3. Integrate it on a IDE (Visual Studio Code).

> On this project I use:
>
> - `node.js` as javascript runtime.
> - `pnpm` as package manager.
> - `ECMAScript` as module systems.
{: .prompt-info }

## Table of contents

- [Table of contents](#table-of-contents)
- [Installing utilities](#installing-utilities)
- [Learning how to use the utilities](#learning-how-to-use-the-utilities)
  - [The linter: ESLint](#the-linter-eslint)
    - [Create Eslint configuration file: Start catching bugs on your code](#create-eslint-configuration-file-start-catching-bugs-on-your-code)
    - [*eslint.config.js* configuration file example](#eslintconfigjs-configuration-file-example)
    - [Basic use of ESLint on the terminal](#basic-use-of-eslint-on-the-terminal)
    - [Integration on IDE: VS Code's ESLint extension](#integration-on-ide-vs-codes-eslint-extension)
  - [The formatter: Prettier](#the-formatter-prettier)
    - [Create Prettier configuration file: Start styling your code](#create-prettier-configuration-file-start-styling-your-code)
    - [*prettier.config.js* configuration file example](#prettierconfigjs-configuration-file-example)
    - [*.prettierignore* configuration file example](#prettierignore-configuration-file-example)
    - [Basic use of Prettier on the terminal](#basic-use-of-prettier-on-the-terminal)
    - [Integration on IDE: VS Code's Prettier extension](#integration-on-ide-vs-codes-prettier-extension)
- [References](#references)

## Installing utilities

```shell
pnpm init # Initialize the project (if you haven't already)
pnpm add --save-dev eslint @eslint/js # Install ESLint
pnpm add --save-dev typescript-eslint # Add ESLint's TypeScript plugin if you use it
pnpm add --save-dev prettier # Install prettier
pnpm add --save-dev eslint-config-prettier # Help turning off all ESLint rules that conflict with Prettier
```

> Note that `eslint-config-prettier` config only turns rules off, so it only makes sense using it together with some other config.
{: .prompt-warning }

## Learning how to use the utilities

### The linter: ESLint

#### Create Eslint configuration file: Start catching bugs on your code

There are different ESLint configuration files:

- `eslint.config.js` -> Uses **CommonJS** module format by default. So you need to add `"type": "module"` in the `package.json` file of project.
- `eslint.config.mjs` -> Uses **ECMAScript** module (ESM) format.

> For more information about this go to ESLint [configuration files](https://eslint.org/docs/latest/use/configure/configuration-files){:target="_blank"} section on official documentation. And to view all ESLint rules go to [Rules Reference](https://eslint.org/docs/latest/rules/){:target="_blank"}
{: .prompt-info }

#### *eslint.config.js* configuration file example

```javascript
import js from "@eslint/js";
import ts from "typescript-eslint";
import prettierCompatibility from "eslint-config-prettier";
import prettier from "eslint-plugin-prettier";

export default [
  {
    // Ignore desired folders and files
    ignores: ["dist", "built", "node_modules"],
  },
  {
    // Lint all files with these extensions
    files: ["**/*.{ts,tsx,cts,mts,js,cjs,mjs}"],
  },
  // Add recommended linting rules
  js.configs.recommended,
  ...ts.configs.strict,
  // Enable eslint-plugin-prettier to run Prettier as an ESLint rule
  // and report any formatting issues as ESLint errors
  {
    plugins: {
      prettier: prettier,
    },
    rules: {
      "prettier/prettier": "error",
    },
  },
  // Turns off all rules that are unnecessary or might conflict with Prettier
  // Put always on the final part to be the last rules to be proceed
  prettierCompatibility,
];

```

#### Basic use of ESLint on the terminal

```shell
pnpx eslint file1.js # Run on a specific file(s)
pnpx eslint lib/** # Run on a specific directory
pnpx eslint # Run on all project
```

> For more information on the available CLI options, refer to [Command Line Interface](https://eslint.org/docs/latest/use/command-line-interface){:target="_blank"}.
{: .prompt-info }

#### Integration on IDE: VS Code's ESLint extension

To integrate ESLint on VS Code you only need to install [ESLint extension](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint){:target="_blank"} by Microsoft. This extension use the ESLint installed on `node_modules` and its configuration file (eslint.config.js) of the project to
analyze your code and show error on the editor.

>If the configuration file have an error and `pnpx eslint` does not work, the extension go to an error status and you need to restart it.
{: .prompt-warning }

>An other useful extension to see the ESLint (and other extensions) generated messages inline is [Error Lens](https://marketplace.visualstudio.com/items?itemName=usernamehw.errorlens){:target="_blank"}.
{: .prompt-tip }

### The formatter: Prettier

#### Create Prettier configuration file: Start styling your code

There are many ways to create a Prettier config file ([see](https://prettier.io/docs/en/configuration){:target="_blank"}), for me the best way of doing it and to be consistent with the ESLint part is to use `prettier.config.js` file.

> Remember to add `"type": "module"` in the `package.json` file of project.
{: .prompt-warning }

Also, to let the Prettier CLI know which files to not format you will need a `.prettierignore`.

> To see al the available rules go to [Options](https://prettier.io/docs/en/options.html){:target="_blank"} section on the official documentation.
{: .prompt-info }

#### *prettier.config.js* configuration file example

```javascript
export default [
  {
    printWidth: 80,
    tabWidth: 2,
    useTabs: false,
    semi: false,
    singleQuote: false,
    quoteProps: "as-needed",
    jsxSingleQuote: false,
    trailingComma: "all",
    bracketSpacing: true,
    bracketSameLine: true,
    arrowParens: "always",
    requirePragma: false,
    insertPragma: false,
    proseWrap: "preserve",
    htmlWhitespaceSensitivity: "css",
    endOfLine: "lf",
    embeddedLanguageFormatting: "auto",
    singleAttributePerLine: false,
  },
];
```

#### *.prettierignore* configuration file example

```text
dist
built
node_modules
```

#### Basic use of Prettier on the terminal

```shell
# "--check" is like "--write", but only checks that files are already formatted, rather than overwriting them.
pnpx prettier --check . # Run on all project
pnpx prettier --write .
pnpx eslint --check file1.js # Run on a specific file(s)
pnpx eslint --check lib/** # Run on a specific directory
```

> Here you have more information of the available [CLI](https://prettier.io/docs/en/cli){:target="_blank"} options.
{: .prompt-info }

#### Integration on IDE: VS Code's Prettier extension

You only need to install [Prettier - Code formatter](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode){:target="_blank"}. If you want to format the code automatically when saving. You must enable the *Format On Save* option in the VS Code settings.

> Once Prettier extension is installed, maybe, you can have conflicts with others formatters for `JavaScript`, `TypeScript`, `Markdown`... files. So Prettier should be configured as default formatter globally or for each language you want on VS Code settings.
{: .prompt-warning }

## References

- [ESLint website](https://eslint.org/){:target="_blank"}
- [TypeScript ESLint website](https://typescript-eslint.io/){:target="_blank"}
- [Prettier website](https://prettier.io/){:target="_blank"}
- [eslint-plugin-prettier](https://github.com/prettier/eslint-plugin-prettier){:target="_blank"}
- [eslint-config-prettier](https://github.com/prettier/eslint-config-prettier){:target="_blank"}
