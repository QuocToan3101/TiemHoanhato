package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import dao.AddressDAO;
import model.Address;
import model.User;

@WebServlet(urlPatterns = {"/address/*"})
public class AddressServlet extends HttpServlet {

    private AddressDAO addressDAO;
    private Gson gson;

    @Override
    public void init() {
        addressDAO = new AddressDAO();
        gson = new Gson();
    }

    // ================= GET =================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User user = getUser(req, resp);
        if (user == null) return;

        String path = getPath(req);

        if (path.equals("") || path.equals("/")) {
            handleList(resp, user);
        } else {
            int id = parseId(path);
            handleDetail(resp, user, id);
        }
    }

    // ================= POST =================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User user = getUser(req, resp);
        if (user == null) return;

        String path = getPath(req);

        switch (path) {
            case "/add":
            case "":
                handleAdd(req, resp, user);
                break;
            case "/update":
                handleUpdate(req, resp, user);
                break;
            default:
                if (path.startsWith("/delete/")) {
                    handleDelete(resp, user, parseId(path));
                } else if (path.startsWith("/default/")) {
                    handleSetDefault(resp, user, parseId(path));
                } else {
                    writeError(resp, "Invalid API");
                }
        }
    }

    // ================= HANDLERS =================

    private void handleList(HttpServletResponse resp, User user) throws IOException {
        List<Address> list = addressDAO.findByUserId(user.getId());

        JsonObject json = new JsonObject();
        json.addProperty("success", true);
        json.add("data", gson.toJsonTree(list));

        writeJson(resp, json);
    }

    private void handleDetail(HttpServletResponse resp, User user, int id) throws IOException {
        Address a = addressDAO.findById(id);

        if (a == null || a.getUserId() != user.getId()) {
            writeError(resp, "Không tìm thấy địa chỉ");
            return;
        }

        JsonObject json = new JsonObject();
        json.addProperty("success", true);
        json.add("data", gson.toJsonTree(a));

        writeJson(resp, json);
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {

        Address a = buildAddress(req, user);

        String error = validate(a);
        if (error != null) {
            writeError(resp, error);
            return;
        }

        int count = addressDAO.countByUserId(user.getId());
        if (count >= 10) {
            writeError(resp, "Tối đa 10 địa chỉ");
            return;
        }

        if (count == 0) a.setDefault(true);

        int id = addressDAO.add(a);

        JsonObject json = new JsonObject();
        json.addProperty("success", id > 0);
        json.addProperty("message", id > 0 ? "Thêm thành công" : "Thêm thất bại");

        writeJson(resp, json);
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        Address old = addressDAO.findById(id);

        if (old == null || old.getUserId() != user.getId()) {
            writeError(resp, "Không có quyền");
            return;
        }

        Address updated = buildAddress(req, user);
        updated.setId(id);

        String error = validate(updated);
        if (error != null) {
            writeError(resp, error);
            return;
        }

        boolean ok = addressDAO.update(updated);

        writeJson(resp, createMessage(ok, "Cập nhật thành công", "Cập nhật thất bại"));
    }

    private void handleDelete(HttpServletResponse resp, User user, int id)
            throws IOException {

        boolean ok = addressDAO.delete(id, user.getId());
        writeJson(resp, createMessage(ok, "Xóa thành công", "Xóa thất bại"));
    }

    private void handleSetDefault(HttpServletResponse resp, User user, int id)
            throws IOException {

        boolean ok = addressDAO.setDefault(id, user.getId());
        writeJson(resp, createMessage(ok, "Đã đặt mặc định", "Thất bại"));
    }

    // ================= HELPER =================

    private User getUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            writeError(resp, "Vui lòng đăng nhập");
        }
        return user;
    }

    private String getPath(HttpServletRequest req) {
        String path = req.getPathInfo();
        return path == null ? "" : path;
    }

    private int parseId(String path) {
        try {
            return Integer.parseInt(path.replaceAll("\\D+", ""));
        } catch (Exception e) {
            return -1;
        }
    }

    private Address buildAddress(HttpServletRequest req, User user) {
        Address a = new Address();
        a.setUserId(user.getId());
        a.setReceiverName(req.getParameter("receiverName"));
        a.setPhone(req.getParameter("phone"));
        a.setProvince(req.getParameter("province"));
        a.setDistrict(req.getParameter("district"));
        a.setWard(req.getParameter("ward"));
        a.setAddressDetail(req.getParameter("addressDetail"));
        a.setNote(req.getParameter("note"));
        a.setDefault("true".equals(req.getParameter("isDefault")));
        return a;
    }

    private String validate(Address a) {
        if (a.getReceiverName() == null || a.getReceiverName().isEmpty())
            return "Thiếu tên";

        if (a.getPhone() == null || a.getPhone().isEmpty())
            return "Thiếu SĐT";

        if (a.getAddressDetail() == null || a.getAddressDetail().isEmpty())
            return "Thiếu địa chỉ";

        return null;
    }

    private JsonObject createMessage(boolean success, String okMsg, String failMsg) {
        JsonObject json = new JsonObject();
        json.addProperty("success", success);
        json.addProperty("message", success ? okMsg : failMsg);
        return json;
    }

    private void writeJson(HttpServletResponse resp, JsonObject json) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(json));
    }

    private void writeError(HttpServletResponse resp, String msg) throws IOException {
        JsonObject json = new JsonObject();
        json.addProperty("success", false);
        json.addProperty("message", msg);
        writeJson(resp, json);
    }
}