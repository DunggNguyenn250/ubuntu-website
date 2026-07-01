# Hướng dẫn Thực hành SSH và FTP — Dự án Quản Lý Ký Túc Xá

> **Môi trường:** Ubuntu (VMware) + Docker | IP máy ảo: `192.168.1.10`
> **Cấu trúc project trên server:** `/var/www/html/` (mount từ `~/ubuntu-website/`)
> ```
> /var/www/html/
> ├── QuanLyKTX_API/      ← Hệ thống Admin (quản lý phòng, SV, hợp đồng...)
> │   ├── Controllers/
> │   ├── Models/
> │   ├── Views/
> │   ├── Public/         ← Entry point: /QuanLyKTX_API/Public/
> │   └── Routes/
> └── QuanLyKTX_user/     ← Cổng Sinh Viên
>     ├── Controllers/
>     ├── Models/
>     ├── Views/
>     └── Public/         ← Entry point: /QuanLyKTX_user/
> ```

---

## PHẦN 1: SSH — Các cấu hình cơ bản

### Bước chuẩn bị: Kiểm tra SSH đã chạy chưa
```bash
sudo systemctl status ssh
# Nếu chưa cài:
sudo apt update && sudo apt install openssh-server -y
sudo systemctl enable ssh
sudo systemctl start ssh
```

---

### 1.1. Đổi Port SSH (từ 22 sang 2222)

```bash
sudo nano /etc/ssh/sshd_config
```

Tìm dòng `#Port 22`, sửa thành:
```text
Port 2222
```

Lưu file (`Ctrl+O` → Enter → `Ctrl+X`), sau đó khởi động lại:
```bash
sudo systemctl restart ssh
sudo ufw allow 2222/tcp
```

**Kiểm tra từ máy Windows:**
```bash
ssh dunggnguyenn@192.168.1.10 -p 2222
```

---

### 1.2. Tạo user KHÔNG có quyền cài đặt (chỉ dùng môi trường sẵn có)

> **Ứng dụng thực tế:** Tạo tài khoản cho thành viên nhóm chỉ được xem log, chạy git pull, không được cài thêm gì.

```bash
# Tạo user bình thường (hệ thống hỏi password)
sudo adduser dev_limited

# Kiểm tra: user này KHÔNG có quyền sudo
groups dev_limited
# Kết quả đúng: dev_limited : dev_limited  (không có chữ "sudo")
```

**Thử nghiệm:**
```bash
# SSH vào với user này
ssh dev_limited@192.168.1.10 -p 2222

# Thử lệnh cần sudo → sẽ bị từ chối
sudo apt install nano    # → Permission denied

# Nhưng vẫn dùng được các lệnh thông thường
ls /var/www/html/QuanLyKTX_API
git -C ~/ubuntu-website pull origin main
```

---

### 1.3. Tạo user có full quyền (tương tự root)

> **Ứng dụng thực tế:** Tài khoản quản trị dự phòng cho trưởng nhóm.

```bash
# Tạo user admin mới
sudo adduser dev_admin

# Cấp quyền sudo (full quyền)
sudo usermod -aG sudo dev_admin

# Kiểm tra
groups dev_admin
# Kết quả đúng: dev_admin : dev_admin sudo
```

**Thử nghiệm:**
```bash
ssh dev_admin@192.168.1.10 -p 2222

# User này có thể làm mọi thứ
sudo systemctl restart docker
sudo docker compose -f ~/ubuntu-website/docker-compose.yml up -d
```

---

### 1.4. Cho phép / Cấm truy cập SSH theo từng user

```bash
sudo nano /etc/ssh/sshd_config
```

Thêm vào **cuối file**:
```text
# Chỉ cho phép 2 user này được SSH vào
AllowUsers dunggnguyenn dev_admin

# Cấm user này dù biết mật khẩu vẫn không SSH được
DenyUsers dev_limited
```

```bash
sudo systemctl restart ssh
```

---

## PHẦN 2: FTP — Các cấu hình cơ bản (vsftpd)

### Bước chuẩn bị: Cài đặt vsftpd

```bash
sudo apt update
sudo apt install vsftpd -y

# Backup cấu hình gốc
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bak

# Tạo thư mục lưu cấu hình riêng theo từng user
sudo mkdir -p /etc/vsftpd/user_conf

# Khai báo thư mục user_conf vào vsftpd (chỉ làm 1 lần)
echo "user_config_dir=/etc/vsftpd/user_conf" | sudo tee -a /etc/vsftpd.conf

# Bật FTP
sudo systemctl enable vsftpd
sudo systemctl start vsftpd
sudo ufw allow 21/tcp
```

---

### 2.1. User cho phép UPLOAD + DOWNLOAD (toàn bộ server) [1]

```bash
sudo adduser ftp_full_access

# Cấu hình riêng cho user này
sudo tee /etc/vsftpd/user_conf/ftp_full_access <<EOF
write_enable=YES
download_enable=YES
EOF

# Cấu hình toàn cục cần bật trong /etc/vsftpd.conf:
#   local_enable=YES
#   write_enable=YES
#   chroot_local_user=NO

sudo systemctl restart vsftpd
```

**Kết quả:** User có thể tải xuống và tải lên file ở bất kỳ đâu có quyền truy cập.

---

### 2.2. User cho phép như [1], nhưng chỉ trong 1 folder (bị nhốt - chroot)

> **Ứng dụng:** Thành viên chỉ được thao tác trong thư mục `QuanLyKTX_user` của mình.

```bash
sudo adduser ftp_user_only

# Tạo thư mục riêng cho user này
sudo mkdir -p /home/ftp_user_only/QuanLyKTX_user
sudo chown ftp_user_only:ftp_user_only /home/ftp_user_only/QuanLyKTX_user

# Cấu hình riêng
sudo tee /etc/vsftpd/user_conf/ftp_user_only <<EOF
write_enable=YES
download_enable=YES
EOF

# Bật chroot trong /etc/vsftpd.conf:
#   chroot_local_user=YES
#   allow_writeable_chroot=YES

sudo systemctl restart vsftpd
```

**Kết quả:** User chỉ thấy `/home/ftp_user_only/` — không thể đi ra ngoài.

---

### 2.3. User cho phép như [1], nhưng trong NHIỀU hơn 1 folder

> **Ứng dụng:** Thành viên cần upload code vào cả `QuanLyKTX_API` lẫn `QuanLyKTX_user`.

```bash
sudo adduser ftp_multi_folder

# Tạo 2 thư mục chia sẻ
sudo mkdir -p /ftp_share/QuanLyKTX_API /ftp_share/QuanLyKTX_user
sudo chown ftp_multi_folder:ftp_multi_folder /ftp_share/QuanLyKTX_API
sudo chown ftp_multi_folder:ftp_multi_folder /ftp_share/QuanLyKTX_user

# Cấu hình riêng
sudo tee /etc/vsftpd/user_conf/ftp_multi_folder <<EOF
write_enable=YES
download_enable=YES
EOF

# TẮT chroot trong /etc/vsftpd.conf để đi được nhiều folder:
#   chroot_local_user=NO

sudo systemctl restart vsftpd
```

---

### 2.4. User chỉ cho phép DOWNLOAD, không được UPLOAD

> **Ứng dụng:** Kiểm tra viên chỉ được tải file log từ server về xem, không được sửa.

```bash
sudo adduser ftp_readonly

# Cấu hình: TẮT write, BẬT download
sudo tee /etc/vsftpd/user_conf/ftp_readonly <<EOF
write_enable=NO
download_enable=YES
EOF

sudo systemctl restart vsftpd
```

**Thử nghiệm:** Kết nối FTP với `ftp_readonly` → thử upload → bị từ chối.

---

### 2.5. User chỉ cho phép UPLOAD, không được DOWNLOAD

> **Ứng dụng:** Tài khoản chỉ dùng để nộp file backup, không được tải về.

```bash
sudo adduser ftp_writeonly

# Tạo thư mục upload
sudo mkdir -p /home/ftp_writeonly/upload
# chmod 311 = Write(2)+Execute(1) nhưng KHÔNG có Read(4)
sudo chmod 311 /home/ftp_writeonly/upload
sudo chown ftp_writeonly:ftp_writeonly /home/ftp_writeonly/upload

# Cấu hình: BẬT write, TẮT download
sudo tee /etc/vsftpd/user_conf/ftp_writeonly <<EOF
write_enable=YES
download_enable=NO
EOF

sudo systemctl restart vsftpd
```

---

### 2.6. User có FULL quyền truy cập tất cả các folder

```bash
sudo adduser ftp_superuser

sudo tee /etc/vsftpd/user_conf/ftp_superuser <<EOF
write_enable=YES
download_enable=YES
EOF

# Đảm bảo chroot_local_user=NO trong /etc/vsftpd.conf

sudo systemctl restart vsftpd
```

---

### 2.7. Chuyển đổi quyền của 1 user NHANH NHẤT

Nhờ `user_config_dir`, chỉ cần **1 lệnh** là đổi quyền ngay:

```bash
# Cấp Full quyền (Upload + Download):
sudo tee /etc/vsftpd/user_conf/ftp_readonly <<EOF
write_enable=YES
download_enable=YES
EOF

# Đổi sang Read-only (chỉ Download):
sudo tee /etc/vsftpd/user_conf/ftp_readonly <<EOF
write_enable=NO
download_enable=YES
EOF

# Chặn hoàn toàn:
sudo tee /etc/vsftpd/user_conf/ftp_readonly <<EOF
write_enable=NO
download_enable=NO
EOF

# Áp dụng ngay lập tức
sudo systemctl restart vsftpd
```

> **Giải thích:** Mỗi user có 1 file tại `/etc/vsftpd/user_conf/[tên_user]`. Khi cần đổi quyền, chỉ cần ghi đè nội dung file đó bằng lệnh `tee` rồi restart vsftpd — không ảnh hưởng đến user khác.

---

## Bảng tổng hợp tất cả user

| User | SSH | FTP Upload | FTP Download | Phạm vi FTP |
|------|-----|-----------|--------------|-------------|
| `dunggnguyenn` | ✅ Full quyền | ✅ | ✅ | Toàn bộ |
| `dev_limited` | ✅ (không sudo) | — | — | — |
| `dev_admin` | ✅ Full quyền (sudo) | — | — | — |
| `ftp_full_access` | — | ✅ | ✅ | Toàn bộ |
| `ftp_user_only` | — | ✅ | ✅ | 1 folder (chroot) |
| `ftp_multi_folder` | — | ✅ | ✅ | Nhiều folder |
| `ftp_readonly` | — | ❌ | ✅ | Toàn bộ |
| `ftp_writeonly` | — | ✅ | ❌ | /upload only |
| `ftp_superuser` | — | ✅ | ✅ | Toàn bộ |

---

## PHẦN 1: SSH — Các cấu hình cơ bản

### 1.1. Đổi port SSH
Mặc định SSH dùng port 22, ta sẽ đổi sang một port khác (ví dụ: 2222) để tăng tính bảo mật.

```bash
sudo nano /etc/ssh/sshd_config
```
Tìm dòng có chữ `#Port 22`, bỏ dấu `#` và sửa thành:
```text
Port 2222
```
Sau đó khởi động lại dịch vụ SSH và mở tường lửa:
```bash
sudo systemctl restart ssh
sudo ufw allow 2222/tcp
```

### 1.2. Tạo người dùng không cho phép cài đặt (chỉ dùng môi trường hiện có)
Để tạo một user bị giới hạn, ta chỉ cần tạo user bình thường và **không** cấp quyền `sudo`.

```bash
# Tạo user mới (hệ thống sẽ hỏi mật khẩu và thông tin)
sudo adduser user_limited

# Kiểm tra xem user có nằm trong nhóm sudo không
groups user_limited
# Kết quả mong đợi: user_limited : user_limited (không có chữ sudo)
```
**Giải thích:** User này có thể kết nối SSH vào server, chạy các lệnh cơ bản (`ls`, `cd`, `git`, v.v.) nhưng không thể dùng lệnh `sudo` (ví dụ: `sudo apt install`) để cài đặt phần mềm hay thay đổi hệ thống.

### 1.3. Tạo người dùng cho phép full quyền (tương tự root)
Tạo user và cấp quyền `sudo` để user này có thể quản trị hệ thống.

```bash
# Tạo user mới
sudo adduser user_admin

# Cấp quyền sudo (full quyền quản trị)
sudo usermod -aG sudo user_admin

# Kiểm tra lại
groups user_admin
# Kết quả mong đợi: user_admin : user_admin sudo
```

### 1.4. Cho phép / Cấm truy cập SSH
Ta có thể cấu hình để chỉ cho phép một số user nhất định được phép SSH, hoặc cấm cụ thể ai đó.

```bash
sudo nano /etc/ssh/sshd_config
```
Thêm vào **cuối file** các cấu hình sau tùy mục đích:
```text
# Chỉ cho phép các user này SSH vào:
AllowUsers dunggnguyenn user_admin

# Hoặc nếu muốn cấm 1 user cụ thể:
DenyUsers user_limited
```
Sau đó khởi động lại SSH:
```bash
sudo systemctl restart ssh
```

---

## PHẦN 2: FTP — Các cấu hình cơ bản (sử dụng vsftpd)

Trước tiên, cài đặt FTP server (`vsftpd`):
```bash
sudo apt update
sudo apt install vsftpd -y
sudo systemctl start vsftpd
sudo systemctl enable vsftpd

# Backup lại file cấu hình gốc để phòng hờ
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bak
```

### 2.1. Tạo người dùng cho phép truy cập (download và upload file) [1]
Mặc định vsftpd có thể chỉ cho download. Ta cần bật quyền ghi (write).

```bash
sudo adduser ftp_user1
sudo nano /etc/vsftpd.conf
```
Tìm và sửa (hoặc thêm) các dòng sau:
```text
write_enable=YES
local_enable=YES
chroot_local_user=NO
```
Khởi động lại FTP:
```bash
sudo systemctl restart vsftpd
```

### 2.2. Tạo người dùng cho phép như [1], nhưng chỉ trong 1 folder nào đấy
Để nhốt (chroot) user vào thư mục cá nhân của họ, không cho đi lang thang ra các thư mục khác của hệ thống:

```bash
sudo adduser ftp_user2

# (Tùy chọn) Tạo một thư mục con riêng để chứa file
sudo mkdir -p /home/ftp_user2/ftp_folder
sudo chown ftp_user2:ftp_user2 /home/ftp_user2/ftp_folder

sudo nano /etc/vsftpd.conf
```
Thêm hoặc sửa cấu hình:
```text
chroot_local_user=YES
allow_writeable_chroot=YES
```
Khởi động lại FTP:
```bash
sudo systemctl restart vsftpd
```

### 2.3. Tạo người dùng cho phép như [1], nhưng trong nhiều hơn 1 folder nào đấy
Để user có thể đi qua lại giữa nhiều thư mục, ta phải **tắt tính năng chroot**.

```bash
sudo adduser ftp_user3

# Tạo các thư mục dùng chung
sudo mkdir -p /ftp_share/folder1 /ftp_share/folder2
sudo chown ftp_user3:ftp_user3 /ftp_share/folder1 /ftp_share/folder2

sudo nano /etc/vsftpd.conf
```
Đảm bảo cấu hình là:
```text
chroot_local_user=NO
```
*(User này sẽ có thể truy cập `folder1`, `folder2` hoặc bất kỳ thư mục nào họ có quyền đọc/ghi).*

### 2.4. Tạo người dùng chỉ cho phép download file, nhưng không được upload file
Ta tạo user và thiết lập quyền `write_enable=NO` **riêng** cho user này.

```bash
sudo adduser ftp_readonly

# Tạo thư mục chứa cấu hình riêng cho từng user
sudo mkdir -p /etc/vsftpd/user_conf

# Bỏ quyền upload của ftp_readonly
echo "write_enable=NO" | sudo tee /etc/vsftpd/user_conf/ftp_readonly

# Khai báo với vsftpd sử dụng thư mục cấu hình riêng này
echo "user_config_dir=/etc/vsftpd/user_conf" | sudo tee -a /etc/vsftpd.conf

sudo systemctl restart vsftpd
```

### 2.5. Tạo người dùng chỉ cho phép upload file, ko cho phép download file
Cách thực hiện: Cấp quyền ghi trên thư mục nhưng **tắt quyền đọc**, kết hợp cấu hình `download_enable=NO`.

```bash
sudo adduser ftp_writeonly

# Tạo thư mục upload
sudo mkdir -p /home/ftp_writeonly/upload

# Phân quyền 311: Có quyền Write (2) và Execute (1) = 3, KHÔNG có quyền Read (4)
sudo chmod 311 /home/ftp_writeonly/upload

# Cấu hình riêng cho user này: Tắt download, Bật upload
echo "write_enable=YES
download_enable=NO" | sudo tee /etc/vsftpd/user_conf/ftp_writeonly

sudo systemctl restart vsftpd
```

### 2.6. Tạo người dùng có full quyền truy cập tất cả các folder
Tạo user, cấp quyền `sudo` và đảm bảo vsftpd không giới hạn (chroot) user này.

```bash
sudo adduser ftp_full
sudo usermod -aG sudo ftp_full

# Đảm bảo cấu hình không giới hạn quyền đọc/ghi
echo "write_enable=YES
download_enable=YES" | sudo tee /etc/vsftpd/user_conf/ftp_full

sudo systemctl restart vsftpd
```
*(Lưu ý: FTP user có full quyền hệ thống là một rủi ro bảo mật lớn).*

---

### 2.7. Làm thế nào để chuyển đổi quyền của 1 user nhanh nhất?

**Cách nhanh nhất và chuẩn xác nhất** với vsftpd là sử dụng tính năng **User Config (Cấu hình riêng theo từng user)** kết hợp với lệnh ghi đè nội dung file.

Ví dụ, để chuyển đổi quyền của `ftp_user1`:

1.  **Muốn cấp quyền Full (Upload + Download):**
    ```bash
    echo "write_enable=YES
    download_enable=YES" | sudo tee /etc/vsftpd/user_conf/ftp_user1
    ```
2.  **Muốn đổi sang Read-only (Chỉ Download):**
    ```bash
    echo "write_enable=NO
    download_enable=YES" | sudo tee /etc/vsftpd/user_conf/ftp_user1
    ```
3.  **Khởi động lại dịch vụ** để áp dụng thay đổi ngay lập tức:
    ```bash
    sudo systemctl restart vsftpd
    ```

**Giải thích:**
Tính năng `user_config_dir` của vsftpd cho phép ghi đè các cấu hình chung. Khi cần đổi quyền, người quản trị chỉ cần chạy 1 lệnh `echo` duy nhất để sửa file cấu hình của riêng user đó mà không làm ảnh hưởng đến bất kỳ user nào khác, không cần phải cấu hình lại các nhóm (groups) rườm rà của Linux.
