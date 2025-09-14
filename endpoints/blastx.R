library(plumber)
library(jsonlite)
#* BLASTX traduce en los 6 marcos de lectura posibles y busca similitudes contra proteínas del PDB
#* @tag BLAST 
#* @param sequence:string 
#* @get /
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

    out <- system2("blastx", args = cmd, stdout = TRUE, stderr = TRUE)

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
# → qseq = la región traducida de la secuencia.