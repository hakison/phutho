#!/bin/bash
CYAN='\033[0;36m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; GREEN='\033[0;32m'; RED='\033[0;31m'; BOLD='\033[1m'; NC='\033[0m'
TARGET_DIR="$HOME/phutho"; SCRIPT_PATH="$0"
cleanup() {
    echo -e "${YELLOW}\n[!] Đang dọn dẹp...${NC}"
    cd "$HOME" || cd /root
    pkill -9 adb >/dev/null 2>&1
    /usr/bin/adb kill-server >/dev/null 2>&1
    [ -d "$TARGET_DIR" ] && rm -rf "$TARGET_DIR"
    exit
}
trap cleanup EXIT INT TERM ERR HUP SIGHUP TSTP QUIT
show_header() {
    clear
    echo -e "${CYAN}${BOLD}=========================================="
    echo -e "${YELLOW}        VIỆT XIAOMI - 0343.22.08.93"
    echo -e "${CYAN}==========================================${NC}"
}
show_header
echo -e "${BLUE}[1/3] Đang cấu hình cài đặt...${NC}"
apk update && apk add android-tools git bash coreutils curl nmap openssl && apk upgrade
echo -e "\n${BLUE}[2/3] Đang tải dữ liệu từ Việt Xiaomi...${NC}"
[ -d "$TARGET_DIR" ] && rm -rf "$TARGET_DIR"
REPO_URL="https://github.com"
if git clone --depth 1 "$REPO_URL" "$TARGET_DIR"; then
    echo -e "\n${GREEN}[✓] Tải toàn bộ thư mục và công cụ thành công!${NC}"
else
    echo -e "\n${RED}${BOLD}[!] LỖI: Kết nối thất bại hoặc sai link...${NC}"
    exit 1
fi
if [ -d "$TARGET_DIR" ]; then
    echo -e "${BLUE}[3/3] Đang chuẩn bị khởi chạy...${NC}"
    cd "$TARGET_DIR" || exit 1
    
    # 🟢 ĐÃ SỬA CHUẨN: Gọi file chạy tool 1.sh nằm bên trong folder phutho vừa tải về
    MAIN_SCRIPT="$TARGET_DIR/1.sh"
    
    if [ -f "$MAIN_SCRIPT" ]; then
        sed -i 's/\r$//' "$MAIN_SCRIPT" && chmod +x "$MAIN_SCRIPT"
        echo -e "${CYAN}${BOLD}>>> BẮT ĐẦU CÀI ĐẶT HỆ THỐNG...${NC}"
        sleep 2
        
        # 🔴 TỰ HỦY: Xóa file mồi m.sh vật lý trước khi khởi chạy tool chính 1.sh
        [ -f "$SCRIPT_PATH" ] && rm -f "$SCRIPT_PATH"
        
        # Chạy file tool chính 1.sh kèm theo toàn bộ folder dữ liệu đã tải
        bash "$MAIN_SCRIPT"
    else
        echo -e "\n${RED}${BOLD}[!] LỖI: Không tìm thấy file chạy tool 1.sh bên trong thư mục!${NC}"
        exit 1
    fi
else
    echo -e "\n${RED}${BOLD}[!] LỖI: Không tìm thấy thư mục cài đặt!${NC}"
    exit 1
fi
