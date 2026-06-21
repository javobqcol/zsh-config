# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="af-magic"

# ============================================
# ZSHRC CON DETECCIÓN DE ENTORNO
# ============================================

# Detectar distribución de Linux
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        echo "$DISTRIB_ID" | tr '[:upper:]' '[:lower:]'
    else
        echo "unknown"
    fi
}

DISTRO=$(detect_distro)

# 1. DETECTAR SI ESTAMOS EN TTY (Consola en modo texto)
if [[ "$TERM" == "linux" ]]; then
    # ============================================
    # MODO TTY - PROMPT SIMPLE
    # ============================================
    # Desactivar Powerlevel10k instant prompt
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
    
    # Alias básicos
    alias ll='ls -la'
    alias la='ls -A'
    alias l='ls -CF'
    alias nano=vim
    
else
    # ============================================
    # MODO GRÁFICO - POWERLEVEL10K
    # ============================================
    
    # Cargar Powerlevel10k tema
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    
    if [ -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        source "$ZSH_CUSTOM/themes/powerlevel10k/powerlevel10k.zsh-theme"
    else
        echo "[!] Powerlevel10k no encontrado en $ZSH_CUSTOM/themes/powerlevel10k"
        echo "[*] Ejecuta: bash <(curl -s https://raw.githubusercontent.com/javobqcol/zsh-config/main/bootstrap.sh)"
    fi
    
    # Configuración personalizada de Powerlevel10k
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    
    # Alias para entorno gráfico
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
    alias nano=vim
fi

# ============================================
# PLUGINS - DINÁMICOS POR DISTRO
# ============================================

# Plugins base (siempre disponibles)
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
  vi-mode
)

# Agregar plugins específicos por distro
case "$DISTRO" in
    arch|manjaro)
        plugins+=(archlinux)
        ;;
    debian|ubuntu)
        # Debian/Ubuntu no tiene plugin específico, pero git está incluido
        ;;
    fedora|rhel|centos)
        # RedHat based
        ;;
esac

source $ZSH/oh-my-zsh.sh

# ============================================
# CONFIGURACIONES COMPARTIDAS
# ============================================

# PATH - Agregar rutas custom sin duplicar
typeset -U PATH path
path=("$HOME/.local/bin" "$HOME/bin" "/usr/local/bin" $path)
export PATH

# Historial
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY

# Editor
export EDITOR=nvim
export VISUAL=nvim
export SYSTEMD_EDITOR=vim

# ============================================
# HERRAMIENTAS OPCIONALES
# ============================================

# NVM - Carga lazy si existe
if [ -s "$HOME/.nvm/nvm.sh" ]; then
    # Función para lazy-load NVM solo cuando se necesite
    nvm() {
        unset -f nvm
        [ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh"
        nvm "$@"
    }
    
    # Completions
    [ -s "$HOME/.nvm/bash_completion" ] && . "$HOME/.nvm/bash_completion"
fi

# ============================================
# INFORMACIÓN DE INICIO (Opcional)
# ============================================

#echo "✅ Zsh cargado - Distro: $DISTRO - Modo: $([[ "$TERM" == "linux" ]] && echo "TTY" || echo "Gráfico")"
