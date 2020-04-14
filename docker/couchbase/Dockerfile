FROM couchbase/server:community-6.5.0

MAINTAINER Federico Pablos

#Pasar a docker-compose.yml y remplazar con  ${USER} y ${PASS}
ENV USER "admin"
ENV PASS "a1d2m3i4n5"

#Pasar a docker-compose.yml y remplazar con  ${PROXY_CONFIG} y ${PROXY}
ENV PROXY_CONFIG "proxy_config"
ENV PROXY_STATISTICS "proxy_statistics"

#Configuración de memoria para el cluster y los diferentes buckets
ENV PROXY_STATISTICS_MEMORY_QUOTA 912
ENV PROXY_CONFIG_MEMORY_QUOTA 100
ENV INDEX_MEMORY_QUOTA 256
ENV SERVER_MEMORY_QUOTA 1024

#Exponemos los puertos necesarios
EXPOSE 8091
EXPOSE 8092
EXPOSE 8093
EXPOSE 8094
EXPOSE 8095
EXPOSE 8096
EXPOSE 11210
EXPOSE 11211

#Extensión del entrypoint de couchbase
COPY entrypoint.sh /config-entrypoint.sh

#Agregamos permisos para ejecución
RUN chmod +x /config-entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/config-entrypoint.sh"]
