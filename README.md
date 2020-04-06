# ML Proxy

Proxy basado en Docker SWARM

## Comandos a correr

Una vez que clone el repositorio, hay que traerse los repositorios que se usan como modulos con los siguientes comandos:

```
git submodule init
git submodule update
```
### Imagenes de Docker para los servicios

Vamos a correr los siguientes comandos parados en la base del directorio donde clonamos el repositorio:

Imagen para el servicio de proxy:
```
docker image build -t fpablos/proxy:latest --no-cache --file docker/proxy/Dockerfile ./web-proxy-service
```
Imagen para el servicio de couchbase:
```
docker image build -t fpablos/couchbase:latest --no-cache --file docker/couchbase/Dockerfile docker/couchbase/
```

Imagen para del balanceador de Descargamos;
```
docker image build -t fpablos/balancer:latest --no-cache --file docker/balancer/Dockerfile docker/balancer/
```

### Iniciamos el SWARM
```
docker swarm init
```
Deployamos el stack de servicios declarados en `docker-compose.yml`

```
docker stack deploy -c docker-compose.yml swarm-ml-proxy
```
## Comandos para verificar el estado de los servicios en el swarm

```
docker service ps swarm-ml-proxy
```
Nota: Si fuese necesario escalar más instancias del proxy podemos usar el siguiente comando:
```
docker service scale swarm-ml-proxy_proxy=50
```
En este caso, aumentamos a 50 instancias del servicio proxy
