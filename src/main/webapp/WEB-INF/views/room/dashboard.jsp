<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hệ Thống Quản Lý BOA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --secondary-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --success-gradient: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            --warning-gradient: linear-gradient(135deg, #f2994a 0%, #f2c94c 100%);
            --danger-gradient: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
        }

        .navbar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            box-shadow: 0 2px 20px rgba(0,0,0,0.1);
        }

        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
            color: #2c3e50;
        }

        .hero-section {
            max-width: 1400px;
            margin: 30px auto;
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }

        .hero-banner {
            position: relative;
            height: 400px;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.9) 0%, rgba(118, 75, 162, 0.9) 100%),
                        url('https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=1600') center/cover;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: white;
            padding: 40px;
        }

        .hero-content h1 {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 20px;
            text-shadow: 2px 2px 10px rgba(0,0,0,0.3);
        }

        .hero-content p {
            font-size: 1.3rem;
            opacity: 0.95;
            margin-bottom: 30px;
        }

        .hero-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn-hero {
            padding: 15px 35px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1.1rem;
            border: none;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .btn-hero-primary {
            background: linear-gradient(135deg, #f2994a 0%, #f2c94c 100%);
            color: white;
        }

        .btn-hero-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(242, 153, 74, 0.4);
            color: white;
        }

        .btn-hero-secondary {
            background: white;
            color: #667eea;
        }

        .btn-hero-secondary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(255,255,255,0.3);
            color: #667eea;
        }

        .features-section {
            padding: 60px 40px;
        }

        .section-title {
            text-align: center;
            margin-bottom: 50px;
        }

        .section-title h2 {
            font-size: 2.5rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 15px;
        }

        .section-title p {
            font-size: 1.1rem;
            color: #7f8c8d;
        }

        .feature-card {
            background: white;
            border-radius: 20px;
            padding: 40px 30px;
            text-align: center;
            transition: all 0.3s;
            border: 2px solid transparent;
            height: 100%;
            position: relative;
            overflow: hidden;
        }

        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: var(--card-gradient);
            transform: scaleX(0);
            transition: transform 0.3s;
        }

        .feature-card:hover::before {
            transform: scaleX(1);
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
            border-color: var(--card-color);
        }

        .feature-icon {
            width: 100px;
            height: 100px;
            margin: 0 auto 25px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: white;
            background: var(--card-gradient);
            position: relative;
            overflow: hidden;
        }

        .feature-icon::after {
            content: '';
            position: absolute;
            width: 100%;
            height: 100%;
            background: rgba(255,255,255,0.2);
            transform: rotate(45deg) translateX(-100%);
            transition: transform 0.6s;
        }

        .feature-card:hover .feature-icon::after {
            transform: rotate(45deg) translateX(100%);
        }

        .feature-card h3 {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 15px;
        }

        .feature-card p {
            color: #7f8c8d;
            margin-bottom: 25px;
            line-height: 1.6;
        }

        .feature-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: var(--card-color);
            font-weight: 600;
            text-decoration: none;
            padding: 12px 25px;
            border-radius: 10px;
            border: 2px solid var(--card-color);
            transition: all 0.3s;
        }

        .feature-link:hover {
            background: var(--card-gradient);
            color: white;
            border-color: transparent;
            transform: scale(1.05);
        }

        /* Card Colors */
        .card-rooms {
            --card-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --card-color: #667eea;
        }

        .card-tenants {
            --card-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --card-color: #f093fb;
        }

        .card-contracts {
            --card-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            --card-color: #4facfe;
        }

        .card-payments {
            --card-gradient: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            --card-color: #11998e;
        }

        .card-statistics {
            --card-gradient: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
            --card-color: #ff6b6b;
        }

        @media (max-width: 768px) {
            .hero-content h1 {
                font-size: 2rem;
            }

            .hero-content p {
                font-size: 1rem;
            }

            .hero-buttons {
                flex-direction: column;
            }

            .section-title h2 {
                font-size: 1.8rem;
            }
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-light">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/trang-chu">
            <i class="fas fa-home"></i> BOA
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/trang-chu">Bảng Điều Khiển</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/quan-ly-phong">Phòng</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/quan-ly-khach-thue">Khách Thuê</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/quan-ly-hop-dong">Hợp Đồng</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/quan-ly-thanh-toan">Thanh Toán</a>
                </li>
                <c:if test="${sessionScope.user.role == 'admin'}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/thong-ke">Thống Kê</a>
                    </li>
                </c:if>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user-circle"></i> ${sessionScope.user.username}
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/auth?action=logout">
                            <i class="fas fa-sign-out-alt"></i> Đăng Xuất
                        </a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<div class="hero-section">
    <div class="hero-banner">
        <div class="hero-content">
            <h1>Hệ Thống Quản Lý B O A</h1>
            <p>Chào mừng trở lại, <strong>${sessionScope.user.fullName}</strong>! Mọi thông tin tổng quan đều được cập nhật tại đây.</p>
            <div class="hero-buttons">
                <a href="${pageContext.request.contextPath}/quan-ly-phong" class="btn btn-hero btn-hero-primary">
                    <i class="fas fa-home"></i> Xem Phòng Trọ
                </a>
                <a href="${pageContext.request.contextPath}/thong-ke" class="btn btn-hero btn-hero-secondary">
                    <i class="fas fa-chart-line"></i> Xem Thống Kê
                </a>
            </div>
        </div>
    </div>

    <!-- Features Section -->
    <div class="features-section">
        <div class="section-title">
            <h2>Các Chức Năng Chính</h2>
            <p>Quản lý toàn diện mọi hoạt động của phòng trọ</p>
        </div>

        <div class="row g-4 justify-content-center">
            <!-- Phòng -->
            <div class="col-md-6 col-lg">
                <div class="feature-card card-rooms">
                    <div class="feature-icon">
                        <i class="fas fa-building"></i>
                    </div>
                    <h3>Phòng</h3>
                    <p>Thêm, sửa, xóa phòng trọ và cập nhật trạng thái.</p>
                    <a href="${pageContext.request.contextPath}/quan-ly-phong" class="feature-link">
                        Quản Lý Phòng <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>

            <!-- Khách Thuê -->
            <div class="col-md-6 col-lg">
                <div class="feature-card card-tenants">
                    <div class="feature-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <h3>Khách Thuê</h3>
                    <p>Quản lý hồ sơ khách, thông tin liên hệ và lịch sử thuê nhà.</p>
                    <a href="${pageContext.request.contextPath}/quan-ly-khach-thue" class="feature-link">
                        Quản Lý Khách <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>

            <!-- Hợp Đồng -->
            <div class="col-md-6 col-lg">
                <div class="feature-card card-contracts">
                    <div class="feature-icon">
                        <i class="fas fa-file-contract"></i>
                    </div>
                    <h3>Hợp Đồng</h3>
                    <p>Tạo mới, gia hạn và kết thúc hợp đồng thuê nhà.</p>
                    <a href="${pageContext.request.contextPath}/quan-ly-hop-dong" class="feature-link">
                        Quản Lý Hợp Đồng <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>

            <!-- Thanh Toán -->
            <div class="col-md-6 col-lg">
                <div class="feature-card card-payments">
                    <div class="feature-icon">
                        <i class="fas fa-money-bill-wave"></i>
                    </div>
                    <h3>Thanh Toán</h3>
                    <p>Theo dõi công nợ, hóa đơn điện nước và thực hiện thanh toán.</p>
                    <a href="${pageContext.request.contextPath}/quan-ly-thanh-toan" class="feature-link">
                        Quản Lý Thanh Toán <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>

            <!-- Thống Kê - CHỈ HIỂN THỊ CHO ADMIN -->
            <c:if test="${sessionScope.user.role == 'admin'}">
                <div class="col-md-6 col-lg">
                    <div class="feature-card card-statistics">
                        <div class="feature-icon">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <h3>Thống Kê</h3>
                        <p>Theo dõi doanh thu, biểu đồ và báo cáo kinh doanh.</p>
                        <a href="${pageContext.request.contextPath}/thong-ke" class="feature-link">
                            Xem Thống Kê <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>