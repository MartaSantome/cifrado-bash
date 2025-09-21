#!/bin/bash

# Uso: ./cipher.sh "mensaje" "clave_sustitucion" "clave_transposicion"
# Ejemplo: ./cipher.sh "HELLO" "QWERTYUIOPASDFGHJKLZXCVBNM" 4

mensaje="$1"
clave_sustitucion="$2"
clave_transposicion="$3"

# 1. Cifrado de sustitución
mensaje_sustitucion=$(echo "$mensaje" | tr 'A-Z' "$clave_sustitucion" | tr 'a-z' 'A-Z')

# 2. Cifrado de transposición
mensaje_limpio=$(echo "$mensaje_sustitucion" | tr -d ' ')
longitud=${#mensaje_limpio}
columnas=$clave_transposicion

# Rellenamos con X si no es divisible por el número de columnas
while (( longitud % columnas != 0 )); do
    mensaje_limpio="${mensaje_limpio}X"
    longitud=${#mensaje_limpio}
done

# Escribimos el mensaje en filas
echo "Mensaje tras sustitución (con relleno): $mensaje_limpio"

# Creamos un archivo temporal para ayudar con la transposición
temp_file=$(mktemp)
echo "$mensaje_limpio" | fold -w$columnas > "$temp_file"

# Leemos por columnas
mensaje_transposicion=""
for ((i=0; i<columnas; i++)); do
    columna=$(cut -c $((i+1)) "$temp_file" | tr -d '\n')
    mensaje_transposicion="$mensaje_transposicion$columna"
done

# Limpiamos el archivo temporal
rm "$temp_file"

echo "Mensaje original: $mensaje"
echo "Tras sustitución: $mensaje_sustitucion"
echo "Tras transposición: $mensaje_transposicion"
