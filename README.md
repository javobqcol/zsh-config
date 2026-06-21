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
- ✅ **15+ Plugins**: Utilidades productivas precargadas

## 📦 Tema

### Powerlevel10k
- **Prompt rápido y personalizador**
- Información git en tiempo real
- Indicador de error de comandos
- Ejecución bajo demanda: `p10k configure`

---

## 🎮 Plugins Instalados

### 🔤 **CORE PLUGINS**

#### **git** - Gestión de repositorios
```bash
# Aliases útiles:
gst              # git status
ga .             # git add
gc -m "msg"      # git commit
gp               # git push
gpl              # git pull
gb               # git branch
gco branch       # git checkout
glog             # git log visual
```
**¿Cómo funciona?** Proporciona decenas de aliases para comandos git comunes.

#### **vi-mode** - Editor vi en terminal
```bash
# Presiona ESC para entrar en modo normal
# Uso de comandos vim: hjkl, w, b, $, ^, etc.
# ESC + ESC para modo comando en cualquier línea
```
**¿Cómo funciona?** Permite editar la línea de comandos como en vim (movimiento, búsqueda, etc).

---

### 🧠 **AUTOCOMPLETADO & BÚSQUEDA**

#### **zsh-autosuggestions** - Sugerencias del historial
```bash
# Escribe inicio de comando:
$ ls /home
# El shell sugiere comandos anteriores en gris
# Presiona → para aceptar la sugerencia
# Presiona Ctrl+Space para aceptar palabra
```
**¿Cómo funciona?** Busca en tu historial comandos que comienzan igual y los sugiere.

#### **zsh-syntax-highlighting** - Colores en tiempo real
```bash
# Mientras escribes:
$ rm -rf /home/user/file   # ← Colores indicando sintaxis válida
$ invalid-command arg      # ← Comando en rojo (no existe)
```
**¿Cómo funciona?** Resalta sintaxis válida/inválida, rutas, variables, etc. en tiempo real.

#### **zsh-history-substring-search** - Búsqueda en historial
```bash
# Escribe un comando y presiona ↑ o ↓
$ docker ps
# ↑ muestra comandos que contienen "docker"
# ↓ muestra el siguiente
```
**¿Cómo funciona?** Busca en el historial comandos que contienen lo que escribiste.

#### **fzf** - Búsqueda fuzzy interactiva ⭐
```bash
# Ctrl+R → Busca en historial interactivamente
$ Ctrl+R
> docker ps
  docker run
  docker build
  # Escribe para filtrar, ↑↓ para seleccionar, Enter para ejecutar

# Ctrl+T → Busca archivos
$ Ctrl+T
/home/user/file.txt   # Se inserta en comando

# Alt+C → Navega directorios
$ Alt+C
# Abre selector de carpetas, Enter para cd
```
**¿Cómo funciona?** Permite búsqueda interactiva con preview de comandos y archivos.

---

### 🛠️ **UTILIDADES**

#### **extract** - Descomprimir cualquier formato
```bash
# Una sola orden para todos los formatos:
extract archive.tar.gz     # tar
extract file.zip           # zip
extract file.rar           # rar
extract file.7z            # 7z
extract file.tar.bz2       # tar.bz2
extract file.tar.xz        # tar.xz
```
**¿Cómo funciona?** Detecta el tipo de archivo automáticamente y lo descomprime.

#### **colored-man-pages** - Páginas de ayuda coloreadas
```bash
# Ejecuta ayuda con colores:
$ man ls
# Las páginas man ahora tienen colores y formatos
```
**¿Cómo funciona?** Aplica colores y formatos a las páginas man para mejor legibilidad.

#### **command-not-found** - Sugerencias inteligentes
```bash
# Escribes un comando que no existe:
$ nvim
Command 'nvim' not found. Did you mean:
  command 'neovim' from deb neovim (0.4.3-1)
Try: sudo apt install neovim
```
**¿Cómo funciona?** Busca en repositorios qué paquete proporciona el comando que escribiste.

#### **copyfile** - Copiar contenido al clipboard
```bash
# Copia contenido completo de archivo:
$ copyfile config.yaml
# El contenido está en clipboard, listo para pegar

# O acceso directo:
$ cat config.yaml | xclip -selection clipboard
```
**¿Cómo funciona?** Lee archivo y copia su contenido al clipboard del sistema.

#### **copypath** - Copiar ruta actual
```bash
# Copia ruta actual del directorio:
$ pwd
/home/user/projects/myapp
$ copypath
# /home/user/projects/myapp está en clipboard
```
**¿Cómo funciona?** Copia `$PWD` al clipboard sin necesidad de `pwd | xclip`.

#### **sudo** - Rápido acceso a sudo
```bash
# Escribe comando normal:
$ apt update
# Presiona ESC ESC:
$ sudo apt update
# ← Se añade sudo automáticamente
```
**¿Cómo funciona?** Presionar ESC dos veces prepend "sudo" al comando actual.

#### **web-search** - Buscar en navegador
```bash
# Busca en Google desde terminal:
$ google "how to use zsh"
# Se abre navegador con resultados

# Otros buscadores:
$ bing "query"
$ ddg "query"        # DuckDuckGo
```
**¿Cómo funciona?** Abre navegador con búsqueda en el motor especificado.

---

### 📦 **PLUGINS POR DISTRIBUCIÓN**

#### **archlinux** (solo Arch/Manjaro)
```bash
# Utilidades específicas de Arch:
pacls              # pacman list
pacinfo            # info del paquete
pacsearch          # buscar en repo
pacupd             # pacman -Syu
pamac-update       # actualizar todo
```
**¿Cómo funciona?** Proporciona aliases para comandos comunes de pacman.

#### **debian** (solo Debian/Ubuntu)
```bash
# Utilidades específicas de Debian:
aptls              # apt list
aptsearch          # apt search
aptupd             # apt update && apt upgrade
```
**¿Cómo funciona?** Proporciona aliases para comandos comunes de apt.

---

## 📚 Resumen de Atajos Principales

| Atajo | Acción |
|-------|--------|
| `→` | Aceptar sugerencia de autosuggestions |
| `Ctrl+R` | Búsqueda fuzzy en historial |
| `Ctrl+T` | Búsqueda fuzzy de archivos |
| `Alt+C` | Buscar y cd a directorio |
| `↑` / `↓` | Buscar en historial por substring |
| `ESC ESC` | Prepend `sudo` al comando |
| `ESC` | Modo normal (vi-mode) |

---

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

### Crear plugin personalizado

```bash
# Crear archivo en custom:
~/.oh-my-zsh/custom/myplugin.zsh

# Añadir:
alias micomando="ls -la"
function mifuncion() {
    echo "Hola desde mi función"
}
```

---

## 🔄 Actualizar configuración en máquinas existentes

```bash
cd ~/ruta/a/zsh-config
git pull origin main
bash install.sh
```

---

## 📝 Notas

- Los archivos anteriores se respaldan con timestamp: `.zshrc.bak.YYYYMMdd-HHMMSS`
- NVM (Node Version Manager) se carga bajo demanda para no ralentizar el shell
- La detección de TTY es automática; sin embargo, puedes forzar un modo modificando `$TERM`
- Todos los plugins se instalan automáticamente durante `bash install.sh`

---

## 🛠️ Archivos

| Archivo | Propósito |
|---------|-----------|
| `bootstrap.sh` | Script de instalación con fallback HTTPS/SSH |
| `install.sh` | Instalador principal (plugins, temas, configuración) |
| `.zshrc` | Configuración principal de Zsh |
| `.p10k.zsh` | Configuración de Powerlevel10k |

---

## 🖥️ Modos soportados

### Modo Gráfico (GUI)
- Carga Powerlevel10k completo
- Todos los plugins activados
- Aliases extendidos

### Modo TTY (Consola de texto)
- Prompt simple (evita caracteres especiales)
- Configuración mínima
- Funcional sin dependencias gráficas

---

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

---

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

### Los plugins no aparecen
- Verifica que Oh My Zsh esté instalado: `ls ~/.oh-my-zsh`
- Ejecuta nuevamente: `bash install.sh`
- Abre nueva terminal para cargar cambios

### Algunos atajos no funcionan en SSH
- Terminal remota puede no soportar ciertos atajos
- Usa `Ctrl+R` para búsqueda (más compatible)
- Considera usar tmux o screen en SSH

---

## 📄 Licencia

MIT - Libre para usar y modificar

---

## 🤝 Contribuciones

¿Mejoras? Abre un issue o PR
