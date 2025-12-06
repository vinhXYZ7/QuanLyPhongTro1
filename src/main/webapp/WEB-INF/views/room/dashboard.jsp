<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Bảng Điều Khiển" scope="request"/>
<jsp:include page="../layout/_header.jsp" />

<style>
    body {
        background-image: none !important;
        background-color: #f8f9fa;
    }

    /* Hero Banner */
    .hero-banner {
        background-image: url('https://goghepminhcuong.com/wp-content/uploads/2023/12/AdobeStock_621015737-scaled.jpeg');
        background-size: cover;
        background-position: center;
        padding: 120px 0;
        margin-bottom: 50px;
        color: white;
        text-align: center;
        box-shadow: 0 4px 20px rgba(0,0,0,0.2);
        position: relative;
    }

    .hero-content {
        position: relative;
        z-index: 2;
    }

    .hero-banner h1 {
        font-size: 3.5rem;
        font-weight: 700;
        margin-bottom: 20px;
        text-shadow: 0 0 10px rgba(0, 0, 0, 0.8), 0 0 20px rgba(0, 0, 0, 0.6);
        animation: fadeInDown 1s ease;
        color: white;
    }

    .hero-banner p {
        font-size: 1.4rem;
        opacity: 0.95;
        max-width: 700px;
        margin: 0 auto;
        text-shadow: 0 0 5px rgba(0,0,0,0.5);
        animation: fadeInUp 1s ease 0.3s both;
        color: white;
    }

    .welcome-name {
        font-weight: 700;
        color: #ffd700;
        text-shadow: 0 2px 10px rgba(0,0,0,0.5);
    }

    @keyframes fadeInDown {
        from {
            opacity: 0;
            transform: translateY(-30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* Features Section */
    .features-section {
        padding: 0 0 60px 0;
    }

    .section-title {
        text-align: center;
        margin-bottom: 50px;
    }

    .section-title h2 {
        font-size: 2rem;
        font-weight: 700;
        color: #2c3e50;
        margin-bottom: 10px;
    }

    .section-title p {
        font-size: 1rem;
        color: #7f8c8d;
    }

    /* Feature Cards */
    .feature-card {
        background: white;
        border-radius: 15px;
        padding: 35px 25px;
        text-align: center;
        transition: all 0.3s;
        border: 2px solid #e0e0e0;
        height: 100%;
        position: relative;
        overflow: hidden;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }

    .feature-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 4px;
        background: var(--card-gradient);
        transform: scaleX(0);
        transition: transform 0.3s;
    }

    .feature-card:hover::before {
        transform: scaleX(1);
    }

    .feature-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        border-color: var(--card-color);
    }

    .feature-icon {
        width: 80px;
        height: 80px;
        margin: 0 auto 20px;
        border-radius: 15px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 2.5rem;
        color: white;
        background: var(--card-gradient);
    }

    .feature-card h3 {
        font-size: 1.3rem;
        font-weight: 700;
        color: #2c3e50;
        margin-bottom: 12px;
    }

    .feature-card p {
        color: #7f8c8d;
        margin-bottom: 20px;
        line-height: 1.5;
        font-size: 0.95rem;
        flex-grow: 1;
    }

    .feature-link {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        color: var(--card-color);
        font-weight: 600;
        text-decoration: none;
        padding: 12px 25px;
        border-radius: 8px;
        border: 2px solid var(--card-color);
        transition: all 0.3s;
        font-size: 0.9rem;
        margin: 0 auto;
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
        .hero-banner h1 {
            font-size: 2rem;
        }

        .hero-banner p {
            font-size: 1.1rem;
        }

        .section-title h2 {
            font-size: 1.6rem;
        }
    }
</style>

<div class="hero-banner">
    <div class="hero-content">
        <div class="container">
            <h1>🏠 Hệ Thống Quản Lý B O A</h1>
            <p>
                Chào mừng <span class="welcome-name">${sessionScope.user.fullName}</span>!<br>
                Quản lý toàn diện mọi hoạt động cho thuê phòng trọ của bạn.
            </p>
        </div>
    </div>
</div>

<div class="features-section">
    <div class="container">
        <div class="section-title">
            <h2>Các Chức Năng Chính</h2>
            <p>Quản lý toàn diện mọi hoạt động của phòng trọ</p>
        </div>

        <div class="row g-4">
            <!-- 1. PHÒNG -->
            <div class="col-md-6 col-lg-4">
                <div class="feature-card card-rooms">
                    <div>
                        <div class="feature-icon">
                            <i class="fas fa-building"></i>
                        </div>
                        <h3>Phòng</h3>
                        <p>Thêm, sửa, xóa phòng trọ và cập nhật trạng thái.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/quan-ly-phong" class="feature-link">
                        Quản Lý Phòng <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>

            <!-- 2. KHÁCH THUÊ -->
            <div class="col-md-6 col-lg-4">
                <div class="feature-card card-tenants">
                    <div>
                        <div class="feature-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <h3>Khách Thuê</h3>
                        <p>Quản lý hồ sơ khách, thông tin liên hệ và lịch sử thuê nhà.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/quan-ly-khach-thue" class="feature-link">
                        Quản Lý Khách <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>

            <!-- 3. HỢP ĐỒNG -->
            <div class="col-md-6 col-lg-4">
                <div class="feature-card card-contracts">
                    <div>
                        <div class="feature-icon">
                            <i class="fas fa-file-contract"></i>
                        </div>
                        <h3>Hợp Đồng</h3>
                        <p>Tạo mới, gia hạn và kết thúc hợp đồng thuê nhà.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/quan-ly-hop-dong" class="feature-link">
                        Quản Lý Hợp Đồng <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>

            <!-- 4. THANH TOÁN -->
            <div class="col-md-6 col-lg-4">
                <div class="feature-card card-payments">
                    <div>
                        <div class="feature-icon">
                            <i class="fas fa-money-bill-wave"></i>
                        </div>
                        <h3>Thanh Toán</h3>
                        <p>Theo dõi công nợ, hóa đơn điện nước và thực hiện thanh toán.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/quan-ly-thanh-toan" class="feature-link">
                        Quản Lý Thanh Toán <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>

            <!-- 5. THỐNG KÊ (CHỈ ADMIN) -->
            <c:if test="${sessionScope.user.role == 'admin'}">
                <div class="col-md-6 col-lg-4">
                    <div class="feature-card card-statistics">
                        <div>
                            <div class="feature-icon">
                                <i class="fas fa-chart-line"></i>
                            </div>
                            <h3> Thống Kê</h3>
                            <p>Theo dõi doanh thu, biểu đồ và báo cáo kinh doanh chi tiết.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/thong-ke" class="feature-link">
                            Xem Thống Kê <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </c:if>
        </div>

        <!-- ✅ THÔNG BÁO CHO USER THƯỜNG -->
        <c:if test="${sessionScope.user.role != 'admin'}">
            <div class="alert alert-info mt-4 text-center" style="border-radius: 15px;">
                <i class="fas fa-info-circle"></i>
                <strong>Lưu ý:</strong> Chức năng <strong>Thống Kê</strong> chỉ dành cho tài khoản Admin.
                Vui lòng liên hệ quản trị viên để nâng cấp quyền.
            </div>
        </c:if>
    </div>
</div>

<jsp:include page="../layout/_footer.jsp" />