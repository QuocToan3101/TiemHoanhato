<%@page contentType="text/html;charset=UTF-8" language="java"%><%@page
isELIgnored="false"%><%@taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core"%><%@taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    
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

    <title>Tiệm Hoa nhà tớ</title>

    <link rel="canonical" href="https://lavieestbelle.vn/" />

    <meta name="robots" content="index,follow,noodp" />

    <meta property="og:type" content="website" />

    <meta
      property="og:image"
      content="http://file.hstatic.net/200000846175/file/z5318389113228_bf05d1d394f756ddf038d8894726eb4c_cf4c6b6a880841b6b51d904a62b0035c.jpg"
    />

    <meta
      property="og:image"
      content="https://file.hstatic.net/200000846175/file/z5318389113228_bf05d1d394f756ddf038d8894726eb4c_cf4c6b6a880841b6b51d904a62b0035c.jpg"
    />

    <meta
      property="og:image:secure_url"
      content="https://file.hstatic.net/200000846175/file/z5318389113228_bf05d1d394f756ddf038d8894726eb4c_cf4c6b6a880841b6b51d904a62b0035c.jpg"
    />

    <meta
      property="og:image:secure_url"
      content="http://file.hstatic.net/200000846175/file/z5318389113228_bf05d1d394f756ddf038d8894726eb4c_cf4c6b6a880841b6b51d904a62b0035c.jpg"
    />

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

        --bg-flashsale: url(//cdn.hstatic.net/themes/200000846175/1001403720/14/bg-flashs-sale.jpg?v=245);

        --imgselect: url(//cdn.hstatic.net/themes/200000846175/1001403720/14/ico-select.svg?v=245);

        --imgsort: url(//cdn.hstatic.net/themes/200000846175/1001403720/14/sort-az.svg?v=245);

        --bgsubcribe: url("//cdn.hstatic.net/themes/200000846175/1001403720/14/modal-banner.jpg?v=245");

        --bg-filter: url("//cdn.hstatic.net/themes/200000846175/1001403720/14/filter.svg?v=245");

        --bg-google: url("//cdn.hstatic.net/themes/200000846175/1001403720/14/google-plus.png?v=245");

        --bg-facebook: url("//cdn.hstatic.net/themes/200000846175/1001403720/14/facebook.png?v=245");

        --heartpage: url(//cdn.hstatic.net/themes/200000846175/1001403720/14/hearts-page.svg?v=245);

        --customer: url(//cdn.hstatic.net/themes/200000846175/1001403720/14/customer-icon-service.svg?v=245);

        --cancel: url(//cdn.hstatic.net/themes/200000846175/1001403720/14/cancel-while.svg?v=245);

        --bg-footer: url(https://file.hstatic.net/200000397757/file/wd-footer-bg_bd337816b3d64003b9fa0ca6f4b8b3fa.png);
      }
    </style>

    <style>
      :root {
        --primary: #c99366;

        --primary-dark: #aa6a3f;

        --brown-main: #3c2922;

        --brown-soft: #6c5845;

        --bg-light: #faf5ef;

        --white: #ffffff;

        --shadow-sm: 0 2px 8px rgba(0, 0, 0, 0.08);

        --shadow-md: 0 4px 16px rgba(0, 0, 0, 0.12);

        --shadow-lg: 0 8px 32px rgba(0, 0, 0, 0.16);
      }

      * {
        margin: 0;

        padding: 0;

        box-sizing: border-box;
      }

      body {
        font-family: "Crimson Text", -apple-system, BlinkMacSystemFont,
          "Segoe UI", sans-serif;

        background: var(--bg-light);

        color: var(--brown-main);

        line-height: 1.6;

        overflow-x: hidden;
      }

      /* Hero Section */

      .hero {
        position: relative;

        min-height: 100vh;

        display: flex;

        align-items: center;

        background: linear-gradient(
            135deg,
            rgba(250, 245, 239, 0.95) 0%,
            rgba(255, 243, 235, 0.9) 100%
          ),
          url("https://images.unsplash.com/photo-1487070183336-b863922373d4?w=1600")
            center/cover;

        overflow: hidden;
      }

      .hero::before {
        content: "";

        position: absolute;

        top: -50%;

        right: -20%;

        width: 800px;

        height: 800px;

        background: radial-gradient(
          circle,
          rgba(201, 147, 102, 0.1) 0%,
          transparent 70%
        );

        border-radius: 50%;

        animation: float 20s infinite ease-in-out;
      }

      @keyframes float {
        0%,
        100% {
          transform: translate(0, 0) rotate(0deg);
        }

        50% {
          transform: translate(-30px, -30px) rotate(180deg);
        }
      }

      .hero-container {
        max-width: 1400px;

        margin: 0 auto;

        padding: 0 2rem;

        width: 100%;

        position: relative;

        z-index: 2;
      }

      .hero-content {
        display: grid;

        grid-template-columns: 1.2fr 1fr;

        gap: 4rem;

        align-items: center;
      }

      .hero-text h1 {
        font-size: 5rem;

        font-weight: 800;

        line-height: 1.1;

        margin-bottom: 1.5rem;

        background: linear-gradient(
          135deg,
          var(--brown-main),
          var(--primary-dark)
        );

        -webkit-background-clip: text;

        -webkit-text-fill-color: transparent;

        background-clip: text;
      }

      .hero-text p {
        font-size: 1.5rem;

        color: var(--brown-soft);

        margin-bottom: 2.5rem;

        font-style: italic;
      }

      .hero-search {
        background: white;

        border-radius: 60px;

        padding: 0.5rem;

        display: flex;

        align-items: center;

        box-shadow: var(--shadow-lg);

        margin-bottom: 2rem;

        max-width: 600px;
      }

      .hero-search input {
        flex: 1;

        border: none;

        outline: none;

        padding: 1rem 1.5rem;

        font-size: 1rem;

        background: transparent;
      }

      .hero-search button {
        background: linear-gradient(
          135deg,
          var(--primary),
          var(--primary-dark)
        );

        color: white;

        border: none;

        padding: 1rem 2.5rem;

        border-radius: 50px;

        font-weight: 600;

        cursor: pointer;

        transition: all 0.3s ease;

        box-shadow: 0 4px 15px rgba(201, 147, 102, 0.3);
      }

      .hero-search button:hover {
        transform: translateY(-2px);

        box-shadow: 0 6px 20px rgba(201, 147, 102, 0.4);
      }

      .hero-buttons {
        display: flex;

        gap: 1.5rem;

        flex-wrap: wrap;
      }

      .btn {
        padding: 1rem 2.5rem;

        border-radius: 50px;

        font-weight: 600;

        font-size: 1.1rem;

        cursor: pointer;

        transition: all 0.3s ease;

        text-decoration: none;

        display: inline-flex;

        align-items: center;

        gap: 0.75rem;

        border: none;
      }

      .btn-primary {
        background: linear-gradient(
          135deg,
          var(--primary),
          var(--primary-dark)
        );

        color: white;

        box-shadow: 0 8px 20px rgba(201, 147, 102, 0.3);
      }

      .btn-primary:hover {
        transform: translateY(-3px);

        box-shadow: 0 12px 30px rgba(201, 147, 102, 0.4);
      }

      .btn-secondary {
        background: white;

        color: var(--brown-main);

        border: 2px solid var(--primary);
      }

      .btn-secondary:hover {
        background: var(--primary);

        color: white;

        transform: translateY(-3px);
      }

      .hero-image {
        position: relative;

        perspective: 1000px;
      }

      .hero-card {
        position: relative;

        background: white;

        border-radius: 30px;

        overflow: hidden;

        box-shadow: var(--shadow-lg);

        transition: transform 0.6s ease;
      }

      .hero-badge {
        position: absolute;

        top: 1.5rem;

        left: 1.5rem;

        background: linear-gradient(135deg, #ff6b6b, #ee5a6f);

        color: white;

        padding: 0.5rem 1.25rem;

        border-radius: 50px;

        font-weight: 700;

        font-size: 0.9rem;

        box-shadow: 0 4px 15px rgba(255, 107, 107, 0.4);

        animation: pulse 2s infinite;
      }

      @keyframes pulse {
        0%,
        100% {
          transform: scale(1);
        }

        50% {
          transform: scale(1.05);
        }
      }

      /* Categories Section */

      .categories {
        padding: 5rem 0;

        background: white;
      }

      .container {
        max-width: 1400px;

        margin: 0 auto;

        padding: 0 2rem;
      }

      .section-header {
        text-align: center;

        margin-bottom: 4rem;
      }

      .section-title {
        font-size: 3rem;

        font-weight: 800;

        margin-bottom: 1rem;

        color: var(--brown-main);
      }

      .section-subtitle {
        font-size: 1.2rem;

        color: var(--brown-soft);
      }

      .categories-grid {
        display: grid;

        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));

        gap: 2rem;
      }

      .category-card {
        position: relative;

        border-radius: 20px;

        overflow: hidden;

        cursor: pointer;

        transition: all 0.4s ease;

        aspect-ratio: 1;
      }

      .category-card:hover {
        transform: translateY(-10px);
      }

      .category-card img {
        width: 100%;

        height: 100%;

        object-fit: cover;

        transition: transform 0.6s ease;
      }

      .category-card:hover img {
        transform: scale(1.1);
      }

      .category-overlay {
        position: absolute;

        bottom: 0;

        left: 0;

        right: 0;

        background: linear-gradient(
          180deg,
          transparent 0%,
          rgba(0, 0, 0, 0.8) 100%
        );

        padding: 2rem 1.5rem;

        color: white;

        transition: all 0.4s ease;
      }

      .category-card:hover .category-overlay {
        background: linear-gradient(
          180deg,
          rgba(201, 147, 102, 0.9) 0%,
          rgba(170, 106, 63, 0.95) 100%
        );
      }

      .category-name {
        font-size: 1.5rem;

        font-weight: 700;

        margin: 0;
      }

      /* Products Section */

      .products {
        padding: 5rem 0;

        background: var(--bg-light);
      }

      .products-grid {
        display: grid;

        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));

        gap: 2rem;
      }

      .product-card {
        background: white;

        border-radius: 20px;

        overflow: hidden;

        transition: all 0.4s ease;

        box-shadow: var(--shadow-sm);
      }

      .product-card:hover {
        transform: translateY(-10px);

        box-shadow: var(--shadow-lg);
      }

      .product-image {
        position: relative;

        width: 100%;

        height: 300px;

        overflow: hidden;
      }

      .product-badge {
        position: absolute;
        top: 12px;
        left: 12px;
        background: #e74c3c;
        color: #fff;
        padding: 4px 10px;
        border-radius: 999px;
        font-size: 0.75rem;
        font-weight: 600;
        z-index: 2;
      }

      .product-image img {
        width: 100%;

        height: 100%;

        object-fit: cover;

        transition: transform 0.6s ease;
      }

      .product-card:hover .product-image img {
        transform: scale(1.1);
      }

      .product-actions {
        position: absolute;

        top: 1rem;

        right: 1rem;

        display: flex;

        flex-direction: column;

        gap: 0.75rem;

        opacity: 0;

        transform: translateX(20px);

        transition: all 0.3s ease;
      }

      .product-card:hover .product-actions {
        opacity: 1;

        transform: translateX(0);
      }

      .action-btn {
        width: 45px;

        height: 45px;

        background: white;

        border: none;

        border-radius: 50%;

        display: flex;

        align-items: center;

        justify-content: center;

        cursor: pointer;

        transition: all 0.3s ease;

        box-shadow: var(--shadow-md);
      }

      .action-btn:hover {
        background: var(--primary);

        color: white;

        transform: scale(1.1);
      }

      .product-info {
        padding: 1.5rem;
      }

      .product-name {
        font-size: 1.25rem;

        font-weight: 700;

        margin-bottom: 0.5rem;

        color: var(--brown-main);
      }

      .product-price {
        font-size: 1.5rem;

        font-weight: 700;

        color: var(--primary-dark);
      }

      .product-add {
        width: 100%;

        padding: 0.875rem;

        background: linear-gradient(
          135deg,
          var(--primary),
          var(--primary-dark)
        );

        color: white;

        border: none;

        border-radius: 12px;

        font-weight: 600;

        cursor: pointer;

        margin-top: 1rem;

        transition: all 0.3s ease;
      }

      .product-add:hover {
        transform: translateY(-2px);

        box-shadow: 0 6px 16px rgba(201, 147, 102, 0.3);
      }

      /* Features Section */

      .features {
        padding: 5rem 0;

        background: white;
      }

      .features-grid {
        display: grid;

        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));

        gap: 3rem;
      }

      .feature-item {
        text-align: center;

        padding: 2rem;

        transition: all 0.3s ease;
      }

      .feature-item:hover {
        transform: translateY(-5px);
      }

      .feature-icon {
        font-size: 4rem;

        margin-bottom: 1.5rem;
      }

      .feature-title {
        font-size: 1.5rem;

        font-weight: 700;

        margin-bottom: 1rem;

        color: var(--brown-main);
      }

      .feature-desc {
        color: var(--brown-soft);

        line-height: 1.7;
      }

      /* Newsletter Section */

      .newsletter {
        padding: 5rem 0;

        background: linear-gradient(
          135deg,
          var(--primary),
          var(--primary-dark)
        );

        color: white;

        text-align: center;
      }

      .newsletter h2 {
        font-size: 3rem;

        font-weight: 800;

        margin-bottom: 1rem;
      }

      .newsletter p {
        font-size: 1.25rem;

        margin-bottom: 2.5rem;

        opacity: 0.95;
      }

      .newsletter-form {
        max-width: 600px;

        margin: 0 auto;

        display: flex;

        gap: 1rem;
      }

      .newsletter-form input {
        flex: 1;

        padding: 1.25rem 2rem;

        border-radius: 50px;

        border: none;

        font-size: 1rem;

        color: #333;

        outline: none;
      }
      
      .newsletter-form input::placeholder {
        color: #999;
      }

      .newsletter-form button {
        padding: 1.25rem 3rem;

        background: white;

        color: var(--primary-dark);

        border: none;

        border-radius: 50px;

        font-weight: 700;

        cursor: pointer;

        transition: all 0.3s ease;

        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
      }

      .newsletter-form button:hover {
        transform: translateY(-3px);

        box-shadow: 0 12px 30px rgba(0, 0, 0, 0.25);
      }

      /* Instagram Section */

      .instagram {
        padding: 5rem 0;

        background: var(--bg-light);
      }

      .instagram-grid {
        display: grid;

        grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));

        gap: 1.5rem;
      }

      .instagram-item {
        position: relative;

        aspect-ratio: 1;

        border-radius: 20px;

        overflow: hidden;

        cursor: pointer;
      }

      .instagram-item img {
        width: 100%;

        height: 100%;

        object-fit: cover;

        transition: transform 0.6s ease;
      }

      .instagram-item:hover img {
        transform: scale(1.1);
      }

      .instagram-overlay {
        position: absolute;

        top: 0;

        left: 0;

        right: 0;

        bottom: 0;

        background: linear-gradient(
          135deg,
          rgba(201, 147, 102, 0.9),
          rgba(170, 106, 63, 0.9)
        );

        display: flex;

        align-items: center;

        justify-content: center;

        opacity: 0;

        transition: opacity 0.3s ease;
      }

      .instagram-item:hover .instagram-overlay {
        opacity: 1;
      }

      .instagram-icon {
        font-size: 3rem;

        color: white;
      }

      /* Responsive */

      @media (max-width: 1024px) {
        .hero-content {
          grid-template-columns: 1fr;

          gap: 3rem;
        }

        .hero-text h1 {
          font-size: 3.5rem;
        }

        .hero-card {
          max-width: 500px;

          margin: 0 auto;
        }
      }

      @media (max-width: 768px) {
        .hero-text h1 {
          font-size: 2.5rem;
        }

        .hero-text p {
          font-size: 1.2rem;
        }

        .hero-buttons {
          flex-direction: column;
        }

        .btn {
          width: 100%;

          justify-content: center;
        }

        .section-title {
          font-size: 2rem;
        }

        .newsletter h2 {
          font-size: 2rem;
        }

        .newsletter-form {
          flex-direction: column;
        }

        .newsletter-form button {
          width: 100%;
        }
      }

      /* Loading Animation */

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

      .animate {
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
      rel="preload"
      as="image"
      href="//cdn.hstatic.net/themes/200000846175/1001403720/14/logo.png?v=245"
    />

    <link
      href="//cdn.hstatic.net/themes/200000846175/1001403720/14/styles-index.scss.css?v=245"
      rel="preload stylesheet"
      as="style"
      type="text/css"
    />

    <link
      rel="preload"
      as="image"
      href="//cdn.hstatic.net/themes/200000846175/1001403720/14/slideshow_1_mob_large.jpg?v=245"
      media="(max-width: 480px)"
    />

    <!-- jQuery từ CDN đáng tin cậy -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
    
    <!-- CSRF Token Helper - Tự động thêm token vào fetch/AJAX -->
    <script src="${pageContext.request.contextPath}/fileJS/csrf-token.js"></script>
    
    <link
      href="//cdn.hstatic.net/themes/200000846175/1001403720/14/main-scripts.js?v=245"
      rel="preload"
      as="script"
      type="text/javascript"
    />

    <script src="https://cdn.tailwindcss.com"></script>

    <!-- Tất cả biến khởi tạo, check sử dụng-->

    <script>
      localStorage.setItem("shop_id", "themes/200000846175/1001403720");

      const tbag_varible = {
        template: "index",

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

      const formatMoney = "{{amount}} VND",
        _0x2c0xa = [
          "\x43\x68\x72\x6F\x6D\x65\x2D\x4C\x69\x67\x68\x74\x68\x6F\x75\x73\x65",
          "\x69\x6E\x64\x65\x78\x4F\x66",
          "\x75\x73\x65\x72\x41\x67\x65\x6E\x74",
          "\x6C\x6F\x61\x64",
        ];

      function getScriptCcd(url, callback) {
        $.ajax({
          type: "GET",
          url: url,
          success: callback,
          dataType: "script",
          cache: true,
        });
      }

      function getdatasite(url, callback, slider) {
        $.ajax({
          type: "GET",
          url: url,
          success: function (data) {
            callback.html(data);
          },
        }).done(() => {
          slider == "true" ? Wanda.slidercallback() : "";
        });
      }

      if (navigator[_0x2c0xa[2]][_0x2c0xa[1]](_0x2c0xa[0]) == -1) {
        $(function () {
          const resultcss = `<link href="//cdn.hstatic.net/themes/200000846175/1001403720/14/render-after.scss.css?v=245" rel="preload stylesheet" as="style" type="text/css"><link href="//cdn.hstatic.net/themes/200000846175/1001403720/14/owl-carousel_modal.css?v=245" rel="preload stylesheet" as="style" type="text/css">`;

          $("head").append(resultcss);
        });

        $(window).load(() => {
          getScriptCcd(tbag_varible.recaptchajs);
        });
      }

      if (typeof Haravan === "undefined") {
        Haravan = {};
      }

      Haravan.shop = "lavieestbelle.vn";

      const tbag_radom = {
        item: [
          "peachy",
          "lovely-hue",
          "chic-petals",
          "pearl-bloom",
          "honey-ball",
          "classic-charm",
          "fresh-mood",
          "tulip-muse-1",
        ],

        name: [],

        time: [
          "20 phút trước",
          "2 giờ trước",
          "15 phút trước",
          "8 phút trước",
          "35 phút trước",
          "14 phút trước",
          "3 giờ trước",
          "1 giờ trước",
        ],
      };
    </script>

    <script type="text/javascript">
      //<![CDATA[

      if (typeof Haravan === "undefined") {
        Haravan = {};
      }

      Haravan.culture = "vi-VN";

      Haravan.shop = "lavieestbelle.myharavan.com";

      Haravan.theme = {
        name: "Customize Lavieestbelle",
        id: 1001403720,
        role: "main",
      };

      Haravan.domain = "lavieestbelle.vn";

      //]]>
    </script>

    <script
      defer
      src="https://stats.hstatic.net/beacon.min.js"
      hrv-beacon-t="200000846175"
    ></script>

    <style>
      .grecaptcha-badge {
        visibility: hidden;
      }
    </style>

    <script type="text/javascript">
      window.HaravanAnalytics = window.HaravanAnalytics || {};

      window.HaravanAnalytics.meta = window.HaravanAnalytics.meta || {};

      window.HaravanAnalytics.meta.currency = "VND";

      var meta = { page: { pageType: "home" } };

      for (var attr in meta) {
        window.HaravanAnalytics.meta[attr] = meta[attr];
      }

      window.HaravanAnalytics.AutoTrack = true;
    </script>

    <script>
      //<![CDATA[

      window.HaravanAnalytics.ga = "UA-000000000-1";

      window.HaravanAnalytics.enhancedEcommerce = false;

      (function (i, s, o, g, r, a, m) {
        i["GoogleAnalyticsObject"] = r;
        (i[r] =
          i[r] ||
          function () {
            (i[r].q = i[r].q || []).push(arguments);
          }),
          (i[r].l = 1 * new Date());
        (a = s.createElement(o)), (m = s.getElementsByTagName(o)[0]);
        a.async = 1;
        a.src = g;
        m.parentNode.insertBefore(a, m);
      })(
        window,
        document,
        "script",
        "//www.google-analytics.com/analytics.js",
        "ga"
      );

      ga("create", window.HaravanAnalytics.ga, "auto", { allowLinker: true });

      ga("send", "pageview");
      ga("require", "linker");
      try {
        if (window.location.href.indexOf("checkouts") > -1) {
          var themeid = Haravan.theme.id;

          !(function (e, t, n) {
            var a = t.getElementsByTagName(n)[0],
              c = t.createElement(n);
            (c.async = false),
              (c.src =
                "https://theme.hstatic.net/200000846175/" +
                themeid +
                "/14/main-tracking.js?v=" +
                new Date().getTime()),
              a.parentNode.insertBefore(c, a);
          })(window, document, "script");
        }
      } catch (e) {}

      //]]>
    </script>

    <script type="application/ld+json">
      {
        "@context": "http://schema.org",
        "@type": "WebSite",
        "name": "lavieestbelle.vn",
        "url": "https://lavieestbelle.vn",
        "potentialAction": {
          "@type": "SearchAction",
          "target": "https://lavieestbelle.vn/search?&q={search_term_string}",
          "query-input": "required name=search_term_string"
        }
      }
    </script>

    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet" />

    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
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

    <!-- End Google Tag Manager (noscript) -->

    <!-- Google Tag Manager (noscript) -->

    <noscript
      ><iframe
        src="https://www.googletagmanager.com/ns.html?id=GTM-NSBT6HTK"
        height="0"
        width="0"
        style="display: none; visibility: hidden"
      ></iframe
    ></noscript>

    <!-- End Google Tag Manager (noscript) -->

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
            style="background-position: -200px -400px"
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
            style="background-position: -0px -0px"
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
            style="background-position: -0px -200px"
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

    <main>
      <section class="hero">
        <div class="hero-container">
          <div class="hero-content">
            <div class="hero-text animate">
              <h1>Tiệm Hoa Nhà Tớ</h1>

              <p>Hoa tươi mỗi ngày – Gửi yêu thương trọn vẹn</p>

              <div class="hero-search">
                <input
                  type="text"
                  placeholder="Tìm bó hoa, giỏ hoa, lan hồ điệp..."
                  id="hero-search-input"
                />
                <button type="button" id="hero-search-btn">Tìm kiếm</button>
              </div>

              <div class="hero-buttons">
                <a href="#products" class="btn btn-primary">
                  Mua ngay

                  <span>→</span>
                </a>

                <a href="#categories" class="btn btn-secondary">
                  Khám phá bộ sưu tập
                </a>
              </div>
            </div>

            <div class="hero-image animate">
              <div class="hero-card">
                <span class="hero-badge">New</span>
                <model-viewer
                  src="/flowerstore/view/bouquet.glb"
                  alt="Bó hoa 3D"
                  camera-controls
                  auto-rotate
                  style="
                    width: 349px;
                    height: 384px;
                    background: #fff;
                    border-radius: 20px;
                    margin-left: 100px;
                  "
                  ar
                  shadow-intensity="1"
                  exposure="1"
                >
                </model-viewer>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Categories Section -->

      <section id="categories" class="categories">
        <div class="container">
          <div class="section-header animate">
            <h2 class="section-title">Danh Mục Nổi Bật</h2>

            <p class="section-subtitle">
              Khám phá các bộ sưu tập hoa tươi đẹp nhất
            </p>
          </div>

          <div class="categories-grid">
            <c:forEach var="category" items="${featuredCategories}">
              <a
                href="${pageContext.request.contextPath}/products/category/${category.slug}"
                class="category-card animate"
              >
                <img
                  src="${category.image != null ? category.image : 'https://via.placeholder.com/400x300?text=No+Image'}"
                  alt="${category.name}"
                  onerror="this.src='https://via.placeholder.com/400x300?text=No+Image'"
                />
                <div class="category-overlay">
                  <h3 class="category-name">${category.name}</h3>
                </div>
              </a>
            </c:forEach>

            <c:if test="${empty featuredCategories}">
              <!-- Fallback nếu không có dữ liệu từ DB -->
              <div class="category-card animate">
                <img
                  src="https://file.hstatic.net/200000846175/file/z5900937479779_23a78c66588e62ae16962ab99bf0d410.jpg"
                  alt="Bó hoa"
                />
                <div class="category-overlay">
                  <h3 class="category-name">BÓ HOA</h3>
                </div>
              </div>
              <div class="category-card animate">
                <img
                  src="https://file.hstatic.net/200000846175/file/z5899444875229_e1c7d0304e0a53ca2be88b52766f04e6.jpg"
                  alt="Bình hoa"
                />
                <div class="category-overlay">
                  <h3 class="category-name">BÌNH HOA</h3>
                </div>
              </div>
              <div class="category-card animate">
                <img
                  src="https://file.hstatic.net/200000846175/file/d7a376e45096e9c8b087-min.jpg"
                  alt="Hoa Tulip"
                />
                <div class="category-overlay">
                  <h3 class="category-name">HOA TULIP</h3>
                </div>
              </div>
              <div class="category-card animate">
                <img
                  src="https://file.hstatic.net/200000846175/file/z5900937515947_82c85e8a4d5c70527c21e29fce363cef.jpg"
                  alt="Giỏ hoa"
                />
                <div class="category-overlay">
                  <h3 class="category-name">GIỎ HOA</h3>
                </div>
              </div>
            </c:if>
          </div>
        </div>
      </section>

      <!-- Products Section -->

      <section id="products" class="products">
        <div class="container">
          <div class="section-header animate">
            <h2 class="section-title">Sản Phẩm Best Seller</h2>

            <p class="section-subtitle">Những bó hoa được yêu thích nhất</p>
          </div>

          <div class="products-grid">
            <c:forEach var="product" items="${bestSellerProducts}">
              <a
                href="${pageContext.request.contextPath}/products/${product.slug}"
                class="product-card animate"
                style="text-decoration: none"
              >
                <div class="product-image">
                  <img
                    src="${product.image != null ? product.image : 'https://via.placeholder.com/300x300?text=No+Image'}"
                    alt="${product.name}"
                    onerror="this.src='https://via.placeholder.com/300x300?text=No+Image'"
                  />
                  <c:if
                    test="${product.salePrice != null && product.salePrice > 0}"
                  >
                    <span class="product-badge"
                      >-<fmt:formatNumber
                        value="${(1 - product.salePrice / product.price) * 100}"
                        maxFractionDigits="0"
                      />%</span
                    >
                  </c:if>
                  <div class="product-actions">
                    <button
                      class="action-btn"
                      title="Yêu thích"
                      onclick="event.preventDefault(); event.stopPropagation();"
                    >
                      ♥
                    </button>
                    <button
                      class="action-btn"
                      title="Xem nhanh"
                      onclick="event.preventDefault(); event.stopPropagation();"
                    >
                      👁
                    </button>
                  </div>
                </div>

                <div class="product-info">
                  <h3 class="product-name">${product.name}</h3>
                  <div class="product-price">
                    <c:choose>
                      <c:when
                        test="${product.salePrice != null && product.salePrice > 0}"
                      >
                        <fmt:formatNumber
                          value="${product.salePrice}"
                          type="number"
                        />
                        VND
                        <span
                          style="
                            text-decoration: line-through;
                            color: #999;
                            font-size: 0.85em;
                            margin-left: 8px;
                          "
                        >
                          <fmt:formatNumber
                            value="${product.price}"
                            type="number"
                          />
                          VND
                        </span>
                      </c:when>
                      <c:otherwise>
                        <fmt:formatNumber
                          value="${product.price}"
                          type="number"
                        />
                        VND
                      </c:otherwise>
                    </c:choose>
                  </div>
                  <button class="product-add" data-product-id="${product.id}">
                    Thêm vào giỏ
                  </button>
                </div>
              </a>
            </c:forEach>

            <c:if test="${empty bestSellerProducts}">
              <!-- Fallback nếu không có dữ liệu -->
              <div class="product-card animate">
                <div class="product-image">
                  <img
                    src="https://cdn.hstatic.net/products/200000846175/z7055354732845_839654631ffda217c68a105a32e32e03-min_dc93e1d5a6ad42ada88d1d7e4cec57b9_1024x1024.jpg"
                    alt="Pure Blossom"
                  />
                  <div class="product-actions">
                    <button class="action-btn" title="Yêu thích">♥</button>
                    <button class="action-btn" title="Xem nhanh">👁</button>
                  </div>
                </div>
                <div class="product-info">
                  <h3 class="product-name">Pure Blossom</h3>
                  <div class="product-price">5,000,000 VND</div>
                  <button class="product-add">Thêm vào giỏ</button>
                </div>
              </div>
            </c:if>
          </div>
        </div>
      </section>

      <!-- Features Section -->

      <section class="features">
        <div class="container">
          <div class="features-grid">
            <div class="feature-item animate">
              <div class="feature-icon">🌸</div>

              <h3 class="feature-title">Hoa Tươi 100%</h3>

              <p class="feature-desc">
                Nhập khẩu trực tiếp, đảm bảo độ tươi mới tuyệt đối
              </p>
            </div>

            <div class="feature-item animate">
              <div class="feature-icon">🚚</div>

              <h3 class="feature-title">Giao Hàng Nhanh</h3>

              <p class="feature-desc">Giao hàng trong 2-4 giờ tại TP.HCM</p>
            </div>

            <div class="feature-item animate">
              <div class="feature-icon">💝</div>

              <h3 class="feature-title">Thiết Kế Độc Đáo</h3>

              <p class="feature-desc">
                Mỗi bó hoa đều là tác phẩm nghệ thuật riêng
              </p>
            </div>

            <div class="feature-item animate">
              <div class="feature-icon">⭐</div>

              <h3 class="feature-title">Dịch Vụ 5 Sao</h3>

              <p class="feature-desc">Hỗ trợ 24/7, tư vấn tận tình</p>
            </div>
          </div>
        </div>
      </section>

      <!-- Newsletter Section -->

      <section class="newsletter">
        <div class="container">
          <h2>Đăng Ký Nhận Ưu Đãi</h2>

          <p>Nhận ngay mã giảm giá 10% cho đơn hàng đầu tiên</p>

          <form class="newsletter-form">
            <input type="email" placeholder="Nhập email của bạn..." />

            <button type="submit">Đăng ký ngay</button>
          </form>
        </div>
      </section>

      <!-- Instagram Section -->

      <section class="instagram">
        <div class="container">
          <div class="section-header animate">
            <h2 class="section-title">Follow Us On Instagram</h2>

            <p class="section-subtitle">@tiemhoa.nhato</p>
          </div>

          <div class="instagram-grid">
            <div class="instagram-item animate">
              <img
                src="https://file.hstatic.net/200000846175/file/untitled-17_e9df1513d5094e93a17620ce62836d02_large.png"
                alt="Instagram 1"
              />

              <div class="instagram-overlay">
                <span class="instagram-icon">📷</span>
              </div>
            </div>

            <div class="instagram-item animate">
              <img
                src="https://file.hstatic.net/200000846175/file/untitled-19_3cd940d31f114594880318e2c90bb0ba_large.png"
                alt="Instagram 2"
              />

              <div class="instagram-overlay">
                <span class="instagram-icon">📷</span>
              </div>
            </div>

            <div class="instagram-item animate">
              <img
                src="https://file.hstatic.net/200000846175/file/untitled-20_d3e041d87d7246af8e26f6935032a81a_large.png"
                alt="Instagram 3"
              />

              <div class="instagram-overlay">
                <span class="instagram-icon">📷</span>
              </div>
            </div>

            <div class="instagram-item animate">
              <img
                src="https://file.hstatic.net/200000846175/file/untitled-21_e3ffb83959f14f208f4984f3b87da53d_large.png"
                alt="Instagram 4"
              />

              <div class="instagram-overlay">
                <span class="instagram-icon">📷</span>
              </div>
            </div>

            <div class="instagram-item animate">
              <img
                src="https://images.unsplash.com/photo-1487070183336-b863922373d4?w=400"
                alt="Instagram 8"
              />

              <div class="instagram-overlay">
                <span class="instagram-icon">📷</span>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>

    <%@ include file="partials/footer.jsp" %>

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
            <p class="modal-title">Thêm vào giỏ thành công</p>

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
            href=" https://zalo.me/3854304162857362827"
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

                <path
                  d="M17.6768 21.6754C18.5419 21.6754 19.3555 21.6698 20.1633 21.6754C20.6159 21.6809 20.8623 21.8638 20.9081 22.213C20.9597 22.6509 20.6961 22.9447 20.2034 22.9502C19.2753 22.9613 18.3528 22.9558 17.4247 22.9558C17.1554 22.9558 16.8919 22.9669 16.6226 22.9502C16.2903 22.9336 15.9637 22.8671 15.8033 22.5345C15.6429 22.2019 15.7575 21.9026 15.9752 21.631C16.8575 20.5447 17.7455 19.4527 18.6336 18.3663C18.6851 18.2998 18.7367 18.2333 18.7883 18.1723C18.731 18.0781 18.6508 18.1224 18.582 18.1169C17.9633 18.1114 17.3388 18.1169 16.72 18.1114C16.5768 18.1114 16.4335 18.0947 16.296 18.067C15.9695 17.995 15.7689 17.679 15.8434 17.3686C15.895 17.158 16.0669 16.9862 16.2846 16.9363C16.4221 16.903 16.5653 16.8864 16.7085 16.8864C17.7284 16.8809 18.7539 16.8809 19.7737 16.8864C19.9571 16.8809 20.1347 16.903 20.3123 16.9474C20.7019 17.0749 20.868 17.4241 20.7133 17.7899C20.5758 18.1058 20.3581 18.3774 20.1404 18.649C19.3899 19.5747 18.6393 20.4948 17.8888 21.4093C17.8258 21.4814 17.7685 21.5534 17.6768 21.6754Z"
                  fill="#000"
                ></path>

                <path
                  d="M24.3229 18.7604C24.4604 18.5886 24.6036 18.4279 24.8385 18.3835C25.2911 18.2948 25.7151 18.5775 25.7208 19.021C25.738 20.1295 25.7323 21.2381 25.7208 22.3467C25.7208 22.6349 25.526 22.8899 25.2453 22.973C24.9588 23.0783 24.6322 22.9952 24.4432 22.7568C24.3458 22.6404 24.3057 22.6183 24.1682 22.7236C23.6468 23.1338 23.0567 23.2058 22.4207 23.0063C21.4009 22.6848 20.9827 21.9143 20.8681 20.9776C20.7478 19.9632 21.0973 19.0986 22.0369 18.5664C22.816 18.1175 23.6067 18.1563 24.3229 18.7604ZM22.2947 20.7836C22.3061 21.0275 22.3863 21.2603 22.5353 21.4543C22.8447 21.8534 23.4348 21.9365 23.8531 21.6372C23.9218 21.5873 23.9848 21.5263 24.0421 21.4543C24.363 21.033 24.363 20.3402 24.0421 19.9189C23.8817 19.7027 23.6296 19.5752 23.3603 19.5697C22.7301 19.5309 22.289 20.002 22.2947 20.7836ZM28.2933 20.8168C28.2474 19.3923 29.2157 18.3281 30.5907 18.2893C32.0517 18.245 33.1174 19.1928 33.1632 20.5785C33.209 21.9808 32.321 22.973 30.9517 23.106C29.4563 23.2502 28.2704 22.2026 28.2933 20.8168ZM29.7313 20.6838C29.7199 20.961 29.8058 21.2326 29.9777 21.4598C30.2928 21.8589 30.8829 21.9365 31.2955 21.6261C31.3585 21.5818 31.41 21.5263 31.4616 21.4709C31.7939 21.0496 31.7939 20.3402 31.4673 19.9189C31.3069 19.7083 31.0548 19.5752 30.7855 19.5697C30.1668 19.5364 29.7313 19.991 29.7313 20.6838ZM27.7891 19.7138C27.7891 20.573 27.7948 21.4321 27.7891 22.2912C27.7948 22.6848 27.474 23.0118 27.0672 23.0229C26.9985 23.0229 26.924 23.0174 26.8552 23.0007C26.5688 22.9287 26.351 22.6349 26.351 22.2857V17.8791C26.351 17.6186 26.3453 17.3636 26.351 17.1031C26.3568 16.6763 26.6375 16.3992 27.0615 16.3992C27.4969 16.3936 27.7891 16.6708 27.7891 17.1142C27.7948 17.9789 27.7891 18.8491 27.7891 19.7138Z"
                  fill="#000"
                ></path>

                <path
                  d="M22.2947 20.7828C22.289 20.0013 22.7302 19.5302 23.3547 19.5634C23.6239 19.5745 23.876 19.702 24.0364 19.9181C24.3573 20.3339 24.3573 21.0322 24.0364 21.4535C23.7271 21.8526 23.1369 21.9357 22.7187 21.6364C22.65 21.5865 22.5869 21.5255 22.5296 21.4535C22.3864 21.2595 22.3062 21.0267 22.2947 20.7828ZM29.7314 20.683C29.7314 19.9957 30.1668 19.5357 30.7856 19.569C31.0549 19.5745 31.307 19.7075 31.4674 19.9181C31.794 20.3394 31.794 21.0544 31.4617 21.4701C31.1408 21.8636 30.545 21.9302 30.1382 21.6198C30.0752 21.5754 30.0236 21.52 29.9778 21.459C29.8059 21.2318 29.7257 20.9602 29.7314 20.683Z"
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

              <defs>
                <linearGradient
                  id="paint3_linear"
                  x1="21.6426"
                  y1="43.3555"
                  x2="21.6426"
                  y2="0.428639"
                  gradientUnits="userSpaceOnUse"
                >
                  <stop offset="50%" stop-color="#000000"></stop>

                  <stop offset="100%" stop-color="#000000"></stop>
                </linearGradient>
              </defs>
            </svg>
          </a>
        </li>
      </ul>
    </div>

    <div class="product-fixed-buy-mart visible-xs"></div>

    <div id="wrapper-box-sw-mb">
      <div class="result-swatch-mb"></div>
    </div>

    <div id="site-overlay-sw" class="site-overlay"></div>

    <div class="modal-backdrop fade"></div>

    <!-- Đây là suggest sale popup -->

    <div class="suggest-notify anislideOutDown sales_animated"></div>

    <script>
      // Intersection Observer for scroll animations

      const observerOptions = {
        threshold: 0.1,

        rootMargin: "0px 0px -50px 0px",
      };

      const observer = new IntersectionObserver((entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.style.opacity = "1";

            entry.target.style.transform = "translateY(0)";
          }
        });
      }, observerOptions);

      // Observe all animated elements

      document.addEventListener("DOMContentLoaded", () => {
        const animatedElements = document.querySelectorAll(".animate");

        animatedElements.forEach((el) => {
          el.style.opacity = "0";

          el.style.transform = "translateY(30px)";

          el.style.transition = "all 0.8s ease-out";

          observer.observe(el);
        });
      });

      // Smooth scroll for anchor links

      document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
        anchor.addEventListener("click", function (e) {
          e.preventDefault();

          const target = document.querySelector(this.getAttribute("href"));

          if (target) {
            target.scrollIntoView({
              behavior: "smooth",

              block: "start",
            });
          }
        });
      });

      // Add to cart functionality

      const addToCartButtons = document.querySelectorAll(".product-add");

      addToCartButtons.forEach((button) => {
        button.addEventListener("click", function () {
          const productName =
            this.closest(".product-info").querySelector(
              ".product-name"
            ).textContent;

          // Animation effect

          this.textContent = "Đã thêm! ✓";

          this.style.background = "linear-gradient(135deg, #4CAF50, #45a049)";

          setTimeout(() => {
            this.textContent = "Thêm vào giỏ";

            this.style.background =
              "linear-gradient(135deg, var(--primary), var(--primary-dark))";
          }, 2000);

          // Show notification

          showNotification(`Đã thêm "${productName}" vào giỏ hàng!`);
        });
      });

      // Wishlist functionality

      const wishlistButtons = document.querySelectorAll(".action-btn");

      wishlistButtons.forEach((button) => {
        if (button.title === "Yêu thích") {
          button.addEventListener("click", function () {
            this.style.color = this.style.color === "red" ? "" : "red";

            this.textContent = this.style.color === "red" ? "❤" : "♥";
          });
        }
      });

      // Newsletter form
      const newsletterForm = document.querySelector(".newsletter-form");

      if (newsletterForm) {
        newsletterForm.addEventListener("submit", async function (e) {
          e.preventDefault();

          const emailInput = this.querySelector('input[type="email"]');
          const email = emailInput.value.trim();
          const submitBtn = this.querySelector('button');

          if (!email) {
            showNotification("Vui lòng nhập email");
            return;
          }

          // Validate email
          const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
          if (!emailRegex.test(email)) {
            showNotification("Email không hợp lệ");
            return;
          }

          try {
            submitBtn.disabled = true;
            submitBtn.textContent = 'Đang gửi...';

            const response = await fetch('${pageContext.request.contextPath}/api/newsletter/subscribe', {
              method: 'POST',
              headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
              },
              body: 'email=' + encodeURIComponent(email)
            });

            const result = await response.json();

            if (result.success) {
              showNotification("Đăng ký thành công! Kiểm tra email để nhận mã giảm giá.");
              this.reset();
            } else {
              showNotification(result.message || "Đăng ký thất bại");
            }
          } catch (error) {
            console.error('Newsletter error:', error);
            showNotification("Có lỗi xảy ra. Vui lòng thử lại sau.");
          } finally {
            submitBtn.disabled = false;
            submitBtn.textContent = 'Đăng ký ngay';
          }
        });
      }

      // Search functionality
      const searchButton = document.querySelector(".hero-search button");
      const searchInput = document.querySelector(".hero-search input");

      if (searchButton && searchInput) {
        searchButton.addEventListener("click", function() {
          const searchTerm = searchInput.value.trim();

          if (searchTerm) {
            // Redirect to search page with query parameter
            const contextPath = '${pageContext.request.contextPath}';
            window.location.href = contextPath + '/search?q=' + encodeURIComponent(searchTerm);
          } else {
            showNotification('Điền từ khóa tìm kiếm');
          }
        });

        searchInput.addEventListener("keypress", function(e) {
          if (e.key === "Enter") {
            e.preventDefault();
            searchButton.click();
          }
        });
      }

      // Category cards click

      const categoryCards = document.querySelectorAll(".category-card");

      categoryCards.forEach((card) => {
        card.addEventListener("click", function () {
          const categoryName = this.querySelector(".category-name").textContent;

          showNotification(`Đang chuyển đến ${categoryName}...`);

          // Here you would typically redirect to the category page
        });
      });

      // Quick view functionality

      const quickViewButtons = document.querySelectorAll(
        '.action-btn[title="Xem nhanh"]'
      );

      quickViewButtons.forEach((button) => {
        button.addEventListener("click", function (e) {
          e.stopPropagation();

          const productName =
            this.closest(".product-card").querySelector(
              ".product-name"
            ).textContent;

          showNotification(`Xem nhanh: ${productName}`);

          // Here you would typically open a modal with product details
        });
      });

      // Notification function

      function showNotification(message) {
        // Remove existing notification if any

        const existingNotif = document.querySelector(".notification");

        if (existingNotif) {
          existingNotif.remove();
        }

        // Create notification

        const notification = document.createElement("div");

        notification.className = "notification";

        notification.textContent = message;

        notification.style.cssText = `

        position: fixed;

        top: 20px;

        right: 20px;

        background: linear-gradient(135deg, #4CAF50, #45a049);

        color: white;

        padding: 1rem 2rem;

        border-radius: 50px;

        box-shadow: 0 8px 20px rgba(0,0,0,0.2);

        z-index: 10000;

        animation: slideInRight 0.3s ease-out;

        max-width: 400px;

        font-weight: 600;

      `;

        document.body.appendChild(notification);

        // Auto remove after 3 seconds

        setTimeout(() => {
          notification.style.animation = "slideOutRight 0.3s ease-out";

          setTimeout(() => notification.remove(), 300);
        }, 3000);
      }

      // Add notification animations to CSS

      const style = document.createElement("style");

      style.textContent = `

      @keyframes slideInRight {

        from {

          transform: translateX(100%);

          opacity: 0;

        }

        to {

          transform: translateX(0);

          opacity: 1;

        }

      }



      @keyframes slideOutRight {

        from {

          transform: translateX(0);

          opacity: 1;

        }

        to {

          transform: translateX(100%);

          opacity: 0;

        }

      }



      /* Parallax effect for hero */

      .hero {

        background-attachment: fixed;

      }



      /* Hover effect for images */

      img {

        transition: filter 0.3s ease;

      }



      .product-card:hover img,

      .category-card:hover img {

        filter: brightness(1.1);

      }



      /* Custom scrollbar */

      ::-webkit-scrollbar {

        width: 10px;

      }



      ::-webkit-scrollbar-track {

        background: #f1f1f1;

      }



      ::-webkit-scrollbar-thumb {

        background: linear-gradient(180deg, var(--primary), var(--primary-dark));

        border-radius: 10px;

      }



      ::-webkit-scrollbar-thumb:hover {

        background: var(--primary-dark);

      }



      /* Selection color */

      ::selection {

        background: var(--primary);

        color: white;

      }

    `;

      document.head.appendChild(style);

      // Lazy loading images

      if ("IntersectionObserver" in window) {
        const imageObserver = new IntersectionObserver((entries, observer) => {
          entries.forEach((entry) => {
            if (entry.isIntersecting) {
              const img = entry.target;

              if (img.dataset.src) {
                img.src = img.dataset.src;

                img.removeAttribute("data-src");
              }

              observer.unobserve(img);
            }
          });
        });

        // Observe all images with data-src

        document.querySelectorAll("img[data-src]").forEach((img) => {
          imageObserver.observe(img);
        });
      }

      // Add floating animation to hero badge

      const heroBadge = document.querySelector(".hero-badge");

      if (heroBadge) {
        setInterval(() => {
          heroBadge.style.transform = "scale(1.05) rotate(5deg)";

          setTimeout(() => {
            heroBadge.style.transform = "scale(1) rotate(0deg)";
          }, 200);
        }, 2000);
      }

      // Instagram items click

      const instagramItems = document.querySelectorAll(".instagram-item");

      instagramItems.forEach((item) => {
        item.addEventListener("click", () => {
          window.open(
            "https://www.instagram.com/tiemhoa.lavieestbelle/",
            "_blank"
          );
        });
      });

      // Performance optimization: Debounce function

      function debounce(func, wait) {
        let timeout;

        return function executedFunction(...args) {
          const later = () => {
            clearTimeout(timeout);

            func(...args);
          };

          clearTimeout(timeout);

          timeout = setTimeout(later, wait);
        };
      }

      // Optimize scroll events

      let lastScrollTop = 0;

      const handleScroll = debounce(() => {
        const scrollTop =
          window.pageYOffset || document.documentElement.scrollTop;

        // Add/remove class based on scroll direction

        if (scrollTop > lastScrollTop && scrollTop > 100) {
          // Scrolling down

          document.body.classList.add("scrolled-down");
        } else {
          // Scrolling up

          document.body.classList.remove("scrolled-down");
        }

        lastScrollTop = scrollTop <= 0 ? 0 : scrollTop;
      }, 100);

      window.addEventListener("scroll", handleScroll);

      console.log("🌸 La Vie Est Belle - Website loaded successfully!");
    </script>

    <!-- Add to cart function for home page -->
    <script>
      // Event delegation for add to cart buttons
      document.addEventListener("DOMContentLoaded", function () {
        document.addEventListener("click", function (e) {
          const addButton = e.target.closest(".product-add[data-product-id]");
          if (addButton) {
            e.preventDefault();
            e.stopPropagation();
            const productId = addButton.getAttribute("data-product-id");
            addToCartHome(productId);
          }
        });
      });

      function addToCartHome(productId) {
        fetch("${pageContext.request.contextPath}/api/cart/add", {
          method: "POST",
          headers: { "Content-Type": "application/x-www-form-urlencoded" },
          body: "productId=" + productId + "&quantity=1",
        })
          .then((response) => response.json())
          .then((data) => {
            if (data.success) {
              alert("Đã thêm vào giỏ hàng!");
              // Update cart count if exists
              const cartCount = document.querySelector(".number-cart");
              if (cartCount && data.cartCount) {
                cartCount.textContent = data.cartCount;
              }
            } else {
              if (data.message && data.message.includes("đăng nhập")) {
                window.location.href =
                  "${pageContext.request.contextPath}/login";
              } else {
                alert(data.message || "Có lỗi xảy ra");
              }
            }
          })
          .catch((error) => {
            console.error("Error:", error);
            alert("Có lỗi xảy ra khi thêm vào giỏ hàng");
          });
      }
    </script>

    <script
      type="module"
      src="https://unpkg.com/@google/model-viewer/dist/model-viewer.min.js"
    ></script>

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

    <script>
      AOS.init();
    </script>

    <style>
      img[src*="//sstatic1.histats.com/0.gif"]
      {
        display: none !important;
      }
    </style>
  </body>
</html>
