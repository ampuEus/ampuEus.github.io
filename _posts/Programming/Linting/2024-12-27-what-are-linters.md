---
title: What are Linters and Code Formatters?
description: Guide explaining what a linter and code formatter are and a bit of its history.
# author:
# authors:
date: 2024-12-27 19:00:00 +0100
# last_modified_at: 2024-12-27 19:00:00 +0100
categories: [Programming]
tags: [what is, linter, style]  # TAG names should always be lowercase
toc: true  # (Table of Contents) The default value is on _config.yml
pin: false
math: false
mermaid: false
comments: false
image:
  path: /assets/img/others/pc_code-ia.webp
  # lqip:
  # alt:
---

> This article often interprets the term *linter* in a wide sense, to include resources for SAST (Static Application Security Testing), SCA (Source Code Analysis), memory management validators, code formatters, and style guides.
{: .prompt-info}

In this article you will know about what a linter and code formatter are, how they work, why are they useful, differences between static and dynamic code analysis and finally see how to implement them in a basic C project.

## Table of contents

- [Table of contents](#table-of-contents)
- [What is a linter?](#what-is-a-linter)
- [What are Code Formatter?](#what-are-code-formatter)
- [A little bit of linters' history](#a-little-bit-of-linters-history)
- [Static vs Dynamic code analysis](#static-vs-dynamic-code-analysis)
- [Compilation flags](#compilation-flags)
- [References](#references)
  - [Some linters](#some-linters)
  - [Extensions](#extensions)

## What is a linter?

Linters are **automated** tools that ***statically* analyze** the source **code before compilation**. With the goal of **detect potential errors**, security **vulnerabilities or stylistic issues**, making it easier to maintain code quality and giving consistency across a project promoting best practices in coding.

does not have to run or compile your C code before she detects potential errors and wrong styles. -> codebase no matter what compiler you are using

## What are Code Formatter?

Code formatters, despise linters, only are used to **standardize code formatting based on a given style guide**, making easier to read and understand code.

This is important working on large projects with multiple developers, where everyone needs to be able to read and understand each other's code. Having a consistent code across a project or team helps preventing errors and improving code quality. They also make it easier to maintain code over time, as the code is formatted consistently.

## A little bit of linters' history

The term *lint* comes from the name of the first lint tool, a Unix utility for C, which was developed in the early 1970s by a team of Bell Labs researchers led by Stephen C. Johnson. It was designed to analyze C source code for potential errors and stylistic issues. Since then, linting tools have evolved to work with a variety of programming languages.

The name "*lint*" refers to the lint shed by clothing, because the program acts like a clothes dryer lint trap in that it caught the excess "fibers" without affecting the whole cloth. In other words, the "lint" in your code is the code that technically works, but could either have a bug or be suboptimal in some other way.

## Static vs Dynamic code analysis

**Static analysis is done before compilation**. On this *linting* step, programmers can maintain a higher level of code discipline, increasing the reliability of the code in multiple compilers and environments.

**Dynamic analysis is done by running the code**. Thanks to *unit tests* programmers examine how code behaves for different inputs and corner cases.

## Compilation flags

Another way to review the code before compilation is to use the flags that are offered in the compiler you are using. Many compilers include options to prevent dirty code from compiling like:

- `-Wall` to turn on warnings
- `-Wextra` for even more warnings
- `-Werror` to treat warnings as errors
- ...

In addition, there are tools that can extract information from execution errors or other unwanted behaviors of the program. Like *Valgrind*, used to Detect Memory Leaks.

## References

- <https://github.com/mcandre/linters>{:target="_blank"}
- <https://github.com/caramelomartins/awesome-linters>{:target="_blank"}
- <https://github.com/readme/guides/formatters-linters-compilers>{:target="_blank"}
- <https://stackoverflow.blog/2020/07/20/linters-arent-in-your-way-theyre-on-your-side/>{:target="_blank"}
- <https://www.freecodecamp.org/news/using-prettier-and-jslint/>{:target="_blank"}
- <https://www.freecodecamp.org/news/what-is-linting-and-how-can-it-save-you-time/>{:target="_blank"}
- <https://www.welchcanavan.com/why-i-lint-everything/>{:target="_blank"}
- <https://gcc.gnu.org/onlinedocs/gcc/Static-Analyzer-Options.html>{:target="_blank"}
- <https://en.wikipedia.org/wiki/Lint_(software)>{:target="_blank"}
- <https://www.perforce.com/blog/qac/what-is-linting>{:target="_blank"}
- <https://web.archive.org/web/20220123141016/https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.56.1841&rep=rep1&type=pdf>{:target="_blank"}
- <https://dev.to/mcsavvy/meet-betty-the-c-code-linter-1lld>{:target="_blank"}
- <https://developers.redhat.com/blog/2021/04/06/get-started-with-clang-tidy-in-red-hat-enterprise-linux#using_clang_tidy_in_red_hat_enterprise_linux>{:target="_blank"}
- <https://inventwithpython.com/blog/2022/11/19/python-linter-comparison-2022-pylint-vs-pyflakes-vs-flake8-vs-autopep8-vs-bandit-vs-prospector-vs-pylama-vs-pyroma-vs-black-vs-mypy-vs-radon-vs-mccabe/>{:target="_blank"}

### Some linters

- <https://splint.org/>{:target="_blank"}
- <https://github.com/cpp-linter>{:target="_blank"}
- <https://clang.llvm.org/docs/ClangTools.html>{:target="_blank"}
- <https://www.labri.fr/perso/fleury/posts/programming/using-clang-tidy-and-clang-format.html>{:target="_blank"}
- <https://clangpowertools.com/>{:target="_blank"}
- <https://zed0.co.uk/clang-format-configurator/>{:target="_blank"}
- <https://github.com/Sarcasm/run-clang-format>{:target="_blank"}
- <https://github.com/Prezzido/Betty>{:target="_blank"}
- <https://github.com/dustinspecker/awesome-eslint>{:target="_blank"}
- <https://github.com/uncrustify/uncrustify>{:target="_blank"}
- <https://pythonspeed.com/articles/pylint-flake8-ruff/>{:target="_blank"}

### Extensions

**Visual Studio Code:**

- <https://www.youtube.com/watch?v=8RSxQ8sluG0>{:target="_blank"}
- <https://devblogs.microsoft.com/cppblog/visual-studio-code-c-december-2021-update-clang-tidy/>{:target="_blank"}
- <https://code.visualstudio.com/docs/python/linting>{:target="_blank"}
