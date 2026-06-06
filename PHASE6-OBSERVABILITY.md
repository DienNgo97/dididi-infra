# Phase 6 — Observability (Prometheus + Grafana)

Đã thêm **Prometheus** (thu thập metrics) + **Grafana** (dashboard) vào `docker-compose.yml`,
cạnh MySQL + Redis. Dữ liệu MySQL/Redis hiện có **không bị ảnh hưởng** (nằm trong volume riêng).

## Cập nhật & chạy
1. Thay thư mục `dididi-infra` bằng bản mới này (giữ nguyên — volume dữ liệu nằm trong Docker, không
   nằm trong thư mục, nên thay file an toàn).
2. Đảm bảo **booking-platform (8080) đang chạy** trên máy (Prometheus scrape host qua `host.docker.internal`).
3. Bật/cập nhật cụm:
   ```bash
   cd đường-dẫn/dididi-infra
   docker compose up -d
   docker compose ps     # thấy thêm dididi-prometheus, dididi-grafana
   ```

## Kiểm tra
- **Endpoint metrics của app** (host): mở `http://localhost:8080/actuator/prometheus` — thấy hàng loạt
  dòng metrics (`jvm_...`, `http_server_requests_...`) là OK.
- **Prometheus**: `http://localhost:9090` → menu **Status → Targets** → job `booking-platform` phải **UP**.
  (Nếu DOWN: kiểm tra booking-platform đang chạy; trên Docker Desktop Mac `host.docker.internal` trỏ về host.)
- **Grafana**: `http://localhost:3000` → đăng nhập **admin / admin**. Datasource Prometheus đã được tạo sẵn.

## Tạo dashboard (import nhanh từ cộng đồng)
Trong Grafana: menu trái **Dashboards → New → Import**, nhập ID rồi chọn datasource **Prometheus**:
- **4701** — *JVM (Micrometer)*: heap/non-heap, GC, threads, CPU.
- **11378** — *Spring Boot Statistics* (HTTP request rate, latency…).
(Grafana sẽ tự tải JSON từ grafana.com — container có internet là được. Nếu máy chặn mạng ra ngoài,
báo mình, mình gửi sẵn file JSON dashboard để import offline.)

## Cổng dùng
- MySQL 3306 · Redis 6379 · Prometheus 9090 · Grafana 3000
- (App: 8080/8081/8082; Angular dev: 4200 — không đụng nhau.)

## Lưu ý
- 2 mock (flight-provider/hotel-pms) chưa có actuator/prometheus nên Prometheus chỉ giám sát
  booking-platform. Nếu muốn giám sát cả 2 mock, mình thêm `spring-boot-starter-actuator` +
  `micrometer-registry-prometheus` vào pom của chúng + 1 job scrape nữa (nói mình nếu cần).
- Mật khẩu Grafana là dev (admin/admin) — chỉ dùng local.

## Bước kế tiếp Phase 6
Sau khi Prometheus **Targets = UP** và Grafana xem được dashboard, mình làm nốt **GitHub Actions CI**
(build + test tự động cho 3 project khi push).
