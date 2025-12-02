package Controller;

import jakarta.servlet.http.HttpSession;
import models.Room;
import Services.RoomService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.User;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "RoomController", urlPatterns = {"/quan-ly-phong"})
public class RoomController extends HttpServlet {

    private RoomService roomService;
    // Hằng số cho đường dẫn JSP
    private static final String ROOM_LIST_JSP = "/WEB-INF/views/room/room-list.jsp";
    private static final String ROOM_FORM_JSP = "/WEB-INF/views/room/room-form.jsp";

    @Override
    public void init() throws ServletException {
        super.init();
        this.roomService = new RoomService();
    }

    // =============================================================
    // PHƯƠNG THỨC XỬ LÝ GET (HIỂN THỊ)
    // =============================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        int userId = getCurrentUserId(request);
        String contextPath = request.getContextPath();

        // 1. Kiểm tra trạng thái đăng nhập (Security Check)
        if (userId < 0) {
            // Nếu chưa đăng nhập, chuyển hướng về trang login
            response.sendRedirect(contextPath + "/auth?action=showLogin");
            return;
        }

        // Đặt hành động mặc định là "list" nếu không có tham số action
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "showAddForm":
                    showAddForm(request, response);
                    break;

                case "showEditForm":
                    showEditForm(request, response, userId);
                    break;

                case "list":
                default:
                    listRooms(request, response, userId);
                    break;
            }
        } catch (Exception ex) {
            // Ghi log lỗi và chuyển hướng đến trang báo lỗi chung
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi xử lý yêu cầu GET: " + ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }

    // =============================================================
    // PHƯƠNG THỨC XỬ LÝ POST (THAO TÁC CRUD)
    // =============================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ Đảm bảo nhận tiếng Việt chính xác
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String contextPath = request.getContextPath();

        if (action == null) {
            response.sendRedirect(contextPath + "/quan-ly-phong");
            return;
        }

        try {
            switch (action) {
                case "add":
                    insertRoom(request, response);
                    break;
                case "update":
                    updateRoom(request, response);
                    break;
                case "delete":
                    deleteRoom(request, response);
                    break;
                default:
                    // Hành động POST không hợp lệ -> về trang danh sách
                    response.sendRedirect(contextPath + "/quan-ly-phong");
                    break;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            // Xử lý lỗi trong quá trình POST
            request.setAttribute("errorMessage", "Đã xảy ra lỗi trong quá trình xử lý dữ liệu: " + ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }

    // -------------------------------------------------------------
    // LOGIC XỬ LÝ GET HELPERS
    // -------------------------------------------------------------

    /**
     * Hiển thị danh sách phòng (Lọc theo userId)
     */
    private void listRooms(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {

        // Gọi Service lấy danh sách phòng thuộc về userId này
        List<Room> listRooms = roomService.getAllRooms(userId);

        // Đặt attribute tên là "rooms" (theo yêu cầu ban đầu)
        request.setAttribute("rooms", listRooms);

        // Chuyển tiếp đến JSP list
        RequestDispatcher dispatcher = request.getRequestDispatcher(ROOM_LIST_JSP);
        dispatcher.forward(request, response);
    }

    /**
     * Hiển thị Form Thêm Phòng mới
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Chuyển tiếp đến JSP form (trong chế độ thêm mới)
        RequestDispatcher dispatcher = request.getRequestDispatcher(ROOM_FORM_JSP);
        dispatcher.forward(request, response);
    }

    /**
     * Hiển thị Form Sửa Phòng hiện có
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {

        // Lấy ID phòng từ request
        int id = Integer.parseInt(request.getParameter("id"));

        // Lấy thông tin phòng (Cần thêm userId vào Service để tránh lỗi bảo mật)
        Room existingRoom = roomService.getRoomById(id, userId);

        if (existingRoom == null) {
            // Phòng không tồn tại hoặc không thuộc về người dùng này
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy phòng hoặc bạn không có quyền truy cập.");
            return;
        }

        // Đặt đối tượng Room vào Request scope
        request.setAttribute("room", existingRoom);

        // Chuyển tiếp đến JSP form (trong chế độ chỉnh sửa)
        RequestDispatcher dispatcher = request.getRequestDispatcher(ROOM_FORM_JSP);
        dispatcher.forward(request, response);
    }

    // -------------------------------------------------------------
    // LOGIC XỬ LÝ POST (CRUD) HELPERS
    // -------------------------------------------------------------

    /**
     * Thêm phòng mới
     */
    private void insertRoom(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        int userId = getCurrentUserId(request);
        Room newRoom = extractRoomData(request, true);

        // ✅ Gán ID của người dùng đang đăng nhập
        newRoom.setUserId(userId);

        boolean success = roomService.addRoom(newRoom);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/quan-ly-phong");
        } else {
            // Thêm thất bại -> quay lại form và giữ lại dữ liệu nhập
            request.setAttribute("errorMessage", "Lỗi: Số phòng đã tồn tại hoặc dữ liệu không hợp lệ.");
            request.setAttribute("room", newRoom); // Giữ lại data đã nhập trên form
            request.getRequestDispatcher(ROOM_FORM_JSP).forward(request, response);
        }
    }

    /**
     * Cập nhật thông tin phòng
     */
    private void updateRoom(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        int userId = getCurrentUserId(request);
        Room updatedRoom = extractRoomData(request, false);

        // ✅ Gán userId cho updatedRoom để Service layer kiểm tra quyền sở hữu
        updatedRoom.setUserId(userId);

        boolean success = roomService.updateRoom(updatedRoom);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/quan-ly-phong");
        } else {
            // Cập nhật thất bại -> quay lại form
            request.setAttribute("errorMessage", "Lỗi: Không tìm thấy ID phòng hoặc dữ liệu cập nhật không hợp lệ.");
            request.setAttribute("room", updatedRoom); // Giữ lại data đã nhập trên form
            request.getRequestDispatcher(ROOM_FORM_JSP).forward(request, response);
        }
    }

    /**
     * Xóa phòng
     */
    private void deleteRoom(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int userId = getCurrentUserId(request);
        int roomId = Integer.parseInt(request.getParameter("id"));

        // Xóa phòng. Logic xóa trong Service phải kiểm tra cả roomId và userId.
        boolean success = roomService.deleteRoom(roomId, userId);

        if (!success) {
            // Dùng Session để truyền thông báo lỗi sau khi Redirect
            request.getSession().setAttribute("message", "Lỗi: Không thể xóa phòng, có thể phòng đang có hợp đồng thuê.");
        }

        response.sendRedirect(request.getContextPath() + "/quan-ly-phong");
    }

    // -------------------------------------------------------------
    // LOGIC TIỆN ÍCH
    // -------------------------------------------------------------

    /**
     * Hàm tiện ích để trích xuất dữ liệu Room từ HttpServletRequest
     */
    private Room extractRoomData(HttpServletRequest request, boolean isNew) {

        // Lấy dữ liệu và xử lý Parsing
        String roomNumber = request.getParameter("roomNumber");
        String type = request.getParameter("type");

        // --- BẮT ĐẦU PHẦN CẬP NHẬT AN TOÀN ---
        // 1. Xử lý Price
        String priceStr = request.getParameter("price");
        long priceValue = 0;
        if (priceStr != null && !priceStr.trim().isEmpty()) {
            try {
                // Loại bỏ dấu phẩy/chấm nếu người dùng nhập theo format (tùy vào locale)
                priceValue = Long.parseLong(priceStr.replaceAll("[^0-9]", ""));
            } catch (NumberFormatException e) {
                // Nếu lỗi, giữ giá trị mặc định là 0 hoặc ném lỗi cụ thể
                System.err.println("Lỗi parse Price: " + priceStr);
            }
        }

        // 2. Xử lý Floor
        String floorStr = request.getParameter("floor");
        int floorValue = 0;
        if (floorStr != null && !floorStr.trim().isEmpty()) {
            try {
                floorValue = Integer.parseInt(floorStr);
            } catch (NumberFormatException e) {
                System.err.println("Lỗi parse Floor: " + floorStr);
            }
        }

        // 3. Xử lý Status và Description
        String status = request.getParameter("status");
        String description = request.getParameter("description");

        Room room = new Room();
        room.setRoomNumber(roomNumber);
        room.setType(type);
        room.setPrice(BigDecimal.valueOf(priceValue)); // Sử dụng giá trị đã parse an toàn
        room.setStatus(status);
        room.setFloor(floorValue); // Sử dụng giá trị đã parse an toàn
        room.setDescription(description);

        // Chỉ đặt RoomId nếu là thao tác Cập nhật (isNew = false)
        if (!isNew) {
            String roomIdStr = request.getParameter("roomId");
            if (roomIdStr != null && !roomIdStr.trim().isEmpty()) {
                try {
                    room.setRoomId(Integer.parseInt(roomIdStr));
                } catch (NumberFormatException e) {
                    // Nếu roomId không phải là số (lỗi bảo mật hoặc form bị can thiệp)
                    // Bạn có thể chọn ném RuntimeException để doPost bắt lấy
                    throw new RuntimeException("ID phòng không hợp lệ.");
                }
            }
        }

        return room;
    }

    /**
     * Lấy ID của người dùng hiện tại từ Session.
     * @return ID của người dùng hoặc -1 nếu chưa đăng nhập.
     */
    private int getCurrentUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            return user.getId();
        }
        return -1;
    }

}