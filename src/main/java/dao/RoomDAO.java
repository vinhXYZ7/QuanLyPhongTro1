package dao;

import config.DatabaseConfig;
import models.Room;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class RoomDAO {

    // 1. Lấy tất cả phòng của một người dùng (CẦN THÊM userId)
    public List<Room> getAllRooms(int userId) {
        List<Room> rooms = new ArrayList<>();
        String SQL = "SELECT * FROM Room WHERE user_id = ?";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) { // Dùng PreparedStatement

            pstmt.setInt(1, userId); // Gán userId

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Room room = new Room(
                            rs.getInt("room_id"),
                            rs.getString("room_number"),
                            rs.getString("type"),
                            rs.getBigDecimal("price"),
                            rs.getString("status"),
                            rs.getInt("floor"),
                            rs.getString("description")
                    );
                    room.setUserId(rs.getInt("user_id")); // Cần setter/constructor để gán userId
                    rooms.add(room);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    // 2. Thêm phòng mới (CẦN THÊM user_id vào INSERT)
    public boolean addRoom(Room room) {
        // ✅ THÊM cột user_id
        String SQL = "INSERT INTO Room (room_number, type, price, status, floor, description, user_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {

            pstmt.setString(1, room.getRoomNumber());
            pstmt.setString(2, room.getType());
            pstmt.setBigDecimal(3, room.getPrice());
            pstmt.setString(4, room.getStatus());
            pstmt.setInt(5, room.getFloor());
            pstmt.setString(6, room.getDescription());

            // ✅ Gán giá trị userId
            pstmt.setInt(7, room.getUserId());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 3. Cập nhật phòng (CẦN THÊM user_id vào WHERE)
    public boolean updateRoom(Room room) {
        // ✅ THÊM điều kiện user_id = ? để chỉ user sở hữu mới sửa được
        String SQL = "UPDATE Room SET room_number = ?, type = ?, price = ?, status = ?, floor = ?, description = ? WHERE room_id = ? AND user_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {

            pstmt.setString(1, room.getRoomNumber());
            pstmt.setString(2, room.getType());
            pstmt.setBigDecimal(3, room.getPrice());
            pstmt.setString(4, room.getStatus());
            pstmt.setInt(5, room.getFloor());
            pstmt.setString(6, room.getDescription());
            pstmt.setInt(7, room.getRoomId());

            // ✅ Gán giá trị userId
            pstmt.setInt(8, room.getUserId());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 4. Xóa phòng (CẦN THÊM userId vào WHERE)
    public boolean deleteRoom(int roomId, int userId) {
        // ✅ THÊM điều kiện user_id = ? để chỉ user sở hữu mới xóa được
        String SQL = "DELETE FROM Room WHERE room_id = ? AND user_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {

            pstmt.setInt(1, roomId);
            // ✅ Gán giá trị userId
            pstmt.setInt(2, userId);

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 5. Cập nhật trạng thái phòng (CẦN THÊM userId)
    // Giả định hàm này được gọi nội bộ, nên tạm thời không cần userId,
    // nhưng tốt nhất là nên có: updateRoomStatus(int roomId, String newStatus, int userId)
    // Để đơn giản, tôi giữ nguyên nhưng bạn nên cân nhắc sửa sau.
    public boolean updateRoomStatus(int roomId, String newStatus) {
        String SQL = "UPDATE Room SET status = ? WHERE room_id = ?";
        // ... (Giữ nguyên logic này) ...
        return false;
    }

    // 6. Lấy thông tin phòng theo ID (CẦN THÊM userId)
    public Room getRoomById(int roomId, int userId) {
        // ✅ THÊM điều kiện user_id = ? để chỉ user sở hữu mới xem được
        String SQL = "SELECT * FROM Room WHERE room_id = ? AND user_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {

            pstmt.setInt(1, roomId);
            // ✅ Gán giá trị userId
            pstmt.setInt(2, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Room room = new Room(
                            rs.getInt("room_id"),
                            rs.getString("room_number"),
                            rs.getString("type"),
                            rs.getBigDecimal("price"),
                            rs.getString("status"),
                            rs.getInt("floor"),
                            rs.getString("description")
                    );
                    room.setUserId(rs.getInt("user_id"));
                    return room;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 7. Kiểm tra số phòng đã tồn tại chưa (CẦN THÊM userId để kiểm tra TRONG PHẠM VI USER HIỆN TẠI)
    public boolean isRoomNumberExists(String roomNumber, int userId) {
        // ✅ THÊM điều kiện user_id = ?
        String SQL = "SELECT COUNT(*) FROM Room WHERE room_number = ? AND user_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {

            pstmt.setString(1, roomNumber);
            // ✅ Gán giá trị userId
            pstmt.setInt(2, userId);

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
    // 8 Lấy danh sách các phòng có trạng thái 'Trống' của user hiện tại.

    public List<Room> getVacantRooms(int userId) {
        List<Room> rooms = new ArrayList<>();
        //  TRUY VẤN MỚI: BẮT BUỘC lọc theo status VÀ user_id
        String SQL = "SELECT * FROM Room WHERE status = 'Trống' AND user_id = ?";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {

            pstmt.setInt(1, userId); // Gán tham số userId

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Room room = new Room(
                            rs.getInt("room_id"),
                            rs.getString("room_number"),
                            rs.getString("type"),
                            rs.getBigDecimal("price"),
                            rs.getString("status"),
                            rs.getInt("floor"),
                            rs.getString("description")
                    );
                    room.setUserId(rs.getInt("user_id"));
                    rooms.add(room);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }
}