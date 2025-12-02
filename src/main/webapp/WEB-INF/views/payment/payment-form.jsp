<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${payment != null ? 'Chỉnh Sửa' : 'Thêm'} Thanh Toán - BOA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
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
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
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
            border-color: #11998e;
            box-shadow: 0 0 0 3px rgba(17, 153, 142, 0.1);
        }

        .input-group-text {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
            border: none;
            font-weight: 600;
            border-radius: 10px 0 0 10px;
        }

        .btn-submit {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
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
            box-shadow: 0 5px 20px rgba(17, 153, 142, 0.4);
        }

        .btn-back {
            background: white;
            border: 2px solid #11998e;
            padding: 14px 40px;
            border-radius: 10px;
            color: #11998e;
            font-weight: 600;
            width: 100%;
            transition: all 0.3s;
        }

        .btn-back:hover {
            background: #f8f9fa;
            color: #11998e;
        }

        .alert {
            border-radius: 10px;
            border: none;
        }

        .required {
            color: #e74c3c;
        }

        .info-box {
            background: #f8f9fa;
            border-left: 4px solid #11998e;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .info-box i {
            color: #11998e;
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
            <i class="fas fa-${payment != null ? 'edit' : 'plus-circle'}"></i>
            ${payment != null ? 'Chỉnh Sửa' : 'Thêm'} Thanh Toán
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
            <strong>Lưu ý:</strong> Vui lòng kiểm tra kỹ thông tin trước khi lưu. Thanh toán chỉ có thể thực hiện cho các hợp đồng đang hoạt động.
        </div>

        <!-- Form -->
        <form method="post" action="${pageContext.request.contextPath}/quan-ly-thanh-toan">
            <!-- Hidden Fields -->
            <input type="hidden" name="action" value="${payment != null ? 'update' : 'add'}">
            <c:if test="${payment != null}">
                <input type="hidden" name="paymentId" value="${payment.paymentId}">
            </c:if>

            <!-- Mã Hợp Đồng -->
            <div class="mb-3">
                <label for="contractId" class="form-label">
                    Mã Hợp Đồng <span class="required">*</span>
                </label>
                <select class="form-select" id="contractId" name="contractId" required>
                    <option value="">-- Chọn Hợp Đồng --</option>
                    <c:forEach var="cid" items="${contractIds}">
                        <option value="${cid}" ${payment != null && payment.contractId == cid ? 'selected' : ''}>
                            Hợp Đồng #${cid}
                        </option>
                    </c:forEach>
                </select>
                <small class="text-muted">Chỉ hiển thị các hợp đồng đang hoạt động</small>
            </div>

            <!-- Số Tiền -->
            <div class="mb-3">
                <label for="amount" class="form-label">
                    Số Tiền (VNĐ) <span class="required">*</span>
                </label>
                <div class="input-group">
                    <span class="input-group-text">
                        <i class="fas fa-dong-sign"></i>
                    </span>
                    <input type="number"
                           class="form-control"
                           id="amount"
                           name="amount"
                           value="${payment != null ? payment.amount : ''}"
                           placeholder="Ví dụ: 5000000"
                           min="1000"
                           step="1000"
                           required>
                </div>
            </div>

            <!-- Ngày Thanh Toán -->
            <div class="mb-3">
                <label for="paymentDate" class="form-label">
                    Ngày Thanh Toán <span class="required">*</span>
                </label>
                <input type="date"
                       class="form-control"
                       id="paymentDate"
                       name="paymentDate"
                       value="${payment != null ? payment.paymentDate : ''}"
                       required>
            </div>

            <!-- Phương Thức Thanh Toán -->
            <div class="mb-3">
                <label for="method" class="form-label">
                    Phương Thức Thanh Toán <span class="required">*</span>
                </label>
                <select class="form-select" id="method" name="method" required>
                    <option value="">-- Chọn Phương Thức --</option>
                    <option value="Tiền mặt" ${payment != null && payment.method == 'Tiền mặt' ? 'selected' : ''}>
                        <i class="fas fa-money-bill"></i> Tiền mặt
                    </option>
                    <option value="Chuyển khoản" ${payment != null && payment.method == 'Chuyển khoản' ? 'selected' : ''}>
                        <i class="fas fa-credit-card"></i> Chuyển khoản
                    </option>
                </select>
            </div>

            <!-- Mô Tả -->
            <div class="mb-3">
                <label for="description" class="form-label">Mô Tả / Ghi Chú</label>
                <textarea class="form-control"
                          id="description"
                          name="description"
                          rows="3"
                          placeholder="Ví dụ: Thanh toán tiền thuê tháng 12/2024">${payment != null ? payment.description : ''}</textarea>
            </div>

            <!-- Buttons -->
            <div class="row mt-4">
                <div class="col-md-6 mb-2">
                    <a href="${pageContext.request.contextPath}/quan-ly-thanh-toan" class="btn btn-back">
                        <i class="fas fa-arrow-left"></i> Quay Lại Danh Sách
                    </a>
                </div>
                <div class="col-md-6 mb-2">
                    <button type="submit" class="btn btn-submit">
                        <i class="fas fa-save"></i> ${payment != null ? 'Cập Nhật' : 'Thêm Thanh Toán'}
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Set default date to today if adding new payment
    <c:if test="${payment == null}">
        document.getElementById('paymentDate').valueAsDate = new Date();
    </c:if>

    // Format amount input with thousand separator
    const amountInput = document.getElementById('amount');
    amountInput.addEventListener('blur', function() {
        if (this.value) {
            const value = parseFloat(this.value.replace(/,/g, ''));
            if (!isNaN(value)) {
                this.value = Math.round(value);
            }
        }
    });
</script>

</body>
</html>