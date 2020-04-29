library(usethis)

cn <- c("date", "country_region", "province_state", "type", "cases")
filename <- 'data-raw/c19tr.csv'
c19tr <- read.csv2(filename, na.strings = "",
                   colClasses = c("Date", "integer", "integer",
                                "integer", "integer", "integer", "integer"))
c19tr$recovered <- as.integer(zoo::na.approx(c19tr$recovered))
c19tr$active <- with(c19tr, confirmed - deaths - recovered)
c19trl <- reshape2::melt(c19tr, id.vars = c("date"), variable.name = "type", value.name = "cases")
c19trl$type <- as.character(c19trl$type)
c19trl$country_region <- "Turkey"
c19trl$province_state <- NA
c19trl <- c19trl[,cn]
c19trl <- c19trl[order(c19trl$date, c19trl$type),]
c19trl$country_region <- factor(c19trl$country_region)
c19trl$province_state <- factor(c19trl$province_state)
substring(c19trl$type, 1) <- toupper(substring(c19trl$type, 1, 1))
c19trl$type <- factor(c19trl$type)

use_data(c19tr, c19trl, overwrite = TRUE)

# ---------

filename <- 'data-raw/c19tr_provinces.csv'
c19trp <- read.csv2(filename, na.strings = "")
c19trp <- c19trp[order(c19trp$province),]
for (i in 1:3) c19trp[,i] <- factor(c19trp[,i])
c19trp$lat <- as.numeric(c19trp$lat)
c19trp$long <- as.numeric(c19trp$long)

c19trp <- reshape2::melt(c19trp, id.vars = 1:6, variable.name = "date", value.name = "cases")
c19trp$date <- as.Date(c19trp$date, "X%Y.%m.%d")
c19trp <- c19trp[,c(7, 2:3, 8)]

use_data(c19trp, overwrite = TRUE)
