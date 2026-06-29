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
RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
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
    alias nvim=vim
    
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
    alias nvim=vim
fi

# ============================================
# PLUGINS - DINÁMICOS POR DISTRO
# ============================================

# Plugins base (siempre disponibles)
plugins=(
  # ============================================
  # CORE PLUGINS
  # ============================================
  git                             # Git aliases y utilidades
  vi-mode                         # Modo vi en línea de comandos
  
  # ============================================
  # SYNTAX & AUTOCOMPLETION
  # ============================================
  zsh-autosuggestions             # Sugiere comandos del historial (↵ para aceptar)
  zsh-syntax-highlighting         # Resaltado de sintaxis en tiempo real
  zsh-history-substring-search    # Búsqueda en historial (↑↓ en los comandos)
  
  # ============================================
  # UTILITY PLUGINS
  # ============================================
  fzf                             # Búsqueda fuzzy (Ctrl+R, Ctrl+T)
  extract                         # extract file.tar.gz (soporta zip, rar, 7z, etc)
  colored-man-pages               # Páginas man con colores
  command-not-found               # Sugiere instalar paquete si comando no existe
  copyfile                        # copyfile file.txt (copia contenido al clipboard)
  copypath                        # copypath (copia ruta actual al clipboard)
  sudo                            # ESC+ESC para añadir 'sudo' al comando
  web-search                      # google "query" (busca en navegador)
)

# Agregar plugins específicos por distro
case "$DISTRO" in
    arch|manjaro)
        plugins+=(archlinux)        # Utilidades para Arch
        ;;
    debian|ubuntu)
        plugins+=(debian)           # Utilidades para Debian
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
export EDITOR=vim
export VISUAL=vim
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
