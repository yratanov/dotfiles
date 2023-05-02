# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

eval "$(zoxide init zsh)"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/yuri/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git 
  rbenv
  nvm
  zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/opt/homebrew/opt/postgresql@12/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/postgresql@12/lib"
export PKG_CONFIG_PATH="/opt/homebrew/opt/postgresql@12/lib/pkgconfig"
export CPPFLAGS="-I/opt/homebrew/opt/postgresql@12/include"

# PATH=$(npm bin):$PATH

# export NODE_OPTIONS="--require /Users/yuri/node-15-for-ember-monkeypatching.js"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#878ede"

alias es="ember s --proxy=http://localhost:3000"
alias qa="ssh -i ~/.ssh/id_ed25519 pulse-rw@bastionqa.satchel.cloud"
alias prod="ssh -i ~/.ssh/id_ed25519 pulse-rw@bastionprod.satchel.cloud"
alias ukqa="ssh -i ~/.ssh/id_ed25519 pulse-uk-rw@bastionprod.satchel.cloud"
alias ukprod="ssh -i ~/.ssh/id_ed25519 pulse-uk-rw@bastionqa.satchel.cloud"
alias exam="ember exam --split=10 --parallel > log/test.log"
alias rc="rails console"
alias rdm="rake db:migrate"
alias rdr="rake db:rollback"
alias rgm="rails g migration"
alias test-db-reset="rake db:drop RAILS_ENV=test && rake db:create RAILS_ENV=test && rake db:structure:load RAILS_ENV=test"
alias src="spring rails c"
alias bi="bundle install"
alias bsq="bundle exec sidekiq -C config/sidekiq.yml"
alias bsqc="bundle exec sidekiq -C config/sidekiq.sel_calculations.yml"
alias mux="tmuxinator"
alias api="mux start api"
alias frontend="mux start frontend"
alias dotf="mux start nvim"

# export PATH="/opt/homebrew/opt/node@16/bin:$PATH"

export OP_SESSION_my="k1-mrd0FdcTJHwkIu-vqeD5twcC_AELzZ4QEzzO3XD4"
alias op-signin="op signin my"

source "$HOME/.cargo/env"
export PATH="/Users/yuri/scripts:/opt/homebrew/opt/openjdk/bin:$PATH"
export EDITOR='nvim'
alias config='/usr/bin/git --git-dir=/Users/yuri/.cfg/ --work-tree=/Users/yuri'


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
