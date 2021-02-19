# Lines configured by zsh-newuser-install
setopt autocd beep extendedglob notify 
unsetopt nomatch
bindkey -e # Emacs keybindings 

# Command history configuration
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt sharehistory

# Completion System -- The following lines were added by compinstall
zstyle :compinstall filename '/Users/davidmurphy/.zshrc'
autoload -Uz compinit
compinit

#match middle of word
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
zstyle ':completion:*' menu select.

# Load version control information
autoload -Uz vcs_info
precmd() { 
	vcs_info;
	print -Pn "\e]0;%1~\a";
}

autoload -U colors && colors
# Format the vcs_info_msg_0_ variable

# Lines for vcs_info prompt configuration
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats ": %{$fg[magenta]%}%b%{$reset_color%} %m%{$fg[green]%}%c%{$reset_color%}%{$fg[red]%}%u%{$reset_color%}"
zstyle ':vcs_info:git:*' actionformats ": %{$fg[magenta]%}(%a|%m)%{$reset_color%} %{$fg[green]%}%c%{$reset_color%}%{$fg[red]%}%u%{$reset_color%}"
zstyle ':vcs_info:git:*' patch-format '%10>…>%p%<< (%n applied)'

# Add up/down arrows after branch name, if there are changes to pull/to push
zstyle ':vcs_info:git+post-backend:*' hooks git-post-backend-updown
+vi-git-post-backend-updown() {
  git rev-parse @{upstream} >/dev/null 2>&1 || return
  local -a x; x=( $(git rev-list --left-right --count HEAD...@{upstream} ) )
  hook_com[branch]+="%f" # end coloring
  (( x[1] )) && hook_com[branch]+=" ⇡"
  (( x[2] )) && hook_com[branch]+=" ⇣"
  return 0
}

### Display the existence of files not yet known to VCS
### git: Show marker (T) if there are untracked files in repository
# Make sure you have added staged to your 'formats':  %c
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        # This will show the marker if there are any untracked files in repo.
        # If instead you want to show the marker only if there are untracked
        # files in $PWD, use:
        #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
        hook_com[unstaged]+='T'
    fi
}


# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
PS1=' %{$fg[blue]%}%1~%{$reset_color%} ${vcs_info_msg_0_} > '


#iTerm integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

#### Docker
 fpath=(~/.zsh/completion $fpath)
 autoload -Uz compinit && compinit -i
