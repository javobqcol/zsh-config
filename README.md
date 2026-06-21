# 🚀 Zsh Config

Configuración portátil de Zsh con Oh My Zsh, Powerlevel10k y plugins esenciales. Diseñada para múltiples máquinas con diferentes distribuciones Linux.

## 📋 Requisitos previos

- `bash` (para ejecutar instalador)
- `git`
- `curl` o `wget`
- Acceso a internet

## ⚡ Instalación rápida

```bash
bash <(curl -s https://raw.githubusercontent.com/javobqcol/zsh-config/main/bootstrap.sh)
```

O clonando manualmente:

```bash
git clone https://github.com/javobqcol/zsh-config.git
cd zsh-config
bash install.sh
```

## ✨ Características

- ✅ **Portátil**: Funciona en Arch, Debian, Fedora y otros
- ✅ **Automático**: Instala Oh My Zsh, plugins y temas
- ✅ **TTY Friendly**: Detecta modo texto y adapta la configuración
- ✅ **Smart Loading**: Lazy-load de herramientas como NVM
- ✅ **Backup**: Respalda configuración anterior antes de instalar
- ✅ **Multi-distro**: Detecta distribución y carga plugins apropiados

## 📦 Incluye

### Tema
- **Powerlevel10k**: Prompt rápido y customizable

### Plugins
- `git`: Aliased y utilidades git
- `zsh-autosuggestions`: Autocompletado de historial
- `zsh-syntax-highlighting`: Resaltado de sintaxis
- `zsh-history-substring-search`: Búsqueda en historial
- `vi-mode`: Atajos vim en línea de comandos
- `archlinux` (solo en Arch/Manjaro): Utilidades específicas

## 🛠️ Archivos

| Archivo | Propósito |
|---------|-----------|
| `bootstrap.sh` | Script de instalación con fallback HTTPS/SSH |
| `install.sh` | Instalador principal (plugins, temas, configuración) |
| `.zshrc` | Configuración principal de Zsh |
| `.p10k.zsh` | Configuración de Powerlevel10k |

## 🖥️ Modos soportados

### Modo Gráfico (GUI)
- Carga Powerlevel10k completo
- Todos los plugins activados
- Aliases extendidos

### Modo TTY (Consola de texto)
- Prompt simple (evita caracteres especiales)
- Configuración mínima
- Funcional sin dependencias gráficas

## 🎨 Personalización

### Cambiar el tema de Powerlevel10k

```bash
p10k configure
```

### Editar aliases

Modifica la sección de aliases en `.zshrc` o crea:
```bash
~/.oh-my-zsh/custom/aliases.zsh
```

### Agregar más plugins

En `.zshrc`, modifica:
```bash
plugins=(
  git
  zsh-autosuggestions
  # Agregar más aquí
)
```

## 🔄 Actualizar configuración en máquinas existentes

```bash
cd ~/.config/zsh-config  # o donde lo tengas clonado
git pull origin main
bash install.sh
```

## 📝 Notas

- Los archivos anteriores se respaldan con timestamp: `.zshrc.bak.YYYYMMdd-HHMMSS`
- NVM (Node Version Manager) se carga bajo demanda para no ralentizar el shell
- La detección de TTY es automática; sin embargo, puedes forzar un modo modificando `$TERM`

## ⚙️ Requisitos según distro

### Arch/Manjaro
```bash
sudo pacman -S zsh git curl
```

### Debian/Ubuntu
```bash
sudo apt install zsh git curl
```

### Fedora/RHEL/CentOS
```bash
sudo dnf install zsh git curl
```

## 🐛 Troubleshooting

### "Powerlevel10k no encontrado"
- Ejecuta: `bash install.sh` nuevamente
- O reinstala: `bash <(curl -s https://raw.githubusercontent.com/javobqcol/zsh-config/main/bootstrap.sh)`

### Caracteres raros en TTY
- Es normal; el modo TTY usa fuentes simples
- En GUI deberían verse correctamente

### NVM no funciona
- NVM se carga lazy. Escribe `nvm` en cualquier momento para activarlo
- Verifica que `~/.nvm` exista

## 📄 Licencia

MIT - Libre para usar y modificar

## 🤝 Contribuciones

¿Mejoras? Abre un issue o PR
