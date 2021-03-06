#' Download official data of urbanized areas in Brazil as an sf object.
#'
#' This function reads the official data on the urban footprint of Brazilian cities
#' in the years 2005 and 2015. Orignal data were generated by Institute of Geography
#' and Statistics (IBGE)  For more information about the methodology, see deails at
#' https://biblioteca.ibge.gov.br/visualizacao/livros/liv100639.pdf
#'
#'
#' @param year A year number in YYYY format (defaults to 2015)
#' @param tp Whether the function returns the 'original' dataset with high resolution or a dataset with 'simplified' borders (Default)
#' @export
#' @examples \donttest{
#'
#' library(geobr)
#'
#' # Read urban footprint of Brazilian cities in an specific year
#'   d <- read_urban_area(year=2005)
#'
#' }
#'
#'
read_urban_area <- function(year=NULL, tp="simplified"){

  # Get metadata with data addresses
  metadata <- download_metadata()

  # Select geo
  temp_meta <- subset(metadata, geo=="urban_area")

  # Select data type
  temp_meta <- select_data_type(temp_meta, tp)

  # Verify year input
  if (is.null(year)){ message("Using latest data available, from year 2015\n")
    year <- 2015
    temp_meta <- subset(temp_meta, year==2015)

  } else if (year %in% temp_meta$year){ temp_meta <- temp_meta[temp_meta[,2] == year, ]

  } else { stop(paste0("Error: Invalid Value to argument 'year'. It must be one of the following: ",
                       paste(unique(temp_meta$year),collapse = " ")))
  }


  # list paths of files to download
  filesD <- as.character(temp_meta$download_path)

  # download files
  temps <- download_gpkg(filesD)


  # read sf
  temp_sf <- sf::st_read(temps, quiet=T)
  return(temp_sf)
}
