<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> <%@
taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <title>Đăng ký thành viên</title>

    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/7.1.0/mdb.min.css"
    />

    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
    />

    <link rel="stylesheet" href="registration.css" />
    <style>
      .alert {
        padding: 12px 15px;
        margin-bottom: 15px;
        border-radius: 5px;
        font-size: 14px;
      }
      .alert-danger {
        background-color: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
      }
      .alert-success {
        background-color: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
      }
    </style>
  </head>

  <body>
    <div class="register-container">
      <h2 class="text-center mb-4">Đăng ký thành viên</h2>

      <!-- Nút quay về trang chủ -->

      <a href="${pageContext.request.contextPath}/home" class="home-button">
        <i class="bi bi-house-door-fill"></i>
      </a>

      <!-- Hiển thị thông báo lỗi -->
      <c:if test="${not empty error}">
        <div class="alert alert-danger">
          <i class="bi bi-exclamation-circle me-2"></i>${error}
        </div>
      </c:if>

      <form
        action="${pageContext.request.contextPath}/register"
        method="post"
        id="registerForm"
      >
        <div class="form-group">
          <label for="fullname">Họ và tên</label>
          <input
            type="text"
            id="fullname"
            name="fullname"
            placeholder="Nhập họ và tên"
            value="${fullname}"
            required
          />
        </div>

        <div class="form-group">
          <label for="email">Email</label>
          <input
            type="email"
            id="email"
            name="email"
            placeholder="Nhập email"
            value="${email}"
            required
          />
        </div>

        <div class="form-group">
          <label for="phone">Số điện thoại</label>
          <input
            type="tel"
            id="phone"
            name="phone"
            placeholder="Nhập số điện thoại"
            value="${phone}"
          />
        </div>

        <div class="form-group">
          <label for="password">Mật khẩu</label>
          <input
            type="password"
            id="password"
            name="password"
            placeholder="Nhập mật khẩu"
            required
          />
        </div>

        <div class="form-group">
          <label for="repassword">Nhập lại mật khẩu</label>
          <input
            type="password"
            id="repassword"
            name="repassword"
            placeholder="Nhập lại mật khẩu"
            required
          />
        </div>

        <div class="checkbox-group">
          <label>
            <input type="checkbox" id="agree" name="agree" required /> Tôi đồng
            ý với
            <a href="#">chính sách dịch vụ</a>
          </label>
        </div>

        <button type="submit" class="btn-register w-1200" id="btnRegister">
          ĐĂNG KÝ
        </button>
      </form>

      <div class="login-link">
        Bạn đã có tài khoản?
        <a href="${pageContext.request.contextPath}/view/login_1.jsp"
          >Đăng nhập ngay</a
        >
      </div>
    </div>

    <!-- MDB Script -->

    <script src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/7.1.0/mdb.umd.min.js"></script>

    <script>
      // Client-side validation before submit
      document
        .getElementById("registerForm")
        .addEventListener("submit", function (e) {
          const pass = document.getElementById("password").value;
          const repass = document.getElementById("repassword").value;
          const agree = document.getElementById("agree").checked;

          if (pass !== repass) {
            e.preventDefault();
            alert("Mật khẩu không khớp!");
            return false;
          }

          if (pass.length < 6) {
            e.preventDefault();
            alert("Mật khẩu phải có ít nhất 6 ký tự!");
            return false;
          }

          if (!agree) {
            e.preventDefault();
            alert("Vui lòng đồng ý với chính sách dịch vụ!");
            return false;
          }

          return true;
        });
    </script>
  </body>
</html>
