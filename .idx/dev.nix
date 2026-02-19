{ pkgs, ... }: {
  # Chọn kênh gói phần mềm ổn định
  channel = "stable-23.11";

  # Cài đặt các công cụ cần thiết
  packages = [
    pkgs.docker        # Để chạy Redroid
    pkgs.android-tools # Chứa ADB
    pkgs.wget          # Để tải Bore
    pkgs.procps        # Để xem tiến trình
  ];

  # Bật Docker (Bắt buộc phải có dòng này Docker mới chạy trên IDX)
  services.docker.enable = true;

  # Các lệnh chạy tự động
  idx = {
    workspace = {
      onCreate = {
        # Cấp quyền chạy cho file script
        setup = "chmod +x start.sh";
      };
      onStart = {
        # Tự động chạy script mỗi khi bật máy
        run-android = "./start.sh";
      };
    };
  };
}
