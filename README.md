# Dididi — Hạ tầng dev bằng Docker (MySQL + Redis)

`docker-compose.yml` này chạy MySQL + Redis trong container, tự tạo sẵn 3 database
(`booking`, `flight_provider`, `hotel_pms`) + user `booking`/`booking_dev_pass` khớp đúng
cấu hình 3 app — bật lên là chạy, không phải sửa gì trong code.

## Chuẩn bị (một lần)
1. Cài Docker Desktop: `brew install --cask docker`, rồi mở app Docker (Launchpad) cho engine chạy.
   Kiểm tra: `docker --version && docker compose version`.
2. **Giải phóng cổng 3306 và 6379** (vì đang bị MySQL/Redis native chiếm):
   - Tắt MySQL native: **System Settings → MySQL → Stop**.
   - Tắt Redis của Homebrew: `brew services stop redis`.
   > Nếu không tắt, Docker sẽ báo lỗi "port is already allocated".

## Chạy
Đặt thư mục này (chứa `docker-compose.yml` + `init/`) ở đâu cũng được, rồi:
```bash
cd đường-dẫn/dididi-infra
docker compose up -d
docker compose ps          # xem trạng thái; chờ mysql "healthy" (~20-30s lần đầu)
docker compose logs -f mysql   # (tuỳ chọn) xem log khởi tạo
```
Lần đầu MySQL sẽ chạy `init/01-init.sql` để tạo DB + user.

## Sau đó
- Bật 3 app như thường (flight-provider → hotel-pms → booking-platform). URL JDBC vẫn là
  `localhost:3306` nên **không cần đổi gì**. booking-platform sẽ tự tạo lại schema (ddl-auto) +
  seed admin; 2 mock seed lại qua `data.sql`; sync nạp lại flights/hotels.
- **DBeaver**: kết nối `localhost:3306`, user `booking` / `booking_dev_pass` (hoặc `root` / `root_dev_pass`).
  Lần này dùng native password nên **không cần bật `allowPublicKeyRetrieval`** nữa.

## Lệnh hay dùng
```bash
docker compose stop        # tắt tạm (giữ dữ liệu)
docker compose start       # bật lại
docker compose down        # xoá container (GIỮ dữ liệu trong volume)
docker compose down -v     # xoá luôn dữ liệu -> lần sau init lại từ đầu (reset sạch)
```

## Lưu ý
- **Dữ liệu MySQL trong Docker tách biệt** với MySQL native cũ. Volume `dididi-mysql-data` giữ dữ liệu
  qua các lần `up/down`. Dữ liệu cũ bên native vẫn còn nguyên (không dùng tới khi native đang tắt).
- Muốn quay lại dùng native: `docker compose down`, bật lại MySQL native trong System Settings
  (và `brew services start redis`). Đừng để cả hai cùng chiếm 3306/6379.
- Mật khẩu ở đây là **dev** (`root_dev_pass`, `booking_dev_pass`) — chỉ dùng local.

## Bước kế tiếp của Phase 6
Sau khi cụm này chạy ổn, mình sẽ mở rộng: thêm **Prometheus + Grafana** vào compose để giám sát
(backend đã expose sẵn `/actuator/prometheus`), rồi viết **GitHub Actions CI** build/test tự động.
