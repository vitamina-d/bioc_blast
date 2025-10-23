library(plumber)

#* @apiTitle BLAST
#* @apiDescription API BLAST

api <- Plumber$new()
api$mount("/blastx", Plumber$new("endpoints/blastx.R"))

api$run(host = "0.0.0.0", port = 8001)
