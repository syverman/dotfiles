#!/bin/bash

# Ruta de la imagen del fondo de pantalla
WALLPAPER_PATH="$1"

# Verifica si se proporcionó una ruta de imagen
if [ -z "$WALLPAPER_PATH" ]; then
    echo "Uso: $0 <ruta_a_la_imagen>"
    exit 1
fi

# 1. Ejecuta Pywal para generar el esquema de colores a partir de la imagen
#    Esto crea archivos de configuración en ~/.cache/wal/
wal -i "$WALLPAPER_PATH"

# 2. Establece el fondo de pantalla con swww
#    Aquí puedes personalizar las opciones de transición de swww.
#    -t <tipo_transicion>: wipe, grow, outer, fade, wave, circle, simple, etc.
#    --transition-step: Cantidad de pasos en la animación. Mayor = más suave.
#    --transition-duration: Duración de la transición en segundos.
#    --transition-fps: FPS de la animación (opcional, si quieres controlarlo).
swww img "$WALLPAPER_PATH" \
    --transition-type outer \
    --transition-step 30 \
    --transition-duration 0.7 \
    --transition-fps 60

# 3. Recarga la configuración de Hyprland
#    Esto fuerza a Hyprland a leer el archivo de colores actualizado de Pywal
hyprctl reload

# 4. Opcional: Recargar otras aplicaciones para que tomen los nuevos colores
#    Esto depende de cómo hayas configurado cada aplicación para Pywal.
#    Revisa ~/.cache/wal/ para ver qué archivos genera Pywal para tus apps.

# Ejemplo para Waybar (si está configurada para leer ~/.cache/wal/colors-waybar.css)
pkill waybar && waybar & # Reiniciar Waybar completamente
# O si solo necesita recargarse:
# killall -SIGUSR2 waybar

# Ejemplo para Kitty Terminal (si está configurada para usar el archivo de Pywal)
# Kitty soporta recargar colores sin reiniciar
 kitty @ set-colors -a ~/.cache/wal/colors-kitty.conf

# Ejemplo para Alacritty (necesita reiniciar para tomar los colores)
# killall -SIGUSR1 alacritty

# Puedes añadir cualquier otra aplicación que necesite recargarse.
