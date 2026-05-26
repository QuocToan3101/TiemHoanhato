package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import dao.CustomOrderDAO;
import model.CustomOrder;
import model.User;

/**
 * Serves the custom bouquet builder page and handles custom order submissions.
 */
@WebServlet(urlPatterns = {"/custom-bouquet"})
public class CustomBouquetServlet extends HttpServlet {

    private CustomOrderDAO customOrderDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        customOrderDAO = new CustomOrderDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        // Luồng trung chuyển login: lưu redirectUrl và nhảy đến trang đăng nhập
        if ("login".equals(action)) {
            HttpSession session = request.getSession(true);
            session.setAttribute("redirectUrl", request.getContextPath() + "/custom-bouquet");
            response.sendRedirect(request.getContextPath() + "/view/login_1.jsp");
            return;
        }

        request.getRequestDispatcher("/view/custom-bouquet.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();

        try {
            // Kiểm tra trạng thái đăng nhập
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;

            if (user == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng đăng nhập trước khi đặt hàng!");
                out.print(gson.toJson(jsonResponse));
                return;
            }

            // Đọc và phân tích cú pháp JSON request body
            JsonObject reqBody = JsonParser.parseReader(request.getReader()).getAsJsonObject();

            // Lấy các tham số cấu hình hoa tùy chọn từ JSON body
            String flowerType = getString(reqBody, "flowerType");
            String mainFlower = getString(reqBody, "mainFlower");
            String supportFlower = getString(reqBody, "supportFlower");
            String quantity = getString(reqBody, "quantity");
            String wrapPaper = getString(reqBody, "wrap");
            String colorTone = getString(reqBody, "color");
            String occasion = getString(reqBody, "occasion");
            String customerNote = getString(reqBody, "note");
            
            // Xử lý Accessories (Mảng JSON)
            List<String> accList = new ArrayList<>();
            if (reqBody.has("accessories") && reqBody.get("accessories").isJsonArray()) {
                JsonArray accArray = reqBody.getAsJsonArray("accessories");
                for (JsonElement el : accArray) {
                    accList.add(el.getAsString());
                }
            }
            String accessories = String.join(", ", accList);

            // Phân tích giá cả và ngân sách
            double budgetVal = reqBody.has("budget") ? reqBody.get("budget").getAsDouble() : 900.0;
            double estimatedPriceVal = reqBody.has("estimatedPrice") ? reqBody.get("estimatedPrice").getAsDouble() : 900.0;

            // Nhân 1000 như công thức frontend
            BigDecimal budget = new BigDecimal(budgetVal * 1000);
            BigDecimal estimatedPrice = new BigDecimal(estimatedPriceVal);

            // Tạo thực thể CustomOrder
            CustomOrder order = new CustomOrder();
            order.setUserId(user.getId());
            order.setFlowerType(flowerType);
            order.setMainFlower(mainFlower);
            order.setSupportFlower(supportFlower);
            order.setQuantity(quantity);
            order.setWrapPaper(wrapPaper);
            order.setColorTone(colorTone);
            order.setAccessories(accessories);
            order.setOccasion(occasion);
            order.setBudget(budget);
            order.setEstimatedPrice(estimatedPrice);
            order.setCustomerNote(customerNote);
            order.setStatus("pending");

            // Lưu đơn đặt hàng tùy chỉnh vào cơ sở dữ liệu
            boolean success = customOrderDAO.createCustomOrder(order);

            if (success) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Yêu cầu đặt hoa tùy chỉnh của bạn đã được lưu và gửi tới Admin. Tiệm sẽ liên hệ sớm nhất để tư vấn!");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không thể lưu đơn hàng tùy chỉnh. Vui lòng liên hệ hỗ trợ!");
            }

        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi xử lý server: " + e.getMessage());
            e.printStackTrace();
        }

        out.print(gson.toJson(jsonResponse));
    }

    private String getString(JsonObject body, String key) {
        return body != null && body.has(key) && !body.get(key).isJsonNull() ? body.get(key).getAsString() : "";
    }
}
