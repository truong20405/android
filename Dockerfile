FROM redroid/redroid:11.0.0-latest

USER root

# 1. Cài đặt curl và tar để tải bore
RUN apt-get update && apt-get install -y curl tar && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. Tải và cài đặt bore
RUN curl -L https://github.com/ekzhang/bore/releases/download/v0.5.0/bore-v0.5.0-x86_64-unknown-linux-musl.tar.gz | tar -xz -C /usr/bin/

# 3. Tạo script khởi động All-in-One
# Script này chạy Android ngầm, đợi 10s rồi bật bore để public cổng 5555
RUN echo '#!/bin/bash \n\
echo "--- KHOI DONG ANDROID (XEON MODE) ---" \n\
/init \
    androidboot.redroid_width=720 \
    androidboot.redroid_height=1280 \
    androidboot.redroid_dpi=320 \
    androidboot.redroid_fps=30 \
    androidboot.redroid_gpu_mode=guest & \n\
\n\
sleep 10 \n\
\n\
echo "--- DANG MO CONG BORE ---" \n\
# Chay bore va in ra Logs de anh lay PORT \n\
bore local 5555 --to bore.pub \n\
' > /start.sh && chmod +x /start.sh

# Expose cổng ADB (5555)
EXPOSE 5555

# Chạy script khi container bật
ENTRYPOINT ["/bin/bash", "/start.sh"]
