<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> <%@
taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đặt lại mật khẩu</title>
    
    <!-- CSRF Token -->
    <meta name="csrf-token" content="${csrfToken}">
    <script>window.csrfToken = '${csrfToken}';</script>

    <!-- Bootstrap Icons -->
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
    />
      <!-- CSS riêng -->
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/view/ForgotPassword.css"
    />
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
    
    <!-- CSRF Token Helper -->
    <script src="${pageContext.request.contextPath}/fileJS/csrf-token.js"></script>
  </head>
  <body>
    <div class="forgot-container">
      <a
        href="${pageContext.request.contextPath}/view/login_1.jsp"
        class="home-button"
      >
        <i class="bi bi-arrow-left"></i>
      </a>
      <h2 class="title">Đặt lại mật khẩu</h2>
      <c:if test="${not empty error}">
        <div
          class="error-message"
          style="
            background: #fee;
            color: #c33;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
          "
        >
          <i class="bi bi-exclamation-circle"></i> ${error}
        </div>
      </c:if>

      <c:if test="${not empty email}">
        <p class="subtitle">
          Nhập mật khẩu mới cho tài khoản: <strong>${email}</strong>
        </p>
      </c:if>
      <form id="resetPasswordForm">
        <input type="hidden" name="token" value="${token}" />
        <div class="form-group">
          <label for="newPassword">Mật khẩu mới</label>
          <input
            type="password"
            id="newPassword"
            name="newPassword"
            placeholder="Nhập mật khẩu mới"
            required
            minlength="6"
          />
        </div>
        <div class="form-group">
          <label for="confirmPassword">Xác nhận mật khẩu</label>
          <input
            type="password"
            id="confirmPassword"
            name="confirmPassword"
            placeholder="Nhập lại mật khẩu mới"
            required
          />
        </div>
        <button type="submit" class="btn-submit">Đặt lại mật khẩu</button>
      </form>

      <div class="login-link">
        Đã nhớ mật khẩu?
        <a href="${pageContext.request.contextPath}/view/login_1.jsp"
          >Đăng nhập ngay</a
        >
      </div>
    </div>
    <script>
      document
        .getElementById("resetPasswordForm")
        .addEventListener("submit", function (e) {
          e.preventDefault();

          const btn = this.querySelector(".btn-submit");
          const originalText = btn.textContent;
          btn.disabled = true;
          btn.textContent = "Đang xử lý...";

          const formData = new FormData(this);
          fetch("${pageContext.request.contextPath}/reset-password", {
            method: "POST",
            body: new URLSearchParams(formData),
          })
            .then((response) => response.json())
            .then((data) => {
              if (data.success) {
                alert(data.message);
                window.location.href =
                  "${pageContext.request.contextPath}/view/login_1.jsp";
              } else {
                alert(data.message || "Có lỗi xảy ra");
                btn.disabled = false;
                btn.textContent = originalText;
              }
            })
            .catch((error) => {
              console.error("Error:", error);
              alert("Có lỗi xảy ra, vui lòng thử lại");
              btn.disabled = false;
              btn.textContent = originalText;
            });
        });
    </script>
  </body>
</html>
