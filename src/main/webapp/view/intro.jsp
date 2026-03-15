<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>

<html lang="vi">
  <head>
    <title>Giới thiệu</title>
    
    <!-- CSRF Token -->
    <meta name="csrf-token" content="${csrfToken}">
    <script>window.csrfToken = '${csrfToken}';</script>

    <!-- Google Tag Manager -->
    <script>
      (function (w, d, s, l, i) {
        w[l] = w[l] || [];
        w[l].push({
          "gtm.start": new Date().getTime(),
          event: "gtm.js",
        });
        var f = d.getElementsByTagName(s)[0],
          j = d.createElement(s),
          dl = l != "dataLayer" ? "&l=" + l : "";
        j.async = true;
        j.src = "https://www.googletagmanager.com/gtm.js?id=" + i + dl;
        f.parentNode.insertBefore(j, f);
      })(window, document, "script", "dataLayer", "GTM-W8R4GL2");
    </script>

    <!-- End Google Tag Manager -->

    <script>
      (function (w, d, s, l, i) {
        w[l] = w[l] || [];
        w[l].push({
          "gtm.start": new Date().getTime(),
          event: "gtm.js",
        });
        var f = d.getElementsByTagName(s)[0],
          j = d.createElement(s),
          dl = l != "dataLayer" ? "&l=" + l : "";
        j.async = true;
        j.src = "https://www.googletagmanager.com/gtm.js?id=" + i + dl;
        f.parentNode.insertBefore(j, f);
      })(window, document, "script", "dataLayer", "GTM-NSBT6HTK");
    </script>

    <meta charset="utf-8" />

    <link
      rel="shortcut icon"
      href="//cdn.hstatic.net/themes/200000846175/1001403720/14/favicon.png?v=245"
      type="image/x-icon"
    />

    <link
      rel="icon"
      href="//cdn.hstatic.net/themes/200000846175/1001403720/14/favicon.png?v=245"
      type="image/png"
    />

    <meta content="width=device-width,user-scalable=0" name="viewport" />

    <meta http-equiv="x-ua-compatible" content="ie=edge" />

    <meta name="HandheldFriendly" content="true" />

    <meta name="revisit-after" content="1 day" />

    <meta
      name="description"
      content="Khám phá câu chuyện về Tiệm Hoa nhà tớ. NÆ¡i cảm xúc nảy mầm và cuộc sống được tô điểm bằng những đóa hoa tươi đẹp."
    />

    <link rel="canonical" href="https://lavieestbelle.vn/pages/about-us" />

    <meta name="robots" content="index,follow,noodp" />

    <meta property="og:type" content="website" />

    <meta property="og:title" content="Giới thiệu" />

    <!-- Shop CSS Variables -->

    <style>
      :root {
        --bg-soldout: url(//cdn.hstatic.net/themes/200000846175/1001403720/14/hethang.png?v=245);

        --bgshop: #000000;

        --colorshop: #000000;

        --colorshophover: #212020;

        --bgfooter: #ffffff;

        --colorfooter: #000000;

        --colorbgmenumb: #ffffff;

        --colortextmenumb: #000000;

        --height-head: 72px;

        --bg-page: #faf5ef;

        --brown-main: #3c2922;

        --brown-soft: #6c5845;

        --accent: #c99366;

        --accent-dark: #aa6a3f;
      }
    </style>

    <!-- Modern About Page Styles -->

    <style>
      * {
        margin: 0;

        padding: 0;

        box-sizing: border-box;
      }

      body {
        font-family: "Crimson Text", -apple-system, BlinkMacSystemFont,
          "Segoe UI", sans-serif;

        background: var(--bg-page);

        color: var(--brown-main);

        line-height: 1.6;
      }

      /* Hero Section */

      .about-hero {
        position: relative;
        height: 60vh;
        min-height: 500px;
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
      }

      .hero-background {
        position: absolute;

        top: 0;

        left: 0;

        width: 100%;

        height: 100%;

        background: linear-gradient(
            135deg,
            rgba(201, 147, 102, 0.95) 0%,
            rgba(170, 106, 63, 0.95) 100%
          ),
          url("https://images.unsplash.com/photo-1487070183336-b863922373d4?w=1200")
            center/cover;

        z-index: 0;
      }

      .hero-pattern {
        position: absolute;

        top: 0;

        left: 0;

        width: 100%;

        height: 100%;

        background-image: radial-gradient(
            circle at 20% 50%,
            rgba(255, 255, 255, 0.1) 0%,
            transparent 50%
          ),
          radial-gradient(
            circle at 80% 80%,
            rgba(255, 255, 255, 0.08) 0%,
            transparent 50%
          );

        z-index: 1;
      }

      .hero-content {
        position: relative;

        z-index: 2;

        text-align: center;

        color: #fff;

        max-width: 800px;

        padding: 0 2rem;
      }

      .hero-subtitle {
        font-size: 1.1rem;

        letter-spacing: 3px;

        text-transform: uppercase;

        margin-bottom: 1rem;

        opacity: 0.95;

        font-weight: 500;
      }

      .hero-title {
        font-size: 4rem;

        font-weight: 700;

        margin-bottom: 1.5rem;

        letter-spacing: -0.02em;

        line-height: 1.2;
      }

      .hero-description {
        font-size: 1.35rem;

        opacity: 0.95;

        font-style: italic;

        line-height: 1.6;
      }

      /* Main Container */

      .about-container {
        max-width: 1200px;

        margin: 0 auto;

        padding: 0 2rem;
      }

      /* Story Section */

      .story-section {
        padding: 5rem 0;
      }

      .story-grid {
        display: grid;

        grid-template-columns: 1fr 1fr;

        gap: 4rem;

        align-items: center;
      }

      .story-image {
        position: relative;

        border-radius: 20px;

        overflow: hidden;

        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
      }

      .story-image img {
        width: 100%;

        height: 500px;

        object-fit: cover;

        display: block;

        transition: transform 0.6s ease;
      }

      .story-image:hover img {
        transform: scale(1.05);
      }

      .story-content h2 {
        font-size: 2.5rem;

        font-weight: 700;

        margin-bottom: 1.5rem;

        color: var(--brown-main);

        position: relative;

        padding-left: 1.5rem;
      }

      .story-content h2::before {
        content: "";

        position: absolute;

        left: 0;

        top: 0;

        width: 5px;

        height: 100%;

        background: linear-gradient(180deg, var(--accent), var(--accent-dark));

        border-radius: 10px;
      }

      .story-content p {
        font-size: 1.15rem;

        line-height: 1.8;

        margin-bottom: 1.5rem;

        color: var(--brown-soft);
      }

      .story-highlight {
        background: linear-gradient(
          135deg,
          rgba(201, 147, 102, 0.1),
          rgba(170, 106, 63, 0.1)
        );

        padding: 2rem;

        border-radius: 16px;

        border-left: 4px solid var(--accent);

        margin: 2rem 0;
      }

      .story-highlight p {
        margin: 0;

        font-size: 1.25rem;

        font-style: italic;

        color: var(--brown-main);
      }

      /* Values Section */

      .values-section {
        padding: 5rem 0;

        background: #fff;
      }

      .section-header {
        text-align: center;

        max-width: 700px;

        margin: 0 auto 4rem;
      }

      .section-title {
        font-size: 2.75rem;

        font-weight: 700;

        margin-bottom: 1rem;

        color: var(--brown-main);
      }

      .section-subtitle {
        font-size: 1.2rem;

        color: var(--brown-soft);

        line-height: 1.7;
      }

      .values-grid {
        display: grid;

        grid-template-columns: repeat(3, 1fr);

        gap: 2.5rem;
      }

      .value-card {
        background: var(--bg-page);

        padding: 2.5rem;

        border-radius: 20px;

        text-align: center;

        transition: all 0.4s ease;

        border: 2px solid transparent;
      }

      .value-card:hover {
        transform: translateY(-10px);

        border-color: var(--accent);

        box-shadow: 0 15px 40px rgba(201, 147, 102, 0.2);
      }

      .value-icon {
        font-size: 3.5rem;

        margin-bottom: 1.5rem;
      }

      .value-card h3 {
        font-size: 1.5rem;

        font-weight: 700;

        margin-bottom: 1rem;

        color: var(--brown-main);
      }

      .value-card p {
        font-size: 1.05rem;

        line-height: 1.7;

        color: var(--brown-soft);
      }

      /* Team Section */

      .team-section {
        padding: 5rem 0;
      }

      .team-intro {
        display: grid;

        grid-template-columns: 1.2fr 1fr;

        gap: 4rem;

        align-items: center;

        margin-bottom: 4rem;
      }

      .team-intro-content h2 {
        font-size: 2.5rem;

        font-weight: 700;

        margin-bottom: 1.5rem;

        color: var(--brown-main);
      }

      .team-intro-content p {
        font-size: 1.15rem;

        line-height: 1.8;

        color: var(--brown-soft);

        margin-bottom: 1.5rem;
      }

      .team-stats {
        display: grid;

        grid-template-columns: repeat(3, 1fr);

        gap: 2rem;
      }

      .stat-item {
        text-align: center;

        padding: 1.5rem;

        background: #fff;

        border-radius: 16px;

        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
      }

      .stat-number {
        font-size: 2.5rem;

        font-weight: 700;

        color: var(--accent-dark);

        margin-bottom: 0.5rem;
      }

      .stat-label {
        font-size: 1rem;

        color: var(--brown-soft);
      }

      .team-image {
        position: relative;

        border-radius: 20px;

        overflow: hidden;

        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
      }

      .team-image img {
        width: 100%;

        height: 100%;

        object-fit: cover;

        display: block;
      }

      /* Process Section */

      .process-section {
        padding: 5rem 0;

        background: linear-gradient(
          135deg,
          rgba(201, 147, 102, 0.05),
          rgba(170, 106, 63, 0.05)
        );
      }

      .process-steps {
        display: grid;

        grid-template-columns: repeat(4, 1fr);

        gap: 2rem;

        margin-top: 3rem;
      }

      .process-step {
        position: relative;

        text-align: center;

        padding: 2rem 1.5rem;

        background: #fff;

        border-radius: 20px;

        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
      }

      .process-step::after {
        content: "→";

        position: absolute;

        top: 50%;

        right: -1.5rem;

        transform: translateY(-50%);

        font-size: 2rem;

        color: var(--accent);

        opacity: 0.5;
      }

      .process-step:last-child::after {
        display: none;
      }

      .process-number {
        width: 60px;

        height: 60px;

        background: linear-gradient(135deg, var(--accent), var(--accent-dark));

        color: #fff;

        border-radius: 50%;

        display: flex;

        align-items: center;

        justify-content: center;

        font-size: 1.5rem;

        font-weight: 700;

        margin: 0 auto 1.5rem;

        box-shadow: 0 8px 20px rgba(201, 147, 102, 0.3);
      }

      .process-step h3 {
        font-size: 1.25rem;

        font-weight: 700;

        margin-bottom: 0.75rem;

        color: var(--brown-main);
      }

      .process-step p {
        font-size: 0.95rem;

        line-height: 1.6;

        color: var(--brown-soft);
      }

      /* Gallery Section */

      .gallery-section {
        padding: 5rem 0;
      }

      .gallery-grid {
        display: grid;

        grid-template-columns: repeat(4, 1fr);

        gap: 1.5rem;

        margin-top: 3rem;
      }

      .gallery-item {
        position: relative;

        border-radius: 16px;

        overflow: hidden;

        aspect-ratio: 1;

        cursor: pointer;
      }

      .gallery-item img {
        width: 100%;

        height: 100%;

        object-fit: cover;

        transition: transform 0.6s ease;
      }

      .gallery-overlay {
        position: absolute;

        top: 0;

        left: 0;

        width: 100%;

        height: 100%;

        background: linear-gradient(
          180deg,
          transparent 0%,
          rgba(0, 0, 0, 0.7) 100%
        );

        opacity: 0;

        transition: opacity 0.3s ease;

        display: flex;

        align-items: flex-end;

        padding: 1.5rem;
      }

      .gallery-item:hover img {
        transform: scale(1.1);
      }

      .gallery-item:hover .gallery-overlay {
        opacity: 1;
      }

      .gallery-caption {
        color: #fff;

        font-size: 1rem;

        font-weight: 600;
      }

      /* CTA Section */

      .cta-section {
        padding: 5rem 0;

        background: linear-gradient(
          135deg,
          var(--accent) 0%,
          var(--accent-dark) 100%
        );

        color: #fff;

        text-align: center;
      }

      .cta-content {
        max-width: 700px;

        margin: 0 auto;
      }

      .cta-content h2 {
        font-size: 2.75rem;

        font-weight: 700;

        margin-bottom: 1.5rem;
      }

      .cta-content p {
        font-size: 1.25rem;

        margin-bottom: 2.5rem;

        opacity: 0.95;

        line-height: 1.7;
      }

      .cta-buttons {
        display: flex;

        gap: 1.5rem;

        justify-content: center;

        flex-wrap: wrap;
      }

      .cta-btn {
        padding: 1rem 2.5rem;

        border-radius: 50px;

        font-size: 1.1rem;

        font-weight: 600;

        text-decoration: none;

        transition: all 0.3s ease;

        display: inline-flex;

        align-items: center;

        gap: 0.75rem;
      }

      .cta-btn-primary {
        background: #fff;

        color: var(--accent-dark);

        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
      }

      .cta-btn-primary:hover {
        transform: translateY(-3px);

        box-shadow: 0 12px 30px rgba(0, 0, 0, 0.25);
      }

      .cta-btn-secondary {
        background: transparent;

        color: #fff;

        border: 2px solid #fff;
      }

      .cta-btn-secondary:hover {
        background: #fff;

        color: var(--accent-dark);

        transform: translateY(-3px);
      }

      /* Responsive Design */

      @media (max-width: 1024px) {
        .story-grid,
        .team-intro {
          grid-template-columns: 1fr;

          gap: 3rem;
        }

        .values-grid {
          grid-template-columns: repeat(2, 1fr);
        }

        .process-steps {
          grid-template-columns: repeat(2, 1fr);
        }

        .process-step::after {
          display: none;
        }

        .gallery-grid {
          grid-template-columns: repeat(3, 1fr);
        }
      }

      @media (max-width: 768px) {
        .hero-title {
          font-size: 2.5rem;
        }

        .hero-description {
          font-size: 1.1rem;
        }

        .about-hero {
          height: 50vh;

          min-height: 400px;
        }

        .story-section,
        .values-section,
        .team-section,
        .process-section,
        .gallery-section {
          padding: 3rem 0;
        }

        .section-title {
          font-size: 2rem;
        }

        .story-content h2 {
          font-size: 2rem;
        }

        .values-grid {
          grid-template-columns: 1fr;

          gap: 1.5rem;
        }

        .process-steps {
          grid-template-columns: 1fr;
        }

        .gallery-grid {
          grid-template-columns: repeat(2, 1fr);

          gap: 1rem;
        }

        .team-stats {
          grid-template-columns: 1fr;
        }

        .cta-content h2 {
          font-size: 2rem;
        }

        .cta-buttons {
          flex-direction: column;
        }

        .cta-btn {
          width: 100%;

          justify-content: center;
        }

        .about-container {
          padding: 0 1rem;
        }
      }

      /* Animations */

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

      .animate-on-scroll {
        animation: fadeInUp 0.8s ease-out;
      }
    </style>

    <link
      href="https://fonts.googleapis.com/css2?family=Crimson Text:ital,wght@0,300;0,400;0,500;0,600;0,700;1,400;1,500;1,600;1,700&display=fallback"
      as="style"
      type="text/css"
      rel="preload stylesheet"
    />

    <link
      href="//cdn.hstatic.net/themes/200000846175/1001403720/14/plugin-style.css?v=245"
      rel="preload stylesheet"
      as="style"
      type="text/css"
    />

    <link
      href="//cdn.hstatic.net/themes/200000846175/1001403720/14/styles-new.scss.css?v=245"
      rel="preload stylesheet"
      as="style"
      type="text/css"
    />

    <link
      href="//cdn.hstatic.net/themes/200000846175/1001403720/14/style-page.scss.css?v=245"
      rel="preload stylesheet"
      as="style"
      type="text/css"
    />

    <!-- jQuery từ CDN đáng tin cậy -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>

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

        sgnotify: "false",

        recaptchajs:
          "https://www.google.com/recaptcha/api.js?render=6LdD18MUAAAAAHqKl3Avv8W-tREL6LangePxQLM-",

        jsonmap:
          "https://file.hstatic.net/200000397757/file/hethongcuahang_f1ee212eddc04706b09d43518b50a964.json",

        typepaginate: "default",

        typeimage: false,

        trash:
          "//cdn.hstatic.net/themes/200000846175/1001403720/14/trash.svg?v=245",

        cancel:
          "//cdn.hstatic.net/themes/200000846175/1001403720/14/cancel.svg?v=245",

        productjson: { error: "json not allowed for this object" },

        producthandle: "",

        typerelated: "type",

        vendorurl: "/collections/vendors?q=&view=related-product",

        typeurl: "/collections/types?q=&view=related-product",

        sortbydefault: "",
      };

      if (typeof Haravan === "undefined") {
        Haravan = {};
      }

      Haravan.shop = "lavieestbelle.vn";

      Haravan.culture = "vi-VN";

      Haravan.shop = "lavieestbelle.myharavan.com";

      Haravan.theme = {
        name: "Customize Lavieestbelle",
        id: 1001403720,
        role: "main",
      };

      Haravan.domain = "lavieestbelle.vn";
    </script>

    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet" />

    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    
    <!-- CSRF Token Helper -->
    <script src="${pageContext.request.contextPath}/fileJS/csrf-token.js"></script>
  </head>

  <body id="wandave-theme" class="index" data-theme="tbag-fashion">
    <!-- Google Tag Manager (noscript) -->

    <noscript
      ><iframe
        src="https://www.googletagmanager.com/ns.html?id=GTM-W8R4GL2"
        height="0"
        width="0"
        style="display: none; visibility: hidden"
      ></iframe
    ></noscript>

    <noscript
      ><iframe
        src="https://www.googletagmanager.com/ns.html?id=GTM-NSBT6HTK"
        height="0"
        width="0"
        style="display: none; visibility: hidden"
      ></iframe
    ></noscript>

    <%@ include file="partials/header.jsp" %>

    <main>
      <!-- Hero Section -->

      <section class="about-hero">
        <div class="hero-background"></div>

        <div class="hero-pattern"></div>

        <div class="hero-content" data-aos="fade-up">
          <p class="hero-subtitle">Welcome to</p>

          <h1 class="hero-title">Tiệm hoa nhà tớ</h1>

          <p class="hero-description">
            Cuộc sống tươi đẹp - Nơi cảm xúc nảy mầm
          </p>
        </div>
      </section>

      <!-- Story Section -->

      <section class="story-section">
        <div class="about-container">
          <div class="story-grid">
            <div class="story-image" data-aos="fade-right">
              <img
                src="https://cdn.hstatic.net/files/200000846175/file/z5318389113228_bf05d1d394f756ddf038d8894726eb4c_cf4c6b6a880841b6b51d904a62b0035c.jpg"
                alt="Tiệm Hoa nhà tớ"
              />
            </div>

            <div class="story-content" data-aos="fade-left">
              <h2>Câu Chuyện Của Chúng Tôi</h2>

              <p>
                Tại <strong>Tiệm Hoa nhà tớ</strong>, chúng tôi tin rằng cuộc
                sống là những khoảnh khắc đẹp. Hoa không chỉ là một món quà, mà
                là một ngôn ngữ tinh tế để kể những câu chuyện cảm xúc, kết nối
                yêu thương và tôn vinh vẻ đẹp trong cuộc sống hàng ngày.
              </p>

              <p>
                Được thành lập với niềm đam mê về nghệ thuật cắm hoa và mong
                muốn mang lại những trải nghiệm đặc biệt cho khách hàng, chúng
                tôi không ngừng sáng tạo và đổi mới để mỗi bó hoa đều mang một ý
                nghđ©a riêng, một câu chuyện riêng.
              </p>

              <div class="story-highlight">
                <p>
                  "Mỗi đóa hoa là một lời chúc, mỗi bó hoa là một câu chuyện.
                  Chúng tôi không chỉ bán hoa, chúng tôi tạo nên những kỷ niệm
                  đáng nhớ."
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Values Section -->

      <section class="values-section">
        <div class="about-container">
          <div class="section-header" data-aos="fade-up">
            <h2 class="section-title">Giá Trị Cốt Lõi</h2>

            <p class="section-subtitle">
              Những nguyên tắc định hình cách chúng tôi làm việc và phục vụ
              khách hàng
            </p>
          </div>

          <div class="values-grid">
            <div class="value-card" data-aos="fade-up" data-aos-delay="100">
              <div class="value-icon">🌿</div>

              <h3>Tinh Thần Hiện Đại</h3>

              <p>
                Liên tục cập nhật xu hướng cắm hoa quốc tế, từ phong cách tối
                giản, thanh lịch đến các thiết kế theo mùa, đảm bảo bó hoa của
                bạn luôn thời thượng và độc đáo.
              </p>
            </div>

            <div class="value-card" data-aos="fade-up" data-aos-delay="200">
              <div class="value-icon">✨</div>

              <h3>Chất Lượng Cao Cấp</h3>

              <p>
                Hoa được nhập trực tiếp từ các vườn chọn lọc, đảm bảo độ tươi
                mới tuyệt đối. Chúng tôi ưu tiên sử dụng các vật liệu gói thân
                thiện với môi trường.
              </p>
            </div>

            <div class="value-card" data-aos="fade-up" data-aos-delay="300">
              <div class="value-icon">💝</div>

              <h3>Dịch Vụ Cá Nhân Hóa</h3>

              <p>
                Mỗi thiết kế là độc bản, dựa trên câu chuyện, ngân sách và sở
                thích riêng của người nhận. Chúng tôi không chỉ bán hoa, chúng
                tôi kiến tạo trải nghiệm.
              </p>
            </div>
          </div>
        </div>
      </section>

      <!-- Team Section -->

      <section class="team-section">
        <div class="about-container">
          <div class="team-intro">
            <div class="team-intro-content" data-aos="fade-right">
              <h2>Đội Ngũ & Tầm Nhìn</h2>

              <p>
                Đội ngũ Florist (nghệ nhân hoa) tại Tiệm Hoa nhà tớ là những
                người trẻ, đam mê và giàu sáng tạo, luôn cắm hoa bằng cả trái
                tim và sự tỉ mỉ.
              </p>

              <p>
                Chúng tôi mong muốn trở thành thương hiệu hoa được yêu thích, là
                nÆ¡i khách hàng tìm đến không chỉ để mua hoa, mà còn để tìm kiếm
                sự bình yên và vẻ đẹp tinh tế.
              </p>
            </div>

            <div class="team-image" data-aos="fade-left">
              <img
                src="https://images.unsplash.com/photo-1522543558187-768b6df7c25c?w=600"
                alt="Đội ngũ Tiệm Hoa"
              />
            </div>
          </div>

          <div class="team-stats" data-aos="fade-up">
            <div class="stat-item">
              <div class="stat-number">5000+</div>

              <div class="stat-label">Khách hàng hài lòng</div>
            </div>

            <div class="stat-item">
              <div class="stat-number">10+</div>

              <div class="stat-label">Florist tài năng</div>
            </div>

            <div class="stat-item">
              <div class="stat-number">100%</div>

              <div class="stat-label">Hoa tươi mỗi ngày</div>
            </div>
          </div>
        </div>
      </section>

      <!-- Process Section -->

      <section class="process-section">
        <div class="about-container">
          <div class="section-header" data-aos="fade-up">
            <h2 class="section-title">Quy Trình Làm Việc</h2>

            <p class="section-subtitle">
              Từ ý tưởng đến khi bó hoa đến tay bạn, mọi bước đều được chăm chút
            </p>
          </div>

          <div class="process-steps">
            <div class="process-step" data-aos="fade-up" data-aos-delay="100">
              <div class="process-number">1</div>

              <h3>Tư Vấn</h3>

              <p>Lắng nghe câu chuyện, hiểu rõ mục đích và sở thích của bạn</p>
            </div>

            <div class="process-step" data-aos="fade-up" data-aos-delay="200">
              <div class="process-number">2</div>

              <h3>Thiết Kế</h3>

              <p>Florist sáng tạo thiết kế riêng, phù hợp với ngân sách</p>
            </div>

            <div class="process-step" data-aos="fade-up" data-aos-delay="300">
              <div class="process-number">3</div>

              <h3>Thực Hiện</h3>

              <p>Cắm hoa tươi, gói cẩn thận với vật liệu cao cấp</p>
            </div>

            <div class="process-step" data-aos="fade-up" data-aos-delay="400">
              <div class="process-number">4</div>

              <h3>Giao Hàng</h3>

              <p>Giao tận nơi nhanh chóng, đảm bảo hoa luôn tươi đẹp</p>
            </div>
          </div>
        </div>
      </section>

      <!-- Gallery Section -->

      <section class="gallery-section">
        <div class="about-container">
          <div class="section-header" data-aos="fade-up">
            <h2 class="section-title">Khoảnh Khắc Đáng Nhớ</h2>

            <p class="section-subtitle">
              Những bó hoa và câu chuyện đã làm nên Tiệm Hoa nhà tớ
            </p>
          </div>

          <div class="gallery-grid" id="galleryGrid">
            <!-- Gallery items will be loaded dynamically -->
            <div class="loading-gallery" style="grid-column: 1 / -1; text-align: center; padding: 60px 20px; color: #999;">
              <i class="fas fa-spinner fa-spin" style="font-size: 32px; margin-bottom: 16px;"></i>
              <p>Đang tải hình ảnh...</p>
            </div>
          </div>
        </div>
      </section>

      <!-- CTA Section -->

      <section class="cta-section">
        <div class="about-container">
          <div class="cta-content" data-aos="fade-up">
            <h2>Hãy Để Tiệm Hoa nhà tớ Tô Điểm Cho Khoảnh Khắc Của Bạn!</h2>

            <p>
              Khám phá các bộ sưu tập mới nhất hoặc liên hệ ngay để thiết kế
              riêng một bó hoa hoàn hảo. Chúng tôi luôn sẵn sàng lắng nghe và
              biến ý tưởng của bạn thành hiện thực.
            </p>

            <div class="cta-buttons">
              <a href="product.jsp" class="cta-btn cta-btn-primary">
                Khám phá sản phẩm

                <span>→</span>
              </a>

              <a href="contact.jsp" class="cta-btn cta-btn-secondary">
                Liên hệ ngay
              </a>
            </div>
          </div>
        </div>
      </section>
    </main>

    <%@ include file="partials/footer.jsp" %>

    <!-- Modals - giữ nguyên -->

    <div class="modal" id="pro-qv-wanda"></div>

    <div class="modal" id="success-cart-wanda">
      <div class="row">
        <div class="modal-content">
          <div class="modal-icon sweet-alert">
            <div class="sa-icon sa-success animate">
              <span class="sa-line sa-tip animateSuccessTip"></span>

              <span class="sa-line sa-long animateSuccessLong"></span>

              <div class="sa-placeholder"></div>

              <div class="sa-fix"></div>
            </div>
          </div>

          <div class="modal-body text-center">
            <p class="modal-title">Thêm vào giờ thành công</p>

            <div class="media-success"></div>
          </div>
        </div>
      </div>
    </div>

    <div class="modal" id="cart-mini-wanda">
      <div class="modal-header">Giỏ hàng</div>

      <div class="modal-content">
        <div class="cart-view clearfix">
          <div class="cart-scroll">
            <table id="cart-view">
              <tbody></tbody>
            </table>
          </div>

          <span class="line"></span>

          <table class="table-total">
            <tbody>
              <tr>
                <td class="text-left title-total">TỔNG TIỀN:</td>

                <td class="text-right" id="total-view-cart"></td>
              </tr>

              <tr>
                <td colspan="2">
                  <a href="cart.jsp" class="wanda-checkout-url btn"
                    >Thanh toán</a
                  >
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <div class="modal" id="modal-error">
      <img
        src="//cdn.hstatic.net/themes/200000846175/1001403720/14/alert.png?v=245"
        width="44"
        height="38"
      />

      <span class="title">Thông báo!</span>

      <p></p>
    </div>

    <div class="modal" id="success-subcribe-wanda">
      <div class="row">
        <div class="modal-content">
          <div class="modal-icon sweet-alert">
            <div class="sa-icon sa-success animate">
              <span class="sa-line sa-tip animateSuccessTip"></span>

              <span class="sa-line sa-long animateSuccessLong"></span>

              <div class="sa-placeholder"></div>

              <div class="sa-fix"></div>
            </div>
          </div>

          <div class="modal-body text-center">
            <p class="modal-title">
              Đăng ký thành công.<br />Thông báo sẽ tự động tắt sau 3 giây
            </p>
          </div>
        </div>
      </div>
    </div>

    <div class="social-fixed">
      <ul class="active overflow-active">
        <li class="hotline">
          <a
            href="tel:0919897969"
            data-toggle="tooltip"
            data-original-title="Liên hệ 0919897969"
            ><i class="fa fa-phone"></i
          ></a>
        </li>

        <li class="zalo">
          <a
            href="https://zalo.me/3854304162857362827"
            data-toggle="tooltip"
            data-original-title="Liên hệ với chúng tôi qua Zalo"
          >
            <svg
              viewBox="0 0 44 44"
              fill="none"
              xmlns="http://www.w3.org/2000/svg"
            >
              <circle
                cx="22"
                cy="22"
                r="22"
                fill="url(#paint4_linear)"
              ></circle>

              <g clip-path="url(#clip0)">
                <path
                  fill-rule="evenodd"
                  clip-rule="evenodd"
                  d="M15.274 34.0907C15.7773 34.0856 16.2805 34.0804 16.783 34.0804C16.7806 34.0636 16.7769 34.0479 16.7722 34.0333C16.777 34.0477 16.7808 34.0632 16.7832 34.0798C16.8978 34.0798 17.0124 34.0854 17.127 34.0965H25.4058C26.0934 34.0965 26.7809 34.0977 27.4684 34.0989C28.8434 34.1014 30.2185 34.1039 31.5935 34.0965H31.6222C33.5357 34.0798 35.0712 32.5722 35.0597 30.7209V27.4784C35.0597 27.4582 35.0612 27.4333 35.0628 27.4071C35.0676 27.3257 35.0731 27.2325 35.0368 27.2345C34.9337 27.2401 34.7711 27.2757 34.7138 27.3311C34.2744 27.6145 33.8483 27.924 33.4222 28.2335C32.57 28.8525 31.7179 29.4715 30.7592 29.8817C27.0284 31.0993 23.7287 31.157 20.2265 30.3385C20.0349 30.271 19.9436 30.2786 19.7816 30.292C19.6773 30.3007 19.5436 30.3118 19.3347 30.3068C19.3093 30.3077 19.2829 30.3085 19.2554 30.3093C18.9099 30.3197 18.4083 30.3348 17.8088 30.6877C16.4051 31.1034 14.5013 31.157 13.5175 31.0147C13.522 31.0245 13.5247 31.0329 13.5269 31.0407C13.5236 31.0341 13.5204 31.0275 13.5173 31.0208C13.5036 31.0059 13.4864 30.9927 13.4696 30.98C13.4163 30.9393 13.3684 30.9028 13.46 30.8268C13.4867 30.8102 13.5135 30.7929 13.5402 30.7757C13.5937 30.7412 13.6472 30.7067 13.7006 30.6771C14.4512 30.206 15.1559 29.6905 15.6199 28.9311C16.2508 28.1911 15.9584 27.9025 15.4009 27.3524L15.3799 27.3317C12.6639 24.6504 11.8647 21.8054 12.148 17.9785C12.486 15.8778 13.4829 14.0708 14.921 12.4967C15.7918 11.5433 16.8288 10.7729 17.9632 10.1299C17.9796 10.1198 17.9987 10.1116 18.0182 10.1032C18.0736 10.0793 18.1324 10.0541 18.1408 9.98023C18.1475 9.92191 18.0507 9.90264 18.0163 9.90264C17.3698 9.90264 16.7316 9.89705 16.0964 9.89148C14.8346 9.88043 13.5845 9.86947 12.3041 9.90265C10.465 9.95254 8.78889 11.1779 8.81925 13.3614C8.82689 17.2194 8.82435 21.0749 8.8218 24.9296C8.82053 26.8567 8.81925 28.7835 8.81925 30.7104C8.81925 32.5007 10.2344 34.0028 12.085 34.0749C13.1465 34.1125 14.2107 34.1016 15.274 34.0907ZM13.5888 31.1403C13.5935 31.1467 13.5983 31.153 13.6032 31.1594C13.7036 31.2455 13.8031 31.3325 13.9021 31.4202C13.8063 31.3312 13.7072 31.2423 13.6035 31.1533C13.5982 31.1487 13.5933 31.1444 13.5888 31.1403ZM16.5336 33.8108C16.4979 33.7885 16.4634 33.7649 16.4337 33.7362C16.4311 33.7358 16.4283 33.7352 16.4254 33.7345C16.4281 33.7371 16.4308 33.7397 16.4335 33.7423C16.4632 33.7683 16.4978 33.79 16.5336 33.8108Z"
                  fill="#000"
                ></path>
              </g>

              <defs>
                <linearGradient
                  id="paint4_linear"
                  x1="22"
                  y1="0"
                  x2="22"
                  y2="44"
                  gradientUnits="userSpaceOnUse"
                >
                  <stop offset="50%" stop-color="#ffffff"></stop>

                  <stop offset="100%" stop-color="#ffffff"></stop>
                </linearGradient>

                <clipPath id="clip0">
                  <rect
                    width="26.3641"
                    height="24.2"
                    fill="white"
                    transform="translate(8.78906 9.90234)"
                  ></rect>
                </clipPath>
              </defs>
            </svg>
          </a>
        </li>

        <li class="">
          <a
            href="https://www.messenger.com/login.php?next=https%3A%2F%2Fwww.messenger.com%2Ft%2Ftiemhoa.lavieestbelle"
            data-toggle="tooltip"
            data-original-title="Liên hệ với chúng tôi qua Messenger"
          >
            <svg
              width="44"
              height="44"
              viewBox="0 0 44 44"
              fill="none"
              xmlns="http://www.w3.org/2000/svg"
            >
              <circle cx="22" cy="22" r="22" fill="#fff"></circle>

              <path
                fill-rule="evenodd"
                clip-rule="evenodd"
                d="M22.0026 7.70215C14.1041 7.70215 7.70117 13.6308 7.70117 20.9442C7.70117 25.1115 9.78083 28.8286 13.0309 31.256V36.305L17.9004 33.6325C19.2 33.9922 20.5767 34.1863 22.0026 34.1863C29.9011 34.1863 36.304 28.2576 36.304 20.9442C36.304 13.6308 29.9011 7.70215 22.0026 7.70215ZM23.4221 25.5314L19.7801 21.6471L12.6738 25.5314L20.4908 17.2331L24.2216 21.1174L31.239 17.2331L23.4221 25.5314Z"
                fill="#000"
              ></path>
            </svg>
          </a>
        </li>
      </ul>
    </div>

    <!-- JavaScript -->

    <script>
      // Initialize AOS

      document.addEventListener("DOMContentLoaded", function () {
        if (typeof AOS !== "undefined") {
          AOS.init({
            duration: 800,

            once: true,

            offset: 100,

            easing: "ease-out",
          });
        }

        // Smooth scroll for CTA buttons

        document.querySelectorAll('a[href^="/"]').forEach((anchor) => {
          anchor.addEventListener("click", function (e) {
            // Let normal navigation work
          });
        });

        // Gallery lightbox effect (simple version)

        const galleryItems = document.querySelectorAll(".gallery-item");

        galleryItems.forEach((item) => {
          item.addEventListener("click", function () {
            const img = this.querySelector("img");

            const caption = this.querySelector(".gallery-caption");

            if (img && caption) {
              alert(caption.textContent);
            }
          });
        });

        // Counter animation for stats

        const statNumbers = document.querySelectorAll(".stat-number");

        const animateCounter = (element) => {
          const target = element.textContent.replace(/\D/g, "");

          const duration = 2000;

          const start = 0;

          const increment = target / (duration / 16);

          let current = start;

          const timer = setInterval(() => {
            current += increment;

            if (current >= target) {
              element.textContent = element.textContent.replace(/\d+/, target);

              clearInterval(timer);
            } else {
              element.textContent = element.textContent.replace(
                /\d+/,
                Math.floor(current)
              );
            }
          }, 16);
        };

        // Intersection Observer for counter animation

        const observer = new IntersectionObserver(
          (entries) => {
            entries.forEach((entry) => {
              if (entry.isIntersecting) {
                animateCounter(entry.target);

                observer.unobserve(entry.target);
              }
            });
          },
          { threshold: 0.5 }
        );

        statNumbers.forEach((stat) => observer.observe(stat));
      });

      // Async loading

      var checkapp = false;

      let loadasyncdefer = () => {};

      function resolveAfter5Seconds() {
        return new Promise((resolve) => {
          if (tbag_varible.template == "index") {
            setTimeout(() => {
              if (typeof loadslider === "function") loadslider();
            }, 100);
          }

          setTimeout(() => {
            loadasyncdefer();
          }, 200);
        });
      }

      function asyncCall() {
        resolveAfter5Seconds();
      }
      
      // Load gallery from database
      async function loadGallery() {
        const galleryGrid = document.getElementById('galleryGrid');
        
        try {
          const response = await fetch('${pageContext.request.contextPath}/api/gallery/list');
          const result = await response.json();
          
          if (result.success && result.data && result.data.length > 0) {
            galleryGrid.innerHTML = '';
            result.data.forEach((item, index) => {
              const delay = (index % 4) * 100 + 100;
              const galleryItem = document.createElement('div');
              galleryItem.className = 'gallery-item';
              galleryItem.setAttribute('data-aos', 'zoom-in');
              galleryItem.setAttribute('data-aos-delay', delay);
              
              galleryItem.innerHTML = '<img src="' + item.imageUrl + '" alt="' + item.caption + '" onerror="this.src=\'https://via.placeholder.com/400x300?text=No+Image\'" />' +
                '<div class="gallery-overlay">' +
                  '<span class="gallery-caption">' + item.caption + '</span>' +
                '</div>';
              
              galleryGrid.appendChild(galleryItem);
            });
            
            // Reinitialize AOS for new elements
            if (typeof AOS !== 'undefined') {
              AOS.refresh();
            }
          } else {
            galleryGrid.innerHTML = '<div style="grid-column: 1 / -1; text-align: center; padding: 60px 20px; color: #999;">' +
              '<p>Chưa có hình ảnh nào</p>' +
              '</div>';
          }
        } catch (error) {
          console.error('Error loading gallery:', error);
          galleryGrid.innerHTML = '<div style="grid-column: 1 / -1; text-align: center; padding: 60px 20px; color: #999;">' +
            '<p>Không thể tải hình ảnh</p>' +
            '</div>';
        }
      }
      
      // Load gallery when page loads
      document.addEventListener('DOMContentLoaded', function() {
        loadGallery();
      });
    </script>

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

    <script
      type="text/javascript"
      src="//cdn.hstatic.net/themes/200000846175/1001403720/14/main-page.js?v=245"
      defer
    ></script>
  </body>
</html>
