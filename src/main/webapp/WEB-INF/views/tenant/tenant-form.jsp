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

        /* ✅ VALIDATION STYLES */
        .form-control.is-invalid {
            border-color: #e74c3c;
        }

        .form-control.is-valid {
            border-color: #27ae60;
        }

        .invalid-feedback {
            color: #e74c3c;
            font-size: 0.875rem;
            margin-top: 5px;
            display: block;
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

        .info-box {
            background: #e8ebff;
            border-left: 4px solid #667eea;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .info-box i {
            color: #667eea;
            margin-right: 10px;
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

        <!-- Info Box -->
        <div class="info-box">
            <i class="fas fa-info-circle"></i>
            <strong>Lưu ý:</strong> CMND/CCCD và số điện thoại phải là duy nhất trong hệ thống.
        </div>

        <!-- Form -->
        <form method="post" action="${pageContext.request.contextPath}/quan-ly-khach-thue" id="tenantForm" novalidate>
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
                       minlength="3"
                       maxlength="100"
                       required>
                <div class="invalid-feedback">Họ tên phải từ 3-100 ký tự</div>
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
                <div class="invalid-feedback">CMND phải có 9 số hoặc CCCD phải có 12 số</div>
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
                       pattern="0[0-9]{9,10}"
                       title="Số điện thoại phải bắt đầu bằng 0 và có 10-11 chữ số"
                       required>
                <div class="invalid-feedback">Số điện thoại phải có 10-11 số và bắt đầu bằng 0</div>
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
                <div class="invalid-feedback">Email không hợp lệ</div>
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
                          minlength="10"
                          maxlength="255"
                          required>${tenant != null ? tenant.address : ''}</textarea>
                <div class="invalid-feedback">Địa chỉ phải từ 10-255 ký tự</div>
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
<script>
    // ✅ VALIDATION SCRIPT
    (function() {
        'use strict';

        const form = document.getElementById('tenantForm');
        const nameInput = document.getElementById('name');
        const idCardInput = document.getElementById('idCard');
        const phoneInput = document.getElementById('phone');
        const emailInput = document.getElementById('email');

        // Validate name (chỉ chữ cái và khoảng trắng)
        nameInput.addEventListener('input', function() {
            const value = this.value.trim();
            const validPattern = /^[a-zA-ZÀ-ỹ\s]+$/;

            if (value && !validPattern.test(value)) {
                this.setCustomValidity('Họ tên chỉ được chứa chữ cái và khoảng trắng');
            } else {
                this.setCustomValidity('');
            }
        });

        // Validate ID Card (9 hoặc 12 số)
        idCardInput.addEventListener('input', function() {
            this.value = this.value.replace(/\D/g, ''); // Chỉ cho phép số

            const length = this.value.length;
            if (this.value && length !== 9 && length !== 12) {
                this.setCustomValidity('CMND phải có 9 số hoặc CCCD phải có 12 số');
            } else {
                this.setCustomValidity('');
            }
        });

        // Validate Phone (10-11 số, bắt đầu bằng 0)
        phoneInput.addEventListener('input', function() {
            this.value = this.value.replace(/\D/g, ''); // Chỉ cho phép số

            const value = this.value;
            if (value && (!value.startsWith('0') || value.length < 10 || value.length > 11)) {
                this.setCustomValidity('Số điện thoại phải có 10-11 số và bắt đầu bằng 0');
            } else {
                this.setCustomValidity('');
            }
        });

        // Form validation on submit
        form.addEventListener('submit', function(event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }

            // Mark all fields as validated
            const inputs = form.querySelectorAll('input, textarea');
            inputs.forEach(function(input) {
                if (input.value.trim()) {
                    if (input.checkValidity()) {
                        input.classList.remove('is-invalid');
                        input.classList.add('is-valid');
                    } else {
                        input.classList.remove('is-valid');
                        input.classList.add('is-invalid');
                    }
                }
            });
        }, false);

        // Real-time validation
        const inputs = form.querySelectorAll('input, textarea');
        inputs.forEach(function(input) {
            input.addEventListener('blur', function() {
                if (this.value.trim()) {
                    if (this.checkValidity()) {
                        this.classList.remove('is-invalid');
                        this.classList.add('is-valid');
                    } else {
                        this.classList.remove('is-valid');
                        this.classList.add('is-invalid');
                    }
                }
            });
        });
    })();
</script>

</body>
</html>