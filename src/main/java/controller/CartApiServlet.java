package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import model.CartItem;
import model.CartOperationResult;
import model.SessionCartItem;
import model.User;
import service.CartService;

/**
 * API Servlet để quản lý giỏ hàng
 */
@WebServlet("/api/cart/*")
public class CartApiServlet extends HttpServlet {

    private CartService cartService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        cartService = new CartService();
        gson = new Gson();
    }

    /**
     * GET - Lấy thông tin giỏ hàng
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();

        HttpSession session = request.getSession(false);

        User user = session != null ? (User) session.getAttribute("user") : null;

        BigDecimal total = BigDecimal.ZERO;
        int itemCount = 0;

        if (user != null) {
            List<CartItem> cartItems = cartService.getUserCartItems(user.getId());
            for (CartItem item : cartItems) {
                total = total.add(item.getSubtotal());
                itemCount += item.getQuantity();
            }
            jsonResponse.add("items", gson.toJsonTree(cartItems));
        } else {
            List<SessionCartItem> sessionItems = cartService.getSessionCartItems(session);
            for (SessionCartItem item : sessionItems) {
                total = total.add(item.getSubtotal());
                itemCount += item.getQuantity();
            }
            jsonResponse.add("items", gson.toJsonTree(sessionItems));
        }

        jsonResponse.addProperty("success", true);
        jsonResponse.addProperty("itemCount", itemCount);
        jsonResponse.addProperty("cartCount", itemCount);
        jsonResponse.addProperty("cart_count", itemCount);
        jsonResponse.addProperty("total", total.toString());
        jsonResponse.addProperty("cart_total", total);

        out.print(gson.toJson(jsonResponse));
    }

    /**
     * POST - Thêm sản phẩm vào giỏ hàng
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();

        HttpSession session = request.getSession(true);

        try {
            User user = (User) session.getAttribute("user");

            // Kiểm tra xem có phải là path /add hay không
            String pathInfo = request.getPathInfo();

            int productId;
            int quantity;

            // Đọc dữ liệu từ JSON body
            if (pathInfo != null && pathInfo.equals("/add")) {
                JsonObject jsonRequest = parseRequestBody(request);
                Integer parsedProductId = getIntFromBodyOrParam(jsonRequest, request, "productId");
                Integer parsedQuantity = getIntFromBodyOrParam(jsonRequest, request, "quantity");
                if (parsedProductId == null) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Thiếu productId");
                    out.print(gson.toJson(jsonResponse));
                    return;
                }
                productId = parsedProductId;
                quantity = parsedQuantity != null ? parsedQuantity : 1;
            } else {
                // Đọc từ parameters (backward compatibility)
                try {
                    productId = Integer.parseInt(request.getParameter("productId"));
                    String quantityParam = request.getParameter("quantity");
                    quantity = quantityParam == null ? 1 : Integer.parseInt(quantityParam);
                } catch (Exception ex) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Tham số không hợp lệ");
                    out.print(gson.toJson(jsonResponse));
                    return;
                }
            }

            CartOperationResult result = cartService.addToCart(
                session,
                user != null ? user.getId() : null,
                productId,
                quantity
            );

            writeOperationResult(jsonResponse, result);
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi: " + e.getMessage());
        }

        out.print(gson.toJson(jsonResponse));
    }

    /**
     * PUT - Cập nhật số lượng sản phẩm
     */
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();

        HttpSession session = request.getSession(false);

        try {
            User user = session != null ? (User) session.getAttribute("user") : null;
            JsonObject jsonRequest = parseRequestBody(request);
            Integer productId = getIntFromBodyOrParam(jsonRequest, request, "productId");
            Integer quantity = getIntFromBodyOrParam(jsonRequest, request, "quantity");

            if (productId == null || quantity == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Tham số không hợp lệ");
                out.print(gson.toJson(jsonResponse));
                return;
            }

            CartOperationResult result = cartService.updateQuantity(
                session,
                user != null ? user.getId() : null,
                productId,
                quantity
            );

            writeOperationResult(jsonResponse, result);
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi: " + e.getMessage());
        }

        out.print(gson.toJson(jsonResponse));
    }

    /**
     * DELETE - Xóa sản phẩm khỏi giỏ hàng
     */
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();

        HttpSession session = request.getSession(false);

        try {
            User user = session != null ? (User) session.getAttribute("user") : null;
            String pathInfo = request.getPathInfo();

            if (pathInfo != null && pathInfo.equals("/clear")) {
                CartOperationResult result = cartService.clearCart(session, user != null ? user.getId() : null);
                writeOperationResult(jsonResponse, result);
            } else {
                JsonObject jsonRequest = parseRequestBody(request);
                Integer productId = getIntFromBodyOrParam(jsonRequest, request, "productId");

                if (productId == null) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Tham số không hợp lệ");
                    out.print(gson.toJson(jsonResponse));
                    return;
                }

                CartOperationResult result = cartService.removeFromCart(
                    session,
                    user != null ? user.getId() : null,
                    productId
                );
                writeOperationResult(jsonResponse, result);
            }
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi: " + e.getMessage());
        }

        out.print(gson.toJson(jsonResponse));
    }

    private void writeOperationResult(JsonObject jsonResponse, CartOperationResult result) {
        jsonResponse.addProperty("success", result.isSuccess());
        jsonResponse.addProperty("message", result.getMessage());
        jsonResponse.addProperty("cartCount", result.getCartCount());
        jsonResponse.addProperty("itemCount", result.getCartCount());
        jsonResponse.addProperty("cartItemCount", result.getCartCount());
        jsonResponse.addProperty("cart_count", result.getCartCount());
        jsonResponse.addProperty("total", result.getCartTotal().toString());
        jsonResponse.addProperty("cart_total", result.getCartTotal());
    }

    private JsonObject parseRequestBody(HttpServletRequest request) {
        String contentType = request.getContentType();
        if (contentType == null || !contentType.toLowerCase().contains("application/json")) {
            return null;
        }
        try {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }
            if (sb.length() == 0) {
                return null;
            }
            return gson.fromJson(sb.toString(), JsonObject.class);
        } catch (Exception e) {
            return null;
        }
    }

    private Integer getIntFromBodyOrParam(JsonObject body, HttpServletRequest request, String key) {
        try {
            if (body != null && body.has(key) && !body.get(key).isJsonNull()) {
                return body.get(key).getAsInt();
            }
        } catch (Exception ignored) {
            // Fall through to request parameter.
        }

        String value = request.getParameter(key);
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }
}
