package Controller;

import Services.StatisticsService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Map;

@WebServlet(name = "StatisticsController", urlPatterns = {"/thong-ke"})
public class StatisticsController extends HttpServlet {

    private static final String STATISTICS_JSP = "/WEB-INF/views/statistics/statistics.jsp";
    private StatisticsService statisticsService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.statisticsService = new StatisticsService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=showLogin");
            return;
        }

        int userId = user.getId();

        try {
            // Lấy tham số năm và tháng từ request (mặc định là năm hiện tại)
            String yearStr = request.getParameter("year");
            int year = (yearStr != null && !yearStr.isEmpty()) ? Integer.parseInt(yearStr) : java.time.Year.now().getValue();

            String monthStr = request.getParameter("month");
            Integer month = (monthStr != null && !monthStr.isEmpty()) ? Integer.parseInt(monthStr) : null;

            // Lấy thống kê tổng quan
            Map<String, Object> overview = statisticsService.getOverviewStatistics(userId);
            request.setAttribute("overview", overview);

            // Lấy doanh thu theo tháng
            Map<Integer, BigDecimal> monthlyRevenue;
            if (month != null) {
                // Nếu chọn tháng cụ thể, lấy doanh thu từng ngày trong tháng
                monthlyRevenue = statisticsService.getDailyRevenueByMonth(userId, year, month);
                request.setAttribute("viewType", "daily");
                request.setAttribute("selectedMonth", month);
            } else {
                // Mặc định: lấy doanh thu 12 tháng
                monthlyRevenue = statisticsService.getMonthlyRevenue(userId, year);
                request.setAttribute("viewType", "monthly");
            }

            request.setAttribute("monthlyRevenue", monthlyRevenue);
            request.setAttribute("selectedYear", year);

            // Lấy thống kê theo phòng
            Map<String, BigDecimal> roomRevenue = statisticsService.getRevenueByRoom(userId);
            request.setAttribute("roomRevenue", roomRevenue);

            // Lấy thống kê thanh toán gần đây
            request.setAttribute("recentPayments", statisticsService.getRecentPayments(userId, 5));

            request.getRequestDispatcher(STATISTICS_JSP).forward(request, response);

        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi xử lý thống kê: " + ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
}