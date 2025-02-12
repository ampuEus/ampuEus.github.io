---
title: How to implement a linter and code formatter in a Python project (RUFF)
description: Guide explaining how to implement RUFF a linter and a code formatter on a Python project.
# author:
# authors:
date: 2025-02-03 20:14:35 +0100
# last_modified_at: 2025-02-03 20:14:43 +0100
categories: [Programming]
tags: [how to, linter, style, python]  # TAG names should always be lowercase
toc: true  # (Table of Contents) The default value is on _config.yml
pin: false
math: false
mermaid: false
comments: false
image:
  path: /assets/img/logos/ruff_logo.png
  # lqip:
  alt: Ruff logo
---

In this article you will know how to use a linter in a python project, rather for a Unix or Windows environment:

  1. Install the linter and the formatter (Ruff)
  2. Learn how to use it
  3. Integrate it on a IDE (Visual Studio Code)

## Table of contents

- [Table of contents](#table-of-contents)
- [Why Ruff?: Ruff vs Flake8 vs Pylint](#why-ruff-ruff-vs-flake8-vs-pylint)
- [Installing utilities](#installing-utilities)
- [Create configuration file: Set a coding style](#create-configuration-file-set-a-coding-style)
- [*ruff.toml* configuration file example](#rufftoml-configuration-file-example)
- [Basic use](#basic-use)
- [Integration on IDE](#integration-on-ide)
  - [VS Code](#vs-code)
- [References](#references)

## Why Ruff?: Ruff vs Flake8 vs Pylint

Ruff is both a linter and a formatter. As it is written in Rust (with special focus on performance) is much faster than other python linters.

About [rules](https://docs.astral.sh/ruff/rules/){:target="_blank"}, Ruff support a lot of rules many of which are inspired by popular tools like Flake8, isort, pyupgrade... But now a days (on year 2025) it does not have as many as other tools like pylint.

## Installing utilities

```shell
pip install ruff
```

## Create configuration file: Set a coding style

Ruff can be configured through a `pyproject.toml`, `ruff.toml`, or `.ruff.toml` files.

> Go to [Configuration](https://docs.astral.sh/ruff/configuration/){:target="_blank"}, or [Settings](https://docs.astral.sh/ruff/settings/){:target="_blank"} for a complete list of all configuration options.

## *ruff.toml* configuration file example

```shell
# This configuration file is based on PEP8 Style Guide for Python

# Exclude a variety of commonly ignored directories.
exclude = [
    ".bzr",
    ".direnv",
    ".eggs",
    ".git",
    ".git-rewrite",
    ".hg",
    ".ipynb_checkpoints",
    ".mypy_cache",
    ".nox",
    ".pants.d",
    ".pyenv",
    ".pytest_cache",
    ".pytype",
    ".ruff_cache",
    ".svn",
    ".tox",
    ".venv",
    ".vscode",
    "__pypackages__",
    "_build",
    "buck-out",
    "build",
    "dist",
    "node_modules",
    "site-packages",
    "venv",
]

# Same as PEP8.
line-length = 79
indent-width = 4

[lint]
preview = true
select = ["F",      # Pyflakes
          "E",      # pycodestyle
          "I",      # isort
          "N",      # pep8-naming
          "FBT",    # flake8-boolean-trap
          "B",      # flake8-bugbear
          "A",      # flake8-builtins
          "COM",    # flake8-commas
          "C4",     # flake8-comprehensions
          "DTZ",    # flake8-datetimez
          "EM",     # flake8-errmsg
          "EXE",    # flake8-executable
          "ISC",    # flake8-implicit-str-concat
          "ICN",    # flake8-import-conventions
          "LOG",    # flake8-logging
          "G",      # flake8-logging-format
          "PIE",    # flake8-pie
          "PYI",    # flake8-pyi
          "Q",      # flake8-quotes
          "RSE",    # flake8-raise
          "RET",    # flake8-return
          "SLOT",   # flake8-slots
          "SIM",    # flake8-simplify
          "TID",    # flake8-tidy-imports
          "TCH",    # flake8-type-checking
          "ARG",    # flake8-unused-arguments
          "PD",     # pandas-vet
          "TRY",    # tryceratops
          "PERF",   # Perflint
          "RUF"]    # Ruff-specific rules
ignore = []

# Allow fix for all enabled rules (when `--fix`) is provided.
fixable = ["ALL"]
unfixable = []

# Allow unused variables when underscore-prefixed.
dummy-variable-rgx = "^(_+|(_+[a-zA-Z0-9_]*[a-zA-Z0-9]+?))$"

[format]
line-ending = "auto" # Automatically detect the appropriate line ending.
# quote-style = "double" # Don't work when is flake8-quotes (Q) activated | Use double quotes for strings.
indent-style = "space" # Indent with spaces, rather than tabs.
skip-magic-trailing-comma = false # Respect magic trailing commas.


# Enable auto-formatting of code examples in docstrings. Markdown,
# reStructuredText code/literal blocks and doctests are all supported.
#
# This is currently disabled by default, but it is planned for this
# to be opt-out in the future.
docstring-code-format = false

# Set the line length limit used when formatting code snippets in
# docstrings.
#
# This only has an effect when the `docstring-code-format` setting is
# enabled.
docstring-code-line-length = "dynamic"
```

## Basic use

```shell
ruff check   # Lint all files in the current directory.
ruff format  # Format all files in the current directory.
```

## Integration on IDE

### VS Code

To integrate ruff on VS Code you only need to install [Ruff extension](https://marketplace.visualstudio.com/items?itemName=charliermarsh.ruff){:target="_blank"}. Moreover, it is not necessary to have Ruff installed as the extension itself has an embedded version of Ruff. You only need to change the `Import Strategy` option from `fromEnvironment` to `useBundled`.

>An other useful extension to see the Ruff (and other extensions) generated messages inline is [Error Lens](https://marketplace.visualstudio.com/items?itemName=usernamehw.errorlens){:target="_blank"}.
{: .prompt-tip }

By default the extension looks for a configuration file in the directory of each .py to apply its rules. If it doesn't find one, it looks for the nearest configuration file above the folder tree. Even so, by modifying the parameter `ruff.lint.args` you can choose the file you want setting the absolute path to the file: `--config=/absolute/path/to/ruff.toml`.

## References

- [ruff website](https://docs.astral.sh/ruff/){:target="_blank"}
- [ruff github](https://github.com/astral-sh/ruff){:target="_blank"}
- [PEP 8 – Style Guide for Python Code](https://peps.python.org/pep-0008/){:target="_blank"}
- <https://pythonspeed.com/articles/pylint-flake8-ruff/>{:target="_blank"}
- <https://codilime.com/blog/python-code-quality-linters/>{:target="_blank"}
