#!/bin/bash

# --- PHẦN 1: TẢI BORE (Nếu chưa có) ---
if [ ! -f "bore" ]; then
  echo ">>> Đang tải Bore..."
  wget https://github.com/ekzhang/bore/releases/download/v0.5.0/bore-v0.5.0-x86_64-unknown-linux-musl.tar.gz
  tar -xzf bore-v0.5.0-x86_64-unknown-linux-musl.tar.gz
  rm bore-v0.5.0-x86_64-unknown-linux-musl.tar.gz
  chmod +x bore
fi

# --- PHẦN 2: CHẠY ANDROID (REDROID) ---
# Xóa container cũ nếu còn sót lại để tránh lỗi trùng tên
docker rm -f android-idx 2>/dev/null

echo ">>> Đang khởi động Android..."
# Lưu ý: Chế độ guest được bật để chạy mượt trên Cloud không GPU
docker run -d \
  --privileged \
  --name android-idx \
  -p 5555:5555 \
  redroid/redroid:11.0.0-latest \
  androidboot.redroid_width=480 \
  androidboot.redroid_height=854 \
  androidboot.redroid_dpi=240 \
  androidboot.redroid_fps=30 \
  androidboot.redroid_gpu_mode=guest

# --- PHẦN 3: KẾT NỐI BORE ---
echo ">>> Đợi 10 giây cho Android khởi động..."
sleep 10

echo "---------------------------------------------------"
echo "   KẾT NỐI CỦA ANH ĐÂY (LẤY DÒNG bore.pub:XXXXX) "
echo "---------------------------------------------------"

# Chạy bore và đưa cổng 5555 (ADB) ra ngoài
./bore local 5555 --to bore.pub
