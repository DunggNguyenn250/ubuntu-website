# Hướng dẫn Thực hành SSH và FTP trên Ubuntu

Tài liệu này hướng dẫn chi tiết các bước để thực hiện yêu cầu cấu hình SSH và FTP cơ bản trên Ubuntu.

---

# Cách để lấy đung IP Host-only để kết nối

    ```bash
        hostname -I
    ```

Bạn nhìn vào kết quả, sẽ thấy máy ảo bây giờ có 2 địa chỉ IP khác nhau (tương ứng với 2 card mạng bạn đã bật):

Một IP dùng để ra mạng (bỏ qua cái này).

Một IP thường có đầu số là 192.168.56.x (nếu dùng VirtualBox) hoặc dải khác tương tự. Đây chính là IP của card Host-only.

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

    Nếu bạn đổi port trong file cấu hình thành 2222 nhưng quên chạy lệnh sudo ufw allow 2222/tcp, thì ngay sau khi bạn khởi động lại SSH, tường lửa sẽ chặn đứng cổng 2222 lại và bạn sẽ bị ngắt kết nối hoàn toàn khỏi server (bị lỗi Connection refused hoặc Timeout).

# Cách 1: Chỉ liệt kê các tài khoản do con người tạo ra (Khuyên dùng)

Mặc định khi bạn tạo một tài khoản thông thường trên Ubuntu, hệ thống sẽ cấp cho tài khoản đó một ID (gọi là UID) bắt đầu từ 1000 trở đi. Lệnh này sẽ lọc ra chính xác những tài khoản này:

```bash
awk -F: '$3 >= 1000 && $3 != 65534 {print $1}' /etc/passwd

```

# Trường hợp 1: Đăng nhập bằng tài khoản Quản trị (dunggnguyenn)

Tài khoản này có toàn quyền (nằm trong nhóm sudo). Bạn dùng lệnh này từ máy thật:

```bash
 ssh dunggnguyenn@192.168.190.128 -p 2222
```

# Trường hợp 2: Đăng nhập bằng tài khoản Giới hạn (user_limited)

Tài khoản này chỉ dùng để xem code hoặc chạy lệnh cơ bản, không có quyền admin.

```bash
 ssh user_limited@192.168.190.128 -p 2222
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

# Nhóm lệnh quản lý File và Thư mục (Thao tác cơ bản)

Đây là những lệnh để di chuyển và quản lý dữ liệu.

# pwd (Print Working Directory): Xem mình đang đứng ở thư mục nào.

# cd (Change Directory): Di chuyển qua lại giữa các thư mục.

Ví dụ: cd ~ để về ngay thư mục nhà của mình. User thường có thể cd /etc (thư mục hệ thống) để vào xem, nhưng không thể tạo file trong đó.

# ls (List): Liệt kê các file và thư mục con. Thường dùng ls -la để xem cả file ẩn và quyền hạn (permissions) của file.

# mkdir (Make Directory) & touch: Tạo thư mục mới hoặc tạo một file rỗng.

Giới hạn: Chỉ chạy được trong /home/tên_user hoặc thư mục /tmp (thư mục tạm). Nếu gõ mkdir /test_folder ở thư mục gốc, hệ thống sẽ báo ngay: Permission denied.

# cp (Copy) & mv (Move/Rename): Sao chép hoặc di chuyển/đổi tên file.

# rm (Remove): Xóa file hoặc thư mục (rm -rf).

⚠️ Cảnh báo an toàn: User thường chỉ xóa được file do chính họ tạo ra hoặc file họ có quyền sở hữu. Họ không thể gõ rm -rf / để xóa sạch hệ điều hành được (lệnh này bắt buộc phải có sudo).

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

# Cách 1: Chỉ xóa tài khoản, GIỮ LẠI file cá nhân (An toàn)

Lệnh này sẽ xóa tên user khỏi hệ thống, user đó sẽ không thể đăng nhập được nữa. Tuy nhiên, toàn bộ thư mục code, file dữ liệu của họ ở /home/tên_user vẫn sẽ được giữ lại để phòng trường hợp sau này bạn cần lấy lại file.

Ví dụ bạn muốn xóa user_limited:

```bash
sudo deluser user_limited
```

# Cách 2: Xóa SẠCH SẼ cả tài khoản và dữ liệu (Khuyên dùng khi làm bài tập)

Lệnh này sẽ xóa bỏ hoàn toàn user, đồng thời quét sạch thư mục /home/tên_user của họ trên ổ cứng. Máy sẽ sạch sẽ như chưa từng có user này tồn tại.

Ví dụ bạn muốn xóa sạch user_limited:

```bash
sudo deluser --remove-home user_limited
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

# Ấn Ctrl + O (để thực hiện lệnh ghi file - WriteOut).

# Ấn phím Enter để xác nhận lưu vào file /etc/ssh/sshd_config.

# Ấn Ctrl + X để thoát màn hình nano quay về lại Terminal.

Sau đó khởi động lại SSH:

```bash
sudo systemctl restart ssh
```

---

## PHẦN 2: FTP — Các cấu hình cơ bản (sử dụng vsftpd)

Trước tiên, cài đặt FTP server (`vsftpd`):

```bash
sudo apt update -- Cập nhật danh mục phần mềm.
sudo apt install vsftpd -y
-- Cài đặt vsftpd.

sudo systemctl start vsftpd -- Bật vsftpd.
sudo systemctl enable vsftpd -- Bật vsftpd khi khởi động.

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

```bash
write_enable=YES -- bỏ dấu #
local_enable=YES

chroot_local_user=NO -- thêm vào, đằng sau #utf8_filesystem=YES (dòng cuối cùng)
```

# Cuối cùng, bạn chỉ cần bấm Ctrl + O -> nhấn Enter để lưu, rồi Ctrl + X để thoát ra ngoài và restart lại dịch vụ là xong!

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

```bash
chroot_local_user=YES -- nếu làm 2.1 rồi thì sửa lại, không thì phải thêm
allow_writeable_chroot=YES -- thêm vào, đằng sau #utf8_filesystem=YES (dòng cuối cùng)
-- ngay sau chroot_local_user=YES
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

```bash
chroot_local_user=NO -- chỉ cần sửa lại thôi
```

Khởi động lại FTP:

```bash
sudo systemctl restart vsftpd
```

_(User này sẽ có thể truy cập `folder1`, `folder2` hoặc bất kỳ thư mục nào họ có quyền đọc/ghi)._

### 2.4. Tạo người dùng chỉ cho phép download file, nhưng không được upload file

Ta tạo user và thiết lập quyền `write_enable=NO` **riêng** cho user này.

````bash
sudo adduser ftp_readonly

# Tạo thư mục chứa cấu hình riêng cho từng user
sudo mkdir -p /etc/vsftpd/user_conf

# Bỏ quyền upload của ftp_readonly
echo "write_enable=NO" | sudo tee /etc/vsftpd/user_conf/ftp_readonly

# Khai báo với vsftpd sử dụng thư mục cấu hình riêng này
echo "user_config_dir=/etc/vsftpd/user_conf" | sudo tee -a /etc/vsftpd.conf

Sau khi chạy xong, nếu muốn cẩn thận kiểm tra xem file cấu hình chính trông như thế nào, bạn có thể chạy lệnh:

```bash
tail -n 5 /etc/vsftpd.conf

(Lệnh này sẽ hiển thị 5 dòng cuối cùng của file cấu hình để bạn xem xem dòng chữ đã được chèn vào đẹp đẽ và chuẩn xác chưa)

sudo systemctl restart vsftpd

````

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

_(Lưu ý: FTP user có full quyền hệ thống là một rủi ro bảo mật lớn)._

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
