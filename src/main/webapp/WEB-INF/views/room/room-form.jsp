<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${room != null ? 'Chỉnh Sửa' : 'Thêm'} Phòng Trọ - BOA</title>
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
            max-width: 900px;
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

        .input-group-text {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            font-weight: 600;
            border-radius: 10px 0 0 10px;
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
            <i class="fas fa-${room != null ? 'edit' : 'plus-circle'}"></i>
            ${room != null ? 'Chỉnh Sửa' : 'Thêm'} Phòng Trọ Mới
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
            <strong>Lưu ý:</strong> Vui lòng điền đầy đủ thông tin. Số phòng phải là duy nhất trong hệ thống của bạn.
        </div>

        <!-- Form -->
        <form method="post" action="${pageContext.request.contextPath}/quan-ly-phong">
            <!-- Hidden Fields -->
            <input type="hidden" name="action" value="${room != null ? 'update' : 'add'}">
            <c:if test="${room != null}">
                <input type="hidden" name="roomId" value="${room.roomId}">
            </c:if>

            <div class="row">
                <!-- Số Phòng -->
                <div class="col-md-6 mb-3">
                    <label for="roomNumber" class="form-label">
                        Số Phòng <span class="required">*</span>
                    </label>
                    <input type="text"
                           class="form-control"
                           id="roomNumber"
                           name="roomNumber"
                           value="${room != null ? room.roomNumber : ''}"
                           placeholder="Ví dụ: A101"
                           required>
                </div>

                <!-- Loại Phòng -->
                <div class="col-md-6 mb-3">
                    <label for="type" class="form-label">
                        Loại Phòng <span class="required">*</span>
                    </label>
                    <select class="form-select" id="type" name="type" required>
                        <option value="">-- Chọn Loại Phòng --</option>
                        <option value="Phòng Thường" ${room != null && room.type == 'Phòng Thường' ? 'selected' : ''}>Phòng Thường</option>
                        <option value="Phòng VIP" ${room != null && room.type == 'Phòng VIP' ? 'selected' : ''}>Phòng VIP</option>
                        <option value="Căn Hộ" ${room != null && room.type == 'Căn Hộ' ? 'selected' : ''}>Căn Hộ</option>
                    </select>
                </div>
            </div>

            <div class="row">
                <!-- Giá Thuê -->
                <div class="col-md-6 mb-3">
                    <label for="price" class="form-label">
                        Giá Thuê (VNĐ/tháng) <span class="required">*</span>
                    </label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-dong-sign"></i>
                        </span>
                        <input type="number"
                               class="form-control"
                               id="price"
                               name="price"
                               value="${room != null ? room.price : ''}"
                               placeholder="Ví dụ: 3000000"
                               min="100000"
                               step="100000"
                               required>
                    </div>
                </div>

                <!-- Tầng -->
                <div class="col-md-6 mb-3">
                    <label for="floor" class="form-label">
                        Tầng <span class="required">*</span>
                    </label>
                    <input type="number"
                           class="form-control"
                           id="floor"
                           name="floor"
                           value="${room != null ? room.floor : ''}"
                           placeholder="Ví dụ: 1, 2, 3..."
                           min="1"
                           max="50"
                           required>
                </div>
            </div>

            <!-- Trạng Thái -->
            <div class="mb-3">
                <label for="status" class="form-label">
                    Trạng Thái <span class="required">*</span>
                </label>
                <select class="form-select" id="status" name="status" required>
                    <option value="">-- Chọn Trạng Thái --</option>
                    <option value="Trống" ${room != null && room.status == 'Trống' ? 'selected' : ''}>
                        Trống
                    </option>
                    <option value="Đang thuê" ${room != null && room.status == 'Đang thuê' ? 'selected' : ''}>
                        Đang thuê
                    </option>
                    <option value="Bảo trì" ${room != null && room.status == 'Bảo trì' ? 'selected' : ''}>
                        Bảo trì
                    </option>
                </select>
            </div>

            <!-- Mô Tả -->
            <div class="mb-3">
                <label for="description" class="form-label">Mô Tả Chi Tiết</label>
                <textarea class="form-control"
                          id="description"
                          name="description"
                          rows="4"
                          placeholder="Ví dụ: Phòng có điều hòa, nóng lạnh, WC riêng, ban công...">${room != null ? room.description : ''}</textarea>
            </div>

            <!-- Buttons -->
            <div class="row mt-4">
                <div class="col-md-6 mb-2">
                    <a href="${pageContext.request.contextPath}/quan-ly-phong" class="btn btn-back">
                        <i class="fas fa-arrow-left"></i> Quay Lại Danh Sách
                    </a>
                </div>
                <div class="col-md-6 mb-2">
                    <button type="submit" class="btn btn-submit">
                        <i class="fas fa-save"></i> ${room != null ? 'Cập Nhật' : 'Thêm Phòng'}
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Format price input
    const priceInput = document.getElementById('price');
    priceInput.addEventListener('blur', function() {
        if (this.value) {
            const value = parseFloat(this.value.replace(/,/g, ''));
            if (!isNaN(value)) {
                // Round to nearest 100,000
                this.value = Math.round(value / 100000) * 100000;
            }
        }
    });
</script>

</body>
</html>