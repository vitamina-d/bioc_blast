library(plumber)
library(jsonlite)
#* BLASTP
#* @tag BLAST 
#* @param sequence:string 
#* @post /
#* @serializer unboxedJSON 

function(sequence) {

    start_time <- Sys.time()

    tmpfile <- tempfile(fileext = ".fna")
    writeLines(sequence, tmpfile)
  
    cmd <- c(
        "-query", tmpfile, 
        "-db", "/blast/blastdb/pdbaa", 
        "-outfmt", "15"
    )

    out <- system2("blastp", args = cmd, stdout = TRUE, stderr = TRUE)

    #deserialize
    out_text <- paste(out, collapse = "\n")
    result <- jsonlite::fromJSON(out_text, simplifyVector = FALSE)
    
    unlink(tmpfile) 
    
    end_time <- Sys.time()
    time <- as.numeric(difftime(end_time, start_time, units = "secs"))

    response <- list(
            code = 200,
            datetime = start_time,
            time_secs = time,
            data = list (
                message = "Ok.",
                blast = result
            )
        )
}
