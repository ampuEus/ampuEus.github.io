---
title: How to implement a linter and code formatter in a C/C++ project (clang-format and clang-tidy)
description: Guide explaining how to implement a linter and a code formatter on a C project.
# author:
# authors:
date: 2025-02-10 20:10:00 +0100
# last_modified_at: 2025-02-10 20:10:06 +0100
categories: [Programming]
tags: [how to, linter, style, c, cpp]  # TAG names should always be lowercase
toc: true  # (Table of Contents) The default value is on _config.yml
pin: false
math: false
mermaid: false
comments: false
image:
  path: /assets/img/others/how-to-setup-clang-tidy-clang-formatter.svg
  # lqip:
  alt: How to setup a linter and formatter with clang tools
---

In this article you will know how to use a linter in a C project, rather for a Linux or Windows environment:

  1. Install the linter and the formatter
     - **clang-tidy** is a clang-based C/C++ **linter** tool
     - **clang-format** is both a library and a stand-alone tool with the goal of automatically **reformatting** C/C++ sources files according to configurable style guides
  2. Learn how to use them
  3. Integrate them on a IDE (Visual Studio Code)

## Table of contents

- [Table of contents](#table-of-contents)
- [Installing utilities](#installing-utilities)
- [Learning how to use the utilities](#learning-how-to-use-the-utilities)
  - [clang-tidy: Start linting your code](#clang-tidy-start-linting-your-code)
    - [Create a config file to set checking rules](#create-a-config-file-to-set-checking-rules)
      - [*.clang-tidy* configuration file example](#clang-tidy-configuration-file-example)
    - [clang-tidy basic use](#clang-tidy-basic-use)
  - [How clang-format is use](#how-clang-format-is-use)
    - [Make a config file to set a coding style](#make-a-config-file-to-set-a-coding-style)
    - [clang-format basic use](#clang-format-basic-use)
- [How to integrate them in VS Code](#how-to-integrate-them-in-vs-code)
- [References](#references)
  - [Useful tools](#useful-tools)
  - [Useful extensions](#useful-extensions)
  - [Some implementations on real projects](#some-implementations-on-real-projects)

## Installing utilities

To install only `clang-format` and `clang-tidy` tools without having to install the entire *clang* compiler, do the following:

**On linux:**

```shell
sudo apt install clang-format clang-tidy
```

**On windows:**

Looking for how to get these two tools I have found these ways (more or less simple) to install them on windows:

- Go to [clang official repository](https://github.com/llvm/llvm-project/releases){:target="_blank"} and install Windows binaries exe: `LLVM-<version>-win64.exe`. Once installed, in the route `/installation/path/LLVM/bin` you will have the 2 tools.
- **"Emulate" linux environment** on Windows (MinGW, Cygwin, WSL...) and install like a linux machine.
- On [cpp-linter](https://github.com/cpp-linter/clang-tools-pip){:target="_blank"} github repository make a python pip package to install only `clang-format` and `clang-tidy`, among other clang compiler's tools. You **need** to have **correct version of python installed** on your PC. Use `pip install clang-tools` to install it.

> In my case I have used the first installation option, so from now on the way you call the tools will only be validated for that option
{: .prompt-info }

## Learning how to use the utilities

### clang-tidy: Start linting your code

#### Create a config file to set checking rules

First, to use `clang-tidy` you need to implement all the [checks](https://clang.llvm.org/extra/clang-tidy/checks/list.html){:target="_blank"} that you want the utility to review.

The checks can be listed in two ways:

- Creating a configuration file named `.clang-tidy` in your project’s directory
- `--checks=<string>` comma-separated list of globs. Whose value is added to the value of the *Checks* option of the `.clang-tidy` file, if it exists.

##### *.clang-tidy* configuration file example

```shell
Checks: 'clang-diagnostic-*,
        clang-analyzer-*,
        cppcoreguidelines-*,
        modernize-*,
        -modernize-use-trailing-return-type'
        # clang-analyzer-     --> Clang Static Analyzer checks.
        # cppcoreguidelines-  --> Checks related to C++ Core Guidelines.
        # modernize-          --> Checks that advocate usage of modern (currently “modern” means “C++11”) language constructs.
WarningsAsErrors: true
HeaderFilterRegex: ''
AnalyzeTemporaryDtors: false
FormatStyle: 'file' # Uses .clang-format file in the closest parent directory
CheckOptions:
  - key:    cert-dcl16-c.NewSuffixes
    value:  'L;LL;LU;LLU'
  - key:    cert-oop54-cpp.WarnOnlyIfThisHasSuspiciousField
    value:  '0'
  - key:    cppcoreguidelines-explicit-virtual-functions.IgnoreDestructors
    value:  '1'
  - key:    cppcoreguidelines-non-private-member-variables-in-classes.IgnoreClassesWithAllMemberVariablesBeingPublic
    value:  '1'
  - key:    google-readability-braces-around-statements.ShortStatementLines
    value:  '1'
  - key:    google-readability-function-size.StatementThreshold
    value:  '800'
  - key:    google-readability-namespace-comments.ShortNamespaceLines
    value:  '10'
  - key:    google-readability-namespace-comments.SpacesBeforeComments
    value:  '2'
  - key:    modernize-loop-convert.MaxCopySize
    value:  '16'
  - key:    modernize-loop-convert.MinConfidence
    value:  reasonable
  - key:    modernize-loop-convert.NamingStyle
    value:  CamelCase
  - key:    modernize-pass-by-value.IncludeStyle
    value:  llvm
  - key:    modernize-replace-auto-ptr.IncludeStyle
    value:  llvm
  - key:    modernize-use-nullptr.NullMacros
    value:  'NULL'
```

#### clang-tidy basic use

As an example, the following code (with namefile "test.c") is used:

```c
#include <stdio.h>

int main(int argc, char const *argv[])
{
  unsigned int var = 10;
  printf("The default value of \"var\" is: %i\n", var);
  return 0;
}
```

With this `.clang-tidy` file, that will apply all the possible check on the given file(s):

```shell
Checks: '*'
WarningsAsErrors: ''
AnalyzeTemporaryDtors: false
FormatStyle: 'file'
```

Although the code compiles and works, it has several good practice errors. And using the following command:

```shell
clang-tidy test.c --
           └─┬──┘ ├┘
             │    └─────╴> To avoid "Error while trying to load a compilation database"
             └────╴> File to make the checks of ".clang-tidy" file
```

> On [How To Setup Tooling For LLVM](https://clang.llvm.org/docs/HowToSetupToolingForLLVM.html){:target="_blank"} you can learn how to configure a compilation database
{: .prompt-tip }

Its output will show you the correct way to code:

```shell
1374 warnings generated.
/file/absolute/path/test.c:1:1: warning: system include stdio.h not allowed [llvmlibc-restrict-system-libc-headers]
#include <stdio.h>
^~~~~~~~~~~~~~~~~~
/file/absolute/path/test.c:3:14: warning: parameter 'argc' is unused [misc-unused-parameters]
int     main(int argc, char const *argv[])
                 ^
/file/absolute/path/test.c:3:32: warning: parameter 'argv' is unused [misc-unused-parameters]
int     main(int argc, char const *argv[])
                                   ^
/file/absolute/path/test.c:5:21: warning: 10 is a magic number; consider replacing it with a named constant [cppcoreguidelines-avoid-magic-numbers,readability-magic-numbers]
        unsigned int var = 10;
                           ^
Suppressed 1369 warnings (1369 in non-user code).
Use -header-filter=.* to display errors from all non-system headers. Use -system-headers to display errors from system headers as well.
```

As an example, focusing on the *magic number* warning `cppcoreguidelines-avoid-magic-numbers,readability-magic-numbers`, the proper way to fix it is creating a constant variable (or a `#define`...) with a descriptive name and then give the value. Like this:

```c
#include <stdio.h>

const int DEFAULT_INITIAL_VALUE = 10;

int main(int argc, char const *argv[])
{
  unsigned int var = DEFAULT_INITIAL_VALUE;
  printf("The default value of \"var\" is: %i\n", var);
  return 0;
}
```

But if you know what are you doing you **can ignore** that **error** in the `.clang-tidy` file adding this:

```shell
Checks: '*'
WarningsAsErrors: ''
AnalyzeTemporaryDtors: false
CheckOptions:
    - key: 'cppcoreguidelines-avoid-magic-numbers.IgnoredIntegerValues'
      value: '10'
    - key: 'readability-magic-numbers.IgnoredIntegerValues'
      value: '10'
FormatStyle: 'file'
```

### How clang-format is use

#### Make a config file to set a coding style

First, to use `clang-format` you need to [stablish a coding style](https://clang.llvm.org/docs/ClangFormatStyleOptions.html){:target="_blank"}. You can use one of the predefined styles (GNU, Google, Chromium...) or a custom one.

> To make easier a custom style or to preview any style, you can use one of these tools:
>
>- [clang-format-configurator](https://zed0.co.uk/clang-format-configurator/){:target="_blank"} based on web
>- [clang-format-editor](https://clangpowertools.com/clang-format-editor.html){:target="_blank"} the oficial application (only for windows)
{: .prompt-info }

The style can be added in two ways:

- With `--style=llvm`(for predefined options) and/or `--style="{key: value, ...}"` (for custom options)
- Creating a style configuration file named `.clang-format` in your project’s directory and using `--style=file`

<table>
<thead>
  <tr>
    <th>Shell command</th>
    <th><code lang="text">.clang-format</code> file</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td><code lang="text">clang-format --style="{BasedOnStyle: Chromium, IndentWidth: 4, ColumnLimit: 120, AccessModifierOffset: -2}" file_path</code></td>
    <td><pre lang="text">---
BasedOnStyle: Chromium
IndentWidth: 4
ColumnLimit: 120
AccessModifierOffset: -2</pre></td>
  </tr>
</tbody>
</table>

#### clang-format basic use

As an example, the following code (with namefile "test.c") is used:

```c
#include <stdio.h>

int main(int argc, char const *argv[])
{
  unsigned int var = 10;
  printf("The default value of \"var\" is: %i\n", var);
  return
  0;
}
```

Although it compiles and works, it has several formatting bugs if you rely on the GNU standard. And using `clang-format --style=gnu test.c`, its output will show you the correct way to format the code:

```shell
root@62b80bb26435:/# clang-format --style=gnu test.c
#include <stdio.h>

int
main (int argc, char const *argv[])
{
  unsigned int var = 10;
  printf ("The default value of \"var\" is: %i\n", var);
  return 0;
}
```

Other way to see which parts of the code need to be formatted you can add `-dry-run` (or `-n`) option:

```shell
root@62b80bb26435:/# clang-format -n --style=gnu test.c
test.c:3:4: warning: code should be clang-formatted [-Wclang-format-violations]
int     main(int argc, char const *argv[])
   ^^^^^
test.c:3:9: warning: code should be clang-formatted [-Wclang-format-violations]
int     main(int argc, char const *argv[])
            ^
test.c:4:2: warning: code should be clang-formatted [-Wclang-format-violations]
{
 ^
test.c:5:25: warning: code should be clang-formatted [-Wclang-format-violations]
                unsigned int var = 10;
                                      ^
test.c:6:8: warning: code should be clang-formatted [-Wclang-format-violations]
        printf("The default value of \"var\" is: %i\n", var);
              ^
test.c:6:55: warning: code should be clang-formatted [-Wclang-format-violations]
        printf("The default value of \"var\" is: %i\n", var);
                                                             ^
test.c:7:8: warning: code should be clang-formatted [-Wclang-format-violations]
        return
              ^
test.c:9:2: warning: code should be clang-formatted [-Wclang-format-violations]
}
```

This commands only shows you, in console, the correct way to format the code, but does not modify it. **To automatically format** the code you need to add the `-i` **option**:

```shell
root@62b80bb26435:/# clang-format -i --style=gnu test.c
```

## How to integrate them in VS Code

Apart of `clang-format` and `clang-tidy` programs, you only need the [C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools){:target="_blank"} extension.

These are the setting that you need to know to setup both utilities:

- For `clang-format` you have "C_Cpp -> formatting" subsettings
- For`clang-tidy` you have "C_Cpp -> Code Analysis" subsettings

As setting.json:

```json
"C_Cpp.clang_format_style": "file"
"C_Cpp.clang_format_fallbackStyle": "Visual Studio"
"C_Cpp.clang_format_path": "/absolute/path/clang-format-14"

"C_Cpp.codeAnalysis.clangTidy.enabled": true
"C_Cpp.codeAnalysis.clangTidy.config": ""
"C_Cpp.codeAnalysis.clangTidy.fallbackConfig": ""
"C_Cpp.codeAnalysis.clangTidy.path": "/absolute/path/clang-tidy-14.exe"
```

**On Linux** normally the configuration is very staghforward once the tools are installed **plug-and-play**, because VS Code search the tools on the **standard path**. But **on windows** as you installed them as show on [Installing utilities](#installing-utilities) part, and you need to **set the path of tools on extension settings**.

## References

- <https://clang.llvm.org/docs/ClangTools.html>{:target="_blank"}
- <https://www.clangpowertools.com/blog/getting-started-with-clang-format-style-options.html>{:target="_blank"}
- <https://developers.redhat.com/blog/2021/04/06/get-started-with-clang-tidy-in-red-hat-enterprise-linux#using_clang_tidy_in_red_hat_enterprise_linux>{:target="_blank"}
- <https://github.com/cpp-linter>{:target="_blank"}
- <https://www.labri.fr/perso/fleury/posts/programming/using-clang-tidy-and-clang-format.html>{:target="_blank"}

### Useful tools

- Windows application to create `.clang-format` file -> <https://clangpowertools.com/>{:target="_blank"}
- Web based application to create `.clang-format` file -> <https://zed0.co.uk/clang-format-configurator/>{:target="_blank"}
- Utility to implement CI formatter -> <https://github.com/Sarcasm/run-clang-format>{:target="_blank"}

### Useful extensions

**Visual Studio Code:**

- <https://www.youtube.com/watch?v=8RSxQ8sluG0>{:target="_blank"}
- <https://devblogs.microsoft.com/cppblog/visual-studio-code-c-december-2021-update-clang-tidy/>{:target="_blank"}

### Some implementations on real projects

- [LLVM project](https://github.com/llvm/llvm-project){:target="_blank"} the maintainer of `clang-format` and `clang-tidy`.
- [Flight Software & Embedded Systems Framework](https://github.com/nasa/fprime){:target="_blank"} by NASA
- [GTKWave](https://github.com/gtkwave/gtkwave){:target="_blank"} a fully featured GTK+ based wave viewer
