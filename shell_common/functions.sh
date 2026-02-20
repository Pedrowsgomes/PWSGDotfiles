# --- FUNÇÕES COMPARTILHADAS (BASH & ZSH) ---

# Sync dotfiles
function dotsync() {
    local msg="${1:-update dotfiles}"
    # Caminho atualizado para dentro de .config
    cd ~/.config/dotfiles
    git add .
    git commit -m "$msg"
    git push origin main
    cd -
}

# Extract Ultra-Universal v3.0
extract() {
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xvf "$1"        ;;
      *.tar.gz)    tar xvf "$1"        ;;
      *.tar.xz)    tar xvf "$1"        ;;
      *.tar.zst)   tar --zstd -xvf "$1" ;;
      *.bz2)       bunzip2 "$1"        ;;
      *.rar)       unrar x "$1"        ;;
      *.gz)        gunzip "$1"         ;;
      *.tar)       tar xvf "$1"        ;;
      *.tbz2)      tar xvf "$1"        ;;
      *.tgz)       tar xvf "$1"        ;;
      *.zip)       unzip "$1"          ;;
      *.Z)         uncompress "$1"     ;;
      *.7z)        7z x "$1"           ;;
      *.xz)        unxz "$1"           ;;
      *.exe)       7z x "$1"           ;;
      *.zst)       unzstd "$1"         ;;
      *.dmg|*.pkg) 7z x "$1"           ;;
      *.iso)       7z x "$1"           ;;
      *.cab)       7z x "$1"           ;;
      *.rpm)       rpm2cpio "$1" | cpio -idmv ;;
      *.deb)       7z x "$1" && 7z x data.tar ;;
      *.jar|*.war|*.ear|*.apk) unzip "$1" ;;
      *)           echo "'$1' não pode ser extraído via extract()" ;;
    esac
  else
    echo "'$1' não é um arquivo válido"
  fi
}

