<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Liên hệ - Tiệm Hoa nhà tớ</title>

    <meta name="csrf-token" content="${csrfToken}">
    <script>window.csrfToken = '${csrfToken}';</script>

    <link rel="shortcut icon" href="../img/logo.png" type="image/x-icon" />

    <link
      href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Inter:wght@300;400;500;600&family=Crimson+Text:wght@400;600;700&display=swap"
      rel="stylesheet"
    />

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
    <link
      href="//cdn.hstatic.net/themes/200000846175/1001403720/14/styles-index.scss.css?v=245"
      rel="stylesheet"
      type="text/css"
    />

    <%@ include file="partials/head-icons.jsp" %>

    <link href="https://cdn.jsdelivr.net/npm/aos@2.3.1/dist/aos.css" rel="stylesheet" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
      localStorage.setItem("shop_id", "themes/200000846175/1001403720");
      const tbag_varible = {
        template: "page",
        navLeftText:
          '<button class="slick-prev slick-arrow custom-style" aria-label="Previous"><span class="arrow-custom arrow-left"><div class="arrow-top"></div><div class="arrow-bottom"></div></span></button>',
        navRightText:
          '<button class="slick-next slick-arrow custom-style" aria-label="Next"><span class="arrow-custom arrow-right"><div class="arrow-top"></div><div class="arrow-bottom"></div></span></button>',
        checklocation: "false",
        checkproducthot: "true",
        checkproductrelated: "true",
        checkproductseen: "false",
        heartactive:
          "//cdn.hstatic.net/themes/200000846175/1001403720/14/heart-fill.svg?v=245",
        addtocart:
          "//cdn.hstatic.net/themes/200000846175/1001403720/14/add-to-cart.svg?v=245",
        heart:
          "//cdn.hstatic.net/themes/200000846175/1001403720/14/heart.svg?v=245",
        trash:
          "//cdn.hstatic.net/themes/200000846175/1001403720/14/trash.svg?v=245",
        cancel:
          "//cdn.hstatic.net/themes/200000846175/1001403720/14/cancel.svg?v=245",
      };
      if (typeof Haravan === "undefined") {
        Haravan = {};
      }
      Haravan.shop = "tiemhoanhato.site";
    </script>

    <style>
      :root {
        --primary: #c99366;
        --primary-dark: #aa6a3f;
        --primary-light: #e8d4c4;
        --brown-main: #3c2922;
        --brown-soft: #6c5845;
        --bg-light: #faf5ef;
        --bg-cream: #fff9f4;
        --white: #ffffff;
        --shadow-sm: 0 2px 8px rgba(0, 0, 0, 0.06);
        --shadow-md: 0 8px 30px rgba(0, 0, 0, 0.08);
        --shadow-lg: 0 15px 50px rgba(0, 0, 0, 0.12);
        --radius-sm: 12px;
        --radius-md: 20px;
        --radius-lg: 30px;
      }

      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        font-family: "Inter", -apple-system, BlinkMacSystemFont, sans-serif;
        background: var(--bg-light);
        color: var(--brown-main);
        line-height: 1.7;
      }

      /* ===== HERO SECTION ===== */
      .contact-hero {
        position: relative;
         background: linear-gradient(
            135deg,
            rgba(201, 147, 102, 0.95) 0%,
            rgba(170, 106, 63, 0.95) 100%
          ),
          url("https://images.unsplash.com/photo-1487070183336-b863922373d4?w=1200")
            center/cover;
        padding: 100px 20px 140px;
        text-align: center;
        overflow: hidden;
      }

      .contact-hero::before {
        content: "";
        position: absolute;
        top: -100px;
        right: -100px;
        width: 400px;
        height: 400px;
        background: radial-gradient(
          circle,
          rgba(255, 255, 255, 0.15) 0%,
          transparent 70%
        );
        border-radius: 50%;
        animation: float 6s ease-in-out infinite;
      }

      .contact-hero::after {
        content: "";
        position: absolute;
        bottom: -80px;
        left: -50px;
        width: 300px;
        height: 300px;
        background: radial-gradient(
          circle,
          rgba(255, 255, 255, 0.1) 0%,
          transparent 70%
        );
        border-radius: 50%;
        animation: float 8s ease-in-out infinite reverse;
      }

      @keyframes float {
        0%,
        100% {
          transform: translateY(0px);
        }
        50% {
          transform: translateY(-20px);
        }
      }

      .hero-content {
        position: relative;
        z-index: 2;
        max-width: 700px;
        margin: 0 auto;
      }

      .contact-hero h1 {
        font-family: "Playfair Display", serif;
        font-size: 3.5rem;
        font-weight: 700;
        color: #fff;
        margin-bottom: 16px;
        text-shadow: 0 2px 20px rgba(0, 0, 0, 0.1);
      }

      .contact-hero p {
        font-size: 1.2rem;
        color: rgba(255, 255, 255, 0.95);
        font-weight: 300;
        max-width: 500px;
        margin: 0 auto;
      }

      /* ===== MAIN CONTAINER ===== */
      .contact-main {
        max-width: 1200px;
        margin: -80px auto 60px;
        padding: 0 20px;
        position: relative;
        z-index: 10;
      }

      .contact-grid {
        display: grid;
        grid-template-columns: 1.3fr 1fr;
        gap: 30px;
      }

      @media (max-width: 968px) {
        .contact-grid {
          grid-template-columns: 1fr;
        }
      }

      /* ===== FORM CARD ===== */
      .contact-form-card {
        background: var(--white);
        border-radius: var(--radius-md);
        padding: 45px;
        box-shadow: var(--shadow-lg);
      }

      .card-header {
        margin-bottom: 32px;
      }

      .card-header h2 {
        font-family: "Playfair Display", serif;
        font-size: 1.9rem;
        color: var(--brown-main);
        margin-bottom: 10px;
      }

      .card-header p {
        color: var(--brown-soft);
        font-size: 1rem;
      }

      .form-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
        margin-bottom: 20px;
      }

      @media (max-width: 600px) {
        .form-row {
          grid-template-columns: 1fr;
        }
      }

      .form-group {
        margin-bottom: 22px;
      }

      .form-group label {
        display: block;
        font-size: 0.95rem;
        font-weight: 600;
        color: var(--brown-main);
        margin-bottom: 10px;
      }

      .form-group label .required {
        color: #e74c3c;
        margin-left: 2px;
      }

      .form-control {
        width: 100%;
        padding: 15px 20px;
        border: 2px solid #e8ddd4;
        border-radius: var(--radius-sm);
        font-size: 1rem;
        font-family: inherit;
        transition: all 0.3s ease;
        background: var(--bg-cream);
      }

      .form-control:focus {
        outline: none;
        border-color: var(--primary);
        background: var(--white);
        box-shadow: 0 0 0 4px rgba(201, 147, 102, 0.15);
      }

      .form-control::placeholder {
        color: #b5a99a;
      }

      textarea.form-control {
        min-height: 150px;
        resize: vertical;
      }

      select.form-control {
        cursor: pointer;
        appearance: none;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%236c5845' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: right 18px center;
        padding-right: 45px;
      }

      .submit-btn {
        width: 100%;
        padding: 18px 36px;
        background: linear-gradient(
          135deg,
          var(--primary) 0%,
          var(--primary-dark) 100%
        );
        color: #fff;
        border: none;
        border-radius: var(--radius-sm);
        font-size: 1.05rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 12px;
        box-shadow: 0 10px 30px rgba(170, 106, 63, 0.35);
        margin-top: 10px;
      }

      .submit-btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 15px 40px rgba(170, 106, 63, 0.45);
      }

      .submit-btn:active {
        transform: translateY(-1px);
      }

      .submit-btn i {
        font-size: 1.2rem;
        transition: transform 0.3s;
      }

      .submit-btn:hover i {
        transform: translateX(5px);
      }

      /* ===== INFO CARDS ===== */
      .contact-info-card {
        display: flex;
        flex-direction: column;
        gap: 24px;
      }

      .info-box {
        background: linear-gradient(135deg, #fff9f4 0%, #fff 100%);
        border-radius: var(--radius-md);
        padding: 32px;
        box-shadow: var(--shadow-md);
        border: 1px solid rgba(201, 147, 102, 0.15);
        transition: transform 0.3s ease;
      }

      .info-box:hover {
        transform: translateY(-5px);
      }

      .info-box.highlight {
        background: linear-gradient(
          135deg,
          var(--primary) 0%,
          var(--primary-dark) 100%
        );
        color: #fff;
        border: none;
      }

      .info-box.highlight .info-title,
      .info-box.highlight .info-text,
      .info-box.highlight .info-label {
        color: #fff;
      }

      .info-box.highlight .info-icon {
        background: rgba(255, 255, 255, 0.2);
        color: #fff;
      }

      .info-title {
        font-family: "Playfair Display", serif;
        font-size: 1.4rem;
        color: var(--brown-main);
        margin-bottom: 24px;
        display: flex;
        align-items: center;
        gap: 12px;
      }

      .info-title i {
        color: var(--primary);
        font-size: 1.3rem;
      }

      .info-box.highlight .info-title i {
        color: #fff;
      }

      .info-item {
        display: flex;
        align-items: flex-start;
        gap: 16px;
        margin-bottom: 20px;
      }

      .info-item:last-child {
        margin-bottom: 0;
      }

      .info-icon {
        width: 50px;
        height: 50px;
        border-radius: 14px;
        background: var(--primary-light);
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--primary-dark);
        font-size: 1.3rem;
        flex-shrink: 0;
      }

      .info-content {
        flex: 1;
      }

      .info-label {
        font-size: 0.8rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1.2px;
        color: var(--brown-soft);
        margin-bottom: 5px;
      }

      .info-text {
        font-size: 1.05rem;
        color: var(--brown-main);
        font-weight: 500;
      }

      .info-text a {
        color: inherit;
        text-decoration: none;
        transition: color 0.3s;
      }

      .info-text a:hover {
        color: var(--primary);
      }

      .info-note {
        font-size: 0.9rem;
        color: var(--brown-soft);
        margin-top: 5px;
      }

      .urgent-badge {
        margin-top: 20px;
        padding: 14px 20px;
        background: rgba(255, 255, 255, 0.15);
        border-radius: 12px;
        font-size: 0.95rem;
        display: flex;
        align-items: center;
        gap: 10px;
      }

      .urgent-badge i {
        font-size: 1.2rem;
        color: #ffd700;
      }

      /* Social Links */
      .social-section {
        margin-top: 24px;
        padding-top: 24px;
        border-top: 1px dashed #e8ddd4;
      }

      .social-section .info-label {
        margin-bottom: 16px;
      }

      .social-links {
        display: flex;
        gap: 14px;
        flex-wrap: wrap;
      }

      .social-link {
        width: 50px;
        height: 50px;
        border-radius: 14px;
        background: var(--white);
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--brown-main);
        font-size: 1.4rem;
        transition: all 0.3s ease;
        box-shadow: var(--shadow-sm);
        text-decoration: none;
      }

      .social-link:hover {
        background: var(--primary);
        color: #fff;
        transform: translateY(-4px);
        box-shadow: 0 8px 20px rgba(170, 106, 63, 0.3);
      }

      .social-link.facebook:hover {
        background: #1877f2;
      }
      .social-link.instagram:hover {
        background: linear-gradient(
          45deg,
          #f09433,
          #e6683c,
          #dc2743,
          #cc2366,
          #bc1888
        );
      }
      .social-link.zalo:hover {
        background: #0068ff;
      }
      .social-link.tiktok:hover {
        background: #000;
      }

      /* ===== MAP SECTION ===== */
      .map-section {
        max-width: 1200px;
        margin: 0 auto 60px;
        padding: 0 20px;
      }

      .map-card {
        background: var(--white);
        border-radius: var(--radius-md);
        overflow: hidden;
        box-shadow: var(--shadow-md);
      }

      .map-header {
        padding: 28px 35px;
        border-bottom: 1px solid #f0e6dd;
        display: flex;
        align-items: center;
        justify-content: space-between;
        flex-wrap: wrap;
        gap: 15px;
      }

      .map-header h3 {
        font-family: "Playfair Display", serif;
        font-size: 1.5rem;
        color: var(--brown-main);
        display: flex;
        align-items: center;
        gap: 12px;
      }

      .map-header h3 i {
        color: var(--primary);
      }

      .map-direction-btn {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 12px 24px;
        background: var(--primary-light);
        color: var(--primary-dark);
        border-radius: 50px;
        font-size: 0.95rem;
        font-weight: 600;
        text-decoration: none;
        transition: all 0.3s;
      }

      .map-direction-btn:hover {
        background: var(--primary);
        color: #fff;
      }

      .map-container {
        height: 400px;
      }

      .map-container iframe {
        width: 100%;
        height: 100%;
        border: none;
      }

      /* ===== FEATURES SECTION ===== */
      .features-section {
        max-width: 1200px;
        margin: 0 auto 60px;
        padding: 0 20px;
      }

      .features-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 24px;
      }

      @media (max-width: 968px) {
        .features-grid {
          grid-template-columns: repeat(2, 1fr);
        }
      }

      @media (max-width: 500px) {
        .features-grid {
          grid-template-columns: 1fr;
        }
      }

      .feature-item {
        background: var(--white);
        border-radius: var(--radius-md);
        padding: 30px 24px;
        text-align: center;
        box-shadow: var(--shadow-sm);
        transition: all 0.3s;
      }

      .feature-item:hover {
        transform: translateY(-8px);
        box-shadow: var(--shadow-md);
      }

      .feature-icon {
        width: 70px;
        height: 70px;
        border-radius: 50%;
        background: linear-gradient(135deg, var(--primary-light), #fff);
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 18px;
        font-size: 1.8rem;
        color: var(--primary-dark);
      }

      .feature-item h4 {
        font-family: "Playfair Display", serif;
        font-size: 1.1rem;
        color: var(--brown-main);
        margin-bottom: 8px;
      }

      .feature-item p {
        font-size: 0.9rem;
        color: var(--brown-soft);
      }

      /* ===== RESPONSIVE ===== */
      @media (max-width: 768px) {
        .contact-hero {
          padding: 80px 20px 120px;
        }

        .contact-hero h1 {
          font-size: 2.5rem;
        }

        .contact-form-card {
          padding: 30px 25px;
        }

        .info-box {
          padding: 25px;
        }

        .map-container {
          height: 300px;
        }
      }

      /* ===== ANIMATIONS ===== */
      @keyframes fadeInUp {
        from {
          opacity: 0;
          transform: translateY(30px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }
    </style>

    <script src="${pageContext.request.contextPath}/js/csrf-helper.js"></script>

    <!-- SweetAlert2 CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.5/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.5/dist/sweetalert2.all.min.js"></script>

    <!-- Notification System Utility -->
    <script src="${pageContext.request.contextPath}/js/notification.js?v=20260527"></script>
  </head>

  <body id="wandave-theme" class="index" data-theme="tbag-fashion">

    <nav id="menu-mobile" class="hidden-md">
      <button
        id="wanda-close-handle"
        class="wanda-close-handle"
        aria-label="Đóng"
        title="Đóng"
      >
        <span class="mb-menu-cls" aria-hidden="true"
          ><span class="bar animate"></span></span
        >Đóng
      </button>
      <ul class="mb-menu"></ul>
      <ul class="list-lang">
        <li class="btn-language-vi" title="Vietnamese">
          <a
            href="#"
            onclick="doGTranslate('vi|vi');return false;"
            title=""
            class="lang-vi gflag vietnam nturl"
          >
            <img
              src="//gtranslate.net/flags/blank.png"
              height="24"
              width="24"
              alt="Vietnamese"
            />
          </a>
        </li>
        <li class="btn-language-en" title="English">
          <a
            href="#"
            onclick="doGTranslate('vi|en');return false;"
            title=""
            class="lang-en gflag nturl"
          >
            <img
              src="//gtranslate.net/flags/blank.png"
              height="24"
              width="24"
              alt="English"
            />
          </a>
        </li>
        <li class="btn-language-ko" title="Korean">
          <a
            href="#"
            onclick="doGTranslate('vi|ko');return false;"
            title=""
            class="lang-ko gflag nturl"
          >
            <img
              src="//gtranslate.net/flags/blank.png"
              height="24"
              width="24"
              alt="Korean"
            />
          </a>
        </li>
      </ul>
    </nav>

    <div id="site-overlay" class="site-overlay active"></div>

    <%@ include file="partials/header.jsp" %>

    <section class="contact-hero">
      <div class="hero-content" data-aos="fade-up">
        <h1>Liên hệ với chúng tớ</h1>
        <p>Hãy để tụi mình chuẩn bị thật chỉn chu bó hoa dành cho bạn nhé!</p>
      </div>
    </section>

    <main class="contact-main">
      <div class="contact-grid">

        <div class="contact-form-card" data-aos="fade-up" data-aos-delay="100">
          <div class="card-header">
            <h2>Gửi lời nhắn cho Tiệm</h2>
            <p>
              Điền thông tin bên dưới, tụi mình sẽ liên hệ lại sớm nhất có thể!
            </p>
          </div>

          <form
            id="contactForm"
            method="post"
            action="${pageContext.request.contextPath}/contact"
            onsubmit="return false;"
          >
            <div class="form-row">
              <div class="form-group">
                <label>Họ và tên <span class="required">*</span></label>
                <input
                  type="text"
                  class="form-control"
                  name="name"
                  id="contactName"
                  placeholder="Nhập tên của bạn"
                  required
                />
              </div>
              <div class="form-group">
                <label>Số điện thoại <span class="required">*</span></label>
                <input
                  type="tel"
                  class="form-control"
                  name="phone"
                  placeholder="0123 456 789"
                  required
                />
              </div>
            </div>

            <div class="form-row">
              <div class="form-group">
                <label>Email</label>
                <input
                  type="email"
                  class="form-control"
                  name="email"
                  placeholder="example@gmail.com"
                />
              </div>
              <div class="form-group">
                <label>Chủ đề</label>
                <select class="form-control" name="subject">
                  <option value="">-- Chọn chủ đề --</option>
                  <option value="order">Đặt hoa theo yêu cầu</option>
                  <option value="consult">Tư vấn tone màu / concept</option>
                  <option value="event">Hoa khai trương - sự kiện</option>
                  <option value="wedding">Hoa cưới</option>
                  <option value="partner">Hợp tác / đối tác</option>
                  <option value="other">Khác</option>
                </select>
              </div>
            </div>

            <div class="form-group">
              <label>Lời nhắn <span class="required">*</span></label>
              <textarea
                class="form-control"
                name="message"
                placeholder="Nội dung bạn muốn tư vấn: tone màu yêu thích, ngân sách dự kiến, thời gian giao, địa chỉ giao hàng..."
                required
              ></textarea>
            </div>

            <button type="button" id="contactSubmitBtn" class="submit-btn" data-original="Gửi liên hệ">
              Gửi liên hệ
              <i class="bi bi-arrow-right"></i>
            </button>
          </form>
        </div>

        <div class="contact-info-card">

          <div
            class="info-box highlight"
            data-aos="fade-up"
            data-aos-delay="200"
          >
            <div class="info-title">
              <i class="bi bi-clock-fill"></i>
              Giờ làm việc
            </div>
            <div class="info-item">
              <div class="info-content">
                <div
                  class="info-text"
                  style="font-size: 1.5rem; font-weight: 600"
                >
                  07:30 - 21:00
                </div>
                <div
                  class="info-note"
                  style="color: rgba(255, 255, 255, 0.85); margin-top: 8px"
                >
                  Thứ 2 - Chủ nhật (kể cả ngày lễ)
                </div>
              </div>
            </div>
            <div class="urgent-badge">
              <i class="bi bi-lightning-charge-fill"></i>
              <span>Nhận đơn gấp & giao trong ngày!</span>
            </div>
          </div>

          <div class="info-box" data-aos="fade-up" data-aos-delay="300">
            <div class="info-title">
              <i class="bi bi-info-circle-fill"></i>
              Thông tin liên hệ
            </div>

            <div class="info-item">
              <div class="info-icon">
                <i class="bi bi-geo-alt-fill"></i>
              </div>
              <div class="info-content">
                <div class="info-label">Địa chỉ</div>
                <div class="info-text">
                  11A Nguyễn An, Thạnh Mỹ Lợi, TP. Thủ Đức, TP.HCM
                </div>
              </div>
            </div>

            <div class="info-item">
              <div class="info-icon">
                <i class="bi bi-telephone-fill"></i>
              </div>
              <div class="info-content">
                <div class="info-label">Hotline & Zalo</div>
                <div class="info-text">
                  <a href="tel:0919897969">0919 897 969</a>
                </div>
              </div>
            </div>

            <div class="info-item">
              <div class="info-icon">
                <i class="bi bi-envelope-fill"></i>
              </div>
              <div class="info-content">
                <div class="info-label">Email</div>
                <div class="info-text">
                  <a href="mailto:tiemhoanhato@gmail.com"
                    >tiemhoanhato@gmail.com</a
                  >
                </div>
              </div>
            </div>

            <div class="social-section">
              <div class="info-label">Kết nối với chúng tớ</div>
              <div class="social-links">
                <a
                  href="https://www.facebook.com/"
                  class="social-link facebook"
                  title="Facebook"
                  target="_blank"
                >
                  <i class="bi bi-facebook"></i>
                </a>
                <a
                  href="https://www.instagram.com/"
                  class="social-link instagram"
                  title="Instagram"
                  target="_blank"
                >
                  <i class="bi bi-instagram"></i>
                </a>
                <a
                  href="https://zalo.me/0919897969"
                  class="social-link zalo"
                  title="Zalo"
                  target="_blank"
                >
                  <i class="bi bi-chat-dots-fill"></i>
                </a>
                <a
                  href="https://www.tiktok.com/"
                  class="social-link tiktok"
                  title="TikTok"
                  target="_blank"
                >
                  <i class="bi bi-tiktok"></i>
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>

    <section class="features-section" data-aos="fade-up" data-aos-delay="100">
      <div class="features-grid">
        <div class="feature-item">
          <div class="feature-icon">
            <i class="bi bi-truck"></i>
          </div>
          <h4>Giao hàng nhanh</h4>
          <p>Giao hoa tận nơi trong 2h tại TP.HCM</p>
        </div>
        <div class="feature-item">
          <div class="feature-icon">
            <i class="bi bi-flower2"></i>
          </div>
          <h4>Hoa tươi 100%</h4>
          <p>Cam kết hoa tươi, đẹp như hình</p>
        </div>
        <div class="feature-item">
          <div class="feature-icon">
            <i class="bi bi-palette"></i>
          </div>
          <h4>Thiết kế riêng</h4>
          <p>Tư vấn & thiết kế theo yêu cầu</p>
        </div>
        <div class="feature-item">
          <div class="feature-icon">
            <i class="bi bi-shield-check"></i>
          </div>
          <h4>Đảm bảo chất lượng</h4>
          <p>Đổi trả nếu không hài lòng</p>
        </div>
      </div>
    </section>

    <section class="map-section" data-aos="fade-up" data-aos-delay="200">
      <div class="map-card">
        <div class="map-header">
          <h3><i class="bi bi-pin-map-fill"></i> Tìm đường đến Tiệm</h3>
          <a
            href="https://maps.google.com/?q=11A+Nguyen+An+Thanh+My+Loi+Thu+Duc"
            target="_blank"
            class="map-direction-btn"
          >
            <i class="bi bi-cursor-fill"></i>
            Chỉ đường
          </a>
        </div>
        <div class="map-container">
          <iframe
            src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3919.2!2d106.76!3d10.79!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2zMTDCsDQ3JzI0LjAiTiAxMDbCsDQ1JzM2LjAiRQ!5e0!3m2!1svi!2s!4v1703664000000!5m2!1svi!2s"
            allowfullscreen=""
            loading="lazy"
            referrerpolicy="no-referrer-when-downgrade"
          >
          </iframe>
        </div>
      </div>
    </section>

    <%@ include file="partials/footer.jsp" %>

    <script
      type="text/javascript"
      src="//cdn.hstatic.net/themes/200000846175/1001403720/14/pluginscript.js?v=245"
      defer
    ></script>
    <script
      type="text/javascript"
      src="//cdn.hstatic.net/themes/200000846175/1001403720/14/main-scripts.js?v=245"
      defer
    ></script>

    <script src="https://cdn.jsdelivr.net/npm/aos@2.3.1/dist/aos.js"></script>
    <script>
      // Initialize AOS
      AOS.init({
        duration: 800,
        once: true,
        offset: 50,
        easing: "ease-out-cubic",
      });

      // Form submission with AJAX (wrapped to avoid errors preventing handler)
      document.addEventListener('DOMContentLoaded', function () {
        try {
          const contactForm = document.getElementById('contactForm');
          if (!contactForm) return;

          // Ensure button triggers our AJAX flow instead of native submit
          const contactBtn = document.getElementById('contactSubmitBtn');
          if (contactBtn) {
            contactBtn.addEventListener('click', function (ev) {
              ev.preventDefault();
              contactForm.dispatchEvent(new Event('submit', { cancelable: true }));
            });
          }

          contactForm.addEventListener('submit', async function (e) {
            e.preventDefault();
            try {
              const btn = this.querySelector('.submit-btn');

      // Map iframe fallback: show link if iframe doesn't load in time
      document.addEventListener('DOMContentLoaded', function () {
        try {
          const mapContainer = document.querySelector('.map-container');
          if (!mapContainer) return;
          const iframe = mapContainer.querySelector('iframe');
          if (!iframe) return;

          let loaded = false;
          iframe.addEventListener('load', function () { loaded = true; });

          setTimeout(function () {
            if (!loaded) {
              // show fallback overlay with link
              const overlay = document.createElement('div');
              overlay.className = 'map-fallback-overlay';
              overlay.innerHTML = '<div class="map-fallback"><p>Google Maps không tải được.</p><a class="btn" target="_blank" href="https://maps.google.com/?q=11A+Nguyen+An+Thanh+My+Loi+Thu+Duc">Mở Google Maps</a></div>';
              mapContainer.appendChild(overlay);
            }
          }, 4000);
        } catch (err) {
          console.error('Map fallback handler error', err);
        }
      });
              const originalText = btn ? btn.innerHTML : '';
              if (btn) {
                btn.innerHTML = '<i class="bi bi-hourglass-split"></i> Đang gửi...';
                btn.disabled = true;
              }

              const formData = new FormData(this);
              const body = new URLSearchParams();
              for (const pair of formData.entries()) body.append(pair[0], pair[1]);

              const resp = await fetch('${pageContext.request.contextPath}/contact', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: body.toString(),
              });

              let data;
              try {
                data = await resp.json();
              } catch (err) {
                data = { success: false, message: 'Không nhận được phản hồi hợp lệ từ server' };
              }

              if (data && data.success) {
                showNotification(data.message || 'Gửi liên hệ thành công', 'success');
                this.reset();
              } else {
                showNotification(data.message || 'Có lỗi xảy ra', 'error');
              }
            } catch (err) {
              console.error('Contact submit error:', err);
              showNotification('Có lỗi xảy ra, vui lòng thử lại', 'error');
            } finally {
              const btn = this.querySelector('.submit-btn');
              if (btn) {
                btn.innerHTML = btn.getAttribute('data-original') || 'Gửi liên hệ';
                btn.disabled = false;
              }
            }
          });
        } catch (err) {
          console.error('Failed to attach contactForm handler:', err);
        }
      });

      // Notification function (synchronized to use the unified premium notification.js system)
      function showNotification(message, type) {
        if (type === 'success') {
          if (typeof showSuccess === 'function') {
            showSuccess(message, 'Liên hệ');
          } else {
            alert(message);
          }
        } else {
          if (typeof showError === 'function') {
            showError(message, 'Liên hệ');
          } else {
            alert(message);
          }
        }
      }
    </script>

    <style>
      .map-container { position: relative; }
      .map-fallback-overlay {
        position: absolute;
        inset: 0;
        display: flex;
        align-items: center;
        justify-content: center;
        background: rgba(245,245,245,0.95);
        border-radius: 12px;
        z-index: 5;
      }
      .map-fallback { text-align: center; }
      .map-fallback p { margin-bottom: 12px; color: #666; }
      .map-fallback .btn { background: var(--primary); color: #fff; padding: 10px 14px; border-radius: 8px; text-decoration: none; }
    </style>
  </body>
</html>
