# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export DRACULA_THEME=$HOME/dracula

# Set name of the theme to load.
# Cursor / VS Code: Spaceship + zsh-autosuggestions broke ZLE redraw after `cd`. Keep robbyrussell here;
# autosuggestions are OK with that theme if we avoid rebinding widgets every precmd (see below).
if [[ "$TERM_PROGRAM" == "vscode" || "$TERM_PROGRAM" == "cursor" || -n "${VSCODE_SHELL_INTEGRATION:-}" ]]; then
  ZSH_THEME="robbyrussell"
else
  ZSH_THEME="spaceship"
  # Never let the prompt block on a daemon: spaceship's docker/kubectl sections
  # shell out (docker version / kubectl version) and hang every new tab when
  # the daemon is wedged. Version segments are cosmetic — keep them off.
  SPACESHIP_DOCKER_SHOW=false
  SPACESHIP_KUBECTL_VERSION_SHOW=false
fi

# if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
# else
#    export TERM='xterm-color'
# fi

# --- Claude Code: undo macOS Gatekeeper quarantine ("Apple cannot verify...") ---
# Apple's XProtect occasionally quarantines or deletes the (signed but un-notarized)
# claude binary. Run `fix-claude` to reinstall if missing and strip the quarantine flag.
fix-claude() {
  local bin
  bin="$(readlink -f "$(command -v claude)" 2>/dev/null)"
  if [[ -z "$bin" || ! -f "$bin" ]]; then
    echo "claude binary missing — reinstalling via Homebrew..."
    brew reinstall --cask --force claude-code || return 1
    bin="$(readlink -f "$(command -v claude)" 2>/dev/null)"
  fi
  xattr -d com.apple.quarantine "$bin" 2>/dev/null
  hash -r
  echo "Fixed: $(claude --version 2>&1)"
}

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git autojump npm composer zsh-autosuggestions)

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:$HOME/.composer/vendor/bin"

if [[ "$TERM_PROGRAM" == "vscode" || "$TERM_PROGRAM" == "cursor" || -n "${VSCODE_SHELL_INTEGRATION:-}" ]]; then
  export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
fi

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
export ZSH_CUSTOM
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias c="cd ~/Code"
alias localsites='cd "$HOME/Local Sites"'
# alias python="/usr/bin/python3"  # commented so virtualenv activation sets python correctly
# Safe aliases for system Python (do not override python; venv will control that):
alias py='/usr/bin/python3'
alias pysys='/usr/bin/python3'
alias py39='/usr/bin/python3'
# Homebrew Python (if installed)
if [[ -x /opt/homebrew/bin/python3.11 ]]; then alias pybrew='/opt/homebrew/bin/python3.11'
elif [[ -x /opt/homebrew/bin/python3 ]]; then alias pybrew='/opt/homebrew/bin/python3'
fi
# pip follows active interpreter
alias pip='python -m pip'
alias pip3='python -m pip'
# Create .venv in current dir and show activate instructions
venv() { python3 -m venv .venv && echo "Created .venv. Activate with: source .venv/bin/activate"; }

export PATH="/usr/local/sbin:$PATH"

# Add Visual Studio Code (code)
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
# prompt spaceship

# Delete git tag locally & remotely
#
# Example dt 2.0.0
function dt() {
  git tag --delete $1
  git push origin :$1
  echo "$1 was deleted locally and remotely."
}

# option + left/right for cursor to skip words
bindkey "[D" backward-word
bindkey "[C" forward-word
fpath=($fpath "/Users/tiki/.zfunctions")

export PATH="/opt/homebrew/opt/php@7.4/bin:$PATH"
export PATH="/opt/homebrew/opt/php@7.4/sbin:$PATH"

export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

# Use Homebrew's Ruby install
# export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
# export PATH="$HOME/.rbenv/bin:$PATH"
# eval "$(rbenv init - zsh)"
alias rom='cd ~/rubyonmac && /usr/bin/env bash ~/rubyonmac/rom-ultimate 2>&1 | tee ~/rom-ultimate.log'

alias romup='cd ~/Downloads/rubyonmac-ultimate && /usr/bin/env bash ~/Downloads/rubyonmac-ultimate/update'

source /opt/homebrew/opt/chruby/share/chruby/chruby.sh

source /opt/homebrew/opt/chruby/share/chruby/auto.sh

chruby ruby-3.1.2

chruby ruby-2.7.6

eval "$(nodenv init -)"

nodenv global 18.13.0

# Requires: nvm and plop installed globally
alias gplop="ts-node --script-mode \"/Users/$USER/.nvm/versions/node/$(node -v)/bin/plop\" --plopfile ~/Code/plopfiles/plopfile.ts"


# pnpm
export PNPM_HOME="/Users/tiki/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH="/Users/tiki/bin:/Users/tiki/.local/bin:$PATH"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Java (OpenJDK 17 via Homebrew)
export JAVA_HOME="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"

# Android SDK (Android Studio)
export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

# Cursor / VS Code integrated terminal fixes (TERM_PROGRAM=vscode, VSCODE_SHELL_INTEGRATION=1):
# 1) Safer `j` — no colored echo -e (harmless if shell integration still glitches).
# 2) Sync autojump DB update on cd — upstream uses `autojump --add ... &!` in chpwd; background
#   jobs here often leave the prompt line broken until Ctrl+C. `ls` never triggers chpwd; `j` does.
if [[ "$TERM_PROGRAM" == "vscode" || "$TERM_PROGRAM" == "cursor" || -n "${VSCODE_SHELL_INTEGRATION:-}" ]]; then
  j() {
    if [[ ${1} == -* ]] && [[ ${1} != "--" ]]; then
      autojump "${@}"
      return
    fi
    setopt localoptions noautonamedirs
    local output="$(autojump "${@}")"
    if [[ -d "${output}" ]]; then
      print -r -- "${output}"
      builtin cd "${output}"
    else
      echo "autojump: directory '${@}' not found"
      echo "\n${output}\n"
      echo "Try \`autojump --help\` for more information."
      false
    fi
  }

  if (( ${+functions[autojump_chpwd]} )); then
    chpwd_functions=( "${(@)chpwd_functions:#autojump_chpwd}" )
  fi
  _autojump_chpwd_sync_vscode() {
    command autojump --add "$(pwd)" >/dev/null 2>&1
  }
  chpwd_functions+=(_autojump_chpwd_sync_vscode)
fi
# pm — unified Product Mommy launcher.
#
# Opens a fresh claude conversation in ~/Code with the chosen personality. Each
# invocation gets a new session UUID; closing the terminal ends it. The session
# JSONL lands in ~/.claude/projects/-Users-tiki-Code/ like any claude session
# but nothing registers it in .product-mommy/agents.json so the launcher UI
# never sees it.
#
# Keyed off the claude session UUID (CLAUDE_CODE_SESSION_ID, also delivered
# to hooks on stdin as session_id), so two `pm` windows running simultaneously
# never see each other's completion notifications.
#
# Usage:
#   pm                            # base product-mommy identity
#   pm urm-mommy                  # clones the urm-mommy personality
#   pm product-mommy-chase        # clones the chase personality
#   pm --list                     # show available personalities
#   pm --resume <id>              # resume an existing named session
#   pm <flavor> -p "..."          # extra args forward to claude
pm() {
  local PM_DIR="$HOME/Code/tarik-ai/.product-mommy"
  if [[ "$1" == "--list" ]]; then
    echo "Available pm personalities:"
    echo "  product-mommy (default — base instructions)"
    if [[ -d "$PM_DIR/personalities/.compiled" ]]; then
      for f in "$PM_DIR/personalities/.compiled"/*.md; do
        [[ -f "$f" ]] || continue
        local id="$(basename "$f" .md)"
        # Skip orphans — only list compiled files whose source still exists.
        [[ -f "$PM_DIR/personalities/${id}.md" ]] && echo "  $id"
      done
    fi
    echo ""
    echo "Modifier flags (combine with any personality):"
    echo "  --orchestrator / -o   routing-first PM that delegates by default"
    return 0
  fi
  if [[ "$1" == "--resume" ]]; then
    shift
    local resume_id="${1:-}"
    if [[ -z "$resume_id" ]]; then
      echo "pm --resume requires a session id" >&2
      return 1
    fi
    shift
    cd ~/Code && claude --resume "$resume_id" "$@"
    return
  fi
  # Strip --orchestrator / -o from the front, if present.
  local orchestrator=0
  local PM_FAST=""
  if [[ "$1" == "--fast" || "$1" == "-f" ]]; then PM_FAST=1; shift; fi
  if [[ "$1" == "--orchestrator" || "$1" == "-o" ]]; then
    orchestrator=1
    shift
  fi
  local flavor="${1:-product-mommy}"
  local instructions_path
  if [[ "$flavor" == "product-mommy" ]]; then
    instructions_path="$PM_DIR/instructions.md"
  else
    instructions_path="$PM_DIR/personalities/.compiled/${flavor}.md"
    shift
  fi
  # Also accept --orchestrator AFTER the flavor for natural typing.
  if [[ "$1" == "--orchestrator" || "$1" == "-o" ]]; then
    orchestrator=1
    shift
  fi
  if [[ "$1" == "--fast" || "$1" == "-f" ]]; then PM_FAST=1; shift; fi
  if [[ ! -f "$instructions_path" ]]; then
    echo "pm: no personality '$flavor' at $instructions_path" >&2
    echo "Run 'pm --list' to see available personalities." >&2
    return 1
  fi
  # Overlay: when --orchestrator is set, concat the orchestrator addendum
  # onto the base personality into a temp file and use that as the system
  # prompt. The original personality files are not modified.
  if [[ $orchestrator -eq 1 ]]; then
    local overlay_path="$PM_DIR/personalities/orchestrator.md"
    if [[ -f "$overlay_path" ]]; then
      local tmp_file
      tmp_file="$(mktemp -t pm-orchestrator.XXXXXXXX).md"
      cat "$instructions_path" > "$tmp_file"
      printf '\n\n---\n\n' >> "$tmp_file"
      cat "$overlay_path" >> "$tmp_file"
      instructions_path="$tmp_file"
      flavor="${flavor}-orchestrator"
    else
      echo "pm: warning: orchestrator overlay not found at $overlay_path" >&2
    fi
  fi
  local -a fast_flags
  if [[ -n "${PM_FAST:-}" ]]; then
    fast_flags=(--setting-sources project,local \
                --settings "$HOME/Code/tarik-ai/.product-mommy/lab/settings-nohooks.json")
  fi
  cd ~/Code && claude --name "$flavor" --append-system-prompt-file "$instructions_path" ${fast_flags[@]} "$@"
}

# Back-compat alias so muscle memory keeps working during the pmtemp → pm
# transition. Forwards every arg to pm verbatim.
pmtemp() { pm "$@"; }

# iterm-open — open an iTerm profile by name in a new tab (or new window if
# iTerm has none open / isn't running). Profile name must match exactly what
# iTerm shows in its profile list (case + spacing matter).
#
# Usage:
#   iterm-open Photos
#   iterm-open "tarik-ai dev"
#   iterm-open --list                # show every profile iTerm knows about
iterm-open() {
  if [[ "$1" == "--list" ]]; then
    osascript -e 'tell application "iTerm" to return name of every profile' \
      | tr ',' '\n' | sed 's/^ *//'
    return 0
  fi
  if [[ -z "$1" ]]; then
    echo "iterm-open: needs a profile name (try --list)" >&2
    return 1
  fi
  local profile="$1"
  osascript <<APPLESCRIPT
tell application "iTerm"
  activate
  try
    tell current window
      create tab with profile "$profile"
    end tell
  on error
    create window with profile "$profile"
  end try
end tell
APPLESCRIPT
}

# --- Auto-launch tmux in iTerm (control mode) ---------------------------------
# One persistent session ("main") so work survives disconnects and is reachable
# remotely (SSH in, then `tmux attach -t main`). Guards:
#   $TMUX empty        -> don't recurse inside tmux's own panes
#   iTerm.app only     -> never hijack SSH/Termius/VS Code sessions (-CC needs iTerm)
#   $NO_TMUX empty     -> escape hatch: `NO_TMUX=1 zsh` for a plain shell
if [[ -z "$TMUX" && "$TERM_PROGRAM" == "iTerm.app" && -z "$NO_TMUX" ]]; then
  # Only become the -CC gateway when "main" has no attached client yet. A second
  # control-mode client for a session iTerm already mirrors never completes its
  # handshake, leaving the tab as a dead control channel (no prompt, keys echo).
  # Once main is attached, extra tabs are plain shells; `tmux attach` by hand.
  if ! /opt/homebrew/bin/tmux ls -F '#{session_name} #{session_attached}' 2>/dev/null | grep -q '^main [1-9]'; then
    exec /opt/homebrew/bin/tmux -CC new -A -s main
  fi
fi

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C
# <<< grok installer <<<

# Claude Code profiles (prompt-lab)
source ~/Code/tarik-ai/.product-mommy/lab/aliases.zsh
