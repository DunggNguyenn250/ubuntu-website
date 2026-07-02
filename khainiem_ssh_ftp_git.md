## 1. SSH (Secure Shell) là gì và dùng để làm gì?

# SSH là gì?

SSH là một giao thức mạng dùng để thiết lập một kết nối mã hóa an toàn giữa máy tính của bạn (Client) và máy chủ từ xa (Server). Cổng kết nối (Port) mặc định của SSH là 22.

# Dùng để làm gì?

SSH cung cấp cho bạn một giao diện dòng lệnh (Terminal) để bạn điều khiển máy chủ bằng các câu lệnh văn bản. Khi bạn SSH vào máy chủ, bạn có thể:

```bash
    Cài đặt phần mềm, dịch vụ (như cài Docker, MySQL, Apache, Nginx...).

    Khởi động, dừng hoặc restart các dịch vụ hệ thống (như sudo systemctl restart vsftpd).

    Quản lý người dùng, phân quyền file/thư mục (như chown, chmod).

    Cấu hình hệ thống thông qua các trình chỉnh sửa văn bản dạng dòng lệnh (như nano, vim).



💡 Hình tượng hóa: SSH giống như việc bạn kết nối Bàn phím và Màn hình Terminal vào máy chủ. Bạn dùng nó để "ra lệnh" cho máy tính làm việc.

```

# Tóm tắt các lệnh phần SSH

```bash
    // Để lấy IP của máy ảo Host-only
    hostname -I

    // Khởi tạo kho lưu trữ Git
    git init

    // Tạo user mới
    sudo adduser user_limited

    // Cấp quyền sudo (full quyền quản trị)
    sudo usermod -aG sudo user_admin

    // Xóa sạch sẽ cả tài khoản và dữ liệu (Khuyên dùng khi làm bài tập)
    sudo deluser --remove-home user_limited

    // Cấu hình SSH - Đổi cấu hình từ Port 22 sang cổng bất kỳ (như 2222)
    sudo nano /etc/ssh/sshd_config


```

## 2. FTP (File Transfer Protocol) là gì và dùng để làm gì?

# FTP là gì?

FTP là giao thức truyền tải tập tin tiêu chuẩn giữa máy tính của bạn và máy chủ. Nó được thiết kế riêng cho mục đích di chuyển file dữ liệu. Cổng kết nối mặc định của FTP là 21 (hoặc cổng 22 nếu dùng bản bảo mật SFTP).

# Dùng để làm gì?

FTP được sử dụng để quản lý cấu trúc file, thư mục và truyền tải dữ liệu qua lại giữa máy thật và máy chủ. Thường bạn sẽ dùng các phần mềm có giao diện kéo thả (như FileZilla) để thực hiện:

```bash

    Upload (tải lên) mã nguồn website, hình ảnh, video, file database .sql từ máy thật lên máy chủ.

    Download (tải về) các file backup, file dữ liệu, log hệ thống từ máy chủ về máy thật để lưu trữ.

    Đổi tên, xóa file, hoặc tạo các thư mục lưu trữ dữ liệu trực quan bằng chuột mà không cần gõ lệnh.

💡 Hình tượng hóa: FTP giống như một sợi dây cáp dữ liệu (hoặc cổng USB) kết nối ổ cứng máy chủ với máy thật của bạn. Bạn dùng nó để copy-paste file.
```

# Tóm tắt các lệnh phần FTP

```bash
    // Cài đặt FTP Server (vsftpd)
    sudo apt install vsftpd

    // Cấu hình FTP Server
    sudo nano /etc/vsftpd.conf

    // Cấu hình FTP - Tạo thư mục lưu trữ user
    sudo mkdir -p /srv/ftp/user_limited

    // Cấu hình FTP - Cấp quyền sở hữu thư mục
    sudo chown user_limited:user_limited /srv/ftp/user_limited

    // Cấu hình FTP - Thiết lập quyền
    sudo chmod 775 /srv/ftp/user_limited

    // Mở cổng FTP
    sudo ufw allow 20/tcp
    sudo ufw allow 21/tcp

    // Cấu hình FTP - Cho phép local user
    local_enable=YES

    // Cấu hình FTP - Cho phép ghi file
    write_enable=YES

    -- Bật tính năng FTP cơ bản
    // Cho phép tài khoản local đăng nhập và có quyền Đọc + Ghi (Upload + Download) dữ liệu mặc định.

    chroot_local_user=YES
    // Nhốt User vào thư mục riêng
    // User đăng nhập vào sẽ bị giữ chân trong folder cá nhân của họ, không thể bấm lùi ra để "ngó nghiêng" các file hệ thống khác.

    write_enable=NO
    // Cấm ghi dữ liệu (Read-only)
    // Khóa chặt tính năng Upload file và tạo thư mục mới. User chỉ được phép tải file từ Server về máy thật.

    download_enable=NO
    + chmod 311 <thư_mục>
    // Cấm tải về (Private Content)
    // Không cho phép User tải bất cứ thứ gì xuống máy của họ.

    user_config_dir=/etc/vsftpd/user_conf
    // Kích hoạt folder cấu hình riêng cho từng user
    // Cho phép quản trị viên tạo file cấu hình riêng (ví dụ: /etc/vsftpd/user_conf/user_limited) để tùy chỉnh quyền cho từng người mà không đụng chạm đến file cấu hình chung /etc/vsftpd.conf.

```

## 3. GitHub là gì và dùng để làm gì?

# GitHub là gì?

```bash
GitHub là một dịch vụ lưu trữ trên đám mây (Cloud) dành cho các dự án lập trình. Nó sử dụng hệ thống quản lý phiên bản Git để theo dõi toàn bộ quá trình thay đổi mã nguồn (source code) của lập trình viên.

Nếu ví Git là một "bộ máy" chạy bằng dòng lệnh trên máy tính của bạn, thì GitHub chính là một "mạng xã hội" hoặc một "kho lưu trữ trực tuyến" khổng lồ kết nối hàng triệu lập trình viên trên thế giới.
```

# GitHub dùng để làm gì?

```bash
Lưu trữ mã nguồn an toàn: Giúp bạn đưa toàn bộ project, bài tập lớn, hoặc file database (như file .sql của bạn) lên mạng. Cho dù máy tính của bạn có bị hỏng, code của bạn vẫn an toàn trên GitHub.

Quản lý lịch sử (Version Control): GitHub ghi lại chi tiết ai đã sửa gì, vào lúc nào, ở dòng code nào. Nếu code mới bị lỗi, bạn có thể dễ dàng "quay du hành thời gian" về phiên bản chạy ổn định ngày hôm trước.

Làm việc nhóm dễ dàng: Nhiều lập trình viên có thể cùng lao vào sửa chung một project mà không sợ bị ghi đè hay mất file của nhau nhờ tính năng chia nhánh (Branch) và gộp code (Merge).

Làm "Portfolio" (Hồ sơ năng lực): GitHub giống như một chiếc CV công nghệ của bạn. Khi đi xin việc, nhà tuyển dụng chỉ cần nhìn vào trang GitHub của bạn là biết bạn có chăm chỉ code hay không và trình độ viết code như thế nào.
```

# Các câu lệnh Git cơ bản trên Terminal và mục đích sử dụng

```bash
Để đưa được code lên GitHub bằng giao diện dòng lệnh (Terminal/Command Prompt), bạn sẽ cần sử dụng các câu lệnh Git cốt lõi sau đây. Chúng được chia làm 4 nhóm theo đúng quy trình làm việc thực tế:
```

Nhóm 1: Khởi tạo và kết nối

```bash
    git init

    // Mục đích: Khởi tạo một kho lưu trữ Git (gọi là Git Repository hay .git folder) ngay tại thư mục dự án trên máy tính của bạn. Đây là bước đầu tiên để bắt đầu "theo dõi" thay đổi.

    git clone <đường_dẫn_url>

    // Mục đích: Tải toàn bộ code và lịch sử của một dự án trên GitHub về máy tính của bạn. Thường dùng khi bạn muốn lấy bài tập về để sửa tiếp.

    git remote add origin <URL_CỦA_REPO>

    // Mục đích: Liên kết kho lưu trữ local (máy tính bạn) với kho lưu trữ remote (GitHub). <URL_CỦA_REPO> là địa chỉ https://github.com/TênUser/TênRepo.git mà bạn tạo trên web.

    git branch -M main

    // Mục đích: Đổi tên nhánh (Branch) hiện tại thành "main". Đây là quy ước tên nhánh chính của hầu hết các dự án hiện đại trên GitHub.
```

Nhóm 2: Chuẩn bị dữ liệu (Lên lịch đóng gói)

```bash
    git status

    // Mục đích: Xem trạng thái của dự án. Lệnh này sẽ báo cho bạn biết file nào đã thay đổi, file nào đã được thêm vào "danh sách chờ" (staging area) và file nào chưa được Git theo dõi.

    git add <tên_file> hoặc git add .

    // Mục đích: Đưa file vào vùng chờ (Staging Area) để chuẩn bị cho việc đóng gói (Commit). Nếu dùng dấu chấm (.) là thêm tất cả các file thay đổi.
```

Nhóm 3: Lưu trữ dưới máy local

```bash
    git commit -m "Nội dung mô tả ngắn gọn thay đổi"

    // Mục đích: Đóng gói và ghi nhật ký (Commit) phiên bản hiện tại của dự án và lưu nó vĩnh viễn vào lịch sử local của bạn. Dòng "Nội dung mô tả" nên tóm tắt bạn đã sửa gì (ví dụ: "Fix lỗi đăng nhập", "Thêm trang liên hệ").
```

Nhóm 4: Đẩy code lên GitHub

```bash
    git push -u origin main

    // Mục đích: Đẩy code lên mạng (Push) toàn bộ code đã commit từ máy tính của bạn lên kho lưu trữ trên GitHub (Remote Repository). Lệnh này sẽ làm xuất hiện project và các file của bạn trên trang github.com.

    git pull origin main

    // Mục đích: Kéo code mới nhất từ GitHub về máy tính. Trường hợp bạn làm việc nhóm, nếu người khác đã push code lên trước, bạn cần lệnh này để cập nhật máy mình trước khi bắt đầu làm tiếp.
```

Nhóm 5: Quản lý nhánh

```bash
    git branch

    // Mục đích: Liệt kê tất cả các nhánh hiện có trong dự án local. Nhánh đang được chọn (hiện tại của bạn) sẽ có dấu sao (*) bên cạnh.

    git branch <tên_nhánh_mới>

    // Mục đích: Tạo một nhánh mới dựa trên phiên bản hiện tại của bạn. Đây là bước quan trọng để tạo "nhánh thử nghiệm" (feature branch) trước khi gộp vào main.

    git checkout <tên_nhánh>

    // Mục đích: Chuyển sang làm việc trên nhánh khác. Ví dụ: git checkout main để quay về nhánh chính, hoặc git checkout feature-a để sang nhánh vừa tạo.


    git checkout -b <tên_nhánh>

    // Mục đích: Tạo một nhánh mới và chuyển sang làm việc trên nhánh đó ngay lập tức. Tương đương với việc chạy lệnh git branch <tên_nhánh> và sau đó là git checkout <tên_nhánh>.

    git fetch

    // Mục đích: Tải thông tin nhánh và các thay đổi từ Remote Repository (GitHub) về Local Repository (máy tính của bạn), nhưng KHÔNG tự động gộp (merge) vào nhánh hiện tại. Lệnh này giúp bạn xem trước có thay đổi gì mới mà không làm ảnh hưởng đến code đang làm dở của mình.
```

-- Gộp nhánh

```bash
    git merge feature (Gộp nhánh dưới máy Local)

    // Đây là hành động bạn tự gộp các nhánh do chính bạn tạo ra và đang nằm hoàn toàn dưới máy tính của bạn.

    git merge origin/feature (Gộp nhánh từ trên mạng GitHub xuống)

    // Cụm từ origin/ đại diện cho "Phản chiếu của GitHub dưới máy bạn". Khi bạn thấy origin/feature, đó là nhánh feature đang nằm trên GitHub do người khác đẩy lên.

```
