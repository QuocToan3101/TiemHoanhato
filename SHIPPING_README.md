# Shipping & Delivery Integration (Leaflet + OpenStreetMap + GHN)

This document explains how to configure and enable the new shipping/address features added to the application.

1) Address search and map

- The frontend uses Leaflet.js and OpenStreetMap tiles.
- Address autocomplete uses Nominatim directly from the browser with debounce.
- The backend validates the selected place with Nominatim lookup/reverse and rejects free-text submissions.

- Add your shipping settings to `src/main/resources/application.properties`:

```properties
shipping.free_enabled=true
shipping.max_radius_km=25
nominatim.user_agent=FlowerStore/1.0 (contact: support@yourdomain.vn)
```

2) GHN (Giao Hàng Nhanh)

- If you want GHN-based fee estimates, set:

```properties
ghn.base_url=https://online-gateway.ghn.vn
ghn.token=YOUR_GHN_TOKEN
```

3) Store location

- Set store coordinates used for distance/ETA calculations (example is Ho Chi Minh City):

```properties
store.latitude=10.762622
store.longitude=106.660172
```

4) DB Migration

- Run `database/migrations/001_create_shipping_tables.sql` to add required tables.

5) Frontend

- `cart.jsp` now includes an address input with Nominatim autocomplete and a Leaflet mini-map preview.
- The JS lives at `/js/shipping.js` and lazily loads Leaflet when the first address is selected.

6) Backend

- `ShippingApiServlet` listens at `/api/shipping/calculate` and expects JSON:

```json
{ "place_id": "...", "formatted_address": "...", "lat": 10.7, "lng": 106.6 }
```

- The servlet requires `place_id` and validates the selection server-side with Nominatim.

7) Notes & Fallbacks

- The client enforces selection from autocomplete. If Nominatim fails, a friendly error is shown.
- GHN integration is best-effort: if GHN fails the internal fee rule is used.
- Distance results are cached in memory and optionally Redis by `ShippingService`.

8) Cost optimizations & best practices

- Nominatim has usage policies and rate limits; keep debounce enabled and set a descriptive `User-Agent`.
- Use server-side proxying for sensitive GHN requests if you want to hide credentials.
- Keep Redis enabled in multi-instance deployments so cache and rate limits remain consistent.

9) Next steps

- Add unit tests for `ShippingService`.
- Add admin UI to manage `delivery_zone` and `shipping_fee_rule` records.

10) Production hardening checklist

- Hide GHN token in environment variables or secret manager; do NOT embed it in frontend code.
- Keep the Nominatim `User-Agent` descriptive and rate limit the shipping endpoint.
- Use Redis for caching shipping calculations across instances and for rate-limiting.
- Run `database/migrations/001_create_shipping_tables.sql` which now includes `delivery_history` and indexes.
- Configure `redis.host` and `redis.port` in `application.properties` or environment.
- Add `RateLimitFilter` (provided) and configure via `web.xml` if needed for init params.
- Use Docker and Nginx reverse proxy in front of tomcat/jetty; keep client IP in `X-Forwarded-For` header for rate-limiting.

11) Docker & Nginx (example)

- A minimal `Dockerfile` and `nginx` example are included in the repo under `deploy/` for reference (create as needed):

```nginx
server {
  listen 80;
  server_name yourdomain.com;

  location / {
    proxy_pass http://app:8080;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $host;
  }
}
```

12) Logging & Monitoring

- Ensure SLF4J/Logback is configured to capture errors and slow external calls (GHN/Google).
- Add simple metrics (counts, latencies) to Prometheus/Grafana for shipping API.

13) Security notes

- Validate `Referer`/`Origin` server-side and require `place_id` selection.
- Rate-limit endpoint and optionally require authentication to increase limits for logged-in users.
