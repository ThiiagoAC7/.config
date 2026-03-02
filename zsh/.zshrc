# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH="$PATH:/opt/nvim/" 
export PATH="$PATH:/usr/local/go/bin"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH=$PATH:/home/thiago/.spicetify

export PATH=$PATH:~/zig/

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

## JUST
alias jg='just -g'

# fastfetch

eval "$(starship init zsh)"


### android studio

export PATH="$PATH:/home/thiago/android-studio-2024.3.1.13-linux/android-studio/bin"
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

alias studio="nohup /home/thiago/android-studio-2024.3.1.13-linux/android-studio/bin/studio.sh > /dev/null 2>&1 &"


# Load custom functions from .dotfiles/zsh/functions
for file in $HOME/.dotfiles/zsh/functions/*.zsh; do
  [ -f "$file" ] && source "$file"
done

starship_precmd_user_func="set_win_title"


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export PATH="/home/thiago/.pixi/bin:$PATH"

# opencode
export PATH=/home/thiago/.opencode/bin:$PATH
