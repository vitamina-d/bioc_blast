library(plumber)
library(jsonlite)
#* BLASTX traduce en los 6 marcos de lectura posibles y busca similitudes contra proteínas del PDB
#* @tag BLAST 
#* @param sequence:string
#* @post /
#* @serializer unboxedJSON 

function(sequence) {

    cat("SEQUENCE: ", sequence, "\n")
    
    tmpfile <- tempfile(fileext = ".fna")
    cat("TEMP: ", tmpfile, "\n")

    writeLines(sequence, tmpfile)
  
    cmd <- c(
        "-query", tmpfile, 
        "-db /opt/blast/blastdb/pdbaa", 
        "-outfmt", "15"
    )

    cat("CMD: ", cmd, "\n")

    out <- tryCatch({
        cat("-----------START tryCatch", "\n")
        res <- system2("blastx", args = cmd, stdout = TRUE, stderr = TRUE)
        cat("-----------END tryCatch", "\n")
        res
    }, error = function(e) {
        cat("ERROR en tryCatch:", conditionMessage(e), "\n")
        NULL
    })
    
    unlink(tmpfile) 

    if (is.null(out)) {
        cat("OUT IS NULL", "\n")

        response <- list(
            code = 500,
            message = "try catch",
            data = NULL
        )

    } else {
        cat("OUT IS NOT NULL", "\n")

        cat("OUT IS: ", paste(out, collapse = "\n"), "\n")
#SOLUCION
        out_text <- paste(out, collapse = "\n")
        out_text <- iconv(out_text, from = "", to = "UTF-8", sub = "byte")  # limpia cualquier carácter problemático
# Parsear JSON con tryCatch
        result <- tryCatch({
            jsonlite::fromJSON(out_text, simplifyVector = FALSE)
        }, error = function(e) {
            cat("ERROR jsonlite::fromJSON------------- ", "\n")
        })
        
        response <- list(
            code = 200,
            message = "Ok",
            data = result
        )
    }
    return(response)
}
# → qseq = la región traducida de la secuencia.