<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle} | B O A Management</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

    <script>
            // Script này sẽ chạy ngay khi trình duyệt đọc đến thẻ <head>
            (function() {
                const THEME_KEY = 'theme-mode';
                const savedTheme = localStorage.getItem(THEME_KEY);

                if (savedTheme === 'dark') {
                    // Áp dụng class dark-mode vào thẻ <html> (document.documentElement)
                    // để đảm bảo nó được gán trước khi body được tải hoàn toàn.
                    document.documentElement.classList.add('dark-mode');
                }
            })();
        </script>
    </head>

<body class="bg-light">

    <nav class="navbar navbar-expand-lg bg-white py-3 border-bottom shadow-sm">
        <div class="container-fluid container-lg">

            <div class="d-flex align-items-center">
                <a href="${pageContext.request.contextPath}/trang-chu" class="text-decoration-none text-dark">
                    <div class="fw-bold fs-5 me-4">B O A</div>
                </a>

                <c:if test="${sessionScope.user != null}">
                    <div class="d-none d-lg-flex gap-4 small fw-semibold">
                        <a href="${pageContext.request.contextPath}/trang-chu" class="nav-link text-dark">Bảng Điều Khiển</a>
                        <a href="${pageContext.request.contextPath}/quan-ly-phong" class="nav-link text-dark">Phòng</a>
                        <a href="${pageContext.request.contextPath}/quan-ly-hop-dong" class="nav-link text-dark">Hợp Đồng</a>
                    </div>
                </c:if>
            </div>

            <div class="dropdown">
                <c:choose>
                    <c:when test="${sessionScope.user != null}">
                        <div class="user-dropdown-toggle d-flex align-items-center gap-2" data-bs-toggle="dropdown" aria-expanded="false" style="cursor: pointer;">
                            <i class="bi bi-person-circle fs-5"></i>
                            <span class="fw-semibold text-dark"><c:out value="${sessionScope.user.fullName}" default="Quản trị viên"/></span>
                        </div>

                        <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2">
                            <li class="px-3 py-2 border-bottom bg-light">
                                <div class="fw-bold"><c:out value="${sessionScope.user.fullName}"/></div>
                                <div class="small text-muted">@<c:out value="${sessionScope.user.username}"/></div>
                            </li>

                            <li>
                                <a class="dropdown-item py-2" href="#" id="theme-toggle">
                                    <i class="bi bi-moon-fill me-2"></i> Chế độ Tối
                                </a>
                            </li>

                            <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/profile"><i class="bi bi-person-badge me-2"></i> Thông tin tài khoản</a></li>
                            <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/settings"><i class="bi bi-gear me-2"></i> Cài đặt</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item py-2 text-danger fw-bold" href="${pageContext.request.contextPath}/auth?action=logout"><i class="bi bi-box-arrow-right me-2"></i> Đăng xuất</a></li>
                        </ul>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/auth?action=showLogin" class="btn btn-dark fw-bold me-2 py-2">Đăng Nhập</a>
                        <a href="${pageContext.request.contextPath}/auth?action=showRegister" class="btn btn-outline-dark fw-bold py-2 d-none d-md-inline-block">Đăng Ký</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>

    <main>