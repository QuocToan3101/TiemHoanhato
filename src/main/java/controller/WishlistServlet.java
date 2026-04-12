package controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import dao.WishlistDAO;
import model.User;

/**
 * API Servlet xử lý wishlist.
 */
@WebServlet("/api/wishlist/*")
public class WishlistServlet extends HttpServlet {

    private WishlistDAO wishlistDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        wishlistDAO = new WishlistDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject json = new JsonObject();

        User user = getLoggedInUser(request);
        if (user == null) {
            json.addProperty("success", false);
            json.addProperty("message", "Vui lòng đăng nhập");
            json.addProperty("count", 0);
            json.add("data", gson.toJsonTree(new java.util.ArrayList<>()));
            out.print(gson.toJson(json));
            return;
        }

        String pathInfo = request.getPathInfo();
        if ("/check".equals(pathInfo)) {
            int productId = parseInt(request.getParameter("productId"), -1);
            boolean inWishlist = productId > 0 && wishlistDAO.isInWishlist(user.getId(), productId);

            json.addProperty("success", true);
            json.addProperty("inWishlist", inWishlist);
            json.addProperty("count", wishlistDAO.countByUserId(user.getId()));
            out.print(gson.toJson(json));
            return;
        }

        json.addProperty("success", true);
        json.addProperty("count", wishlistDAO.countByUserId(user.getId()));
        json.add("data", gson.toJsonTree(wishlistDAO.getByUserIdWithProducts(user.getId())));
        out.print(gson.toJson(json));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject json = new JsonObject();

        User user = getLoggedInUser(request);
        if (user == null) {
            json.addProperty("success", false);
            json.addProperty("message", "Vui lòng đăng nhập");
            out.print(gson.toJson(json));
            return;
        }

        JsonObject body;
        try {
            body = gson.fromJson(request.getReader(), JsonObject.class);
        } catch (Exception ex) {
            body = null;
        }

        String action = body != null && body.has("action") ? body.get("action").getAsString() : "toggle";
        int productId = body != null && body.has("productId") ? body.get("productId").getAsInt() : -1;

        if (productId <= 0) {
            json.addProperty("success", false);
            json.addProperty("message", "productId không hợp lệ");
            out.print(gson.toJson(json));
            return;
        }

        boolean success;
        boolean inWishlist;

        switch (action) {
            case "add":
                success = wishlistDAO.add(user.getId(), productId) || wishlistDAO.isInWishlist(user.getId(), productId);
                inWishlist = wishlistDAO.isInWishlist(user.getId(), productId);
                json.addProperty("message", success ? "Đã thêm vào yêu thích" : "Không thể thêm vào yêu thích");
                break;
            case "remove":
                success = wishlistDAO.remove(user.getId(), productId);
                inWishlist = wishlistDAO.isInWishlist(user.getId(), productId);
                json.addProperty("message", success ? "Đã xóa khỏi yêu thích" : "Không thể xóa khỏi yêu thích");
                break;
            case "toggle":
            default:
                if (wishlistDAO.isInWishlist(user.getId(), productId)) {
                    success = wishlistDAO.remove(user.getId(), productId);
                    inWishlist = false;
                    json.addProperty("message", success ? "Đã xóa khỏi yêu thích" : "Không thể xóa khỏi yêu thích");
                } else {
                    success = wishlistDAO.add(user.getId(), productId);
                    inWishlist = success;
                    json.addProperty("message", success ? "Đã thêm vào yêu thích" : "Không thể thêm vào yêu thích");
                }
                break;
        }

        json.addProperty("success", success);
        json.addProperty("inWishlist", inWishlist);
        json.addProperty("count", wishlistDAO.countByUserId(user.getId()));
        out.print(gson.toJson(json));
    }

    private User getLoggedInUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (User) session.getAttribute("user");
    }

    private int parseInt(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return defaultValue;
        }
    }
}