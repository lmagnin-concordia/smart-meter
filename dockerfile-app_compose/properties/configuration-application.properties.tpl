### TEMP
gatling_scala_version=2.11.8
hadoop_docker_image=sequenceiq/hadoop-docker

###

APPLICATION_NAME="smartmeter"
NETWORK_NAME="smartmeter"

STACK_NAME=\${STACK_NAME:-smartmeter}

EUREKA_AVAILABILITY_PORT=6868

SPARK_HOME="\\\$SPARK_HOME"
SPARK_MASTER_NAME="spark-master"
SPARK_WORKER_NAME="spark-worker"
SPARK_UI_PORT=8181

HADOOP_NAME="hadoop"
HDFS_PORT=9000
HDFS_URL="hdfs://\${HADOOP_NAME}:\${HDFS_PORT}"

# https://docs.docker.com/engine/reference/run/#/restart-policies---restart
# DOCKER_RESTART_POLICY="--restart on-failure:3"
DOCKER_RESTART_POLICY="--rm"

# https://github.com/moby/moby/issues/25209
EUREKA_NAME="eureka"
EUREKA_WAITER_PARAMS_SERVICE="--mount type=bind,source=/proc,destination=/writable-proc"
EUREKA_WAITER_PARAMS_RUN="--sysctl net.ipv4.icmp_echo_ignore_all=1 -v /proc:/writable-proc"

VOLTAGE_RANDOMNESS=0.2
GATLING_TO_NATS_SUBJECT=smartmeter.raw
GATLING_USERS_PER_SEC=500
GATLING_DURATION=50
GATLING_MAIN_CLASS="com.logimethods.smartmeter.inject.NatsInjection"
## https://mvnrepository.com/artifact/org.scalanlp/breeze_2.11
GATLING_breeze_version=0.13.2
## http://www.scalatest.org/install
GATLING_scalactic_version=3.0.4

APP_STREAMING_NAME=app_streaming
APP_STREAMING_VERSION="1.0"
APP_STREAMING_TARGETS=DEFAULT
APP_STREAMING_LOG_LEVEL=INFO
APP_STREAMING_MAIN_CLASS="com.logimethods.nats.connector.spark.app.SparkMaxProcessor"
APP_STREAMING_SUBJECT_INPUT="smartmeter.raw"
APP_STREAMING_SUBJECT_OUTPUT="smartmeter.extract"
APP_STREAMING_APP_NAME="Smartmeter MAX Streaming"
SPARK_LOCAL_URL=local[*]
SPARK_MASTER_URL_STREAMING=local[*]
STREAMING_DURATION=5000
APP_STREAMING_SPARK_CORES_MAX=1

PREDICTION_ALERT_THRESHOLD=116
PREDICTION_LENGTH=12
PREDICTION_TRAINER_NAME=app_prediction_trainer
PREDICTION_TRAINER_LOG_LEVEL=INFO
PREDICTION_TRAINER_MAIN_CLASS=com.logimethods.nats.connector.spark.app.SparkPredictionTrainer
PREDICTION_TRAINER_SPARK_CORES_MAX=1
PREDICTION_TRAINER_SUBJECT_INPUT="NONE"
PREDICTION_TRAINER_SUBJECT_OUTPUT="NONE"
PREDICTION_TRAINER_APP_NAME="Smartmeter PREDICTION TRAINER"
PREDICTION_TRAINER_READY_WHEN="New model of size"
PREDICTION_ORACLE_LOG_LEVEL=INFO
PREDICTION_ORACLE_MAIN_CLASS=com.logimethods.nats.connector.spark.app.SparkPredictionOracle
PREDICTION_ORACLE_SPARK_CORES_MAX=1
PREDICTION_ORACLE_SUBJECT_INPUT="smartmeter.raw.temperature.forecast.12"
PREDICTION_ORACLE_SUBJECT_OUTPUT="smartmeter.extract.voltage.prediction.12"
PREDICTION_ORACLE_APP_NAME="Smartmeter PREDICTION ORACLE"
PREDICTION_ORACLE_SPARK_CORES_MAX=1

NATS_NAME="nats"
NATS_USERNAME="deetazilla"
NATS_PASSWORD="xyz1234"
NATS_CLUSTER_USERNAME="nats_cluster"
NATS_CLUSTER_PASSWORD="1234xyz"

#NATS_URI=nats://\${NATS_USERNAME}:\${NATS_PASSWORD}@nats:4222
#NATS_URI=nats://nats:4222
#NATS_CLUSTER_URI=nats://\${NATS_USERNAME}:\${NATS_PASSWORD}@nats:4222
## https://nats.io/documentation/server/gnatsd-usage/
##NATS_DEBUG="-DV"

NATS_CLIENT_NAME=nats_client
#NATS_CLIENT_SUBJECT="deetazilla.voltage.raw.temperature"
NATS_CLIENT_SUBJECT="smartmeter.extract.>"

JMX_PASSWORD="DDwe45Df2sdsaf45Dsff"

SPARK_MASTER_URL_BATCH=spark://spark-master:7077
APP_BATCH_LOG_LEVEL=INFO

MONITOR_MAIN_CLASS="org.deetazilla.monitor.NatsOutputMonitor"
MONITOR_SUBJECT_INPUT="smartmeter.extract.>"

MONITOR_TEST_VALUE=150.0

zeppelin_logs_volume=zeppelin_logs
zeppelin_notebook_volume=zeppelin_notebook
ZEPPELIN_LOG_DIR='/logs'
ZEPPELIN_NOTEBOOK_DIR='/notebook'
ZEPPELIN_WEB_PORT=8282

JOLOKIA_PORT=8778

METRICS_GRAPHITE_NAME="graphite"
METRICS_GRAFANA_WEB_PORT=80
METRICS_WEB_PORT=80
METRICS_GRAPHITE_WEB_PORT=81
METRICS_GRAPHITE_TCP_PORT=2003
METRICS_PATH=~/Documents/GitHub/smart-meter/dockerfile-metrics

INFLUXDB_NAME=influxdb

GF_SECURITY_ADMIN_PASSWORD="a2min"

CASSANDRA_ROOT_NAME="cassandra-cluster"
CASSANDRA_MAIN_NAME="\${CASSANDRA_ROOT_NAME}-main"
CASSANDRA_NODE_NAME="\${CASSANDRA_ROOT_NAME}-node"
CASSANDRA_DEFAULT_VOLUME_SIZE=5G
CASSANDRA_REMOTE_VOLUME_SIZE=10G
CASSANDRA_LOCAL_VOLUME_SIZE=1G
CASSANDRA_KEYSPACE_NAME=deetazilla
CASSANDRA_KEYSPACE_REPLICATION="{ 'class' : 'SimpleStrategy', 'replication_factor' : 1 }"
CASSANDRA_SETUP_FILE="/cql/create-timeseries.cql"
CASSANDRA_COUNT_PORT=6161

CASSANDRA_INJECT_LOG_LEVEL=INFO
# See http://docs.datastax.com/en/cql/3.3/cql/cql_reference/cqlshConsistency.html
CASSANDRA_INJECT_CONSISTENCY=ONE
# ANY ONE TWO THREE QUORUM ALL LOCAL_QUORUM" EACH_QUORUM LOCAL_ONE

# See https://github.com/nats-io/prometheus-nats-exporter
prometheus_image='((docker-app_prometheus-repository))'
prometheus_tag='((docker-app_prometheus-tag))((docker-additional-tag))'
PROMETHEUS_NAME="prometheus"
PROMETHEUS_NATS_EXPORTER_NAME="prometheus_nats_exporter"
PROMETHEUS_NATS_EXPORTER_FLAGS="-varz -connz -routez -subz"
PROMETHEUS_NATS_EXPORTER_URLS="\"http://\${NATS_NAME}:8222\""
PROMETHEUS_NATS_EXPORTER_SERVICE_MODE="--mode global"
#PROMETHEUS_NATS_EXPORTER_DEBUG="-DV"

FLASK_DEBUG=0
FLASK_PORT=5000