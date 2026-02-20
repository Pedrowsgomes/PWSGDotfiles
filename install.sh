#!/bin/bash

# ==============================================================================
# Script de Instalação de Dotfiles e Configuração do Sistema (Fedora Minimal)
# Autor: Pedro Winter (baseado no rascunho)
# ==============================================================================

# Cores para logs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
error() { echo -e "${RED}[ERRO]${NC} $1"; }

# Para o script se houver erro
set -e

# ------------------------------------------------------------------------------
# 1. Otimização do DNF (Prioridade para velocidade)
# ------------------------------------------------------------------------------
log "Otimizando DNF..."
# Adiciona configurações apenas se não existirem
sudo grep -q "max_parallel_downloads" /etc/dnf/dnf.conf || echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf
sudo grep -q "fastestmirror" /etc/dnf/dnf.conf || echo "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf
sudo grep -q "defaultyes" /etc/dnf/dnf.conf || echo "defaultyes=True" | sudo tee -a /etc/dnf/dnf.conf
# Desabilitar install_weak_deps globalmente (Cuidado: pode quebrar funcionalidades opcionais do GNOME/KDE, mas ok para Minimal/WMs)
sudo grep -q "install_weak_deps" /etc/dnf/dnf.conf || echo "install_weak_deps=False" | sudo tee -a /etc/dnf/dnf.conf

# ------------------------------------------------------------------------------
# 2. Repositórios e Atualização Base
# ------------------------------------------------------------------------------
log "Instalando repositórios (RPM Fusion, Terra, COPRs)..."

# RPM Fusion
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

# Terra (Fyra Labs)
sudo dnf install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release -y

# COPRs (Niri e Hyprland)
sudo dnf copr enable yalter/niri -y
sudo dnf copr enable solopasha/hyprland -y

# Cisco OpenH264
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1 -y

log "Atualizando sistema e Firmware..."
sudo dnf group upgrade core -y
sudo dnf update -y

# ------------------------------------------------------------------------------
# 3. Multimídia e Drivers (Intel)
# ------------------------------------------------------------------------------
log "Configurando Multimídia e Drivers..."

sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y
sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
sudo dnf install rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted -y

# Drivers Intel (Crucial para seu Acer i5) e suporte a DVD
sudo dnf install intel-media-driver libva-intel-driver libdvdcss -y
sudo dnf --repo=rpmfusion-nonfree-tainted install "*-firmware" -y

# ------------------------------------------------------------------------------
# 4. Ferramentas Base e Git
# ------------------------------------------------------------------------------
log "Instalando ferramentas essenciais..."
sudo dnf install git gh stow curl wget unzip p7zip p7zip-plugins xz zstd lzip unrar binutils cpio rpm2cpio bat eza fzf ripgrep -y

# ------------------------------------------------------------------------------
# 5. Clonagem e Stow dos Dotfiles
# ------------------------------------------------------------------------------
DOTFILES_DIR="$HOME/.config/dotfiles"

if [ -d "$DOTFILES_DIR" ]; then
    log "Dotfiles já existem. Atualizando..."
    cd "$DOTFILES_DIR" && git pull
else
    log "Clonando dotfiles..."
    git clone https://github.com/pedrogwinter/dotfiles "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"

# Configura o stowrc se existir
if [ -f "stowrc" ]; then
    cp stowrc ~/.stowrc
fi

log "Aplicando Stow..."
# Lista de pastas para aplicar o stow
PKGS=(
  alacritty bash dms fish foot fuzzel gtk hypr kitty inputrc
  libreoffice micro sheldon shell_common starship sway waybar
  wlogot zsh niri
)

for pkg in "${PKGS[@]}"; do
    if [ -d "$pkg" ]; then
        log "Stowing $pkg..."
        # Remove arquivos existentes para evitar conflito (faz backup se necessário antes de rodar o script ou use --adopt com cuidado)
        # O comando abaixo deleta o arquivo padrão do sistema (ex: .bashrc) para colocar o link simbólico
        # Se quiser backup, use: mv "$HOME/.$pkg" "$HOME/.$pkg.bak" 2>/dev/null

        stow -R -v -t "$HOME" "$pkg"
    else
        error "Pasta $pkg não encontrada nos dotfiles, pulando..."
    fi
done

# ------------------------------------------------------------------------------
# 6. Instalação de Pacotes (WMs, Shells, Utils)
# ------------------------------------------------------------------------------
log "Instalando Pacotes do Ambiente Gráfico e Utils..."

# Shells e Plugins
sudo dnf install fish zsh zsh-autocomplete zsh-syntax-highlighting bash-color-prompt bash-completion bashmount starship -y

# Rust e Ferramentas Rust
sudo dnf install rustup cargo openssl-devel -y
# Instalação do Sheldon via Cargo (mais seguro que dnf se não houver pacote oficial atualizado)
if ! command -v sheldon &> /dev/null; then
    log "Instalando Sheldon via Cargo..."
    cargo install sheldon --locked
fi
if ! command -v clock-rs &> /dev/null; then
    cargo install clock-rs
fi

# Compositores e Ferramentas Wayland
# Nota: Adicionei dependências comuns do Sway/Hyprland
sudo dnf install \
    niri \
    hyprland hyprlock xdg-desktop-portal-hyprland \
    sway SwayNotificationCenter SwayOSD sway-audio-idle-inhibit sway-systemd \
    sway-wallpapers swayfx swayfx-config-upstream swayfx-wallpapers \
    swaylock-effects swayidle swayimg \
    mangowc fuzzel wlogout waybar \
    alacritty kitty foot \
    polkit-gnome \
    thunar \
    pavucontrol \
    blueman \
    grim slurp wl-clipboard \
    -y

# ------------------------------------------------------------------------------
# 7. Flatpak
# ------------------------------------------------------------------------------
log "Configurando Flatpak..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# ------------------------------------------------------------------------------
# Finalização
# ------------------------------------------------------------------------------
success "Instalação concluída! Reinicie o computador para garantir que todos os drivers e variáveis de ambiente carreguem corretamente."
log "Lembre-se de verificar se o Shell padrão foi alterado (chsh -s /usr/bin/fish ou /usr/bin/zsh)."
