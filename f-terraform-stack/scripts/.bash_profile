echo "LOADED .bash_profile "

# Prompt con git info
parse_git_branch() {
  git rev-parse --is-inside-work-tree &>/dev/null || return
  local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null)
  local status=$(git status --porcelain 2>/dev/null)
  local dirty=""
  [ -n "$status" ] && dirty="*"
  echo " (git:$branch$dirty)"
}


export ICONS_GIT_BRANCH='🌊 k-vscode 🦎'
PS1='\[\e[0;32m\]\u@\h \[\e[0;34m\]\w\[\e[0;31m\]$(parse_git_branch)\[\e[0m\]\n ${ICONS_GIT_BRANCH} $ '

alias who='clear && echo -e "\033[1;34m🌊 ${CONTAINER_NAME} – $(date +%H:%M:%S)\033[0m" && command who '


export ICONS_GIT_BRANCH='🦎 k01 🐸'
export CONTAINER_NAME='K-Magic'
export PS1='${CONTAINER_NAME} 🐳 \[\e[0;32m\]\u@\h \[\e[0;34m\]\w\[\e[0;31m\]$(parse_git_branch)\[\e[0m\]\n${ICONS_GIT_BRANCH} $ '
alias ll='ls -lah --color=auto'



#------------------# Aliases
run_echo() {
  echo "+ $@"
  "$@"
}

alias repos='cd ~/repos/labs-mvp  '
alias repos1='cd ~/repos/labs-mvp/PoC-01  '
alias repos2='cd ~/repos/labs-mvp/PoC-02  '


alias ll=' ls -lah --color=auto '
alias prof=' source  ~/.bash_profile '
alias prof-copy=' cp ~/repos/labs-mvp/.config/ec2_bastion/.bash_profile  ~/.bash_profile '

alias vimaws=' vim ~/.aws/credentials '



#-----------------#  Enhance Linux Commands
alias history-grep='history | grep --color=auto'
alias history-fzf='history | fzf '

__fzf_history_run() {
  local selected
  selected=$(history | sort -r | uniq | fzf --tac --reverse --height 40% --ansi --prompt="History > " | sed 's/^ *[0-9]\+ *//')
  if [ -n "$selected" ]; then
    READLINE_LINE="$selected"
    READLINE_POINT=${#READLINE_LINE}
  fi
}

delete_history_exact_command() {
  local exact="$1"
  local tmpfile=$(mktemp)
  local histfile="${HISTFILE:-$HOME/.bash_history}"

  # Backup history file
  cp "$histfile" "$histfile.bak"

  # Count before
  local count_before
  count_before=$(wc -l < "$histfile")

  # Filter lines matching exact command
  grep -vxF "$exact" "$histfile" > "$tmpfile"

  # Count after
  local count_after
  count_after=$(wc -l < "$tmpfile")

  echo "⚠️ Commands matching exactly '$exact' will be deleted."
  echo "📊 History count: before = $count_before, after = $count_after"
  echo -n "Proceed? (y/N): "
  read -r confirm
  if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    mv "$tmpfile" "$histfile"

    echo "do history -c  - history -r   to reload history" 
    echo "✅ Deleted commands matching exactly '$exact'."
  else
    echo "❌ Operation cancelled."
    rm "$tmpfile"
  fi
}



bind -x '"\C-r": "__fzf_history_run"'

#------------------# Environment Variables
export HISTIGNORE_BASH="ls:ll:pwd:exit:clear:history:cd"
export HISTIGNORE_GIT="git branch:git checkout:git pull:git push:git add:git commit:git merge:git rebase:git reset:git log"
export HISTIGNORE_PEI="prof:prof-copy:repos:repos-script:repos-3:repos-5:repos-10"
export HISTIGNORE="${HISTIGNORE_BASH}:${HISTIGNORE_GIT}:${HISTIGNORE_PEI}"

export HISTCONTROL=ignoreboth
export HISTSIZE=10000
export HISTFILESIZE=20000
export PROMPT_COMMAND="history -a; history -n"  # Write and reload history each prompt


#------------------# Functions
menu() {

   echo "alias  repos | ll | prof | who"
   echo "alias  kube-* "

   echo "welcome sandobx: "
   echo " ss -tuln | egrep ':8080|:8443|:3000|:9090'"
   sudo   ss -tuln | egrep ':8080|:8443|:3000|:9090'
   

}

tips() {
   echo "grep --exclude-dir=* node.nodeUrl * "
   echo "your_command | tee log.txt | file - "

   echo "du -sh .[!.]* * | sort -hr | head -20"
   echo "find . -type f -name '*.txt' | xargs grep 'search_term' | wc -l"
 
}

who
menu



#------------------# Notes for MAC
# Use uninstall script to remove fzf.
# With zsh, you even get:
# 	•	Tab completion with fuzzy matching.
# 	•	CTRL-R to browse history with search.
# 	•	CTRL-T to fuzzy-search files and insert them into the command line.
# 	•	ALT-C to jump between directories.  (not work on mac ...)
