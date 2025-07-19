# BitBlock Logging Observability

This folder contains starter templates and patterns for collecting, parsing, and visualizing logs across your infrastructure and applications.  
**Powered by Grafana Loki** for efficient, scalable, and cost-effective log aggregation.

## Included
- Loki and Promtail config files (K8s-ready & bare metal)
- Example log parsing patterns (JSON, Grok)
- Sample Logback (Java) & NGINX structured logging configs
- Grafana dashboard template for logs

## How To Use

1. **Deploy Loki & Promtail** using provided configs.
2. Point Promtail to your log files/containers or use sidecar deployment in Kubernetes.
3. Use parsing patterns to extract fields for querying and alerting.
4. Import the Grafana dashboard for instant log visibility.

See `loki/`, `parsers/`, and `dashboards/` for details.

---

> For advanced use cases, integrate with OpenTelemetry Collector or Fluent Bit as log forwarders.  
> See Grafana docs for more advanced alerting and pipeline stages.
