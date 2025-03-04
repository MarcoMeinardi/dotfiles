# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/.ghcup/bin
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/.local/share/gem/ruby/3.3.0/bin

export MAKEFLAGS='-j6'

export EDITOR=/bin/nvim

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

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
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

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
export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	autojump
	colored-man-pages
	command-not-found
	dirhistory
	docker
	docker-compose
	extract
	fzf
	pip
	virtualenv
	virtualenvwrapper
	zsh-autosuggestions
	zsh-syntax-highlighting
)

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

alias ll='ls -AlhF'
alias la='ls -A'
alias l='ls -CF'
alias sl='sl -G -w'
alias exp='fzf --preview "bat --color=always {}"'

alias cls='clear'
alias dw='cd ~/Downloads'
alias ds='cd ~/Desktop'
alias dc='cd ~/Documents'
alias myip='curl ifconfig.me -q'
alias tmp='cd /tmp'
alias tt='gio trash'
alias py='python'
alias ipy='ipython'
alias vi='nvim'
alias cpsel='xclip -selection clipboard'
alias viconf='cd ~/.config/nvim; nvim .; cd - &> /dev/null'
alias gef='sudo gdb -nx -x ~/.gdbinit-gef.py'
alias reset='tput reset'
alias pasteimg='xclip -o -selection clipboard'
alias cal='cal -y -m'
alias tssh='kitten ssh'

function cpfile() {
	echo -n "file://$(realpath $1)" | xclip -selection clipboard -t text/uri-list
}

export TIMEFMT=$'
wall\t%E
cpu\t%U
sys\t%S'

bindkey -v

mk() {
    if [ -f $1.cpp ]; then
        echo "$1.cpp exists"
    else
        cp ~/Documents/coding/base.cpp $1.cpp
        vi $1.cpp -c "34j"
    fi
}

fastswap() {
	sudo swapoff /swapfile 2> /dev/null
	sudo rm /swapfile 2> /dev/null
	sudo mkswap -U clear --size ${1}G --file /swapfile && sudo swapon /swapfile
}

build_and_run() {
    option=$1
    shift

    compile_only=false
    keep_exec=false
    get_time=false
    output="main"
    files=()
    other_flags=()

    while (( $# >= 1 )); do
        if [ "$1" = "-c" ]; then
            compile_only=true
        elif [ "$1" = "-k" ]; then
            keep_exec=true
        elif [ "$1" = "-t" ]; then
            get_time=true
        elif [ "$1" = "-o" ]; then
            shift
            output="$1"
        else
            if [[ "$1" = -* ]]; then
                other_flags+=($1)
            else
                files+=($1)
            fi
        fi
        shift
    done

    if $compile_only; then
        if $get_time; then
            time $option -Wall ${files[@]} ${other_flags} -o $output
        else
            $option -Wall ${files[@]} ${other_flags} -o $output
        fi
    elif $keep_exec; then
        $option -Wall ${files[@]} ${other_flags} -o $output || return
        if $get_time; then	
            time ./$output
        else
            ./$output
        fi
    else
        $option -Wall ${files[@]} ${other_flags} -o $output || return
        if $get_time; then
            time ./$output
        else
            ./$output
        fi
        rm $output
    fi
}

alias cpp='build_and_run g++'
alias c='build_and_run gcc'

# virtualenvwrapper settings:
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export WORKON_HOME=~/.virtualenvs
export VIRTUALENVWRAPPER_SCRIPT=/home/marco/.local/bin/virtualenv
source virtualenvwrapper.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
