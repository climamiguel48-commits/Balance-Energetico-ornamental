
#Cuando actualices las bases cada 15 días, 
#basta con reemplazar los archivos dentro de la carpeta `data/` manteniendo los mismos nombres.

## Recomendación para actualización quincenal

1. Reemplazar el Excel correspondiente dentro de `data/`.
2. Mantener exactamente el mismo nombre del archivo.
3. Ejecutar `quarto render`.
4. Subir los cambios a GitHub.

::: {.callout-note}
La lectura de datos fue ajustada para evitar errores por columnas con tipos mixtos entre archivos, como `RECORD`. El sitio lee las bases inicialmente como texto y luego convierte solo las variables necesarias para graficar.
:::