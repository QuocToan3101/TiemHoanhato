package controller;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import dao.AddressDAO;
import model.Address;
import model.User;
/**
 * Servlet xử lý sổ địa chỉ
 */
@WebServlet(urlPatterns = {"/address/*", "/api/address/*"})
public class AddressServlet extends HttpServlet {
    private AddressDAO addressDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        addressDAO = new AddressDAO();
        gson = new Gson();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            sendJsonError(response, "Vui lòng đăng nhập");
            return;
        }
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
            // Lấy danh sách địa chỉ
            listAddresses(response, user);
        } else if (pathInfo.startsWith("/detail/")) {
            // Lấy chi tiết địa chỉ
            getAddressDetail(request, response, user);
        } else {
            sendJsonError(response, "Invalid action");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            sendJsonError(response, "Vui lòng đăng nhập");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/add")) {
            // Thêm địa chỉ mới
            addAddress(request, response, user);
        } else if (pathInfo.equals("/update")) {
            // Cập nhật địa chỉ
            updateAddress(request, response, user);
        } else if (pathInfo.startsWith("/delete/")) {
            // Xóa địa chỉ
            deleteAddress(request, response, user);
        } else if (pathInfo.startsWith("/set-default/")) {
            // Đặt địa chỉ mặc định
            setDefaultAddress(request, response, user);
        } else {
            sendJsonError(response, "Invalid action");
        }
    }
    private void listAddresses(HttpServletResponse response, User user) throws IOException {
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            List<Address> addresses = addressDAO.findByUserId(user.getId());
            jsonResponse.addProperty("success", true);
            jsonResponse.add("addresses", gson.toJsonTree(addresses));
            jsonResponse.addProperty("count", addresses.size());
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi: " + e.getMessage());
        }
        
        out.print(gson.toJson(jsonResponse));
    }
    
    /**
     * Lấy chi tiết địa chỉ
     */
    private void getAddressDetail(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            String pathInfo = request.getPathInfo();
            int addressId = Integer.parseInt(pathInfo.substring("/detail/".length()));
            
            Address address = addressDAO.findById(addressId);
            
            if (address == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không tìm thấy địa chỉ");
            } else if (address.getUserId() != user.getId()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Bạn không có quyền xem địa chỉ này");
            } else {
                jsonResponse.addProperty("success", true);
                jsonResponse.add("address", gson.toJsonTree(address));
            }
        } catch (NumberFormatException e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "ID địa chỉ không hợp lệ");
        }
        
        out.print(gson.toJson(jsonResponse));
    }
    
    /**
     * Thêm địa chỉ mới
     */
    private void addAddress(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            String receiverName = request.getParameter("receiverName");
            String phone = request.getParameter("phone");
            String province = request.getParameter("province");
            String district = request.getParameter("district");
            String ward = request.getParameter("ward");
            String addressDetail = request.getParameter("addressDetail");
            String note = request.getParameter("note");
            boolean isDefault = "true".equals(request.getParameter("isDefault"));
            
            // Validate
            if (receiverName == null || receiverName.trim().isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng nhập tên người nhận");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            if (phone == null || phone.trim().isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng nhập số điện thoại");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            if (addressDetail == null || addressDetail.trim().isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng nhập địa chỉ chi tiết");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            // Kiểm tra giới hạn số lượng địa chỉ (tối đa 10)
            int currentCount = addressDAO.countByUserId(user.getId());
            if (currentCount >= 10) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Bạn chỉ có thể lưu tối đa 10 địa chỉ");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            // Nếu là địa chỉ đầu tiên, tự động đặt làm mặc định
            if (currentCount == 0) {
                isDefault = true;
            }
            
            Address address = new Address();
            address.setUserId(user.getId());
            address.setReceiverName(receiverName.trim());
            address.setPhone(phone.trim());
            address.setProvince(province != null ? province.trim() : "");
            address.setDistrict(district != null ? district.trim() : "");
            address.setWard(ward != null ? ward.trim() : "");
            address.setAddressDetail(addressDetail.trim());
            address.setNote(note != null ? note.trim() : "");
            address.setDefault(isDefault);
            
            int newId = addressDAO.add(address);
            
            if (newId > 0) {
                address.setId(newId);
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Đã thêm địa chỉ mới");
                jsonResponse.add("address", gson.toJsonTree(address));
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không thể thêm địa chỉ");
            }
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi: " + e.getMessage());
        }
        
        out.print(gson.toJson(jsonResponse));
    }
    
    /**
     * Cập nhật địa chỉ
     */
    private void updateAddress(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            int addressId = Integer.parseInt(request.getParameter("id"));
            
            // Kiểm tra quyền
            Address existingAddress = addressDAO.findById(addressId);
            if (existingAddress == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không tìm thấy địa chỉ");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            if (existingAddress.getUserId() != user.getId()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Bạn không có quyền sửa địa chỉ này");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            String receiverName = request.getParameter("receiverName");
            String phone = request.getParameter("phone");
            String province = request.getParameter("province");
            String district = request.getParameter("district");
            String ward = request.getParameter("ward");
            String addressDetail = request.getParameter("addressDetail");
            String note = request.getParameter("note");
            boolean isDefault = "true".equals(request.getParameter("isDefault"));
            
            // Validate
            if (receiverName == null || receiverName.trim().isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng nhập tên người nhận");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            if (phone == null || phone.trim().isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng nhập số điện thoại");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            if (addressDetail == null || addressDetail.trim().isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng nhập địa chỉ chi tiết");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            existingAddress.setReceiverName(receiverName.trim());
            existingAddress.setPhone(phone.trim());
            existingAddress.setProvince(province != null ? province.trim() : "");
            existingAddress.setDistrict(district != null ? district.trim() : "");
            existingAddress.setWard(ward != null ? ward.trim() : "");
            existingAddress.setAddressDetail(addressDetail.trim());
            existingAddress.setNote(note != null ? note.trim() : "");
            existingAddress.setDefault(isDefault);
            
            boolean success = addressDAO.update(existingAddress);
            
            if (success) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Đã cập nhật địa chỉ");
                jsonResponse.add("address", gson.toJsonTree(existingAddress));
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không thể cập nhật địa chỉ");
            }
        } catch (NumberFormatException e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "ID địa chỉ không hợp lệ");
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi: " + e.getMessage());
        }
        
        out.print(gson.toJson(jsonResponse));
    }
    
    /**
     * Xóa địa chỉ
     */
    private void deleteAddress(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            String pathInfo = request.getPathInfo();
            int addressId = Integer.parseInt(pathInfo.substring("/delete/".length()));
            
            // Kiểm tra quyền
            Address address = addressDAO.findById(addressId);
            if (address == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không tìm thấy địa chỉ");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            if (address.getUserId() != user.getId()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Bạn không có quyền xóa địa chỉ này");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            boolean success = addressDAO.delete(addressId, user.getId());
            
            if (success) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Đã xóa địa chỉ");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không thể xóa địa chỉ");
            }
        } catch (NumberFormatException e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "ID địa chỉ không hợp lệ");
        }
        
        out.print(gson.toJson(jsonResponse));
    }
    
    /**
     * Đặt địa chỉ mặc định
     */
    private void setDefaultAddress(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            String pathInfo = request.getPathInfo();
            int addressId = Integer.parseInt(pathInfo.substring("/set-default/".length()));
            
            // Kiểm tra quyền
            Address address = addressDAO.findById(addressId);
            if (address == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không tìm thấy địa chỉ");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            if (address.getUserId() != user.getId()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Bạn không có quyền thao tác địa chỉ này");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            boolean success = addressDAO.setDefault(addressId, user.getId());
            
            if (success) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Đã đặt làm địa chỉ mặc định");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không thể đặt địa chỉ mặc định");
            }
        } catch (NumberFormatException e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "ID địa chỉ không hợp lệ");
        }
        
        out.print(gson.toJson(jsonResponse));
    }
    
    private void sendJsonError(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject json = new JsonObject();
        json.addProperty("success", false);
        json.addProperty("message", message);
        out.print(gson.toJson(json));
    }
}
