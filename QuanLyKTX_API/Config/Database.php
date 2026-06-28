<?php
namespace Config;

class Database {

    private static $connection = null;

    public static function getConnection() {

        if (self::$connection === null) {

            $host = 'localhost';     // Dùng localhost khi chạy với XAMPP
            $user = 'root';
            $pass = '';              // Mật khẩu mặc định của XAMPP thường để trống
            $db   = 'quanlykytucxa';
            $port = 3306;            // Đã đổi từ 3307 về cổng 3306 mặc định

            self::$connection = new \mysqli($host, $user, $pass, $db, $port);

            if (self::$connection->connect_error) {
                die("Lỗi kết nối CSDL: " . self::$connection->connect_error);
            }
            self::$connection->set_charset("utf8");
        }
        return self::$connection;
    }
}