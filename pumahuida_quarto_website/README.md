# Proyecto Pumahuida — Quarto Website

## Cómo previsualizar el sitio completo

IMPORTANTE: no uses `quarto preview index.qmd`, porque eso renderiza solo la página de inicio. Si haces eso, las pestañas del menú pueden mostrar `Not found` porque las otras páginas no fueron generadas.

Usa este flujo:

```bash
cd pumahuida_quarto_website
quarto preview
```

O, si quieres renderizar todo el sitio primero:

```bash
cd pumahuida_quarto_website
quarto render
```

Luego abre:

```bash
docs/index.html
```

## En Windows

También puedes hacer doble clic en:

- `preview_sitio.bat` para previsualizar el sitio completo.
- `render_sitio.bat` para generar todos los HTML dentro de la carpeta `docs`.

## Actualización quincenal de datos

Cada 15 días reemplaza los Excel dentro de la carpeta `data/` manteniendo exactamente los mismos nombres de archivo. Luego ejecuta:

```bash
quarto render
```

## Descargas

Los archivos descargables están declarados como recursos en `_quarto.yml`, por lo que Quarto los copia al sitio publicado.
