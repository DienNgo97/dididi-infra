-- Tao 3 database + user 'booking' khop voi cau hinh 3 app.
-- File nay chi chay LAN DAU khi volume MySQL con trong (docker-entrypoint-initdb.d).

CREATE DATABASE IF NOT EXISTS booking         CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS flight_provider CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS hotel_pms        CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Trong Docker, app ket noi tu host -> MySQL thay la host '%', nen cap quyen cho '%'.
CREATE USER IF NOT EXISTS 'booking'@'%' IDENTIFIED BY 'booking_dev_pass';
GRANT ALL PRIVILEGES ON booking.*         TO 'booking'@'%';
GRANT ALL PRIVILEGES ON flight_provider.* TO 'booking'@'%';
GRANT ALL PRIVILEGES ON hotel_pms.*       TO 'booking'@'%';
FLUSH PRIVILEGES;
