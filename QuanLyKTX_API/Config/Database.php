<?php
namespace Config;

class Database {

    private static $connection = null;

    public static function getConnection() {

        if (self::$connection === null) {

            $host = 'localhost';     // Dùng localhost khi chạy với XAMPP
            $user = 'root';
            $pass = ''; // Khớp với MYSQL_ROOT_PASSWORD trong docker-compose.yml
            $db   = 'quanlykytucxa';
            $port = 3307;            // Cổng MySQL của XAMPP (3306 bị chiếm, dùng 3307)

            self::$connection = new \mysqli($host, $user, $pass, $db, $port);

            if (self::$connection->connect_error) {
                die("Lỗi kết nối CSDL: " . self::$connection->connect_error);
            }
            self::$connection->set_charset("utf8");
        }
        return self::$connection;
    }
}