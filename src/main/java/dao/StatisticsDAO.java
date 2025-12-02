package dao;

import config.DatabaseConfig;
import models.Payment;

import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

public class StatisticsDAO {

    // Tổng số phòng
    public int getTotalRooms(int userId) {
        String SQL = "SELECT COUNT(*) FROM Room WHERE user_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Số phòng đang thuê
    public int getOccupiedRooms(int userId) {
        String SQL = "SELECT COUNT(*) FROM Room WHERE user_id = ? AND status = 'Đang thuê'";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Số phòng trống
    public int getVacantRooms(int userId) {
        String SQL = "SELECT COUNT(*) FROM Room WHERE user_id = ? AND status = 'Trống'";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Tổng doanh thu
    public BigDecimal getTotalRevenue(int userId) {
        String SQL = "SELECT COALESCE(SUM(p.amount), 0) " +
                "FROM Payment p " +
                "INNER JOIN Contract c ON p.contract_id = c.contract_id " +
                "WHERE c.user_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    // Doanh thu theo tháng
    public BigDecimal getRevenueByMonth(int userId, int year, int month) {
        String SQL = "SELECT COALESCE(SUM(p.amount), 0) " +
                "FROM Payment p " +
                "INNER JOIN Contract c ON p.contract_id = c.contract_id " +
                "WHERE c.user_id = ? AND YEAR(p.payment_date) = ? AND MONTH(p.payment_date) = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, year);
            pstmt.setInt(3, month);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    // Số hợp đồng đang hoạt động
    public int getActiveContracts(int userId) {
        String SQL = "SELECT COUNT(*) FROM Contract WHERE user_id = ? AND status = 'Đang thuê'";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Doanh thu theo tháng trong năm (12 tháng)
    public Map<Integer, BigDecimal> getMonthlyRevenue(int userId, int year) {
        Map<Integer, BigDecimal> result = new LinkedHashMap<>();

        // Khởi tạo 12 tháng với giá trị 0
        for (int i = 1; i <= 12; i++) {
            result.put(i, BigDecimal.ZERO);
        }

        String SQL = "SELECT MONTH(p.payment_date) as month, COALESCE(SUM(p.amount), 0) as total " +
                "FROM Payment p " +
                "INNER JOIN Contract c ON p.contract_id = c.contract_id " +
                "WHERE c.user_id = ? AND YEAR(p.payment_date) = ? " +
                "GROUP BY MONTH(p.payment_date) " +
                "ORDER BY MONTH(p.payment_date)";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, year);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    int month = rs.getInt("month");
                    BigDecimal total = rs.getBigDecimal("total");
                    result.put(month, total);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    // Doanh thu theo ngày trong tháng
    public Map<Integer, BigDecimal> getDailyRevenueByMonth(int userId, int year, int month) {
        Map<Integer, BigDecimal> result = new LinkedHashMap<>();

        // Khởi tạo các ngày trong tháng với giá trị 0
        Calendar cal = Calendar.getInstance();
        cal.set(year, month - 1, 1);
        int daysInMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

        for (int i = 1; i <= daysInMonth; i++) {
            result.put(i, BigDecimal.ZERO);
        }

        String SQL = "SELECT DAY(p.payment_date) as day, COALESCE(SUM(p.amount), 0) as total " +
                "FROM Payment p " +
                "INNER JOIN Contract c ON p.contract_id = c.contract_id " +
                "WHERE c.user_id = ? AND YEAR(p.payment_date) = ? AND MONTH(p.payment_date) = ? " +
                "GROUP BY DAY(p.payment_date) " +
                "ORDER BY DAY(p.payment_date)";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, year);
            pstmt.setInt(3, month);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    int day = rs.getInt("day");
                    BigDecimal total = rs.getBigDecimal("total");
                    result.put(day, total);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    // Doanh thu theo phòng
    public Map<String, BigDecimal> getRevenueByRoom(int userId) {
        Map<String, BigDecimal> result = new LinkedHashMap<>();

        String SQL = "SELECT r.room_number, COALESCE(SUM(p.amount), 0) as total " +
                "FROM Room r " +
                "LEFT JOIN Contract c ON r.room_id = c.room_id " +
                "LEFT JOIN Payment p ON c.contract_id = p.contract_id " +
                "WHERE r.user_id = ? " +
                "GROUP BY r.room_id, r.room_number " +
                "ORDER BY total DESC " +
                "LIMIT 10";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    result.put(rs.getString("room_number"), rs.getBigDecimal("total"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    // Lấy thanh toán gần đây
    public List<Payment> getRecentPayments(int userId, int limit) {
        List<Payment> payments = new ArrayList<>();

        String SQL = "SELECT p.* " +
                "FROM Payment p " +
                "INNER JOIN Contract c ON p.contract_id = c.contract_id " +
                "WHERE c.user_id = ? " +
                "ORDER BY p.payment_date DESC " +
                "LIMIT ?";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, limit);
            try (ResultSet rs = pstmt.executeQuery()) {
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
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }
}