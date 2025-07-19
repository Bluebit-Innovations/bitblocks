## Parsing JSON Application Logs

Promtail automatically detects JSON logs if the log line starts with a `{`.

**Example log:**
```json
{"level":"info","ts":1689825600,"msg":"User signup","user":"jane","status":201}
```

In Grafana, use **Log labels** and **JSON parsing** to extract fields from your logs.