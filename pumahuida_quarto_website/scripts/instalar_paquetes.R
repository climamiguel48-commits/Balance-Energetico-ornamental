# Ejecutar una sola vez si falta algún paquete
paquetes <- c(
  "readxl", "dplyr", "lubridate", "readr", "stringr", "purrr",
  "ggplot2", "plotly", "DT", "tidyr", "tibble"
)
instalados <- rownames(installed.packages())
faltantes <- setdiff(paquetes, instalados)
if (length(faltantes) > 0) install.packages(faltantes)
