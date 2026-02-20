# =======================================================
# FISH CONFIGURATION: POWER SIDE (FEDORA + NIRI)
# =======================================================

# --- 1. AMBIENTE E PATH ---
set -gx PATH "$HOME/.local/bin" "$HOME/.cargo/bin" /usr/local/bin $PATH
set -gx EDITOR micro
set -gx VISUAL micro

# --- 2. ALIASES (IA, SISTEMA, GIT) ---

# IA
alias ai='sgpt --code --model gpt-4o'
alias aiexec='sgpt --execute'
alias gem='gemini-cli'
alias aicode='gemini-cli -m gemini-2.5-flash -c "me dê apenas o código para a pergunta a seguir:"'

# Sistema e Navegação
alias c='clear'
alias m='micro'
alias l='ls -lh --color=auto'
alias la='ls -lha --color=auto'
alias ll='ls -l --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias df='df -h'
alias p='ps aux'

# DNF (Fedora)
alias d='sudo dnf'
alias install='sudo dnf install'
alias update='sudo dnf update'
alias clean='sudo dnf autoremove && sudo dnf clean all'
alias findpkg='sudo dnf search'

# Git
alias gpull='git pull --rebase'
alias glog='git log --oneline --decorate --all --graph'
alias gco='git checkout'
alias gcb='git checkout -b'

# Outros
alias ytmp3='yt-dlp -x --audio-format mp3'
alias mounttool='bashmount'

# --- 3. FUNÇÕES CUSTOMIZADAS ---

# Sudo (Esc Esc)
function sudo_last_command
    set -l cmd (commandline)
    if test -z "$cmd"
        set cmd $history[1]
    end
    if string match -q "sudo *" "$cmd"
        commandline -r (string replace -r '^sudo ' '' -- "$cmd")
    else
        commandline -r "sudo $cmd"
    end
end

# Sync Dotfiles
function dotsync
    set -l msg (if test -n "$argv[1]"; echo "$argv[1]"; else; echo "update dotfiles"; end)
    cd ~/.config/dotfiles
    git add .
    git commit -m "$msg"
    git push origin main
    cd -
end

# Extract Ultra-Universal v3.0 (Adaptado do Zsh original)
function extract --description "Universal extractor"
    if test -f "$argv[1]"
        switch "$argv[1]"
            case '*.tar.bz2' '*.tbz2'
                tar xvf "$argv[1]"
            case '*.tar.gz' '*.tgz'
                tar xvf "$argv[1]"
            case '*.tar.xz'
                tar xvf "$argv[1]"
            case '*.tar.zst'
                tar --zstd -xvf "$argv[1]"
            case '*.bz2'
                bunzip2 "$argv[1]"
            case '*.rar'
                unrar x "$argv[1]"
            case '*.gz'
                gunzip "$argv[1]"
            case '*.tar'
                tar xvf "$argv[1]"
            case '*.zip' '*.jar' '*.war' '*.ear' '*.apk'
                unzip "$argv[1]"
            case '*.7z' '*.iso' '*.exe' '*.dmg' '*.pkg' '*.cab'
                7z x "$argv[1]"
            case '*.xz'
                unxz "$argv[1]"
            case '*.zst'
                unzstd "$argv[1]"
            case '*.rpm'
                rpm2cpio "$argv[1]" | cpio -idmv
            case '*.deb'
                7z x "$argv[1]"
                7z x data.tar
            case '*'
                echo "'$argv[1]' não pode ser extraído"
        end
    else
        echo "'$argv[1]' não é um arquivo válido"
    end
end

# --- 4. CONFIGURAÇÕES INTERATIVAS E UI ---
if status is-interactive
    # Bindings
    bind \e\e sudo_last_command

    # Prompt (Requer 'sudo dnf install starship')
    if type -q starship
        starship init fish | source
    end
end

set -g fish_greeting ""
