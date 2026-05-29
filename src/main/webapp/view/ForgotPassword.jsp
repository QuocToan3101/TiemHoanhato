<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <title>Quên mật khẩu</title>
    
    <!-- CSRF Token -->
    <meta name="csrf-token" content="${csrfToken}">
    <script>window.csrfToken = '${csrfToken}';</script>

    <%@ include file="partials/head-icons.jsp" %>
    <!-- CSS riêng -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ForgotPassword.css" />
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
    
    <!-- CSRF Token Helper -->
    <script src="${pageContext.request.contextPath}/js/csrf-helper.js"></script>

    <!-- SweetAlert2 CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.5/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.5/dist/sweetalert2.all.min.js"></script>

    <!-- Notification System Utility -->
    <script src="${pageContext.request.contextPath}/js/notification.js"></script>
  </head>

  <body>
    <div class="forgot-container">
      <a
        href="${pageContext.request.contextPath}/view/login_1.jsp"
        class="home-button"
      >
        <i class="bi bi-arrow-left"></i>
      </a>

      <h2 class="title">Quên mật khẩu</h2>

      <p class="subtitle">
        Nhập email của bạn để nhận liên kết đặt lại mật khẩu.
      </p>

      <form id="forgotPasswordForm">
        <div class="form-group">
          <label for="email">Email của bạn</label>
          <input
            type="email"
            id="email"
            name="email"
            placeholder="Nhập email"
            required
          />
        </div>

        <button type="submit" class="btn-submit">Gửi yêu cầu</button>
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
        .getElementById("forgotPasswordForm")
        .addEventListener("submit", function (e) {
          e.preventDefault();

          const btn = this.querySelector(".btn-submit");
          const originalText = btn.textContent;
          btn.disabled = true;
          btn.textContent = "Đang xử lý...";

          const formData = new FormData(this);

          fetch("${pageContext.request.contextPath}/forgot-password", {
            method: "POST",
            body: new URLSearchParams(formData),
          })
            .then((response) => response.json())
            .then((data) => {
              if (data.success) {
                showSuccess(data.message);
                if (data.resetLink) {
                  console.log("Reset link:", data.resetLink);
                  showConfirm("Bạn có muốn đi đến trang đặt lại mật khẩu ngay không?", function() {
                    window.location.href = data.resetLink;
                  });
                }
              } else {
                showError(data.message || "Có lỗi xảy ra");
              }
              btn.disabled = false;
              btn.textContent = originalText;
            })
            .catch((error) => {
              console.error("Error:", error);
              showError("Có lỗi xảy ra, vui lòng thử lại");
              btn.disabled = false;
              btn.textContent = originalText;
            });
        });
    </script>
  </body>
</html>
