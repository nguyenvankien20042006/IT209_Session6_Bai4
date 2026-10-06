# Bài 4: Quản lý Tiến Trình Nền với `nohup` và Tín Hiệu `kill`

## Môn học: IT209 - DevOps  
## Lớp: HN_KS24_CNTT2  
## Session: 06

---

## 1. Mô tả bài tập

Bài tập yêu cầu:
- Viết shell script `loop-monitor.sh` ghi thời gian hệ thống vào `/tmp/monitor.log` mỗi 5 giây.
- Chạy script ở **chế độ nền độc lập** với `nohup` (không bị tắt khi ngắt SSH/Terminal).
- Tìm **PID** của tiến trình đang chạy.
- Dừng tiến trình bằng tín hiệu **SIGTERM (15)** hoặc **SIGKILL (9)**.

---

## 2. Nội dung Script `loop-monitor.sh`

```bash
#!/bin/bash
# Script giám sát hệ thống - ghi log mỗi 5 giây

LOG_FILE="/tmp/monitor.log"

echo "=== Monitor started at $(date) ===" >> "$LOG_FILE"

while true; do
    echo "System time: $(date)" >> "$LOG_FILE"
    sleep 5
done
```

---

## 3. Các bước thực hiện

### Bước 1: Tạo và cấp quyền thực thi cho script

```bash
# Tạo script
cat << 'EOF' > loop-monitor.sh
#!/bin/bash
LOG_FILE="/tmp/monitor.log"
echo "=== Monitor started at $(date) ===" >> "$LOG_FILE"
while true; do
    echo "System time: $(date)" >> "$LOG_FILE"
    sleep 5
done
EOF

# Cấp quyền thực thi
chmod +x loop-monitor.sh
```

### Bước 2: Khởi chạy script ở chế độ nền độc lập với `nohup`

```bash
nohup ./loop-monitor.sh > /dev/null 2>&1 &
```

**Giải thích lệnh:**
| Thành phần | Ý nghĩa |
|---|---|
| `nohup` | Bỏ qua tín hiệu SIGHUP – script không bị tắt khi đóng Terminal |
| `./loop-monitor.sh` | Script cần chạy |
| `> /dev/null` | Chuyển stdout vào "hố đen" (bỏ output) |
| `2>&1` | Chuyển stderr vào cùng với stdout |
| `&` | Chạy tiến trình ở chế độ nền (background) |

**Kết quả terminal hiển thị:**
```
[1] 3742
```
> Số `3742` là PID của tiến trình vừa được khởi chạy.

---

### Bước 3: Kiểm tra tiến trình đang chạy

```bash
ps aux | grep loop-monitor.sh
```

**Kết quả mẫu:**
```
student   3742  0.0  0.0  11280  1024 ?  S   14:30   0:00 /bin/bash ./loop-monitor.sh
student   3758  0.0  0.0  12784   928 pts/0 S+  14:30   0:00 grep --color=auto loop-monitor.sh
```

Hoặc dùng `pgrep` để lấy PID chính xác:
```bash
pgrep -f loop-monitor.sh
```
**Kết quả mẫu:**
```
3742
```

---

### Bước 4: Kiểm tra file log đang được ghi liên tục

```bash
tail -n 10 /tmp/monitor.log
```

**Kết quả mẫu:**
```
=== Monitor started at Tue Oct  6 14:30:01 UTC 2026 ===
System time: Tue Oct  6 14:30:01 UTC 2026
System time: Tue Oct  6 14:30:06 UTC 2026
System time: Tue Oct  6 14:30:11 UTC 2026
System time: Tue Oct  6 14:30:16 UTC 2026
System time: Tue Oct  6 14:30:21 UTC 2026
System time: Tue Oct  6 14:30:26 UTC 2026
System time: Tue Oct  6 14:30:31 UTC 2026
System time: Tue Oct  6 14:30:36 UTC 2026
System time: Tue Oct  6 14:30:41 UTC 2026
```

Theo dõi log real-time:
```bash
tail -f /tmp/monitor.log
```

---

### Bước 5: Tắt tiến trình bằng tín hiệu `kill`

#### 5.1 Gửi SIGTERM (15) – Tắt an toàn (ưu tiên dùng trước)

```bash
kill -15 3742
```

Kiểm tra lại xem tiến trình đã tắt chưa:
```bash
ps aux | grep loop-monitor.sh
```

**Kết quả mong đợi** (tiến trình đã biến mất):
```
student   3760  0.0  0.0  12784   928 pts/0 S+  14:35   0:00 grep --color=auto loop-monitor.sh
```

#### 5.2 Gửi SIGKILL (9) – Buộc tắt ngay lập tức (nếu SIGTERM không hiệu quả)

```bash
kill -9 3742
```

---

## 4. Bảng tổng hợp các tín hiệu kill

| Tín hiệu | Số | Hành vi |
|---|---|---|
| `SIGTERM` | 15 | Yêu cầu tiến trình tự thoát an toàn (mặc định) |
| `SIGKILL` | 9  | Buộc kernel tiêu diệt tiến trình ngay lập tức, **không thể bắt** |
| `SIGHUP`  | 1  | Thông báo "terminal đã đóng", nhiều daemon dùng để reload config |

---

## 5. Kết quả kiểm tra

### Tiến trình chạy nền (sau `nohup`):
```
ps aux | grep loop-monitor.sh
student   3742  0.0  0.0  11280  1024 ?  S   14:30   0:00 /bin/bash ./loop-monitor.sh
```

### File log đang được ghi liên tục:
```
tail -n 10 /tmp/monitor.log
System time: Tue Oct  6 14:30:41 UTC 2026
System time: Tue Oct  6 14:30:46 UTC 2026
System time: Tue Oct  6 14:30:51 UTC 2026
...
```

### Sau khi `kill -15 3742`:
```
ps aux | grep loop-monitor.sh
student   3760  0.0  0.0  12784   928 pts/0 S+  14:35   0:00 grep loop-monitor.sh
```
> Chỉ còn dòng `grep` – tiến trình `loop-monitor.sh` đã **biến mất** hoàn toàn. ✅

---

## 6. Kết luận

- **`nohup`** đảm bảo tiến trình tiếp tục chạy dù Terminal bị đóng (bỏ qua tín hiệu SIGHUP).
- Ký tự **`&`** đẩy tiến trình vào chạy nền, giải phóng Terminal hiện tại.
- **`ps aux | grep`** và **`pgrep`** là công cụ tra cứu PID của tiến trình.
- **`kill -15`** (SIGTERM) là cách tắt tiến trình **an toàn**, ưu tiên dùng trước.
- **`kill -9`** (SIGKILL) là lựa chọn cuối cùng khi SIGTERM không hiệu quả.
