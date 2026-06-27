<?php
/**
 * Auth Controller
 * Xử lý logic xác thực người dùng
 */


require_once __DIR__ . '/../Models/Auth.php';

class AuthController extends Controller {
    private $authRepo;

    public function __construct() {
        $this->authRepo = new AuthModel();
    }

    /**
     * Trang login
     */
    public function index() {
        // Nếu đã login, redirect đến dashboard
        if ($this->getSession('user_id')) {
            $this->redirect(BASE_URL . 'auth/dashboard');
        }

        $this->view('auth/login');
    }

    /**
     * Xử lý login
     */
    public function login() {
        if (!$this->isPost()) {
            $this->redirect(BASE_URL . 'auth');
        }

        $masv = $this->getInput('masv');
        $password = $this->getInput('password');

        // Kiểm tra input
        if (empty($masv) || empty($password)) {
            $_SESSION['error'] = 'Tên đăng nhập và mật khẩu không được để trống!';
            $this->redirect(BASE_URL . 'auth');
        }

        // Xác thực người dùng
        $account = $this->authRepo->authenticate($masv, $password);

        if (!$account) {
            $_SESSION['error'] = 'Tên đăng nhập hoặc mật khẩu không chính xác!';
            $this->redirect(BASE_URL . 'auth');
        }

        // Lưu session - dùng masv làm user_id vì bảng taikhoan_user không có cột id
        $this->setSession('user_id', $account['masv']);
        $this->setSession('masv', $account['masv']);
        if (isset($account['hoten'])) {
            $this->setSession('hoten', $account['hoten']);
        }
        $_SESSION['success'] = 'Đăng nhập thành công!';

        // Redirect tới action dashboard trong module auth
        $this->redirect(BASE_URL . 'auth/dashboard');
    }

    /**
     * Logout
     */
    public function logout() {
        session_destroy();
        $_SESSION = [];
        $this->redirect(BASE_URL . 'auth');
    }

    /**
     * Dashboard
     */
    public function dashboard() {
        // Kiểm tra đã login hay chưa
        if (!$this->getSession('user_id')) {
            $this->redirect(BASE_URL . 'auth');
        }

        // Lấy tên sinh viên từ session (đã lưu khi đăng nhập)
        $hoten = $this->getSession('hoten');

        $data = [
            'masv' => $this->getSession('masv'),
            'user_id' => $this->getSession('user_id'),
            'hoten' => $hoten
        ];

        $this->view('auth/dashboard', $data);
    }