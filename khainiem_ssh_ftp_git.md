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

## 4. Docker là gì và dùng để làm gì?

# Docker là gì?

```bash
Docker là một nền tảng mã nguồn mở cho phép các lập trình viên "đóng gói" toàn bộ ứng dụng cùng với tất cả các môi trường, thư viện, cấu hình đi kèm thành một khối độc lập duy nhất gọi là Container.

Nếu ví ứng dụng của bạn là hàng hóa, thì Docker chính là những chiếc thùng Container tiêu chuẩn. Bất kể bên trong thùng chứa cái gì (Website PHP, database MySQL, hay ứng dụng Java), nó đều có thể xếp lên mọi loại "tàu chở hàng" (máy tính Windows, Mac, hay Server Ubuntu) và chạy ngay lập tức mà không sợ bị đổ vỡ hay kén chọn môi trường.
```

# Docker dùng để làm gì?

```bash
    Giải quyết bài toán "Máy tôi chạy được nhưng máy bạn thì không": Khi làm bài tập nhóm, việc bạn cài MySQL bản 8.0, bạn kia cài bản 5.7 rất dễ gây lỗi code. Docker giúp cả nhóm dùng chung 1 Container duy nhất, đảm bảo môi trường ở mọi máy giống nhau 100%.

    Cô lập ứng dụng (Isolation): Mỗi Container chạy trong một không gian hoàn toàn độc lập. Nếu ứng dụng web của bạn bị lỗi hoặc bị virus tấn công, nó chỉ sập bên trong container đó chứ không thể làm hỏng hệ điều hành của máy thật.

    Cài đặt mọi thứ trong 1 giây: Thay vì mất nửa ngày để lên mạng tải, cấu hình và cài đặt một phần mềm phức tạp như MySQL hay WordPress, với Docker bạn chỉ cần gõ đúng 1 dòng lệnh, hệ thống sẽ tự tải về và chạy mượt mà sau vài giây.

    Tiết kiệm tài nguyên: Khác với Máy ảo (Virtual Machine như VMware, VirtualBox) phải chạy nguyên một hệ điều hành ảo rất nặng, Docker Container dùng chung nhân với hệ điều hành máy thật nên cực kỳ nhẹ, bật tắt chỉ mất 1-2 giây và tốn rất ít RAM.
```

# Các khái niệm cốt lõi cần nhớ trước khi gõ lệnh\

```bash
    Docker Image (Cái khuôn): Giống như một chiếc đĩa cài đặt phần mềm hoặc một "công thức nấu ăn" được đóng gói sẵn và lưu trữ trên mạng (Docker Hub). Nó ở trạng thái tĩnh (không chạy).

    Docker Container (Sản phẩm thực tế): Là một thực thể hoạt động được sinh ra từ Docker Image. Bạn có thể hiểu Image là "bản vẽ ngôi nhà", còn Container là "ngôi nhà thực tế" mà bạn có thể chui vào ở.
```

# Các lệnh Docker cơ bản

Nhóm 1: Quản lý "Khuôn mẫu" (Docker Image)

```bash
    docker pull <tên_image>

    // Mục đích: Tải Image từ Docker Hub về máy local. Ví dụ: docker pull mysql:5.7 hoặc docker pull wordpress. Đây giống như hành động tải file cài đặt (.exe, .dmg) về máy trước khi cài đặt.

    docker images

    // Mục đích: Liệt kê tất cả các Image đã được tải về máy tính của bạn. Bạn sẽ thấy tên Image, phiên bản (Tag), và dung lượng.

    docker rmi <tên_image_hoặc_id>

    // Mục đích: Xóa Image khỏi máy tính để giải phóng dung lượng. Bạn có thể dùng tên (ví dụ: rmi mysql:5.7) hoặc ID (mã số ngắn gọn hiển thị trong cột IMAGE ID).
```

Nhóm 2: Quản lý "Thùng chứa" (Docker Container)

```bash
    docker run -d --name <tên_container> -p <cổng_máy_thật>:<cổng_bên_trong> -e <BIẾN_MÔI_TRƯỜNG>=<giá_trị> <tên_image>

    // Mục đích: Đây là lệnh quan trọng nhất, dùng để "Bật" (chạy) một Container từ Image. Hãy bẻ nhỏ lệnh này như sau:

    -d (Detached Mode): Chạy nền (không làm treo máy).
    --name: Đặt tên cho Container để dễ quản lý (ví dụ: my-mysql-5-7).
    -p: Mở cổng (Port Mapping). Ví dụ: 8080:80 nghĩa là bạn có thể truy cập vào Container ở cổng 8080 trên máy tính của mình.
    -e: Thiết lập Biến môi trường (Environment Variables). Ví dụ: -e MYSQL_ROOT_PASSWORD=123456 để đặt mật khẩu cho MySQL ngay lúc khởi tạo.
    <tên_image>: Nguồn gốc để tạo ra Container này (ví dụ: mysql:5.7).


    docker ps

    // Mục đích: Liệt kê các Container đang chạy (Active). Nếu không thấy gì, nghĩa là không có Container nào đang chạy cả.

    docker ps -a

    // Mục đích: Liệt kê TẤT CẢ Container, bao gồm cả những Container đã tắt (Exited). Điều này rất hữu ích để xem lại các Container bạn đã tạo trước đó.

    docker stop <tên_container_hoặc_id>

    // Mục đích: Tắt (Stop) một Container đang chạy. Dữ liệu bên trong vẫn được giữ nguyên, giống như tắt máy tính thông thường.

    docker start <tên_container_hoặc_id>

    // Mục đích: Bật (Start) lại một Container đã bị tắt.

    docker restart <tên_container_hoặc_id>

    // Mục đích: Khởi động lại Container (Tắt rồi Bật lại).

    docker rm <tên_container_hoặc_id>

    // Mục đích: Xóa Container vĩnh viễn. Lưu ý: Bạn phải tắt Container trước khi có thể xóa nó.

    docker logs <tên_container_hoặc_id>

    // Mục đích: Xem nhật ký (Log) của Container. Ví dụ, khi bạn muốn xem lỗi của website, bạn dùng lệnh này để xem dòng lỗi cuối cùng.

    docker compose up --build -d

    // Mục đích: Đây là lệnh "đũa thần" của Docker. Khi bạn có một file docker-compose.yml định nghĩa sẵn nhiều Container (ví dụ: Web + Database + phpMyAdmin), lệnh này sẽ:

    Build: Biên dịch Image (nếu cần).
    Up: Bật tất cả các Container lên cùng lúc.
    -d: Chạy ở chế độ nền.
```

Nhóm 3: Tương tác và kiểm tra sâu bên trong Container

```bash
    docker exec -it <tên_container> <tên_lệnh>

    // Mục đích: Chạy một lệnh bên trong Container đang hoạt động.

    -it: (Interactive Terminal) Giúp bạn tương tác trực tiếp với Container.
    <tên_container>: Container bạn muốn chui vào (ví dụ: my-mysql-5-7).
    <tên_lệnh>: Lệnh bạn muốn chạy. Ví dụ phổ biến nhất để vào sâu bên trong là: bash

    // Ví dụ: Nếu bạn muốn vào bên trong container MySQL để kiểm tra file hoặc gõ lệnh mysql trực tiếp:

    docker exec -it my-mysql-5-7 bash
    (Lúc này Terminal của bạn sẽ chuyển sang giao diện của Linux bên trong Container)

    docker logs <tên_container>

    // Mục đích: Xem nhật ký (Log) của Container. Ví dụ, khi bạn muốn xem lỗi của website, bạn dùng lệnh này để xem dòng lỗi cuối cùng.

    docker exec -it <tên_container> bash

```
