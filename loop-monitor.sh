#!/bin/bash
# ============================================================
# Script: loop-monitor.sh
# Mô tả:  Giám sát hệ thống - ghi thời gian hiện tại vào file
#         log mỗi 5 giây, chạy liên tục ở chế độ nền.
# Tác giả: HN_KS24_CNTT2_IT209
# ============================================================

LOG_FILE="/tmp/monitor.log"

echo "=== Monitor started at $(date) ===" >> "$LOG_FILE"

while true; do
    echo "System time: $(date)" >> "$LOG_FILE"
    sleep 5
done
