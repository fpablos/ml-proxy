FROM golang:1.14
LABEL maintainer="Federico Pablos"

# Establecemos el directorio de trabajo actual dentro del contenedor
WORKDIR /app/web-proxy-service

# Cargamos las dependencias con módulos externos
COPY go.mod .
COPY go.sum .

# Descargamos las dependencias
RUN go mod download

# Copiamos el proyecto
COPY . .

# Lo construimos
RUN go build -o ./bin/web-proxy-service .

# Exponemos los puertos usados por el proxy
EXPOSE 8081
#EXPOSE 8443

# Ejecutamos
CMD ["./bin/web-proxy-service"]
