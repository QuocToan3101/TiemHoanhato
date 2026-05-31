<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> <%@
taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đặt lại mật khẩu</title>

    <meta name="csrf-token" content="${csrfToken}">
    <script>window.csrfToken = '${csrfToken}';</script>

    <%@ include file="partials/head-icons.jsp" %>

    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/ForgotPassword.css"
    />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>

    <script src="${pageContext.request.contextPath}/js/csrf-helper.js"></script>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.5/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.5/dist/sweetalert2.all.min.js"></script>

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
          
          // Clear previous errors
          clearFormErrors(this);

          const newPwd = document.getElementById("newPassword");
          const confPwd = document.getElementById("confirmPassword");
          let isValid = true;

          // Inline Validations
          if (newPwd.value.length < 8) {
            showFormError(newPwd, "Mật khẩu mới phải có độ dài tối thiểu là 8 ký tự!");
            isValid = false;
          } else if (!/(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/.test(newPwd.value)) {
            showFormError(newPwd, "Mật khẩu phải chứa ít nhất 1 chữ hoa, 1 chữ thường và 1 số!");
            isValid = false;
          }

          if (newPwd.value !== confPwd.value) {
            showFormError(confPwd, "Mật khẩu xác nhận không trùng khớp!");
            isValid = false;
          }

          if (!isValid) return;

          const btn = this.querySelector(".btn-submit");
          setButtonLoading(btn, true, "Đang xử lý...");

          const formData = new FormData(this);
          fetch("${pageContext.request.contextPath}/reset-password", {
            method: "POST",
            body: new URLSearchParams(formData),
          })
            .then((response) => response.json())
            .then((data) => {
              setButtonLoading(btn, false);
              if (data.success) {
                showSuccess(data.message, "Thành công").then(() => {
                  window.location.href = "${pageContext.request.contextPath}/view/login_1.jsp";
                });
              } else {
                showError(data.message || "Không thể đặt lại mật khẩu");
              }
            })
            .catch((error) => {
              console.error("Error:", error);
              setButtonLoading(btn, false);
              showError("Có lỗi xảy ra trong quá trình kết nối với máy chủ.");
            });
        });
    </script>
  </body>
</html>
