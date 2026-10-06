# HN_KS24_CNTT2 – IT209 DevOps | Session 06 – Bài 4

## Quản lý Tiến Trình Nền với `nohup` và Tín Hiệu `kill`

| Thông tin | Chi tiết |
|---|---|
| **Môn học** | IT209 – DevOps |
| **Lớp** | HN_KS24_CNTT2 |
| **Session** | 06 |
| **Bài tập** | Bài 4 – Quản lý tiến trình nền |
| **Sinh viên** | Ngotrungchien232 |

---

## 📁 Cấu trúc bài nộp

```
homework/
└── session_06/
    └── ex4/
        ├── loop-monitor.sh   # Shell script giám sát hệ thống
        └── README.md         # Báo cáo chi tiết
```

---

## 🚀 Nội dung chính

Bài tập thực hành quản lý tiến trình nền trong Linux:

1. **Viết shell script** `loop-monitor.sh` ghi log hệ thống mỗi 5 giây
2. **Chạy nền độc lập** bằng `nohup ... &` (không bị tắt khi đóng Terminal/SSH)
3. **Giám sát tiến trình** với `ps aux` và `pgrep`
4. **Kiểm soát tiến trình** bằng `kill -15` (SIGTERM) và `kill -9` (SIGKILL)

📄 Xem báo cáo chi tiết tại: [`homework/session_06/ex4/README.md`](homework/session_06/ex4/README.md)
