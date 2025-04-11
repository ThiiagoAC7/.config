# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH="$PATH:/opt/nvim/" 
export PATH="$PATH:/usr/local/go/bin"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH=$PATH:/home/thiago/.spicetify

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"


# sudo permission to nvim 
export SUDO_EDITOR="nvim"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git 
         z 
         zsh-autosuggestions 
         zsh-syntax-highlighting
         command-not-found
         )

bindkey '^y' autosuggest-accept

source $ZSH/oh-my-zsh.sh

# personal
alias v="nvim"
alias vim="nvim"
alias exp="open"
alias py="python"

## exa
alias l='exa --long --tree'
alias la='exa -a'
alias ll='exa -lah'
alias ls='exa -l --color=auto'

## fzf
alias f='fzf'

fastfetch

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/thiago/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/thiago/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/thiago/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/thiago/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

conda config --set changeps1 False #(disable conda prompt - using it with starship)
eval "$(starship init zsh)"

function set_win_title() { # set window title as cwd
    echo -ne "\033]0; $(basename "$PWD") \007"
}

## cleans mem cache
memclean() {
  if sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"; then
    echo "Memory cache successfully cleaned."
  else
    echo "Failed to clean memory cache. Check permissions."
  fi
}

starship_precmd_user_func="set_win_title"

