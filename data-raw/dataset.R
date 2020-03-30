library(usethis)

cn <- c("date", "country_region", "province_state", "type",
        "cases", "lat", "long")
filename <- 'data-raw/c19trw.csv'
c19trw <- read.csv2(filename, na.strings = "",
                   colClasses = c("Date", "integer", "integer",
                                "integer", "integer", "integer", "integer"))
c19trl <- reshape2::melt(c19trw, id.vars = c("date"), variable.name = "type", value.name = "cases")
c19trl$type <- as.character(c19trl$type)
c19trl$country_region <- "Turkey"
c19trl$province_state <- NA
c19trl$lat <- 38.9637
c19trl$long <- 35.2433
c19trl <- c19trl[,cn]
c19trl <- c19trl[order(c19trl$date, c19trl$type),]
c19trl$country_region <- factor(c19trl$country_region)
c19trl$province_state <- factor(c19trl$province_state)
substring(c19trl$type, 1) <- toupper(substring(c19trl$type, 1, 1))
c19trl$type <- factor(c19trl$type)

use_data(c19trw, c19trl, overwrite = TRUE)
