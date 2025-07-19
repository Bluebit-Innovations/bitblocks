
# Tracing: Collection, Parsing & Visualization

This folder contains patterns and ready-to-use configs to enable distributed tracing in cloud-native stacks, with end-to-end visibility from application to infrastructure using OpenTelemetry and Grafana Tempo.

## Components

- **collector/**: OpenTelemetry Collector config for ingesting, processing, and exporting traces.
- **exporters/**: Example configs for app instrumentation/exporters.
- **parsers/**: Guidelines for attribute parsing and semantic conventions.
- **dashboards/**: Grafana dashboards for Tempo/Tracing.
- **How it works**:  
  - Apps are instrumented using OpenTelemetry SDKs and send traces to the Collector.
  - The Collector exports traces to Tempo.
  - Grafana (with Tempo as datasource) provides trace search, filtering, and visualization.

## Quick Start

1. `cd tracing/collector && docker-compose up`
2. Instrument your application(s) with OpenTelemetry, pointing to `localhost:4317`.
3. Add the provided dashboard to your Grafana instance and select the Tempo datasource.

### **Summary Table**

| Area       | Tool           | Example File(s)               | Key Config/Pattern             |
| ---------- | -------------- | ----------------------------- | ------------------------------ |
| Collection | Otel Collector | otel-collector-config.yaml    | OTLP receiver + Tempo exporter |
| Export     | OpenTelemetry  | tempo-exporter-config.yaml    | OTLP exporter in app code      |
| Parsing    | Otel SemConv   | example-attribute-parsing.md  | Service/span semantic tags     |
| Storage    | Grafana Tempo  | tempo.yaml                    | Local (or object storage)      |
| Dashboard  | Grafana        | tracing-overview-grafana.json | Trace panel, topk services     |

