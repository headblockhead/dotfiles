# vim:ft=zsh ts=2 sw=2 sts=2

# A modified agnoster made to fit a pink/purple system theme.
# Produced by github.com/headblockhead

# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://github.com/Lokaltog/powerline-fonts).
# Make sure you have a recent version: the code points that Powerline
# uses changed in 2012, and older versions will display incorrectly,
# in confusing ways.

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'
DEFAULT_USER='headb'

case ${SOLARIZED_THEME:-dark} in
    *)     CURRENT_FG='black';;
esac

# Special Powerline characters

() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  # NOTE: This segment separator character is correct.  In 2012, Powerline changed
  # the code points they use for their special characters. This is the new code point.
  # If this is not working for you, you probably have an old version of the
  # Powerline-patched fonts installed. Download and install the new version.
  # Do not submit PRs to change this unless you have reviewed the Powerline code point
  # history and have new information.
  # This is defined using a Unicode escape sequence so it is unambiguously readable, regardless of
  # what font the user is viewing this source code in. Do not replace the
  # escape sequence with a single literal character.
  # Do not change this! Do not make it '\u2b80'; that is the old, wrong code point.
  
  # https://github.com/ryanoasis/powerline-extra-symbols#glyphs
  
  SEGMENT_SEPARATOR=$'\ue0b0' # Regular powerline
  #SEGMENT_SEPARATOR=$'\ue0d1' # LEGO POWER
  #SEGMENT_SEPARATOR=$'\ue0b4' # Curves
  #SEGMENT_SEPARATOR=$'\ue0cc' # hexagons
  #SEGMENT_SEPARATOR=$'\ue0c0' # fire
  #SEGMENT_SEPARATOR=$'\ue0c4' # small pixel blend
  #SEGMENT_SEPARATOR=$'\ue0c6' # large pixel blend
  #SEGMENT_SEPARATOR=$'\ue0d2' # angles
  #SEGMENT_SEPARATOR=$'\ue0c8' # spikes
  #SEGMENT_SEPARATOR=$'\ue0b8' # -45deg 
  #SEGMENT_SEPARATOR=$'\ue0bc' # 45deg 
}

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Time: Show the current time.
prompt_time() {
  prompt_segment 93 255 '%*'
}

# Status:
# - was there an error (red X + err number)
# - am I root (lighhtningbolt)
# - are there background jobs? (cog)
prompt_status() {
  local symbols
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{grey}%}✘ %? "
  [[ $UID -eq 0 ]] && symbols+="%{%F{grey}%} "
  [[  -n "$symbols" ]] && prompt_segment 196 255 "$symbols"
}

# Context: user@hostname (who am I and where am I)
prompt_context() {
  if [[ "$USERNAME" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment 92 255 "%(!.%{%F{bright-white}%}.)%n@%m"
  fi
}

# nix-shell: if currently running nix-shell
prompt_nix_shell() {
  NIXSHELL=$(echo $PATH | tr ':' '\n' | grep '/nix/store' | sed 's#^/nix/store/[a-z0-9]\+-##' | sed 's#-[^-]\+$##' | xargs -n2 -d'\n')
  if [ "$NIXSHELL"  ]; then # Detectes flakes.
    prompt_segment 164 255 "nix-shell"
  fi
}

# Commands: a count of commands executed.
prompt_commands() {
  prompt_segment 129 255 '%!'
}

# Dir: current working directory
prompt_dir() {
  prompt_segment 165 255 '%~'
}

# Git: branch/detached head, dirty status
prompt_git() {
  (( $+commands[git] )) || return
  if [[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
    return
  fi
  local PL_BRANCH_CHAR
  () {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    PL_BRANCH_CHAR=$'\ue0a0'         # 
  }
  local ref dirty mode repo_path

   if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]]; then
    repo_path=$(git rev-parse --git-dir 2>/dev/null)
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment 209 255
    else
      prompt_segment 31 255
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:*' unstagedstr '±'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info
    echo -n "${${ref:gs/%/%%}/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}"
  fi
}

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_time
  prompt_status
  prompt_context
#  prompt_commands
  prompt_nix_shell
  prompt_dir
  prompt_git
  prompt_end
}

PROMPT='%{%f%b%k%}$(build_prompt) '
