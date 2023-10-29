FROM influxdb:latest
USER root
RUN echo $USER; sleep 10
# RUN influx user create --name ${USER} --password ${INFLUX_PASSWORD} --org ${DOCKER_INFLUXDB_INIT_ORG}
# RUN influx user create --name telegraf --password telegraf --org $DOCKER_INFLUXDB_INIT_ORG
USER influxdb