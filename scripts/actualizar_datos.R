# Revisión rápida de archivos antes de renderizar el sitio
library(readxl)
library(dplyr)
library(purrr)

archivos <- list.files("data", pattern = "xlsx$", full.names = TRUE)

map_df(archivos, function(x) {
  tibble(
    archivo = basename(x),
    filas = nrow(read_excel(x, n_max = Inf)),
    columnas = ncol(read_excel(x, n_max = 0)),
    modificado = file.info(x)$mtime
  )
}) |> print()
