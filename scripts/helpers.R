# Funciones comunes para el sitio Quarto Pumahuida
library(readxl)
library(dplyr)
library(lubridate)
library(readr)
library(stringr)
library(purrr)

read_excel_text <- function(path, grupo = NULL) {
  # Lee todo como texto para evitar errores al unir archivos con tipos mixtos
  nm <- names(readxl::read_excel(path, n_max = 0))
  df <- readxl::read_excel(path, col_types = rep("text", length(nm)))
  names(df) <- make.names(names(df), unique = TRUE)
  if (!is.null(grupo)) df$grupo <- grupo
  df
}

parse_num_safe <- function(x) {
  readr::parse_number(as.character(x), locale = readr::locale(decimal_mark = ".", grouping_mark = ","))
}

parse_datetime_safe <- function(x) {
  x <- as.character(x)
  out <- suppressWarnings(lubridate::ymd_hms(x, tz = "America/Santiago"))
  idx <- is.na(out)
  if (any(idx)) out[idx] <- suppressWarnings(lubridate::ymd_hm(x[idx], tz = "America/Santiago"))
  idx <- is.na(out)
  if (any(idx)) out[idx] <- suppressWarnings(as.POSIXct(as.numeric(x[idx]) * 86400, origin = "1899-12-30", tz = "America/Santiago"))
  out
}

first_existing <- function(df, candidates) {
  candidates <- make.names(candidates, unique = FALSE)
  found <- candidates[candidates %in% names(df)]
  if (length(found) == 0) return(rep(NA_real_, nrow(df)))
  parse_num_safe(df[[found[1]]])
}

first_datetime <- function(df) {
  candidates <- c("fecha_hora", "TIMESTAMP", "TIMESTAMP_START", "DateTime", "datetime", "Fecha", "fecha")
  candidates <- make.names(candidates, unique = FALSE)
  found <- candidates[candidates %in% names(df)]
  if (length(found) > 0) return(parse_datetime_safe(df[[found[1]]]))
  rep(as.POSIXct(NA), nrow(df))
}

read_parcelas <- function() {
  files <- list(
    CAE1 = "data/datos_horario_LE_corregidos_final_CAE1.xlsx",
    CAE2 = "data/datos_horario_LE_corregidos_final_CAE2.xlsx",
    Exotico = "data/datos_horario_LE_corregidos_final_exotico.xlsx"
  )
  purrr::imap_dfr(files, ~ read_excel_text(.x, .y)) |>
    mutate(
      fecha_hora = first_datetime(cur_data()),
      fecha = as.Date(fecha_hora),
      LE = first_existing(cur_data(), c("LE_corregido", "LE", "LE_estimado", "LE_Wm2", "LE.ECrot", "LE_Avg")),
      H = first_existing(cur_data(), c("H_corregido", "H", "H_estimado", "H_Wm2", "H.ECrot", "H_Avg")),
      Rn = first_existing(cur_data(), c("Rn", "RN", "NR_Wm2_Avg", "CNR_Wm2_Avg", "Rn_Avg", "RN_Avg")),
      G = first_existing(cur_data(), c("G", "G_std", "flujo_calor_plato", "SHF_Avg", "G1_Avg")),
      temp_aire = first_existing(cur_data(), c("temp_aire", "AirT_C_Avg", "TT_C", "TT_C_Avg", "Tair", "TA")),
      temp_superficie = first_existing(cur_data(), c("temp_superficie", "SBT_C", "SBT_C_Avg", "Ts", "Tsup", "IRT_C_Avg")),
      humedad_suelo = first_existing(cur_data(), c("humedad_volumetrica", "SWC_40CM", "SWC_5CM_Avg", "VWC_1", "VWC", "Humedad")),
      lluvia = first_existing(cur_data(), c("Rain_mm_Tot", "Precip", "P", "precipitacion", "lluvia")),
      ETo = first_existing(cur_data(), c("ETos", "ETo", "ETo_FAO", "ET0"))
    )
}

summarise_daily <- function(df) {
  df |>
    filter(!is.na(fecha)) |>
    group_by(grupo, fecha) |>
    summarise(
      LE_medio = mean(LE, na.rm = TRUE),
      H_medio = mean(H, na.rm = TRUE),
      Rn_medio = mean(Rn, na.rm = TRUE),
      G_medio = mean(G, na.rm = TRUE),
      temp_aire = mean(temp_aire, na.rm = TRUE),
      temp_superficie = mean(temp_superficie, na.rm = TRUE),
      humedad_suelo = mean(humedad_suelo, na.rm = TRUE),
      lluvia = sum(lluvia, na.rm = TRUE),
      ETo = sum(ETo, na.rm = TRUE),
      registros = n(),
      .groups = "drop"
    ) |>
    mutate(across(where(is.numeric), ~ ifelse(is.nan(.x), NA_real_, .x)))
}
