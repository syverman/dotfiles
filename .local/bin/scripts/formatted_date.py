#!/usr/bin/env python3
import datetime
import locale
import sys

# Configurar la localización a español (Chile)
try:
    locale.setlocale(locale.LC_TIME, 'es_CL.UTF-8')
except locale.Error:
    print("Error: No se pudo configurar la localización a 'es_CL.UTF-8'.", file=sys.stderr)
    print("Asegúrate de que esté generada en tu sistema.", file=sys.stderr)
    pass

now = datetime.datetime.now()

# Formatear la fecha y hora en español
formatted_string = now.strftime('%A %d | %H:%M')

# Separar el nombre del día del resto del string
parts = formatted_string.split(' ', 1)

if len(parts) > 1:
    day_name = parts[0]        # Ejemplo: 'sábado'
    rest_of_string = parts[1]  # Ejemplo: '27 - 17:25'

    # *** CAMBIO AQUÍ ***
    # Convertir solo la primera letra del nombre del día a mayúsculas
    capitalized_day_name = day_name.capitalize() # Ejemplo: 'Sábado'

    # Reconstruir el string final
    final_string = f"{capitalized_day_name} {rest_of_string}"
else:
     # Fallback (muy improbable)
     final_string = formatted_string.capitalize()


# Imprime el resultado final
print(final_string)
