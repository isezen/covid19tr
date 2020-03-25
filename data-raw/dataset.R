library(usethis)

cn <- c("date", "country_region", "province_state", "type",
        "cases", "lat", "long")
filename <- 'data-raw/c19tr_w.csv'
c19tr_w <- read.csv2(filename, na.strings = "",
                   colClasses = c("POSIXct", "integer", "integer",
                                "integer", "integer"))
c19tr_l <- reshape2::melt(c19tr_w, id.vars = c("date"), variable.name = "type", value.name = "cases")
c19tr_l$country_region <- "Turkey"
c19tr_l$province_state <- NA
c19tr_l$lat <- 38.9637
c19tr_l$long <- 35.2433
c19tr_l <- c19tr_l[,cn]
c19tr_l <- c19tr_l[order(c19tr_l$date, c19tr_l$type),]
c19tr_l$country_region <- factor(c19tr_l$country_region)
c19tr_l$province_state <- factor(c19tr_l$province_state)
c19tr_l$type <- factor(c19tr_l$type)

use_data(c19tr_w, c19tr_l, overwrite = TRUE)

cmd <- "write.csv2(%s, 'data-raw/%s.csv', row.names = FALSE, quote = FALSE, na = '')"
for (data_name in list("c19dw_w", "c19ra_w", "c19jh_w")) {
  eval(parse(text = sprintf(cmd, data_name, data_name)))
}

