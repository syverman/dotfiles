#!/bin/bash

# ===============================================================================
# SCRIPT CREADOR DE INSTALADORES
# Descripción: Este script genera automáticamente un archivo llamado
#              'instalar_apps.sh' con la lista de tus aplicaciones instaladas
#              actualmente en el sistema.
# Uso: ./crear_script_instalador.sh
# ===============================================================================

echo "Analizando las aplicaciones instaladas en tu sistema CachyOS..."

# -------------------------------------------------------------------------------
# 1. Obtener la lista de aplicaciones instaladas
# -------------------------------------------------------------------------------
# 'pacman -Qqen': Lista los paquetes instalados de forma explícita desde los repositorios oficiales.
# 'pacman -Qqem': Lista los paquetes instalados de forma explícita desde el AUR.
# La salida de ambos comandos se almacena en la variable 'APPS_LIST'.
APPS_LIST=$(pacman -Qqen && pacman -Qqem)

# Verificar si la lista está vacía.
if [ -z "$APPS_LIST" ]; then
    echo "Error: No se encontraron aplicaciones para la lista. ¿Hay paquetes instalados explícitamente?"
    exit 1
fi

echo "¡Lista de aplicaciones obtenida con éxito!"

# -------------------------------------------------------------------------------
# 2. Generar el script de instalación final
# -------------------------------------------------------------------------------
OUTPUT_FILE="instalar_apps.sh"

echo "Creando el script de instalación en '$OUTPUT_FILE'..."

# Usamos un 'here-document' para escribir el contenido del nuevo script
# y rellenar el array 'APPS' con la lista que acabamos de generar.
cat << EOF > "$OUTPUT_FILE"
#!/bin/bash

# ===============================================================================
# SCRIPT ÚNICO: instalar_apps.sh (GENERADO AUTOMÁTICAMENTE)
# Descripción: Este script instala una lista predefinida de aplicaciones
#              usando el gestor de paquetes 'yay' para CachyOS (Arch).
#              La lista de aplicaciones se generó automáticamente desde
#              tu sistema actual.
# ===============================================================================

# -------------------------------------------------------------------------------
# Lista de aplicaciones a instalar
# Puedes editar esta lista si quieres agregar o quitar paquetes.
# -------------------------------------------------------------------------------
APPS=(
$(echo "$APPS_LIST")
)

# -------------------------------------------------------------------------------
# Lógica de instalación (no es necesario modificar esta sección)
# -------------------------------------------------------------------------------

# Verificar si 'yay' está instalado.
if ! command -v yay &> /dev/null; then
    echo "Error: 'yay' no está instalado. Por favor, instálalo para continuar."
    exit 1
fi

echo "Iniciando la instalación de las siguientes aplicaciones:"
echo "\${APPS[@]}"
echo "---"
echo "Se te pedirá confirmación una única vez antes de la instalación."
echo "---"

# Usar yay para instalar todos los paquetes de una vez.
# --needed: No reinstalar los paquetes que ya están instalados.
yay -S --needed "\${APPS[@]}"

echo "¡Proceso de instalación completado! Revisa la salida para ver si hay errores."

EOF

# -------------------------------------------------------------------------------
# 3. Dar permisos de ejecución al nuevo script
# -------------------------------------------------------------------------------
chmod +x "$OUTPUT_FILE"

echo "¡Listo! Se ha creado el script '$OUTPUT_FILE' y se le han dado permisos de ejecución."
echo "Puedes copiar este archivo a tu nueva instalación de CachyOS y ejecutarlo para instalar tus aplicaciones."
