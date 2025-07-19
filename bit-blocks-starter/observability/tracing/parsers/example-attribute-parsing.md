### Standard Trace Attribute Naming

Use the following standard attributes to ensure consistent and effective trace data:

- **`service.name`**: Logical application or service name (**required**)
- **`span.kind`**: Type of span (e.g., `client`, `server`, `internal`) — enables filtering in observability tools like Grafana
- **`http.method`**, **`http.route`**, **`http.status_code`**: For web request spans
- **`db.system`**, **`db.statement`**: For database spans
- **`error`**: Indicates error traces (`true`/`false`)

> **Best Practice:**  
> Follow [OpenTelemetry Semantic Conventions](https://opentelemetry.io/docs/specs/semconv/) for improved parsing, querying, and dashboarding.
