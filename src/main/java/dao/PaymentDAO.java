package dao;

import config.DatabaseConfig;
import models.Payment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class PaymentDAO {

    // Lấy tất cả thanh toán
    public List<Payment> getAllPayments() {
        List<Payment> payments = new ArrayList<>();
        String SQL = "SELECT * FROM Payment ORDER BY payment_date DESC";
        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(SQL)) {

            while (rs.next()) {
                Payment payment = new Payment(
                        rs.getInt("payment_id"),
                        rs.getInt("contract_id"),
                        rs.getBigDecimal("amount"),
                        rs.getDate("payment_date"),
                        rs.getString("method"),
                        rs.getString("description")
                );
                payments.add(payment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }

    // ✅ BỔ SUNG: Lấy thanh toán theo ID
    public Payment getPaymentById(int paymentId) {
        String SQL = "SELECT * FROM Payment WHERE payment_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {

            pstmt.setInt(1, paymentId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new Payment(
                            rs.getInt("payment_id"),
                            rs.getInt("contract_id"),
                            rs.getBigDecimal("amount"),
                            rs.getDate("payment_date"),
                            rs.getString("method"),
                            rs.getString("description")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Thêm thanh toán mới
    public boolean addPayment(Payment payment) {
        String SQL = "INSERT INTO Payment (contract_id, amount, payment_date, method, description) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {

            pstmt.setInt(1, payment.getContractId());
            pstmt.setBigDecimal(2, payment.getAmount());
            pstmt.setDate(3, payment.getPaymentDate());
            pstmt.setString(4, payment.getMethod());
            pstmt.setString(5, payment.getDescription());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cập nhật thanh toán
    public boolean updatePayment(Payment payment) {
        String SQL = "UPDATE Payment SET contract_id = ?, amount = ?, payment_date = ?, method = ?, description = ? WHERE payment_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {

            pstmt.setInt(1, payment.getContractId());
            pstmt.setBigDecimal(2, payment.getAmount());
            pstmt.setDate(3, payment.getPaymentDate());
            pstmt.setString(4, payment.getMethod());
            pstmt.setString(5, payment.getDescription());
            pstmt.setInt(6, payment.getPaymentId());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa thanh toán
    public boolean deletePayment(int paymentId) {
        String SQL = "DELETE FROM Payment WHERE payment_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {

            pstmt.setInt(1, paymentId);

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy tất cả Contract ID (Để dùng cho ComboBox trong PaymentPanel)
    public List<Integer> getAllContractIds() {
        List<Integer> contractIds = new ArrayList<>();
        // Chỉ lấy ID của các hợp đồng đang hoạt động
        String SQL = "SELECT contract_id FROM Contract WHERE status = 'Đang thuê'";
        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(SQL)) {

            while (rs.next()) {
                contractIds.add(rs.getInt("contract_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contractIds;
    }
}