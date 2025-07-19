## Common Log Formats and Grok Patterns

### NGINX Access Log Example

```
$remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent"
```

**Grok Pattern:**

```
%{IPORHOST:remote_addr} - %{USERNAME:remote_user} \[%{HTTPDATE:timestamp}\] "%{WORD:verb} %{URIPATHPARAM:request} HTTP/%{NUMBER:http_version}" %{NUMBER:status} %{NUMBER:body_bytes_sent} "%{DATA:http_referer}" "%{DATA:http_user_agent}"
```

> **Note:** Loki supports grok parsing via LogQL.