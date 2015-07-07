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
#' @return
#' Returns a \code{list} when reading detailed crop outputs (*.out), otherwise a
#' \code{data.frame} is generated.
#'
read.wofost <- function(file) {
  if (missing(file) | !grepl("\\.pps$|\\.wps$|\\.out$", file))
    stop("Specify WOFOST output file.")

  if (grepl("\\.pps$|\\.wps$", file)) {
    text <- readLines(file)
    out <- read.table(textConnection(text),
                      skip = grep("RUNNAM", text))
    names(out) <- unlist(strsplit(text[grep("RUNNAM", text)], "\\s+"))[-1]
  }

  if (grepl("\\.out$", file)) {
    out <- list()
    text <- readLines(file)
    runs <- c(grep("RUNNAM", text), length(text)+1)

    for (i in 2:length(runs)) {
      current <- text[runs[i-1]:(runs[i]-1)]
      name <- trimws(unlist(strsplit(current[1], "->"))[2])
      header <- c()
      for (head in c("WEATHER", "CROP", "SOIL")) {
        header <- c(header, trimws(unlist(strsplit(grep(head, current, value=T), ":"))[2]))
      }
      start <- trimws(unlist(strsplit(grep("START", current, value=T), "->")))[2]
      dates <- unique(na.omit(as.numeric(unlist(strsplit(current[grep("START", current)+1], "[^0-9]+")))))
      dates[dates==99] <- NA
      type <- tolower(trimws(grep("CROP PRODUCTION", current, value = T)))

      df <- read.table(text = current,
                       skip = grep("YEAR", current)+2,
                       nrows = grep("SUMMARY", current)-grep("YEAR", current)-4)
      names(df) <- unlist(strsplit(current[grep("YEAR", current)], "\\s+"))[-1]
      df <- cbind(data.frame(RUNNAM=name, TYPE=type,
                             ISDAY=dates[1], DOS=dates[2], DOE=dates[3]),
                  df,
                  data.frame(WEATHER=header[1], CROP=header[2], SOIL=header[3],
                             START=start))
      out[[type]] <- rbind(out[[type]], df)
    }
  }
  return(out)
}
