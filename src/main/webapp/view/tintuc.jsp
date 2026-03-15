<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <title>Tin Tức - La Vie Est Belle - Flower & Gift</title>
    
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
      })(window, document, "script", "dataLayer", "GTM-NSBT6HTK");
    </script>

    <!-- End Google Tag Manager -->

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
      content="Khám phá những câu chuyện về hoa và cuộc sống đẹp đẽ"
    />

    <link rel="canonical" href="https://lavieestbelle.vn/pages/news" />

    <meta name="robots" content="index,follow,noodp" />

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

    <!-- Modern News Page Styles -->

    <style>
      * {
        margin: 0;

        padding: 0;

        box-sizing: border-box;
      }

      body {
        font-family: "Crimson Text", -apple-system, BlinkMacSystemFont,
          "Segoe UI", sans-serif;

        background: linear-gradient(
            135deg,
            rgba(201, 147, 102, 0.95) 0%,
            rgba(170, 106, 63, 0.95) 100%
          ),
          url("https://images.unsplash.com/photo-1487070183336-b863922373d4?w=1200")
            center/cover;

        color: var(--brown-main);

        line-height: 1.6;
      }
      /* Hero Section */
      .news-hero {
         background: linear-gradient(
            135deg,
            rgba(201, 147, 102, 0.95) 0%,
            rgba(170, 106, 63, 0.95) 100%
          ),
          url("https://images.unsplash.com/photo-1487070183336-b863922373d4?w=1200")
            center/cover;
        color: #fff;

        padding: 4rem 2rem;

        text-align: center;

        position: relative;

        overflow: hidden;
      }

      .news-hero::before {
        content: "";

        position: absolute;

        top: -50%;

        right: -10%;

        width: 500px;

        height: 500px;

        background: radial-gradient(
          circle,
          rgba(255, 255, 255, 0.1) 0%,
          transparent 70%
        );

        border-radius: 50%;
      }

      .news-hero::after {
        content: "";

        position: absolute;

        bottom: -30%;

        left: -5%;

        width: 400px;

        height: 400px;

        background: radial-gradient(
          circle,
          rgba(255, 255, 255, 0.08) 0%,
          transparent 70%
        );

        border-radius: 50%;
      }

      .hero-content {
        position: relative;

        z-index: 1;

        max-width: 800px;

        margin: 0 auto;
      }

      .news-hero h1 {
        font-size: 3.5rem;

        font-weight: 700;

        margin-bottom: 1rem;

        letter-spacing: -0.02em;

        text-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      }

      .news-hero p {
        font-size: 1.25rem;

        opacity: 0.95;

        font-style: italic;
      }

      /* Search & Filter Section */

      .search-filter-section {
        background: #fff;

        padding: 2rem;

        margin: -3rem auto 3rem;

        max-width: 1200px;

        border-radius: 20px;

        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);

        position: relative;

        z-index: 10;
      }

      .search-wrapper {
        display: flex;

        gap: 1rem;

        margin-bottom: 1.5rem;
      }

      .search-input {
        flex: 1;

        padding: 1rem 1.5rem;

        border: 2px solid #f0e8df;

        border-radius: 50px;

        font-size: 1rem;

        font-family: "Crimson Text", serif;

        transition: all 0.3s ease;

        background: #faf8f5;
      }

      .search-input:focus {
        outline: none;

        border-color: var(--accent);

        background: #fff;

        box-shadow: 0 4px 12px rgba(201, 147, 102, 0.15);
      }

      .search-btn {
        padding: 1rem 2.5rem;

        background: linear-gradient(135deg, var(--accent), var(--accent-dark));

        color: #fff;

        border: none;

        border-radius: 50px;

        font-weight: 600;

        font-size: 1rem;

        cursor: pointer;

        transition: all 0.3s ease;

        box-shadow: 0 4px 15px rgba(201, 147, 102, 0.3);
      }

      .search-btn:hover {
        transform: translateY(-2px);

        box-shadow: 0 6px 20px rgba(201, 147, 102, 0.4);
      }

      .search-btn:active {
        transform: translateY(0);
      }

      /* Filter Chips */

      .filter-chips {
        display: flex;

        flex-wrap: wrap;

        gap: 0.75rem;
      }

      .filter-label {
        font-weight: 600;

        color: var(--brown-soft);

        margin-right: 0.5rem;

        display: flex;

        align-items: center;
      }

      .chip {
        padding: 0.5rem 1.25rem;

        border-radius: 50px;

        background: #f4e8dc;

        border: 2px solid transparent;

        cursor: pointer;

        font-weight: 500;

        font-size: 0.9rem;

        transition: all 0.3s ease;

        color: var(--brown-soft);
      }

      .chip:hover {
        background: #ecddd0;

        transform: translateY(-2px);
      }

      .chip.active {
        background: linear-gradient(135deg, var(--accent), var(--accent-dark));

        color: #fff;

        box-shadow: 0 4px 12px rgba(201, 147, 102, 0.3);
      }

      /* Main Container */

      .news-container {
        max-width: 1400px;

        margin: 0 auto;

        padding: 0 2rem 4rem;
      }

      .news-layout {
        display: grid;

        grid-template-columns: 1fr 350px;

        gap: 3rem;
      }

      /* News Grid */

      .news-grid {
        display: grid;

        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));

        gap: 2rem;
      }

      .news-card {
        background: #fff;

        border-radius: 20px;

        overflow: hidden;

        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);

        border: 1px solid rgba(210, 180, 160, 0.2);

        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);

        cursor: pointer;

        display: flex;

        flex-direction: column;
      }

      .news-card:hover {
        transform: translateY(-8px);

        box-shadow: 0 12px 30px rgba(160, 130, 100, 0.2);
      }

      .news-image-wrapper {
        position: relative;

        width: 100%;

        height: 240px;

        overflow: hidden;
      }

      .news-thumb {
        width: 100%;

        height: 100%;

        object-fit: cover;

        transition: transform 0.6s ease;
      }

      .news-card:hover .news-thumb {
        transform: scale(1.1);
      }

      .news-overlay {
        position: absolute;

        top: 0;

        left: 0;

        right: 0;

        bottom: 0;

        background: linear-gradient(
          180deg,
          transparent 0%,
          rgba(0, 0, 0, 0.3) 100%
        );

        opacity: 0;

        transition: opacity 0.3s ease;
      }

      .news-card:hover .news-overlay {
        opacity: 1;
      }

      .news-content {
        padding: 1.75rem;

        display: flex;

        flex-direction: column;

        flex: 1;
      }

      .news-meta {
        display: flex;

        align-items: center;

        gap: 0.75rem;

        margin-bottom: 0.75rem;

        font-size: 0.875rem;
      }

      .news-category {
        display: inline-block;

        padding: 0.25rem 0.875rem;

        background: linear-gradient(
          135deg,
          rgba(201, 147, 102, 0.12),
          rgba(170, 106, 63, 0.12)
        );

        color: var(--accent-dark);

        border-radius: 50px;

        font-weight: 700;

        font-size: 0.75rem;

        text-transform: uppercase;

        letter-spacing: 0.8px;
      }

      .news-date {
        color: var(--brown-soft);

        display: flex;

        align-items: center;

        gap: 0.25rem;
      }

      .news-date::before {
        content: "•";

        font-size: 0.6rem;
      }

      .news-heading {
        font-size: 1.35rem;

        font-weight: 700;

        margin-bottom: 0.75rem;

        color: var(--brown-main);

        line-height: 1.4;

        display: -webkit-box;

        -webkit-line-clamp: 2;

        line-clamp: 2;

        -webkit-box-orient: vertical;

        overflow: hidden;
      }

      .news-excerpt {
        color: var(--brown-soft);

        margin-bottom: 1.25rem;

        flex: 1;

        line-height: 1.7;

        display: -webkit-box;

        -webkit-line-clamp: 3;

        line-clamp: 3;

        -webkit-box-orient: vertical;

        overflow: hidden;
      }

      .news-link {
        display: inline-flex;

        align-items: center;

        gap: 0.5rem;

        color: var(--accent-dark);

        font-weight: 600;

        text-decoration: none;

        transition: all 0.3s ease;

        font-size: 0.95rem;
      }

      .news-link::after {
        content: "→";

        transition: transform 0.3s ease;
      }

      .news-card:hover .news-link::after {
        transform: translateX(5px);
      }

      /* Sidebar */

      .news-sidebar {
        position: sticky;

        top: 100px;
      }

      .sidebar-widget {
        background: #fff;

        padding: 2rem;

        border-radius: 20px;

        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);

        margin-bottom: 2rem;

        border: 1px solid rgba(210, 180, 160, 0.15);
      }

      .sidebar-title {
        font-size: 1.35rem;

        font-weight: 700;

        margin-bottom: 1.25rem;

        color: var(--brown-main);

        display: flex;

        align-items: center;

        gap: 0.5rem;
      }

      .sidebar-title::before {
        content: "";

        width: 4px;

        height: 24px;

        background: linear-gradient(180deg, var(--accent), var(--accent-dark));

        border-radius: 10px;
      }

      .recent-posts {
        list-style: none;
      }

      .recent-post-item {
        padding: 1rem 0;

        border-bottom: 1px solid #f0e8df;

        transition: all 0.3s ease;

        cursor: pointer;
      }

      .recent-post-item:last-child {
        border-bottom: none;
      }

      .recent-post-item:hover {
        padding-left: 0.75rem;
      }

      .recent-post-title {
        color: var(--brown-main);

        font-weight: 600;

        font-size: 1rem;

        margin-bottom: 0.25rem;

        line-height: 1.4;
      }

      .recent-post-date {
        font-size: 0.8rem;

        color: var(--brown-soft);

        font-style: italic;
      }

      .sidebar-note {
        color: var(--brown-soft);

        line-height: 1.7;

        font-size: 0.95rem;

        background: linear-gradient(
          135deg,
          rgba(201, 147, 102, 0.05),
          rgba(170, 106, 63, 0.05)
        );

        padding: 1.25rem;

        border-radius: 12px;

        border-left: 4px solid var(--accent);
      }

      /* Load More Button */

      .load-more-section {
        text-align: center;

        margin-top: 3rem;

        padding: 2rem 0;
      }

      .load-more-btn {
        padding: 1rem 3rem;

        background: #fff;

        color: var(--accent-dark);

        border: 2px solid var(--accent);

        border-radius: 50px;

        font-weight: 600;

        font-size: 1rem;

        cursor: pointer;

        transition: all 0.3s ease;

        box-shadow: 0 4px 15px rgba(201, 147, 102, 0.15);
      }

      .load-more-btn:hover {
        background: linear-gradient(135deg, var(--accent), var(--accent-dark));

        color: #fff;

        transform: translateY(-3px);

        box-shadow: 0 6px 20px rgba(201, 147, 102, 0.3);
      }

      /* Responsive Design */

      @media (max-width: 1200px) {
        .news-layout {
          grid-template-columns: 1fr;
        }

        .news-sidebar {
          position: static;
        }
      }

      @media (max-width: 768px) {
        .news-hero h1 {
          font-size: 2.5rem;
        }

        .news-hero p {
          font-size: 1.1rem;
        }

        .search-filter-section {
          margin: -2rem 1rem 2rem;

          padding: 1.5rem;
        }

        .search-wrapper {
          flex-direction: column;
        }

        .news-grid {
          grid-template-columns: 1fr;
        }

        .news-container {
          padding: 0 1rem 2rem;
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

      .news-card {
        animation: fadeInUp 0.6s ease-out;
      }

      .news-card:nth-child(1) {
        animation-delay: 0.1s;
      }

      .news-card:nth-child(2) {
        animation-delay: 0.15s;
      }

      .news-card:nth-child(3) {
        animation-delay: 0.2s;
      }

      .news-card:nth-child(4) {
        animation-delay: 0.25s;
      }

      .news-card:nth-child(5) {
        animation-delay: 0.3s;
      }

      .news-card:nth-child(6) {
        animation-delay: 0.35s;
      }
    </style>

    <link
      href="https://fonts.googleapis.com/css2?family=Crimson+Text:ital,wght@0,300;0,400;0,500;0,600;0,700;1,400;1,500;1,600;1,700&display=swap"
      rel="stylesheet"
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

    <link
      rel="preload"
      as="image"
      href="//cdn.hstatic.net/themes/200000846175/1001403720/14/logo.png?v=245"
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

      <section class="news-hero">
        <div class="hero-content">
          <h1>Tin Tức & Cảm Hứng</h1>

          <p>Khám phá những câu chuyện về hoa và cuộc sống đẹp đẽ</p>
        </div>
      </section>

      <!-- Search & Filter -->

      <div class="search-filter-section">
        <div class="search-wrapper">
          <input
            type="text"
            class="search-input"
            placeholder="Tìm kiếm bài viết..."
            id="searchInput"
          />

          <button class="search-btn" id="searchBtn">Tìm kiếm</button>
        </div>

        <div class="filter-chips">
          <span class="filter-label">Lọc theo:</span>

          <div class="chip active" data-filter="all">Tất cả</div>

          <div class="chip" data-filter="tips">Tips chọn hoa</div>

          <div class="chip" data-filter="birthday">Sinh nhật</div>

          <div class="chip" data-filter="opening">Khai trương</div>

          <div class="chip" data-filter="proposal">Cầu hôn</div>

          <div class="chip" data-filter="story">Story từ Tiệm</div>
        </div>
      </div>

      <!-- Main Content -->

      <div class="news-container">
        <div class="news-layout">
          <!-- News Grid -->

          <div>
            <section class="news-grid" id="newsGrid">
              <!-- Article 1 -->

              <article class="news-card" data-category="tips">
                <div class="news-image-wrapper">
                  <img
                    class="news-thumb"
                    src="https://cdn.hstatic.net/files/200000846175/file/caf51f824f9dc2c39b8c.jpg"
                    alt="Bó hoa pastel dịu dàng"
                  />

                  <div class="news-overlay"></div>
                </div>

                <div class="news-content">
                  <div class="news-meta">
                    <span class="news-category">Tips chọn hoa</span>

                    <span class="news-date">10/11/2025</span>
                  </div>

                  <h2 class="news-heading">
                    Gợi ý chọn bó hoa pastel cho những ngày cần sự dịu dàng
                  </h2>

                  <p class="news-excerpt">
                    Tone pastel luôn mang lại cảm giác nhẹ nhàng, trong trẻo –
                    rất hợp để tặng những người mình thương vào dịp sinh nhật,
                    kỷ niệm hoặc đơn giản là "vì nhớ bạn".
                  </p>

                  <a href="#" class="news-link">Xem chi tiết</a>
                </div>
              </article>

              <!-- Article 2 -->

              <article class="news-card" data-category="opening">
                <div class="news-image-wrapper">
                  <img
                    class="news-thumb"
                    src="https://product.hstatic.net/200000846175/product/w6_57fe7e7ee65f4097aef741ba053a4609.jpg"
                    alt="Hoa cho ngày khai trương"
                  />

                  <div class="news-overlay"></div>
                </div>

                <div class="news-content">
                  <div class="news-meta">
                    <span class="news-category">Khai trương</span>

                    <span class="news-date">02/11/2025</span>
                  </div>

                  <h2 class="news-heading">
                    Chọn kệ hoa khai trương sao cho tinh tế mà vẫn sang trọng?
                  </h2>

                  <p class="news-excerpt">
                    Không phải cứ thật to là sẽ đẹp – đôi khi một kệ hoa vừa
                    phải, phối màu chuẩn và câu chúc được chăm chút lại gây ấn
                    tượng hơn rất nhiều.
                  </p>

                  <a href="#" class="news-link">Xem chi tiết</a>
                </div>
              </article>

              <!-- Article 3 -->

              <article class="news-card" data-category="story">
                <div class="news-image-wrapper">
                  <img
                    class="news-thumb"
                    src="https://cdn.hstatic.net/files/200000846175/file/z5318389113228_bf05d1d394f756ddf038d8894726eb4c_cf4c6b6a880841b6b51d904a62b0035c.jpg"
                    alt="Hoa và quà tặng"
                  />

                  <div class="news-overlay"></div>
                </div>

                <div class="news-content">
                  <div class="news-meta">
                    <span class="news-category">Story từ Tiệm</span>

                    <span class="news-date">25/10/2025</span>
                  </div>

                  <h2 class="news-heading">
                    Một ngày chuẩn bị 20 đơn "tỏ tình" cùng nhà tớ
                  </h2>

                  <p class="news-excerpt">
                    Có những ngày Tiệm nhận rất nhiều đơn "bí mật" – người gửi
                    giấu tên, chỉ nhắn một câu: "Nhờ Tiệm giúp em nói phần còn
                    lại nhé…".
                  </p>

                  <a href="#" class="news-link">Xem chi tiết</a>
                </div>
              </article>

              <!-- Article 4 -->

              <article class="news-card" data-category="tips">
                <div class="news-image-wrapper">
                  <img
                    class="news-thumb"
                    src="https://file.hstatic.net/200000846175/article/6_d6bdb32719444cc5ad4a6193f4c065f1_master.png"
                    alt="Bó hoa theo ngân sách"
                  />

                  <div class="news-overlay"></div>
                </div>

                <div class="news-content">
                  <div class="news-meta">
                    <span class="news-category">Ngân sách</span>

                    <span class="news-date">18/10/2025</span>
                  </div>

                  <h2 class="news-heading">
                    Tặng hoa với ngân sách vừa phải nhưng vẫn thật chỉn chu
                  </h2>

                  <p class="news-excerpt">
                    Bạn không cần chi quá nhiều để có một bó hoa xinh – quan
                    trọng là chọn đúng concept, tone màu và kiểu gói phù hợp với
                    người nhận.
                  </p>

                  <a href="#" class="news-link">Xem chi tiết</a>
                </div>
              </article>

              <!-- Article 5 -->

              <article class="news-card" data-category="proposal">
                <div class="news-image-wrapper">
                  <img
                    class="news-thumb"
                    src="https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=400"
                    alt="Hoa cầu hôn"
                  />

                  <div class="news-overlay"></div>
                </div>

                <div class="news-content">
                  <div class="news-meta">
                    <span class="news-category">Cầu hôn</span>

                    <span class="news-date">12/10/2025</span>
                  </div>

                  <h2 class="news-heading">
                    Bó hoa cầu hôn hoàn hảo: Chọn sao cho đúng ý?
                  </h2>

                  <p class="news-excerpt">
                    Một khoảnh khắc trọng đại cần một bó hoa đặc biệt. Hãy để
                    chúng tôi giúp bạn tìm được "chìa khóa" cho trái tim người
                    ấy.
                  </p>

                  <a href="#" class="news-link">Xem chi tiết</a>
                </div>
              </article>

              <!-- Article 6 -->

              <article class="news-card" data-category="tips">
                <div class="news-image-wrapper">
                  <img
                    class="news-thumb"
                    src="https://images.unsplash.com/photo-1487070183336-b863922373d4?w=400"
                    alt="Chăm sóc hoa"
                  />

                  <div class="news-overlay"></div>
                </div>

                <div class="news-content">
                  <div class="news-meta">
                    <span class="news-category">Tips chọn hoa</span>

                    <span class="news-date">05/10/2025</span>
                  </div>

                  <h2 class="news-heading">
                    5 bí quyết giữ hoa tươi lâu mà ít ai biết
                  </h2>

                  <p class="news-excerpt">
                    Đừng để bó hoa đẹp của bạn chỉ tồn tại vài ngày. Với những
                    mẹo đơn giản này, hoa có thể tươi hơn bạn nghĩ rất nhiều.
                  </p>

                  <a href="#" class="news-link">Xem chi tiết</a>
                </div>
              </article>
            </section>

            <!-- Load More -->

            <div class="load-more-section">
              <button class="load-more-btn" id="loadMoreBtn">
                Xem thêm bài viết
              </button>
            </div>
          </div>

          <!-- Sidebar -->

          <aside class="news-sidebar">
            <div class="sidebar-widget">
              <h3 class="sidebar-title">Tin mới nhất</h3>

              <ul class="recent-posts">
                <li class="recent-post-item">
                  <div class="recent-post-title">
                    Hoa pastel cho mùa cuối năm
                  </div>

                  <div class="recent-post-date">09/11/2025</div>
                </li>

                <li class="recent-post-item">
                  <div class="recent-post-title">
                    5 mẫu bó hoa "an toàn" nhưng không nhàm chán
                  </div>

                  <div class="recent-post-date">03/11/2025</div>
                </li>

                <li class="recent-post-item">
                  <div class="recent-post-title">
                    Chọn hoa theo cung hoàng đạo – bạn đã thá»­ chưa?
                  </div>

                  <div class="recent-post-date">27/10/2025</div>
                </li>

                <li class="recent-post-item">
                  <div class="recent-post-title">
                    Bí mật của những bó hoa "triệu view"
                  </div>

                  <div class="recent-post-date">20/10/2025</div>
                </li>
              </ul>
            </div>

            <div class="sidebar-widget">
              <h3 class="sidebar-title">Góc nhỏ từ nhà tớ</h3>

              <p class="sidebar-note">
                Nếu bạn có một câu chuyện về hoa cùng Tiệm, hãy nhắn cho tụi
                mình – biết đâu câu chuyện đó sẽ xuất hiện trong chuyên mục
                "Story từ nhà tớ" 💌
              </p>
            </div>
          </aside>
        </div>
      </div>
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

    <!-- JavaScript -->

    <script>
      // Filter functionality

      document.addEventListener("DOMContentLoaded", function () {
        const chips = document.querySelectorAll(".chip");

        const newsCards = document.querySelectorAll(".news-card");

        const searchInput = document.getElementById("searchInput");

        const searchBtn = document.getElementById("searchBtn");

        const loadMoreBtn = document.getElementById("loadMoreBtn");

        // Filter chips

        chips.forEach((chip) => {
          chip.addEventListener("click", function () {
            chips.forEach((c) => c.classList.remove("active"));

            this.classList.add("active");

            const filter = this.getAttribute("data-filter");

            newsCards.forEach((card) => {
              if (
                filter === "all" ||
                card.getAttribute("data-category") === filter
              ) {
                card.style.display = "flex";

                card.style.animation = "fadeInUp 0.6s ease-out";
              } else {
                card.style.display = "none";
              }
            });
          });
        });

        // Search functionality

        function performSearch() {
          const searchTerm = searchInput.value.toLowerCase().trim();

          if (searchTerm === "") {
            newsCards.forEach((card) => {
              card.style.display = "flex";
            });

            return;
          }

          let foundCount = 0;

          newsCards.forEach((card) => {
            const title = card
              .querySelector(".news-heading")
              .textContent.toLowerCase();

            const excerpt = card
              .querySelector(".news-excerpt")
              .textContent.toLowerCase();

            if (title.includes(searchTerm) || excerpt.includes(searchTerm)) {
              card.style.display = "flex";

              card.style.animation = "fadeInUp 0.6s ease-out";

              foundCount++;
            } else {
              card.style.display = "none";
            }
          });

          if (foundCount === 0) {
            alert(
              'Không tìm thấy bài viết phù hợp với từ khóa: "' +
                searchTerm +
                '"'
            );
          }
        }

        searchBtn.addEventListener("click", performSearch);

        searchInput.addEventListener("keypress", function (e) {
          if (e.key === "Enter") {
            performSearch();
          }
        });

        // Load more functionality

        loadMoreBtn.addEventListener("click", function () {
          this.textContent = "Đang tải...";

          this.disabled = true;

          setTimeout(() => {
            alert("Đã hiển thị tất cả bài viết!");

            this.textContent = "Đã tải hết";
          }, 1000);
        });

        // Click on news card

        newsCards.forEach((card) => {
          card.addEventListener("click", function (e) {
            if (!e.target.classList.contains("news-link")) {
              const link = this.querySelector(".news-link");

              if (link) {
                window.location.href = link.getAttribute("href");
              }
            }
          });
        });

        // Recent posts click

        const recentPosts = document.querySelectorAll(".recent-post-item");

        recentPosts.forEach((post) => {
          post.addEventListener("click", function () {
            const title = this.querySelector(".recent-post-title").textContent;

            alert("Đang chuyển đến bài viết: " + title);
          });
        });
        
        // Load news from database
        loadNewsFromDB();

        // Initialize AOS if available

        if (typeof AOS !== "undefined") {
          AOS.init({
            duration: 800,

            once: true,

            offset: 100,
          });
        }
      });
      
      // Load news function
      async function loadNewsFromDB() {
        try {
          const response = await fetch('${pageContext.request.contextPath}/api/news/list');
          const result = await response.json();
          
          if (result.success && result.data && result.data.length > 0) {
            const newsGrid = document.getElementById('newsGrid');
            newsGrid.innerHTML = '';
            
            result.data.forEach(news => {
              const article = document.createElement('article');
              article.className = 'news-card';
              article.setAttribute('data-category', news.category);
              
              const publishedDate = new Date(news.publishedDate);
              const formattedDate = publishedDate.toLocaleDateString('vi-VN');
              
              article.innerHTML = '<div class="news-image-wrapper">' +
                '<img class="news-thumb" src="' + news.imageUrl + '" alt="' + news.title + '" onerror="this.src=\'https://via.placeholder.com/400x300?text=No+Image\'" />' +
                '<div class="news-overlay"></div>' +
                '</div>' +
                '<div class="news-content">' +
                  '<div class="news-meta">' +
                    '<span class="news-category">' + getCategoryName(news.category) + '</span>' +
                    '<span class="news-date">' + formattedDate + '</span>' +
                  '</div>' +
                  '<h2 class="news-heading">' + news.title + '</h2>' +
                  '<p class="news-excerpt">' + (news.excerpt || '') + '</p>' +
                  '<a href="${pageContext.request.contextPath}/news/' + news.slug + '" class="news-link">Xem chi tiết</a>' +
                '</div>';
              
              newsGrid.appendChild(article);
            });
            
            // Re-attach filter events
            filterButtons = document.querySelectorAll(".filter-btn");
            newsCards = document.querySelectorAll(".news-card");
            attachFilterEvents();
          }
        } catch (error) {
          console.error('Error loading news:', error);
        }
      }
      
      function getCategoryName(category) {
        const categories = {
          'tips': 'Tips chọn hoa',
          'opening': 'Khai trương',
          'story': 'Câu chuyện',
          'proposal': 'Cầu hôn',
          'wedding': 'Đám cưới',
          'birthday': 'Sinh nhật'
        };
        return categories[category] || category;
      }
      
      function attachFilterEvents() {
        filterButtons.forEach((btn) => {
          btn.addEventListener("click", function () {
            filterButtons.forEach((b) => b.classList.remove("active"));
            this.classList.add("active");

            const filter = this.getAttribute("data-filter");

            newsCards.forEach((card) => {
              const category = card.getAttribute("data-category");

              if (filter === "all" || category === filter) {
                card.style.display = "block";
              } else {
                card.style.display = "none";
              }
            });
          });
        });
      }

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
