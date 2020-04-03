---
layout: post
title:  "GIT pre-commit hook "
date:   2018-10-01 20:47
categories: PHP
tags: php git hook phpcs
---

Prevents to commit code not accordingly to the coding standard.

Step by step:
1. using [PHP code sniffer](https://github.com/squizlabs/PHP_CodeSniffer)
2. own `ruleset.xml` in the root of the project
3. Create file `.git/hooks/pre-commit`
4. `chmod +x .git/hooks/pre-commit`
5. copy and paste into `.git/hooks/pre-commit` below content

```bash
#!/bin/bash
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep ".php")
CMD="$(pwd)/vendor/bin/phpcs"
PARAMS="--standard=./ruleset.xml --extensions=php"

if [[ "$STAGED_FILES" = "" ]]; then
  exit 0
fi

PASS=true

printf "\nValidating PHP:\n"

# Check for eslint
if [[ ! -x "$CMD" ]]; then
  printf "\t\033[41mPlease install PHP_CodeSniffer\033[0m (composer global require "squizlabs/php_codesniffer=*") & ruleset.xml"
  exit 1
fi

for FILE in ${STAGED_FILES}
do
  ${CMD} ${PARAMS} ${FILE}

  if [[ "$?" == 0 ]]; then
    printf "\t\033[32mPHP_CodeSniffer Passed: ${FILE}\033[0m\n"
  else
    printf "\t\033[41mPHP_CodeSniffer Failed: ${FILE}\033[0m\n"
    PASS=false
  fi
done

printf "\nPHP validation completed!\n"

if ! $PASS; then
  printf "\033[41mCOMMIT FAILED:\033[0m Your commit contains files that should pass PHP_CodeSniffer but do not. Please fix the PHP_CodeSniffer errors and try again.\n"
  exit 1
else
  printf "\033[42mCOMMIT SUCCEEDED\033[0m\n"
fi

exit $?

```

