# --- 1. CARREGAR MÓDULOS PDOTS ---
for file in path env functions aliases; do
    [ -f $HOME/.config/dotfiles/shell_common/$file.sh ] && . $HOME/.config/dotfiles/shell_common/$file.sh
done

# --- 2. CONFIGURAÇÕES DE HISTÓRICO ---
shopt -s histappend                      # Adiciona ao histórico em vez de sobrescrever
HISTCONTROL=ignoredups:erasedups         # Ignora duplicatas 
HISTSIZE=10000                           # Tamanho do histórico em memória 
HISTFILESIZE=20000                       # Tamanho do arquivo de histórico 
shopt -s checkwinsize                    # Atualiza linhas/colunas após cada comando

# --- 3. AUTOCOMPLETAR E CORES ---
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion               # Ativa o sistema de autocompletar do Fedora
fi
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad

# --- 4. READLINE & BIND -X (Sudo Esc Esc) ---
sudo-command-line() {
    [[ -z "$READLINE_LINE" ]] && READLINE_LINE=$(history -p '!!')
    if [[ "$READLINE_LINE" == sudo\ * ]]; then
        READLINE_LINE="${READLINE_LINE#sudo }"
    else
        READLINE_LINE="sudo $READLINE_LINE"
    fi
    READLINE_POINT=${#READLINE_LINE}
}
bind -x '"\e\e": sudo-command-line'     # Mapeia Esc Esc para Sudo 

#if [[ -n "$(command -v starship)" ]]; then
#  eval "$(starship init bash)"
#fi

# Ativa cores no ls e completion do Fedora
if [ -f /etc/profile.d/bash_completion.sh ]; then
    . /etc/profile.d/bash_completion.sh
fi
export CLICOLOR=1

# Função para pegar o branch do git
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Configuração do PS1
# \w = diretório atual completo
# \W = apenas a pasta atual
export PS1="\[\e[32m\]\w\[\e[93m\]\$(parse_git_branch)\[\e[0m\]
❯ "



