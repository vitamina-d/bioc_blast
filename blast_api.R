library(plumber)

#* @apiTitle BLAST
#* @apiDescription API BLAST

api <- Plumber$new()
api$mount("/echo", Plumber$new("endpoints/echo.R"))
#api$mount("/blastx", Plumber$new("endpoints/blastx.R"))
#api$mount("/blastp", Plumber$new("endpoints/blastp.R"))

api$run(host = "0.0.0.0", port = 8001)
