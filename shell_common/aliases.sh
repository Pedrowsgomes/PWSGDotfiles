# --- ALIASES DE IA ---
alias ai='sgpt --code --model gpt-4o'
alias aiexec='sgpt --execute'
alias gem='gemini-cli'
alias aicode='gemini-cli -m gemini-2.5-flash -c "me dê apenas o código para a pergunta a seguir:"'

# --- ALIASES DE SISTEMA ---
alias c='clear'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias mkdir='mkdir -pv'
alias df='df -h'
alias du='du -h'
alias p='ps aux'
alias history='history 1'

# --- NAVEGAÇÃO ---
alias m='micro'
alias l='ls -lh --color=auto'
alias la='ls -lha --color=auto'
alias ll='ls -l --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# --- DNF (FEDORA) ---
alias d='sudo dnf'
alias install='sudo dnf install'
alias update='sudo dnf update'
alias clean='sudo dnf autoremove && sudo dnf clean all'
alias findpkg='sudo dnf search' 

# --- GIT ---
alias gpull='git pull --rebase'
alias glog='git log --oneline --decorate --all --graph'
alias gco='git checkout'
alias gcb='git checkout -b'

# --- CONFIGURAÇÃO E MÍDIA ---
alias zshconfig='micro ~/.zshrc'
alias bashconfig='micro ~/.bashrc'
alias fishconfig='micro ~/.config/fish/config.fish'
alias zshreload='source ~/.zshrc'
alias ytmp3='yt-dlp -x --audio-format mp3'
