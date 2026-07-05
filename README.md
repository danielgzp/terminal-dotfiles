# Respaldo y Restauración de Configuración de Terminal

Este directorio contiene herramientas para guardar, exportar e importar las configuraciones de tu terminal (Zsh, plugins, aliases y Ghostty).

## Contenido
* **`backup.sh`**: Script para copiar tus configuraciones actuales desde tu sistema al directorio `dotfiles/` y empaquetarlo todo en un archivo portátil `terminal_backup.tar.gz`.
* **`restore.sh`**: Script para restaurar todo en un sistema limpio (instala Oh My Zsh, clona plugins de git, y restaura tus archivos de configuración).
* **`dotfiles/`**: Carpeta donde se almacenan las copias de tus archivos de configuración.

---

## Cómo usar

### 1. Crear un respaldo (Exportar)
Ejecuta el script `backup.sh` desde la terminal:
```bash
./backup.sh
```
Esto creará un archivo llamado `terminal_backup.tar.gz` en esta carpeta. **Este es el único archivo que necesitas guardar o llevarte a otra PC.**

### 2. Restaurar en una nueva PC (Importar)
1. Copia el archivo `terminal_backup.tar.gz` a la nueva PC.
2. Descomprímelo en cualquier carpeta de la nueva PC:
   ```bash
   tar -xzf terminal_backup.tar.gz
   ```
3. Entra a la carpeta descomprimida y dale permisos de ejecución a `restore.sh`:
   ```bash
   chmod +x restore.sh
   ```
4. Ejecuta el script de restauración:
   ```bash
   ./restore.sh
   ```
5. Reinicia la terminal o ejecuta `source ~/.zshrc`.

### Requisitos adicionales
Asegúrate de instalar en tu nuevo sistema:
* **eza** (ej. `sudo apt install eza` o `brew install eza`)
* **zoxide** (ej. `sudo apt install zoxide` o `brew install zoxide`)
* **fzf** (ej. `sudo apt install fzf` o `brew install fzf`)
