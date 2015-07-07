#' @title Fixed-format tables
#'
#' @description
#' Generic function to convert a fixed-format Fortran table into a \code{data.frame}.
#' @usage
#' tt2df(data, col.names, prefix, suffix)
#'
#' @param data Table body as vector of strings as read, e.g., by \code{readLines}
#' @param col.names Column names as string separated by whitespaces
#' @param prefix Optional data to insert before the data table
#' @param suffix Optional data to insert after the data table
#'
#' @seealso
#' \code{\link{read.wofost}}
#'
tt2df <- function(data, col.names, prefix, suffix) {
  df <- data.frame(matrix(unlist(strsplit(data, "\\s+")),
                          nrow=length(data), byrow=T))[,-1]
  names(df) <- unlist(strsplit(col.names, "\\s+"))[-1]
  for (i in names(df)) df[,i] <- type.convert(as.character(df[,i]))

  if (missing(prefix) & missing(suffix)) out <- df
  if (missing(prefix) & !missing(suffix)) out <- cbind(df, suffix)
  if (!missing(prefix) & missing(suffix)) out <- cbind(prefix, df)
  if (!missing(prefix) & !missing(suffix)) out <- cbind(prefix, df, suffix)

  return(out)
}

#' @title Read WOFOST results
#'
#' @description
#' Read WOFOST output files (*.out, *.pps, or *.wps) into \R{}
#' @usage
#' read.wofost(file)
#'
#' @param file The name of the file which the data are to be read from.
#' Valid extensions are: *.out, *.pps, or *.wps
#'
#' @seealso
#' \code{\link{tt2df}}
#'
read.wofost <- function(file) {
  if (missing(file) | !grepl("\\.pps$|\\.wps$|\\.out$", file))
    stop("Specify WOFOST output file.")

  if (grepl("\\.pps$|\\.wps$", file)) {
    txt <- readLines(file)
    cols <- txt[grep("RUNNAM", txt)]
    data <- txt[(grep("RUNNAM", txt)+1):length(txt)]
    out <- tt2df(data, cols)
  }

  if (grepl("\\.out$", file)) {
    out <- list()
    txt <- readLines(file)
    run <- c(grep("RUNNAM", txt), length(txt)+1)

    for (i in 2:length(run)) {
      current <- txt[run[i-1]:(run[i]-1)]
      name <- trimws(unlist(strsplit(current[1], "->"))[2])
      header <- c()
      for (head in c("WEATHER", "CROP", "SOIL")) {
        header <- c(header, trimws(unlist(strsplit(grep(head, current, value=T), ":"))[2]))
      }
      start <- trimws(unlist(strsplit(grep("START", current, value=T), "->")))[2]
      dates <- unique(na.omit(as.numeric(unlist(strsplit(current[grep("START", current)+1], "[^0-9]+")))))
      dates[dates==99] <- NA

      type <- tolower(trimws(grep("CROP PRODUCTION", current, value = T)))

      cols <- current[grep("YEAR", current)]
      data <- current[(grep("YEAR", current)+3):(grep("SUMMARY", current)-2)]

      df <- tt2df(data, cols,
                  data.frame(RUNNAM=name, TYPE=type,
                             ISDAY=dates[1], DOS=dates[2], DOE=dates[3]),
                  data.frame(WEATHER=header[1], CROP=header[2], SOIL=header[3],
                             START=start))
      out[[type]] <- rbind(out[[type]], df)
    }
  }
  return(out)
}
