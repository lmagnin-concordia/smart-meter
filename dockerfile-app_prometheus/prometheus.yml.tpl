# my global config
global:
  scrape_interval:     10s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 10s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

  # Attach these labels to any time series or alerts when communicating with
  # external systems (federation, remote storage, Alertmanager).
  external_labels:
      monitor: 'smartmeter-prometheus'

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first.rules"
  # - "second.rules"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'nats'
    scrape_interval: 10s
    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.
    static_configs:
      - targets: ['${PROMETHEUS_NATS_EXPORTER_NAME}:7777']

  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'telegraf_cassandra'
    scrape_interval: 10s
    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.
    static_configs:
      - targets: ['telegraf_cassandra:9126']

  # https://github.com/nabto/cassandra-prometheus/blob/master/integrationtest/prometheus.yml
  - job_name: 'cassandra'
    static_configs:
      - targets: ['${CASSANDRA_MAIN_NAME}:7400']
