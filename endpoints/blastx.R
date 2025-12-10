library(plumber)
library(jsonlite)
#* BLASTX traduce en los 6 marcos de lectura posibles y busca similitudes contra proteínas del PDB
#* @tag BLAST 
#* @param sequence:string
#* @post /
#* @serializer unboxedJSON 

function(sequence) {
    tmpfile <- tempfile(fileext = ".fna")
    writeLines(sequence, tmpfile)
    cmd <- c(
        "-query", tmpfile, 
        "-db /opt/blast/swissprot/swissprot", 
        "-outfmt", "15"
    )
    out <- tryCatch({
        res <- system2("blastx", args = cmd, stdout = TRUE, stderr = TRUE)
        res
    }, error = function(e) {
        NULL
    })
    unlink(tmpfile) 
    if (is.null(out)) {
        response <- list(
            code = 500,
            message = "try catch",
            data = NULL
        )
    } else {
        out_text <- paste(out, collapse = "\n")
        out_text <- iconv(out_text, from = "", to = "UTF-8", sub = "byte")  
        result <- tryCatch({
            jsonlite::fromJSON(out_text, simplifyVector = FALSE)
        }, error = function(e) {})
        response <- list(
            code = 200,
            message = "Ok",
            data = result
        )
    }
    return(response)
}