package dao;

import config.DatabaseConfig;
import models.Tenant;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TenantDAO {

    // ✅ 1. Lấy tất cả khách thuê (Chỉ cần userId)
    public List<Tenant> getAllTenants(int userId) { // SỬA: Bỏ tenantId khỏi chữ ký
        List<Tenant> tenants = new ArrayList<>();
        // SỬA SQL: Chỉ cần lọc theo user_id
        String SQL = "SELECT * FROM Tenant WHERE user_id = ?";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {

            // Bỏ pstmt.setInt(1, tenantId);
            pstmt.setInt(1, userId); // Gán userId

            try (ResultSet rs = pstmt.executeQuery()){
                while (rs.next()) {
                    Tenant tenant = new Tenant(
                            rs.getInt("tenant_id"),
                            rs.getString("name"),
                            rs.getString("phone"),
                            rs.getString("email"),
                            rs.getString("id_card"),
                            rs.getString("address")
                    );
                    tenant.setUserId(rs.getInt("user_id")); // Gán userId từ DB
                    tenants.add(tenant);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tenants;
    }

    // ✅ 2. Thêm khách thuê mới (Thêm user_id vào INSERT)
    public boolean addTenant(Tenant tenant) {
        // THÊM cột user_id
        String SQL = "INSERT INTO Tenant (name, phone, email, id_card, address, user_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, tenant.getName());
            pstmt.setString(2, tenant.getPhone());
            pstmt.setString(3, tenant.getEmail());
            pstmt.setString(4, tenant.getIdCard());
            pstmt.setString(5, tenant.getAddress());
            pstmt.setInt(6, tenant.getUserId()); // Gán userId từ object Tenant

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                // Lấy ID tự động tăng
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        tenant.setTenantId(rs.getInt(1)); // Gán ID mới cho đối tượng Tenant
                    }
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ 3. Cập nhật khách thuê (Thêm user_id vào WHERE)
    public boolean updateTenant(Tenant tenant) {
        // THÊM điều kiện user_id = ?
        String SQL = "UPDATE Tenant SET name = ?, phone = ?, email = ?, id_card = ?, address = ? WHERE tenant_id = ? AND user_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {

            pstmt.setString(1, tenant.getName());
            pstmt.setString(2, tenant.getPhone());
            pstmt.setString(3, tenant.getEmail());
            pstmt.setString(4, tenant.getIdCard());
            pstmt.setString(5, tenant.getAddress());
            pstmt.setInt(6, tenant.getTenantId());
            pstmt.setInt(7, tenant.getUserId()); // Gán userId từ object Tenant

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ 4. Xóa khách thuê (Thêm userId)
    public boolean deleteTenant(int tenantId, int userId) { // SỬA: Thêm userId vào chữ ký
        // THÊM điều kiện user_id = ?
        String SQL = "DELETE FROM Tenant WHERE tenant_id = ? AND user_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {

            pstmt.setInt(1, tenantId);
            pstmt.setInt(2, userId); // Gán userId

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ 5. Lấy thông tin khách thuê theo ID (Đã có chữ ký đúng)
    public Tenant getTenantById(int tenantId, int userId) {
        // THÊM điều kiện user_id = ?
        String SQL = "SELECT * FROM Tenant WHERE tenant_id = ? AND user_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {

            pstmt.setInt(1, tenantId);
            pstmt.setInt(2, userId); // Gán userId

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Tenant tenant = new Tenant(
                            rs.getInt("tenant_id"),
                            rs.getString("name"),
                            rs.getString("phone"),
                            rs.getString("email"),
                            rs.getString("id_card"),
                            rs.getString("address")
                    );
                    // ✅ SỬA LỖI: Cần gán userId vào object Tenant và return object
                    tenant.setUserId(rs.getInt("user_id"));
                    return tenant;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ 6. Kiểm tra CMND/CCCD đã tồn tại chưa (Thêm userId)
    public boolean isIdCardExists(String idCard, int userId) { // SỬA: Thêm userId
        // THÊM điều kiện user_id = ?
        String SQL = "SELECT COUNT(*) FROM Tenant WHERE id_card = ? AND user_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {

            pstmt.setString(1, idCard);
            pstmt.setInt(2, userId); // Gán userId

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ✅ 7. Kiểm tra Số điện thoại đã tồn tại chưa (Thêm userId)
    public boolean isPhoneExists(String phone, int userId) { // SỬA: Thêm userId
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        // THÊM điều kiện user_id = ?
        String SQL = "SELECT COUNT(*) FROM Tenant WHERE phone = ? AND user_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {

            pstmt.setString(1, phone);
            pstmt.setInt(2, userId); // Gán userId

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ✅ 8. Kiểm tra CMND/CCCD có trùng với người khác không (trừ tenantId hiện tại) (Thêm userId)
    public boolean isIdCardExistsExcludingId(String idCard, int currentTenantId, int userId) { // SỬA: Thêm userId
        // THÊM điều kiện user_id = ?
        String SQL = "SELECT COUNT(*) FROM Tenant WHERE id_card = ? AND tenant_id != ? AND user_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {

            pstmt.setString(1, idCard);
            pstmt.setInt(2, currentTenantId);
            pstmt.setInt(3, userId); // Gán userId

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}