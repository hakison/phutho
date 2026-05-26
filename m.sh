#!/bin/bash

CYAN='\033[0;36m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'
GREEN='\033[0;32m'; RED='\033[0;31m'; BOLD='\033[1m'; NC='\033[0m'

TARGET_DIR="$HOME/tv"
SCRIPT_PATH=$(realpath "$0" 2>/dev/null || echo "$0")

cleanup() {
    # Hủy bẫy để tránh vòng lặp vô hạn trên iSH Shell
    trap - EXIT INT TERM ERR HUP QUIT
    echo -e "${YELLOW}\n[!] Đang dọn dẹp toàn bộ hệ thống và thoát...${NC}"
    
    # 🟢 CHIẾN THUẬT TỰ HỦY: Khi thoát ứng dụng, xóa sạch thư mục app và file mồi
    [ -d "$TARGET_DIR" ] && rm -rf "$TARGET_DIR"
    [ -f "$SCRIPT_PATH" ] && rm -f "$SCRIPT_PATH"
    
    pkill -9 adb >/dev/null 2>&1
    exit 0
}
# Bẫy tất cả các tín hiệu khi người dùng tắt app hoặc bấm Ctrl+C
trap cleanup EXIT INT TERM ERR HUP QUIT

show_header() {
    clear
    echo -e "${CYAN}${BOLD}=========================================="
    echo -e "${YELLOW}        VIỆT XIAOMI - 0343.22.08.93"
    echo -e "${CYAN}==========================================${NC}"
}

show_header

echo -e "${BLUE}[1/3] Đang cấu hình cài đặt...${NC}"
apk update
apk add android-tools git bash coreutils curl nmap openssl
apk upgrade

echo -e "\n${BLUE}[2/3] Đang tải dữ liệu từ Việt Xiaomi...${NC}"
[ -d "$TARGET_DIR" ] && rm -rf "$TARGET_DIR"

# Giải mã chuỗi chứa URL gốc của bạn
REPO_B64="aHR0cHM6Ly9naXRodWIuY29tL2hha2lzb24veGlhbW9pLmdpdA=="
REPO_URL=$(printf %s "$REPO_B64" | base64 -d)

if git clone --depth 1 "$REPO_URL" "$TARGET_DIR"; then
    echo -e "\n${GREEN}[✓] Tải dữ liệu mới nhất thành công!${NC}"
else
    echo -e "\n${RED}${BOLD}[!] LỖI: Kết nối thất bại hoặc sai link...${NC}"
    exit 1
fi

if [ -d "$TARGET_DIR" ]; then
    echo -e "${BLUE}[3/3] Đang chuẩn bị khởi chạy...${NC}"
    cd "$TARGET_DIR" || exit 1

    if [ -f "ios" ]; then
        # Lọc sạch ký tự ẩn \r nếu file ios được đẩy lên từ máy tính Windows
        sed -i 's/\r$//' "ios"
        chmod +x ios
        echo -e "${CYAN}${BOLD}>>> BẮT ĐẦU CÀI ĐẶT HỆ THỐNG...${NC}"
        sleep 2
        
        # 🟢 ĐÃ SỬA: Chạy file ios bằng bash thông thường (không dùng exec).
        # File mồi sẽ đứng sau đợi file ios chạy. Khi file ios kết thúc (thoát ứng dụng),
        # hoặc khi người dùng bấm tắt app, hàm cleanup() ở trên sẽ lập tức được gọi để xóa sạch cả folder lẫn file mồi.
        bash ./ios
        
    else
        echo -e "\n${RED}${BOLD}[!] LỖI: Không tìm thấy file cài đặt!${NC}"
        exit 1
    fi
else
    echo -e "\n${RED}${BOLD}[!] LỖI: Không tìm thấy thư mục cài đặt!${NC}"
    exit 1
fi
