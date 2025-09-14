FROM veroyols/blast-r:latest

WORKDIR /bservice
COPY . .
EXPOSE 8001

CMD ["R", "-e", "library(plumber); api <- Plumber$new('blast_api.R'); api$run(host='0.0.0.0', port=8001)"]
