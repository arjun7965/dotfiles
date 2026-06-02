#!/usr/bin/env bash
# Pure-bash powerline-style prompt with git branch + ahead/behind + dirty state.
# Vendored from https://github.com/riobard/bash-powerline (no Python/daemon).
#
# Segments shown on the right of the cwd:
#   ⑂<branch>   current branch (or tag/short-hash on a detached HEAD)
#   *           working tree has uncommitted changes
#   ↑N          local is N commits AHEAD of its upstream (you need to push)
#   ↓N          upstream is N commits AHEAD (origin ahead; you need to pull)
#
# Override any COLOR_* / SYMBOL_* / PS_SYMBOL before sourcing this file to
# customize. Set POWERLINE_GIT=0 to disable git info entirely.

## Uncomment to disable git info
#POWERLINE_GIT=0

__powerline() {
    # Colors
    COLOR_RESET='\[\033[m\]'
    COLOR_CWD=${COLOR_CWD:-'\[\033[0;34m\]'} # blue
    COLOR_GIT=${COLOR_GIT:-'\[\033[0;36m\]'} # cyan
    COLOR_SUCCESS=${COLOR_SUCCESS:-'\[\033[0;32m\]'} # green
    COLOR_FAILURE=${COLOR_FAILURE:-'\[\033[0;31m\]'} # red

    # Symbols
    SYMBOL_GIT_BRANCH=${SYMBOL_GIT_BRANCH:-⑂}
    SYMBOL_GIT_MODIFIED=${SYMBOL_GIT_MODIFIED:-*}
    SYMBOL_GIT_PUSH=${SYMBOL_GIT_PUSH:-↑}
    SYMBOL_GIT_PULL=${SYMBOL_GIT_PULL:-↓}

    if [[ -z "$PS_SYMBOL" ]]; then
      case "$(uname)" in
          Darwin)   PS_SYMBOL='';;
          Linux)    PS_SYMBOL='$';;
          *)        PS_SYMBOL='%';;
      esac
    fi

    __git_info() {
        [[ $POWERLINE_GIT = 0 ]] && return
        hash git 2>/dev/null || return
        local git_eng="env LANG=C git"

        local ref=$($git_eng symbolic-ref --short HEAD 2>/dev/null)

        if [[ -n "$ref" ]]; then
            ref=$SYMBOL_GIT_BRANCH$ref
        else
            ref=$($git_eng describe --tags --always 2>/dev/null)
        fi

        [[ -n "$ref" ]] || return

        local marks

        while IFS= read -r line; do
            # branch line: ## main...origin/main [ahead 1, behind 2]
            if [[ $line =~ ^## ]]; then
                [[ $line =~ ahead\ ([0-9]+) ]] && marks+=" $SYMBOL_GIT_PUSH${BASH_REMATCH[1]}"
                [[ $line =~ behind\ ([0-9]+) ]] && marks+=" $SYMBOL_GIT_PULL${BASH_REMATCH[1]}"
            else
                # there is at least one modified/untracked file
                marks="$SYMBOL_GIT_MODIFIED$marks"
                break
            fi
        done < <($git_eng status --porcelain --branch 2>/dev/null)

        printf " $ref$marks"
    }

    ps1() {
        # capture exit code first; it must be the very first thing in ps1()
        if [ $? -eq 0 ]; then
            local symbol="$COLOR_SUCCESS $PS_SYMBOL $COLOR_RESET"
        else
            local symbol="$COLOR_FAILURE $PS_SYMBOL $COLOR_RESET"
        fi

        local cwd="$COLOR_CWD\w$COLOR_RESET"

        # Bash by default expands the prompt string with promptvars on, so we
        # can use \${...} to defer git lookup; otherwise inline it.
        if shopt -q promptvars; then
            __powerline_git_info="$(__git_info)"
            local git="$COLOR_GIT\${__powerline_git_info}$COLOR_RESET"
        else
            local git="$COLOR_GIT$(__git_info)$COLOR_RESET"
        fi

        PS1="$cwd$git$symbol"
    }

    PROMPT_COMMAND="ps1${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
}

__powerline
unset __powerline
