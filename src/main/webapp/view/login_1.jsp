<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>

<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đăng nhập</title>
    <!-- Bootstrap Icons -->

    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
    />

    <!-- Custom CSS -->

    <style>
      /* 🎨 Tổng thể giao diện login */

      body {
        margin: 0;

        padding: 0;

        font-family: "Poppins", sans-serif;

        background-color: #f5efe6; /* nền be */

        display: flex;

        justify-content: center;

        align-items: center;

        height: 100vh;

        animation: fadeInSlide 1s ease-out;
      }

      @keyframes fadeInSlide {
        0% {
          opacity: 0;

          transform: translateX(-40px);
        }

        100% {
          opacity: 1;

          transform: translateX(0);
        }
      }

      /* 🪞 Khung form */

      .login-container {
        background-color: #fffdf9;

        padding: 4rem 5rem;

        border-radius: 20px;

        box-shadow: 0 6px 25px rgba(0, 0, 0, 0.15);

        width: 500px;

        max-width: 95%;

        box-sizing: border-box;

        animation: fadeInSlide 1s ease-out;

        position: relative;
      }

      /* 🌼 Logo */

      .login-logo {
        display: flex;

        justify-content: center;

        margin-bottom: 2rem;

        transform: scale(2);
      }

      .login-logo img {
        width: 140px;

        height: auto;
      }

      /* 🧾 Tiêu đề */

      .login-title {
        text-align: center;

        font-size: 2rem;

        font-weight: 600;

        color: #6b4f36;

        margin-bottom: 2rem;
      }

      /* ✏️ Input group */

      .input-group {
        position: relative;

        margin-bottom: 1.8rem;
      }

      .input-group input {
        width: 100%;

        padding: 14px 12px;

        border: 1.5px solid #c8b6a6;

        border-radius: 8px;

        outline: none;

        background: transparent;

        transition: 0.3s ease;

        font-size: 1rem;

        color: #6b4f36;
      }

      .input-group label {
        position: absolute;

        top: 50%;

        left: 12px;

        transform: translateY(-50%);

        color: #a1887f;

        font-size: 1rem;

        pointer-events: none;

        transition: 0.25s ease all;

        background-color: #fffdf9;

        padding: 0 6px;
      }

      .input-group input:focus {
        border-color: #6b4f36;
      }

      .input-group input:focus + label,
      .input-group input:not(:placeholder-shown) + label {
        top: 0;

        font-size: 0.85rem;

        color: #6b4f36;
      }

      /* ✅ Checkbox + quên mật khẩu */

      .login-options {
        display: flex;

        justify-content: space-between;

        align-items: center;

        font-size: 0.9rem;

        color: #6b4f36;

        margin-bottom: 1.8rem;
      }

      .login-options input[type="checkbox"] {
        accent-color: #6b4f36; /* màu nâu */
      }

      .login-options a {
        color: #6b4f36;

        text-decoration: none;

        transition: 0.3s ease;
      }

      .login-options a:hover {
        color: #4b3621;
      }

      /* 🔘 Nút đăng nhập */

      .login-button {
        width: 100%;

        background-color: #6b4f36; /* nâu */

        color: #fff;

        padding: 14px 0;

        font-size: 1.15rem;

        font-weight: 500;

        border: none;

        border-radius: 10px;

        cursor: pointer;

        transition: 0.3s ease;
      }

      .login-button:hover {
        background-color: #4b3621;

        transform: translateY(-2px);
      }

      /* 🌐 Liên kết mạng xã hội */

      .social-login {
        text-align: center;

        margin-top: 2rem;
      }

      .social-login p {
        color: #6b4f36;

        margin-bottom: 0.8rem;

        font-weight: 500;
      }

      .social-icons {
        display: flex;

        justify-content: center;

        gap: 18px;
      }

      .social-icons i {
        color: #6b4f36;

        font-size: 1.5rem;

        transition: 0.3s ease;
      }

      .social-icons i:hover {
        color: #4b3621;

        transform: scale(1.2);
      }

      /* 🪶 Liên kết đăng ký */

      .register-link {
        text-align: center;

        margin-top: 1.5rem;

        color: #6b4f36;
      }

      .register-link a {
        color: #6b4f36;

        font-weight: 600;

        text-decoration: none;

        transition: 0.3s ease;
      }

      .register-link a:hover {
        color: #4b3621;
      }

      /* 📱 Responsive */

      @media (max-width: 992px) {
        .login-container {
          width: 450px;

          padding: 3rem 3.5rem;
        }

        .login-title {
          font-size: 1.8rem;
        }

        .login-logo img {
          width: 120px;
        }
      }

      @media (max-width: 768px) {
        .login-container {
          width: 90%;

          padding: 2.5rem;
        }

        .login-title {
          font-size: 1.6rem;
        }

        .login-logo img {
          width: 110px;
        }
      }

      @media (max-width: 480px) {
        .login-container {
          padding: 2rem 1.5rem;
        }

        .login-title {
          font-size: 1.4rem;
        }

        .login-button {
          font-size: 1rem;

          padding: 12px 0;
        }

        .social-icons i {
          font-size: 1.3rem;
        }
      }

      /* 🔙 Nút quay về trang chủ */

      .home-button {
        position: absolute;

        top: 20px; /* Đẩy nút lên cao hơn một chút */

        left: 20px; /* Đẩy nút sang trái một chút */

        background-color: #6b4f36;

        color: #fff;

        padding: 12px 14px;

        border-radius: 12px;

        font-size: 1.4rem;

        display: flex;

        align-items: center;

        justify-content: center;

        cursor: pointer;

        text-decoration: none;

        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.15);

        transition: 0.25s ease;

        z-index: 10;
      }

      .home-button:hover {
        background-color: #4b3621;

        transform: translateY(-2px);
      }
    </style>
  </head>

  <body>
    <!--<a href="home.jsp" class="home-button">-->

    <!--  <i class="bi bi-house-door-fill"></i>-->

    <!--</a>-->

    <div class="login-container">
      <!-- Nút quay về trang chủ -->

      <a href="${pageContext.request.contextPath}/home" class="home-button">
        <i class="bi bi-house-door-fill"></i>
      </a>

      <div class="login-logo">
        <img
          src="${pageContext.request.contextPath}/view/Logo%20Ti%E1%BB%87m%20Hoa.png"
          alt="Tiệm Hoa Nhà Tớ"
        />
      </div>

      <div class="login-title">Đăng nhập</div>

      <c:if test="${not empty error}">
        <div
          style="
            color: #dc3545;
            text-align: center;
            margin-bottom: 1rem;
            padding: 10px;
            background-color: #f8d7da;
            border-radius: 8px;
          "
        >
          <c:out value="${error}" />
        </div>
      </c:if>

      <c:if test="${not empty success}">
        <div
          style="
            color: #155724;
            text-align: center;
            margin-bottom: 1rem;
            padding: 10px;
            background-color: #d4edda;
            border-radius: 8px;
          "
        >
          <c:out value="${success}" />
        </div>
      </c:if>

      <form action="${pageContext.request.contextPath}/login" method="post">
        <!-- Email input -->

        <div class="input-group">
          <input
            type="email"
            id="email"
            name="email"
            placeholder=" "
            value="${email}"
            required
          />

          <label for="email">Nhập email của bạn</label>
        </div>

        <!-- Password input -->

        <div class="input-group">
          <input
            type="password"
            id="password"
            name="password"
            placeholder=" "
            required
          />

          <label for="password">Mật khẩu</label>
        </div>

        <!-- Checkbox + Quên mật khẩu -->

        <div class="login-options">
          <div>
            <input type="checkbox" id="remember" name="remember" />

            <label for="remember">Lưu mật khẩu</label>
          </div>

          <a href="${pageContext.request.contextPath}/view/ForgotPassword.jsp"
            >Quên mật khẩu?</a
          >
        </div>

        <!-- Submit button -->

        <button type="submit" class="login-button">Đăng nhập</button>

        <!-- Register + mạng xã hội -->

        <div class="social-login">
          <p>Hoặc đăng nhập bằng:</p>

          <div class="social-icons">
            <a href="${pageContext.request.contextPath}/oauth/facebook" title="Đăng nhập bằng Facebook" style="text-decoration: none;">
              <i class="bi bi-facebook"></i>
            </a>

            <a href="${pageContext.request.contextPath}/oauth/google" title="Đăng nhập bằng Google" style="text-decoration: none;">
              <i class="bi bi-google"></i>
            </a>
          </div>
        </div>

        <div class="register-link">
          <p>
            Bạn chưa có tài khoản?
            <a href="${pageContext.request.contextPath}/view/registration.jsp"
              >Đăng ký ngay</a
            >
          </p>
        </div>
      </form>
    </div>
  </body>
</html>
