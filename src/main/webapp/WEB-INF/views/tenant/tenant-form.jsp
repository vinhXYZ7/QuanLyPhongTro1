<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${tenant != null ? 'Chỉnh Sửa' : 'Thêm'} Khách Thuê - BOA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
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

        .form-container {
            max-width: 800px;
            margin: 30px auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            overflow: hidden;
        }

        .form-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 30px;
            color: white;
            text-align: center;
        }

        .form-header h2 {
            margin: 0;
            font-size: 2rem;
            font-weight: 600;
        }

        .form-body {
            padding: 40px;
        }

        .form-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
        }

        .form-control, .form-select {
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            transition: all 0.3s;
        }

        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 14px 40px;
            border-radius: 10px;
            color: white;
            font-weight: 600;
            width: 100%;
            margin-top: 20px;
            transition: all 0.3s;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
        }

        .btn-back {
            background: white;
            border: 2px solid #667eea;
            padding: 14px 40px;
            border-radius: 10px;
            color: #667eea;
            font-weight: 600;
            width: 100%;
            transition: all 0.3s;
        }

        .btn-back:hover {
            background: #f8f9fa;
            color: #667eea;
        }

        .alert {
            border-radius: 10px;
            border: none;
        }

        .required {
            color: #e74c3c;
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
    </div>
</nav>

<!-- Form Container -->
<div class="form-container">
    <!-- Form Header -->
    <div class="form-header">
        <h2>
            <i class="fas fa-user-${tenant != null ? 'edit' : 'plus'}"></i>
            ${tenant != null ? 'Chỉnh Sửa' : 'Thêm'} Khách Thuê
        </h2>
    </div>

    <!-- Form Body -->
    <div class="form-body">
        <!-- Error Message -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-triangle"></i> ${errorMessage}
            </div>
        </c:if>

        <!-- Form -->
        <form method="post" action="${pageContext.request.contextPath}/quan-ly-khach-thue">
            <!-- Hidden Fields -->
            <input type="hidden" name="action" value="${tenant != null ? 'update' : 'add'}">
            <c:if test="${tenant != null}">
                <input type="hidden" name="tenantId" value="${tenant.tenantId}">
            </c:if>

            <!-- Họ Tên -->
            <div class="mb-3">
                <label for="name" class="form-label">
                    Họ và Tên <span class="required">*</span>
                </label>
                <input type="text"
                       class="form-control"
                       id="name"
                       name="name"
                       value="${tenant != null ? tenant.name : ''}"
                       placeholder="Ví dụ: Nguyễn Văn A"
                       required>
            </div>

            <!-- CMND/CCCD -->
            <div class="mb-3">
                <label for="idCard" class="form-label">
                    CMND/CCCD <span class="required">*</span>
                </label>
                <input type="text"
                       class="form-control"
                       id="idCard"
                       name="idCard"
                       value="${tenant != null ? tenant.idCard : ''}"
                       placeholder="Ví dụ: 001234567890"
                       pattern="[0-9]{9,12}"
                       title="CMND (9 số) hoặc CCCD (12 số)"
                       required>
            </div>

            <!-- Số Điện Thoại -->
            <div class="mb-3">
                <label for="phone" class="form-label">
                    Số Điện Thoại <span class="required">*</span>
                </label>
                <input type="tel"
                       class="form-control"
                       id="phone"
                       name="phone"
                       value="${tenant != null ? tenant.phone : ''}"
                       placeholder="Ví dụ: 0912345678"
                       pattern="[0-9]{10,11}"
                       title="Số điện thoại 10-11 chữ số"
                       required>
            </div>

            <!-- Email -->
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email"
                       class="form-control"
                       id="email"
                       name="email"
                       value="${tenant != null ? tenant.email : ''}"
                       placeholder="Ví dụ: nguyenvana@email.com">
            </div>

            <!-- Địa Chỉ -->
            <div class="mb-3">
                <label for="address" class="form-label">
                    Địa Chỉ Thường Trú <span class="required">*</span>
                </label>
                <textarea class="form-control"
                          id="address"
                          name="address"
                          rows="3"
                          placeholder="Ví dụ: 123 Đường ABC, Phường XYZ, Quận 1, TP.HCM"
                          required>${tenant != null ? tenant.address : ''}</textarea>
            </div>

            <!-- Buttons -->
            <div class="row mt-4">
                <div class="col-md-6 mb-2">
                    <a href="${pageContext.request.contextPath}/quan-ly-khach-thue" class="btn btn-back">
                        <i class="fas fa-arrow-left"></i> Quay Lại Danh Sách
                    </a>
                </div>
                <div class="col-md-6 mb-2">
                    <button type="submit" class="btn btn-submit">
                        <i class="fas fa-save"></i> ${tenant != null ? 'Cập Nhật' : 'Thêm Khách Thuê'}
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>