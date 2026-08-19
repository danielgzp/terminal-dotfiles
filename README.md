# 🚀 Configuración y Dotfiles para Terminal (Ghostty + Zsh)

Este repositorio contiene una configuración moderna, estética y de alta productividad para tu terminal en Linux y macOS. Integra el emulador **Ghostty**, el shell **Zsh** con **Oh My Zsh** (tema `robbyrussell` por defecto o `p10k`), y utilidades CLI modernas como **eza**, **zoxide**, **fzf** y **fnm**.

---

## 📑 Tabla de Contenidos

1. [Características Principales](#-características-principales)
2. [Estructura del Proyecto](#-estructura-del-proyecto)
3. [Instalación Rápida (Recomendada)](#-instalación-rápida-recomendada)
4. [Instalación Manual de Requisitos por Sistema Operativo](#-instalación-manual-de-requisitos-por-sistema-operativo)
5. [Instalación de la Tipografía (MesloLGS NF)](#-instalación-de-la-tipografía-meslolgs-nf)
6. [Catálogo de Alias y Atajos de Productividad](#-catálogo-de-alias-y-atajos-de-productividad)
7. [Cómo Respaldar Cambios Futuros](#-cómo-respaldar-cambios-futuros)
8. [Solución de Problemas (FAQ)](#-solución-de-problemas-faq)

---

## ✨ Características Principales

* ⚡ **Ghostty**: Emulador de terminal acelerado por GPU con tema Dracula, desenfoque de fondo (*glass effect*), padding y pestañas configuradas.
* 🐚 **Oh My Zsh**: Configurado con tema `robbyrussell` y soporte opcional para `Powerlevel10k`.
* 📂 **Navegación Inteligente (`zoxide`)**: Salta a cualquier directorio frecuente recordando patrones (reemplazo inteligente para `cd`).
* 📁 **Explorador Moderno (`eza`)**: Reemplazo para `ls` con colores, iconos Nerd Font, estado de Git integrado y vista en árbol.
* 🔍 **Buscador Difuso y Autocompletado (`fzf` + `fzf-tab`)**: Navegación interactiva en menús de autocompletado con tabulador.
* 💡 **Plugins de Zsh**:
  * `zsh-autosuggestions`: Sugerencias automáticas basadas en tu historial.
  * `zsh-syntax-highlighting`: Resaltado de sintaxis de comandos en tiempo real.
  * `fzf-tab`: Menú interactivo difuso al presionar `Tab`.
  * `git`: Aliases y funciones para control de versiones.
* 📦 **Node.js Manager (`fnm`)**: Gestor rápido de versiones de Node.js y atajos para `pnpm`.

---

## 📁 Estructura del Proyecto

```text
terminal-dotfiles/
├── dotfiles/
│   ├── ghostty/
│   │   ├── config           # Configuración base de Ghostty
│   │   └── config.ghostty   # Estilos avanzados (Dracula, desenfoque, padding)
│   ├── p10k.zsh             # Configuración visual de Powerlevel10k
│   └── zshrc                # Configuración principal de Zsh y aliases
├── backup.sh                # Script para respaldar tu configuración actual
├── restore.sh               # Script interactivo e idempotente de instalación
├── README.md                # Esta guía de documentación
└── terminal_backup.tar.gz   # Archivo comprimido portable para llevar a otras PCs
```

---

## ⚡ Instalación Rápida (Recomendada)

El script `restore.sh` es **completamente idempotente**: puedes ejecutarlo en una máquina limpia, sobre una instalación existente o si un intento previo quedó a medias.

### Opción A: Vía Git (Recomendada)
```bash
git clone https://github.com/Danielgzp/terminal-dotfiles.git
cd terminal-dotfiles
chmod +x restore.sh
./restore.sh
```

### Opción B: Vía Archivo Comprimido (`terminal_backup.tar.gz`)
Si llevaste el archivo `.tar.gz` en un pendrive o descarga directa:
```bash
tar -xzf terminal_backup.tar.gz
chmod +x restore.sh
./restore.sh
```

> [!TIP]
> Puedes usar la bandera `./restore.sh --yes` (o `-y`) para instalar automáticamente las dependencias y fuentes sin solicitar confirmaciones interactivas.

---

## 📦 Instalación Manual de Requisitos por Sistema Operativo

Si prefieres instalar las dependencias manualmente antes de restaurar los dotfiles, usa los comandos correspondientes a tu distribución:

### 🐧 Ubuntu / Debian / Linux Mint

```bash
# 1. Herramientas base y Zsh
sudo apt update
sudo apt install -y zsh git curl tar fontconfig fzf zoxide

# 2. eza (Reemplazo moderno de ls)
# En Ubuntu 24.04+ / Debian 13+:
sudo apt install -y eza

# Si tu versión de Ubuntu/Debian no incluye eza en repositorios oficiales:
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo apt update && sudo apt install -y eza
```

### 🎩 Fedora / RHEL

```bash
sudo dnf install -y zsh git curl tar fontconfig fzf zoxide eza
```

### 🏹 Arch Linux / Manjaro

```bash
sudo pacman -Syu --noconfirm zsh git curl tar fontconfig fzf zoxide eza
```

### 🍏 macOS (con Homebrew)

```bash
brew install zsh git curl fzf zoxide eza
```

---

## 🔤 Instalación de la Tipografía (MesloLGS NF)

Para que los iconos del prompt (Powerlevel10k), las ramas de Git y los archivos en `eza` se muestren correctamente, es necesario tener instalada la fuente **MesloLGS NF** (Nerd Font).

`restore.sh` intentará instalarla automáticamente. Si deseas instalarla manualmente:

### En Linux:
```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts

curl -fLO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
curl -fLO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
curl -fLO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
curl -fLO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

fc-cache -f ~/.local/share/fonts
```

### En macOS:
Descarga los 4 archivos `.ttf` indicados arriba y haz doble clic sobre cada uno para instalarlos en el Catálogo Tipográfico (*Font Book*), o guárdalos en `~/Library/Fonts/`.

---

## ⌨️ Catálogo de Alias y Atajos de Productividad

Una vez restaurada la configuración, tendrás a disposición los siguientes atajos:

### 📂 Navegación y Archivos
| Alias | Comando Real | Descripción |
|---|---|---|
| `ls` | `eza --icons=always --color=always` | Lista archivos con iconos y colores |
| `ll` | `eza --icons=always -la --git --color=always` | Lista detallada con permisos y estado Git |
| `la` | `eza --icons=always -a --color=always` | Lista incluyendo archivos ocultos |
| `lt` | `eza --icons=always --tree --level=2 --color=always` | Muestra árbol de directorios a 2 niveles |
| `cd <carpeta>` | `z <carpeta>` | Salto inteligente a carpetas por frecuencia (`zoxide`) |
| `..` | `cd ..` | Subir 1 nivel |
| `...` | `cd ../..` | Subir 2 niveles |
| `....` | `cd ../../..` | Subir 3 niveles |

### 🌿 Git Rápido
| Alias | Comando Real | Descripción |
|---|---|---|
| `g` | `git` | Comando base de Git |
| `gs` | `git status` | Ver estado del árbol de trabajo |
| `gd` | `git diff` | Ver diferencias no preparadas |
| `gl` | `git log --oneline --graph --decorate` | Historial en formato grafo compacto |
| `gp` | `git push` | Enviar commits al repositorio remoto |
| `gco` | `git checkout` | Cambiar de rama o restaurar archivos |
| `gc` | `git commit` | Crear un commit |
| `gca` | `git commit --amend` | Enmendar el commit anterior |

### 🛠️ Utilidades y Configuración
| Alias | Comando Real | Descripción |
|---|---|---|
| `config-zsh` | `nano ~/.zshrc` | Editar la configuración de Zsh |
| `config-ghostty` | `nano ~/.config/ghostty/config` | Editar la configuración de Ghostty |
| `pn` | `pnpm` | Atajo rápido para pnpm |
| `antigravity-ide` / `agy-ide` | `antigravity-ide --no-sandbox` | Abrir Antigravity IDE |

---

## 💾 Cómo Respaldar Cambios Futuros

Si modificas tu `.zshrc`, agregas nuevos alias o ajustas los temas de Ghostty en tu máquina local:

1. Ejecuta el script de respaldo desde el directorio del proyecto:
   ```bash
   ./backup.sh
   ```
2. Este script:
   - Copiará tus archivos activos de `~/.zshrc`, `~/.p10k.zsh` y `~/.config/ghostty/` a la carpeta `dotfiles/`.
   - Generará un paquete actualizado `terminal_backup.tar.gz`.
3. Haz un commit y súbelo a tu repositorio Git:
   ```bash
   git add .
   git commit -m "update: sincronizar nuevas configuraciones de terminal"
   git push
   ```

---

## 🛠️ Solución de Problemas (FAQ)

### 1. ¿Por qué veo caracteres extraños o cuadros con signos de interrogación?
Significa que tu terminal no está usando una fuente con glifos Nerd Font.
- Asegúrate de haber instalado **MesloLGS NF** (ver sección de [Tipografía](#-instalación-de-la-tipografía-meslolgs-nf)).
- En Ghostty, la tipografía viene preconfigurada como `font-family = "MesloLGS NF"`. Si usas otra terminal (Alacritty, Kitty, GNOME Terminal), ve a las preferencias de tu terminal y selecciona **MesloLGS NF Regular**.

### 2. ¿Cómo cambio mi shell por defecto a Zsh si sigue abriendo Bash?
Ejecuta el siguiente comando e ingresa tu contraseña si te la solicita:
```bash
chsh -s $(which zsh)
```
Luego cierra sesión en tu sistema operativo o reinicia la computadora para que el cambio surta efecto global.

### 3. ¿Cómo reconfiguro el aspecto visual del prompt de Powerlevel10k?
Puedes volver a ejecutar el asistente interactivo en cualquier momento con:
```bash
p10k configure
```
Esto te permitirá elegir entre diseño clásico, rainbow, formato de tiempo, iconos, etc. Luego ejecuta `./backup.sh` si deseas guardar la nueva configuración generada.

### 4. ¿Qué pasa si `restore.sh` sobreescribe algo que no quería perder?
`restore.sh` nunca sobreescribe destructivamente tus archivos. Antes de modificar cualquier archivo existente, genera una copia de seguridad con la fecha y hora exacta, por ejemplo:
`~/.zshrc.bak_20260818_203000`
