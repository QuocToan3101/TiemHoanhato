<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> <%@ page
isELIgnored="false" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đặt hàng thành công - Tiệm Hoa nhà tớ</title>
    <link
      rel="shortcut icon"
      href="//cdn.hstatic.net/themes/200000846175/1001403720/14/favicon.png?v=245"
      type="image/x-icon"
    />
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Inter:wght@400;500;600;700&family=Crimson+Text:ital,wght@0,400;0,600;0,700;1,400&display=swap"
      rel="stylesheet"
    />
    <!-- Font Awesome -->
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <!-- Main Site CSS -->
    <link
      href="//cdn.hstatic.net/themes/200000846175/1001403720/14/plugin-style.css?v=245"
      rel="stylesheet"
      type="text/css"
    />
    <link
      href="//cdn.hstatic.net/themes/200000846175/1001403720/14/styles-new.scss.css?v=245"
      rel="stylesheet"
      type="text/css"
    />

    <style>
      :root {
        --primary: #c99366;
        --primary-dark: #aa6a3f;
        --primary-light: #e8d5c4;
        --brown-main: #3c2922;
        --brown-soft: #6c5845;
        --bg-light: #faf5ef;
        --bg-cream: #fff9f5;
        --white: #ffffff;
        --border-color: #e8ddd4;
        --text-muted: #8b7d72;
        --success: #27ae60;
        --success-light: #d4edda;
        --shadow-md: 0 8px 24px rgba(60, 41, 34, 0.1);
        --shadow-lg: 0 16px 48px rgba(60, 41, 34, 0.15);
        --radius-md: 16px;
        --radius-lg: 24px;
        --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        --height-head: 72px;
      }

      /* Font Awesome fix */
      .fas,
      .far,
      .fab,
      .fa {
        font-family: "Font Awesome 6 Free" !important;
        font-weight: 900;
      }
      .far {
        font-weight: 400;
      }
      .fab {
        font-family: "Font Awesome 6 Brands" !important;
      }
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }
      body {
        font-family: "Inter", -apple-system, BlinkMacSystemFont, "Segoe UI",
          sans-serif;
        background: linear-gradient(
          135deg,
          var(--bg-light) 0%,
          var(--bg-cream) 100%
        );
        color: var(--brown-main);
        line-height: 1.6;
        min-height: 100vh;
      }
      .success-container {
        max-width: 700px;
        margin: 0 auto;
        padding: 2rem;
        margin-top: calc(var(--height-head) + 40px);
        margin-bottom: 40px;
      }

      .success-card {
        background: var(--white);
        border-radius: var(--radius-lg);
        box-shadow: var(--shadow-lg);
        overflow: hidden;
        text-align: center;
      }
      /* Success Header */
      .success-header {
        background: linear-gradient(135deg, var(--success) 0%, #2ecc71 100%);
        padding: 3rem 2rem;
        color: white;
      }
      .success-icon {
        width: 100px;
        height: 100px;
        background: rgba(255, 255, 255, 0.2);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 1.5rem;
        animation: scaleIn 0.5s ease;
      }
      .success-icon i {
        font-size: 3rem;
        animation: checkmark 0.5s ease 0.3s both;
      }
      @keyframes scaleIn {
        from {
          transform: scale(0);
          opacity: 0;
        }
        to {
          transform: scale(1);
          opacity: 1;
        }
      }

      @keyframes checkmark {
        from {
          transform: scale(0) rotate(-45deg);
          opacity: 0;
        }
        to {
          transform: scale(1) rotate(0);
          opacity: 1;
        }
      }

      .success-header h1 {
        font-family: "Playfair Display", serif;
        font-size: 2rem;
        margin-bottom: 0.5rem;
      }

      .success-header p {
        opacity: 0.9;
        font-size: 1rem;
      }

      /* Order Info */
      .order-info {
        padding: 2rem;
      }

      .order-code {
        background: var(--bg-light);
        border-radius: var(--radius-md);
        padding: 1.5rem;
        margin-bottom: 1.5rem;
      }

      .order-code-label {
        font-size: 0.9rem;
        color: var(--text-muted);
        margin-bottom: 0.5rem;
      }

      .order-code-value {
        font-family: "Crimson Text", serif;
        font-size: 1.75rem;
        font-weight: 700;
        color: var(--primary-dark);
        letter-spacing: 2px;
      }

      .order-details {
        text-align: left;
        border-top: 1px solid var(--border-color);
        padding-top: 1.5rem;
      }

      .detail-row {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        padding: 0.75rem 0;
        border-bottom: 1px dashed var(--border-color);
      }

      .detail-row:last-child {
        border-bottom: none;
      }

      .detail-label {
        color: var(--text-muted);
        font-size: 0.9rem;
      }

      .detail-value {
        font-weight: 500;
        text-align: right;
        max-width: 60%;
      }

      .detail-value.total {
        font-size: 1.25rem;
        color: var(--primary-dark);
        font-weight: 700;
      }

      /* Status Timeline */
      .status-timeline {
        display: flex;
        justify-content: space-between;
        padding: 2rem;
        background: var(--bg-light);
        margin-top: 1rem;
      }

      .timeline-step {
        display: flex;
        flex-direction: column;
        align-items: center;
        flex: 1;
        position: relative;
      }

      .timeline-step:not(:last-child)::after {
        content: "";
        position: absolute;
        top: 20px;
        left: 60%;
        width: 80%;
        height: 2px;
        background: var(--border-color);
      }

      .timeline-step.active:not(:last-child)::after {
        background: var(--success);
      }

      .step-icon {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: var(--border-color);
        color: var(--text-muted);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1rem;
        margin-bottom: 0.5rem;
        position: relative;
        z-index: 1;
      }

      .timeline-step.active .step-icon {
        background: var(--success);
        color: white;
      }

      .timeline-step.upcoming .step-icon {
        background: white;
        border: 2px solid var(--border-color);
      }

      .step-label {
        font-size: 0.75rem;
        color: var(--text-muted);
        text-align: center;
      }

      .timeline-step.active .step-label {
        color: var(--success);
        font-weight: 600;
      }

      /* Actions */
      .success-actions {
        padding: 0 2rem 2rem;
        display: flex;
        gap: 1rem;
        flex-wrap: wrap;
      }

      .btn {
        flex: 1;
        min-width: 200px;
        padding: 1rem 1.5rem;
        border-radius: 12px;
        font-weight: 600;
        font-size: 0.95rem;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
        transition: var(--transition);
        cursor: pointer;
        border: none;
      }

      .btn-primary {
        background: linear-gradient(
          135deg,
          var(--primary) 0%,
          var(--primary-dark) 100%
        );
        color: white;
      }

      .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(201, 147, 102, 0.4);
      }

      .btn-outline {
        background: white;
        border: 2px solid var(--border-color);
        color: var(--brown-main);
      }

      .btn-outline:hover {
        border-color: var(--primary);
        color: var(--primary);
      }

      /* Note */
      .success-note {
        padding: 1.5rem 2rem;
        background: rgba(201, 147, 102, 0.1);
        border-top: 1px solid var(--border-color);
      }

      .note-title {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        font-weight: 600;
        color: var(--primary-dark);
        margin-bottom: 0.75rem;
      }

      .note-content {
        font-size: 0.9rem;
        color: var(--brown-soft);
        line-height: 1.7;
      }

      .note-content p {
        margin-bottom: 0.5rem;
      }

      /* Confetti Animation */
      .confetti {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        pointer-events: none;
        z-index: 1000;
        overflow: hidden;
      }

      .confetti-piece {
        position: absolute;
        width: 10px;
        height: 10px;
        animation: confetti-fall 3s ease-out forwards;
      }

      @keyframes confetti-fall {
        0% {
          transform: translateY(-100vh) rotate(0deg);
          opacity: 1;
        }
        100% {
          transform: translateY(100vh) rotate(720deg);
          opacity: 0;
        }
      }

      /* Responsive */
      @media (max-width: 576px) {
        .success-container {
          padding: 1rem;
          margin-top: calc(var(--height-head) + 20px);
        }

        .success-header {
          padding: 2rem 1.5rem;
        }

        .success-header h1 {
          font-size: 1.5rem;
        }

        .order-code-value {
          font-size: 1.5rem;
        }

        .status-timeline {
          padding: 1.5rem 1rem;
        }

        .step-label {
          font-size: 0.7rem;
        }

        .success-actions {
          flex-direction: column;
        }

        .btn {
          min-width: auto;
        }
      }
    </style>
  </head>
  <body>
    <!-- Header -->
    <%@ include file="partials/header.jsp" %>

    <!-- Confetti -->
    <div class="confetti" id="confetti"></div>

    <div class="success-container">
      <div class="success-card">
        <!-- Success Header -->
        <div class="success-header">
          <div class="success-icon">
            <i class="fas fa-check"></i>
          </div>
          <h1>
            <c:choose>
              <c:when test="${param.payment == 'success'}">
                Thanh toán thành công!
              </c:when>
              <c:otherwise>
                Đặt hàng thành công!
              </c:otherwise>
            </c:choose>
          </h1>
          <p>
            <c:choose>
              <c:when test="${param.payment == 'success'}">
                Đơn hàng của bạn đã được thanh toán và xác nhận thành công
              </c:when>
              <c:otherwise>
                Cảm ơn bạn đã tin tưởng Tiệm Hoa nhà tớ
              </c:otherwise>
            </c:choose>
          </p>
        </div>

        <!-- Order Info -->
        <div class="order-info">
          <div class="order-code">
            <div class="order-code-label">Mã đơn hàng của bạn</div>
            <div class="order-code-value" id="orderCodeValue">
              ${not empty param.orderCode ? param.orderCode : 'Đang tạo...'}
            </div>
          </div>

          <div class="order-details">
            <c:if test="${not empty order}">
              <div class="detail-row">
                <span class="detail-label">Người nhận</span>
                <span class="detail-value">${order.receiverName}</span>
              </div>
              <div class="detail-row">
                <span class="detail-label">Số điện thoại</span>
                <span class="detail-value">${order.receiverPhone}</span>
              </div>
              <div class="detail-row">
                <span class="detail-label">Địa chỉ giao hàng</span>
                <span class="detail-value">${order.shippingAddress}</span>
              </div>
              <div class="detail-row">
                <span class="detail-label">Phương thức thanh toán</span>
                <span class="detail-value">${order.paymentMethodText}</span>
              </div>
              <c:if test="${param.payment == 'success'}">
                <div class="detail-row">
                  <span class="detail-label">Trạng thái thanh toán</span>
                  <span class="detail-value" style="color: var(--success); font-weight: 600;">
                    <i class="fas fa-check-circle"></i> Đã thanh toán
                  </span>
                </div>
              </c:if>
              <div class="detail-row">
                <span class="detail-label">Tổng tiền</span>
                <span class="detail-value total">
                  <fmt:formatNumber
                    value="${order.total}"
                    type="number"
                    groupingUsed="true"
                  />₫
                </span>
              </div>
            </c:if>
            <c:if test="${empty order}">
              <div class="detail-row">
                <span class="detail-label">Trạng thái</span>
                <span class="detail-value" style="color: var(--success)">
                  <i class="fas fa-check-circle"></i> Đã xác nhận
                </span>
              </div>
              <div class="detail-row">
                <span class="detail-label">Dự kiến giao hàng</span>
                <span class="detail-value">2-3 ngày làm việc</span>
              </div>
            </c:if>
          </div>
        </div>

        <!-- Status Timeline -->
        <div class="status-timeline">
          <div class="timeline-step active">
            <div class="step-icon">
              <i class="fas fa-clipboard-check"></i>
            </div>
            <span class="step-label">Đã đặt hàng</span>
          </div>
          <div class="timeline-step upcoming">
            <div class="step-icon">
              <i class="fas fa-box"></i>
            </div>
            <span class="step-label">Đang chuẩn bị</span>
          </div>
          <div class="timeline-step upcoming">
            <div class="step-icon">
              <i class="fas fa-truck"></i>
            </div>
            <span class="step-label">Đang giao hàng</span>
          </div>
          <div class="timeline-step upcoming">
            <div class="step-icon">
              <i class="fas fa-home"></i>
            </div>
            <span class="step-label">Đã giao hàng</span>
          </div>
        </div>

        <!-- Actions -->
        <div class="success-actions">
          <a
            href="${pageContext.request.contextPath}/view/settingProfile.jsp"
            class="btn btn-outline"
          >
            <i class="fas fa-history"></i>
            Xem đơn hàng
          </a>
          <a
            href="${pageContext.request.contextPath}/san-pham"
            class="btn btn-primary"
          >
            <i class="fas fa-shopping-bag"></i>
            Tiếp tục mua sắm
          </a>
        </div>

        <!-- Note -->
        <div class="success-note">
          <div class="note-title">
            <i class="fas fa-info-circle"></i>
            Lưu ý
          </div>
          <div class="note-content">
            <p>
              • Đơn hàng sẽ được xử lý trong vòng 24h (trừ Chủ nhật và ngày lễ)
            </p>
            <p>
              • Bạn sẽ nhận được email/SMS xác nhận khi đơn hàng được giao cho
              đơn vị vận chuyển
            </p>
            <p>
              • Nếu có bất kỳ thắc mắc nào, vui lòng liên hệ hotline:
              <strong>0921.45.06.20</strong>
            </p>
          </div>
        </div>
      </div>
    </div>

    <!-- Footer -->
    <%@ include file="partials/footer.jsp" %>

    <script>
      // Confetti effect
      function createConfetti() {
        const container = document.getElementById("confetti");
        const colors = [
          "#c99366",
          "#27ae60",
          "#f39c12",
          "#e74c3c",
          "#3498db",
          "#9b59b6",
        ];

        for (let i = 0; i < 100; i++) {
          setTimeout(() => {
            const piece = document.createElement("div");
            piece.className = "confetti-piece";
            piece.style.left = Math.random() * 100 + "vw";
            piece.style.background =
              colors[Math.floor(Math.random() * colors.length)];
            piece.style.animationDuration = Math.random() * 2 + 2 + "s";
            piece.style.animationDelay = Math.random() * 0.5 + "s";

            if (Math.random() > 0.5) {
              piece.style.borderRadius = "50%";
            }

            container.appendChild(piece);

            setTimeout(() => {
              piece.remove();
            }, 4000);
          }, i * 30);
        }
      }

      // Run confetti on page load
      document.addEventListener("DOMContentLoaded", createConfetti);
    </script>
  </body>
</html>
