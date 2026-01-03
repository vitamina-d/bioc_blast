# 🔬 bioc_blast

Servicio BLAST del proyecto **Vitamina-D** para análisis de alineamiento de secuencias contra bases de datos de proteínas.

## 📋 Descripción

**bioc_blast** es un microservicio especializado que proporciona capacidades de análisis BLASTx (Basic Local Alignment Search Tool) a través de una API REST construida con R y Plumber. El servicio permite traducir secuencias de ADN en los 6 marcos de lectura posibles y buscar similitudes contra la base de datos SwissProt.

## ✨ Funcionalidades

### 🧬 BLASTx
- Traducción automática de secuencias de nucleótidos en los 6 marcos de lectura
- Búsqueda de similitudes contra proteínas en SwissProt
- Resultados en formato JSON estructurado
- Manejo robusto de errores y secuencias sin hits

## 🛠️ Stack Tecnológico

### Backend
- **R** - Lenguaje de programación estadístico
- **Plumber** - Framework para crear APIs REST en R
- **BLAST+** - Suite de herramientas NCBI BLAST

### Base de Datos
- **SwissProt** - Base de datos curada de secuencias proteicas
  - Parte de UniProtKB
  - Anotaciones manuales de alta calidad
  - Información funcional detallada

### Infraestructura
- **Docker** - Contenedorización del servicio
- **Imagen base**: `veroyols/blast-r:swissprot`
  - R con Bioconductor preinstalado
  - BLAST+ configurado
  - Base de datos SwissProt incluida

## 📁 Estructura del Proyecto

```
bioc_blast/
├── endpoints/
│   └── blastx.R          # Endpoint BLASTx
├── blast_api.R           # API principal de Plumber
├── Dockerfile            # Configuración Docker
├── blast.xml             # Ejemplo de resultado BLAST
├── blastx api.txt        # Ejemplo con hits
└── blastx api no hits.txt # Ejemplo sin hits
```

## 🚀 Inicio Rápido

### Con Docker

```bash
git clone https://github.com/vitamina-d/bioc_blast.git
cd bioc_blast

docker build -t bioc_blast .
docker run -p 8001:8001 bioc_blast
```

## 📡 API Reference

### Endpoint BLASTx

**POST** `/blastx/`

Realiza un análisis BLASTx traduciendo la secuencia de nucleótidos y buscando similitudes contra SwissProt.

#### Request Body

```json
{
  "sequence": "ATGGCTAGCTAGCTAGC..."
}
```

#### Parámetros

| Parámetro |  Tipo  | Descripción |
|-----------|--------|-------------|
| sequence  | string | Secuencia de nucleótidos en formato FASTA o texto plano |

#### Response Success (200)

```json
{
  "code": 200,
  "message": "Ok",
  "data": {
    "BlastOutput2": [
      {
        "report": {
          "results": {
            "search": {
              "hits": [
                {
                  "description": "...",
                  "accession": "P12345",
                  "len": 500,
                  "hsps": [...]
                }
              ]
            }
          }
        }
      }
    ]
  }
}
```

#### Response Error (500)

```json
{
  "code": 500,
  "message": "try catch",
  "data": null
}
```

## 🔧 Configuración

### Dockerfile

```dockerfile
FROM veroyols/blast-r:swissprot

WORKDIR /bservice
COPY . .
EXPOSE 8001

CMD ["R", "-e", "library(plumber); api <- Plumber$new('blast_api.R'); api$run(host='0.0.0.0', port=8001)"]
```

### Variables de Entorno

La base de datos SwissProt está incluida en la imagen base.

## 🧬 Detalles del Algoritmo BLASTx

### ¿Qué es BLASTx?

BLASTx traduce una secuencia de nucleótidos (ADN/ARN) en sus 6 posibles marcos de lectura (3 forward + 3 reverse) y compara las traducciones de proteínas contra una base de datos de proteínas.

### Pasos del Procesamiento

1. **Entrada**: Secuencia de nucleótidos
2. **Traducción**: Conversión a proteínas en 6 marcos de lectura
3. **Búsqueda**: Comparación contra SwissProt usando el algoritmo BLAST
4. **Scoring**: Cálculo de scores de similitud (E-value, bit score)
5. **Filtrado**: Selección de hits significativos
6. **Formato**: Conversión a JSON estructurado

### Parámetros BLAST Utilizados

- `-query`: Archivo temporal con la secuencia
- `-db`: Ruta a la base de datos SwissProt
- `-outfmt 15`: Formato de salida JSON

## 📊 Interpretación de Resultados

### Hits Encontrados

Cuando se encuentran similitudes, el resultado incluye:

- **Accession**: Identificador UniProt de la proteína
- **Description**: Descripción funcional de la proteína
- **Length**: Longitud de la secuencia proteica
- **HSPs** (High-scoring Segment Pairs):
  - **E-value**: Valor esperado (menor = mejor)
  - **Bit score**: Puntuación normalizada
  - **Identity**: Porcentaje de identidad
  - **Query coverage**: Cobertura de la consulta
  - **Alignments**: Alineamientos detallados

### Sin Hits

Si no se encuentran similitudes significativas, el resultado indicará que no hay matches en la base de datos.

## 🔗 Integración con el Ecosistema

**bioc_blast** se integra con:

- **[bioc_back](https://github.com/vitamina-d/bioc_back)** - API que consume este servicio
- **[bioc_front](https://github.com/vitamina-d/bioc_front)** - Visualización de resultados BLAST

### Flujo de Integración

```
Frontend (React)
      ↓
   Backend (ASP.NET)
      ↓
   bioc_blast (R/Plumber)
      ↓
   SwissProt Database
```

## 📝 Licencia

Este proyecto tiene fines educativos y forma parte del Proyecto Integrador Profesional (PIP).
