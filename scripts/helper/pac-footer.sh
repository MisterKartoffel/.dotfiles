#!/usr/bin/env bash
# This script is a GNU sed-less way to parse the following example list:
# 
# pkg1 [installed] pkg2 [installed] pkg3 pkg4 pkg5 [installed]
#
# Into:
#
# pkg1 [installed]
# pkg2 [installed]
# pkg3
# pkg4
# pkg5 [installed]

# This is here because otherwise fzf hangs, don't ask
exec < /dev/null

LIST=${1}

# Regex:
# Captures a group wrapped in single quotes composed of
# - String composed of 1 or more non-space characters (package name)
# - Optional space followed by "[installed]" string
# With another optional space at the end (actual separator between entries)
while [[ ${LIST} =~ \'([^[:space:]]+( \[installed\])?)\'[[:space:]]? ]]; do
    echo "${BASH_REMATCH[1]}"
    LIST=${LIST#*"${BASH_REMATCH[0]}"}
done
