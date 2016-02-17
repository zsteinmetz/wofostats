#' @title Write CABO weather files
#'
#' @description
#' \code{write.cabo} prints weather files as used by WOFOST e.g. from
#' MARS AGRI4CAST data (\url{http://agri4cast.jrc.ec.europa.eu/DataPortal/Default.aspx})
#' being composed of one file per year.
#'
#' @param data E.g. a MARS AGRI4CAST weather data.frame containing at least the
#' following columns: LATITUDE, LONGITUDE, ALTITUDE, DAY, TEMPERATURE_MAX,
#' TEMPERATURE_MIN, PRECIPITATION, RADIATION; ET0 is optional
#' @param country The country where the weather station is located
#' @param station The name of the weather station
#' @param stationno The number of the weather station
#' @param lat The latitude of the weather station
#' @param lon The longitude of the weather station
#' @param alt The altitude/elevation of the weather station
#' @param a,b Ångström coefficients
#' @param citation Reference information on the data set (optional)
#' @param author The author of the data set
#' @param desc A short description of the respective data set
#' @param file The path/file where the CABO output files should be written to
#'
write.cabo <- function(data, country, station, stationno, lat, lon, alt, a, b,
                       citation = NA, author = Sys.getenv("USERNAME"),
                       desc = NA, file) {
  year <- as.numeric(format(data$Date, "%Y"))
  for (yr in unique(year)) {
    if (missing(file)) {
      fext <- paste(substr(country,1,2), substr(station,1,2), '.', substr(yr, 2, 4), sep="")
    } else {
      fext <- paste(file, '.', substr(yr, 2, 4), sep="")
    }
    thefile <- file(fext, "w")

    header <- paste(
      "*-------------------------------------------------------------------------*", "\n",
      "*\n",
      "*   File name: ", fext, "\n",
      "* Description: ", desc, "\n",
      "*\n",
      "*-------------------------------------------------------------------------*", "\n",
      "*     Country: ", country, "\n",
      "*     Station: ", station, "\n",
      "* Station No.: ", stationno, "\n",
      "*        Year: ", yr, "\n",
      "*      Source: ", citation, "\n",
      "*      Author: ", author, "\n",
      "*   Longitude: ", lon, "\n",
      "*    Latitude: ", lat, "\n",
      "*   Elevation: ", alt, "\n",
      "*", "\n",
      "*  Columns", "\n",
      "*  =======", "\n",
      "*  Station number", "\n",
      "*  Year", "\n",
      "*  Julian day", "\n",
      "*  Irradiation (kJ m-2 d-1)", "\n",
      "*  Minimum temperature (degrees Celsius)", "\n",
      "*  Maximum temperature (degrees Celsius)", "\n",
      "*  Vapour pressure (kPa)", "\n",
      "*  Mean wind speed 2 m above ground level (m s-1)", "\n",
      "*  precipitation (mm d-1)", "\n",
      "* \n",
      "** WCCDESCRIPTION=", country, ", ", station, "\n",
      "** WCCFORMAT=2", "\n",
      "** WCCYEARNR=", yr, "\n",
      "*-------------------------------------------------------------------------*", "\n",
      "   ", lon, "  ", lat, "  ", alt, "  ", a, "  ", b, "\n",
      sep="")

    yw <- data[year==yr,]
    yw[is.na(yw)] <- -99
    body <- character()
    for (i in 1:length(yw[,1])) {
      d <- as.numeric(substr(yw$DOY[i], 5, 7))
      m <- as.numeric(format(yw$Date[i], "%m"))
      body <- paste(body,
                    sprintf("%4s", stationno),
                    sprintf("%6.0f", yr),
                    sprintf("%6.0f", d),
                    sprintf("%9.2f", yw$SRAD[i]), sprintf("%6.1f", yw$TMIN[i]),
                    sprintf("%6.1f", yw$TMAX[i]), sprintf("%6.2f", yw$VAP[i]),
                    sprintf("%6.1f", yw$WIND[i]), sprintf("%6.1f", yw$PREC[i]),
                    "\n", sep="")
    }
    cat(header, body, file = thefile, sep = "")
    close(thefile)
  }
}
