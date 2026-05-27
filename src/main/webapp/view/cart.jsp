<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> <%@ page
isELIgnored="false" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="dollar" value="$" />

<!DOCTYPE html>

<html lang="vi">
  <head>
    <title>Giỏ hàng - Tiệm Hoa nhà tớ</title>
    
    <!-- CSRF Token -->
    <meta name="csrf-token" content="${csrfToken}">
    <script>window.csrfToken = '${csrfToken}';</script>
    <meta name="context-path" content="${pageContext.request.contextPath}">
    <script>window.CONTEXT_PATH = '${pageContext.request.contextPath}';</script>

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

    <link rel="canonical" href="https://lavieestbelle.vn/" />

    <meta name="robots" content="index,follow,noodp" />

    <meta property="og:type" content="website" />

    <meta property="og:title" content="La Vie Est Belle ( Flower & Gift)" />

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

    <meta
      property="og:image:alt"
      content="La Vie Est Belle ( Flower &amp; Gift)"
    />

    <meta property="og:url" content="https://lavieestbelle.vn/" />

    <meta property="og:site_name" content="La Vie Est Belle - Flower & Gift" />
    <!-- Shop id asset -->

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

    <link rel="preconnect" href="https://fonts.googleapis.com" />

    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />

    <link
      href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Inter:wght@400;500;600;700&display=swap"
      rel="stylesheet"
    />

    <style>
      :root {
        --rose: #a97155;

        --rose-600: #8a5c44;

        --rose-200: #ead9ca;

        --ink: #2b2926;

        --muted: #7a6e65;

        --card: #ffffffcc;

        --ring: rgba(169, 113, 85, 0.35);

        --shadow: 0 10px 30px rgba(169, 113, 85, 0.18),
          0 8px 24px rgba(0, 0, 0, 0.06);

        --radius: 22px;

        --success: #10b981;

        --error: #ef4444;
      }

      .container {
        max-width: 1400px !important;

        margin: 0 auto !important;

        padding: 0 2rem !important;
      }

      .page-title {
        font-family: "Playfair Display", serif;

        font-size: 38px;

        line-height: 1.2;

        margin: 20px 0 8px;

        text-align: center;
      }

      .subtitle {
        color: var(--muted);

        font-size: 15px;

        text-align: center;

        margin-bottom: 32px;
      }

      .grid {
        display: grid;

        grid-template-columns: 1.2fr 0.8fr;

        gap: 24px;

        margin-bottom: 40px;
      }

      .card {
        background: var(--card);

        backdrop-filter: blur(8px);

        border: 1px solid #fff;

        border-radius: var(--radius);

        box-shadow: var(--shadow);
      }

      /* Cart Table */

      .cart {
        padding: 10px;
      }

      .cart-head {
        display: grid;

        grid-template-columns: 6fr 2fr 2fr 40px;

        gap: 10px;

        padding: 14px 18px;

        color: var(--muted);

        font-weight: 600;

        font-size: 14px;
      }

      .cart-row {
        display: grid;

        grid-template-columns: 6fr 2fr 2fr 40px;

        gap: 10px;

        align-items: center;

        padding: 14px 18px;

        border-top: 1px dashed #f0cddd;
      }

      .prod {
        display: flex;

        gap: 14px;

        align-items: center;
      }

      .photo {
        width: 78px;

        height: 78px;

        border-radius: 16px;

        overflow: hidden;

        flex: 0 0 auto;

        box-shadow: 0 6px 18px rgba(0, 0, 0, 0.06);
      }

      .photo img {
        width: 100%;

        height: 100%;

        object-fit: cover;
      }

      .name {
        font-weight: 600;

        font-size: 15px;
      }

      .meta {
        color: var(--muted);

        font-size: 13px;

        margin-top: 3px;
      }

      .qty-pill {
        display: inline-flex;

        align-items: center;

        border: 1px solid var(--rose-200);

        border-radius: 999px;

        padding: 4px 8px;

        font-weight: 700;

        gap: 8px;
      }
      
      .qty-btn {
        width: 28px;
        height: 28px;
        border: none;
        background: var(--rose-100);
        color: var(--rose-600);
        border-radius: 50%;
        cursor: pointer;
        font-size: 16px;
        font-weight: bold;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.2s;
        user-select: none;
      }
      
      .qty-btn:hover {
        background: var(--rose-200);
        transform: scale(1.1);
      }
      
      .qty-btn:active {
        transform: scale(0.95);
      }
      
      .qty-btn:disabled {
        opacity: 0.4;
        cursor: not-allowed;
      }
      
      .qty-number {
        min-width: 30px;
        text-align: center;
        font-size: 15px;
      }

      .price {
        font-weight: 700;

        font-size: 15px;
      }

      .remove {
        display: grid;

        place-items: center;

        width: 36px;

        height: 36px;

        border-radius: 50%;

        border: 1px solid #ead9ca;

        background: #fff;

        cursor: pointer;

        transition: all 0.2s;
      }

      .remove:hover {
        background: var(--rose-200);

        transform: scale(1.05);
      }

      /* Summary */

      .summary {
        position: sticky;

        top: 20px;

        padding: 18px;
      }

      .section-title {
        display: flex;

        align-items: center;

        gap: 8px;

        font-weight: 800;

        padding: 16px 18px;

        font-size: 16px;
      }

      .sum-row {
        display: flex;

        align-items: center;

        justify-content: space-between;

        margin: 10px 0;

        font-size: 15px;
      }

      .sum-row.muted {
        color: var(--muted);
      }

      .sum-total {
        display: flex;

        align-items: center;

        justify-content: space-between;

        border-top: 1px dashed #f0cddd;

        margin-top: 14px;

        padding-top: 14px;

        font-weight: 800;

        font-size: 18px;
      }

      .code {
        display: flex;

        gap: 10px;

        margin: 12px 0;
      }

      .code input {
        flex: 1;

        padding: 12px 14px;

        border-radius: 14px;

        border: 1px solid var(--rose-200);

        background: #fff;

        font-size: 14px;
      }

      .btn {
        appearance: none;

        border: 0;

        background: var(--rose);

        color: #fff;

        font-weight: 700;

        border-radius: 16px;

        padding: 12px 16px;

        cursor: pointer;

        box-shadow: 0 8px 20px var(--ring);

        text-decoration: none;

        display: inline-block;

        text-align: center;

        font-size: 14px;

        transition: all 0.3s;
      }

      .btn:hover {
        background: var(--rose-600);

        transform: translateY(-2px);
      }

      .btn.secondary {
        background: #fff;

        color: var(--ink);

        border: 1px solid var(--rose-200);

        box-shadow: none;
      }

      .btn.secondary:hover {
        background: var(--rose-200);
      }

      .actions {
        display: flex;

        gap: 12px;

        margin-top: 14px;

        flex-wrap: wrap;
      }

      .actions .btn {
        flex: 1;

        min-width: 140px;
      }

      .note textarea {
        width: 100%;

        min-height: 86px;

        padding: 12px 14px;

        border-radius: 14px;

        border: 1px solid var(--rose-200);

        resize: vertical;

        font-family: inherit;

        font-size: 14px;
      }

      /* Modal Styles */

      .modal-overlay {
        position: fixed;

        inset: 0;

        background: rgba(0, 0, 0, 0.5);

        backdrop-filter: blur(4px);

        display: none;

        align-items: center;

        justify-content: center;

        z-index: 9999;

        animation: fadeIn 0.3s;
      }

      .modal-overlay.active {
        display: flex;
      }

      .modal-content {
        background: white;

        border-radius: 24px;

        padding: 32px;

        max-width: 500px;

        width: 90%;

        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);

        animation: slideUp 0.3s;
      }

      .modal-header {
        font-family: "Playfair Display", serif;

        font-size: 28px;

        margin-bottom: 16px;

        color: var(--ink);
      }

      .modal-body {
        color: var(--muted);

        font-size: 15px;

        line-height: 1.6;

        margin-bottom: 24px;
      }

      .modal-actions {
        display: flex;

        gap: 12px;

        justify-content: flex-end;
      }

      .modal-actions .btn {
        min-width: 120px;
      }

      /* Invoice Styles */

      .invoice {
        background: white;

        border-radius: 20px;

        padding: 24px;

        max-width: 600px;

        margin: 0 auto;

        max-height: 70vh;

        overflow-y: auto;
      }

      .invoice-header {
        text-align: center;

        border-bottom: 2px solid var(--rose-200);

        padding-bottom: 16px;

        margin-bottom: 20px;
      }

      .invoice-header h2 {
        font-family: "Playfair Display", serif;

        font-size: 26px;

        color: var(--rose);

        margin-bottom: 6px;
      }

      .invoice-header p {
        font-size: 13px;

        color: var(--muted);
      }

      .invoice-info {
        display: grid;

        grid-template-columns: 1fr 1fr;

        gap: 16px;

        margin-bottom: 20px;
      }

      .invoice-section h3 {
        font-size: 12px;

        color: var(--muted);

        margin-bottom: 6px;

        text-transform: uppercase;

        letter-spacing: 0.5px;

        font-weight: 600;
      }

      .invoice-section p {
        color: var(--ink);

        font-size: 13px;

        line-height: 1.5;
      }

      .invoice-items {
        margin-bottom: 20px;
      }

      .invoice-items h3 {
        font-size: 14px;

        margin-bottom: 12px;

        color: var(--ink);

        font-weight: 600;
      }

      .invoice-item {
        display: flex;

        justify-content: space-between;

        align-items: flex-start;

        padding: 12px 0;

        border-bottom: 1px dashed var(--rose-200);

        gap: 12px;
      }

      .invoice-item:last-child {
        border-bottom: none;
      }

      .invoice-item-info {
        flex: 1;

        min-width: 0;
      }

      .invoice-item-name {
        font-weight: 600;

        margin-bottom: 3px;

        font-size: 14px;
      }

      .invoice-item-meta {
        font-size: 12px;

        color: var(--muted);
      }

      .invoice-item-price {
        font-weight: 700;

        color: var(--rose);

        font-size: 14px;

        white-space: nowrap;
      }

      .invoice-note {
        background: #faf3ea;

        padding: 12px;

        border-radius: 10px;

        margin-bottom: 20px;
      }

      .invoice-note h3 {
        font-size: 11px;

        color: var(--muted);

        margin-bottom: 6px;

        text-transform: uppercase;

        letter-spacing: 0.5px;
      }

      .invoice-note p {
        font-style: italic;

        color: var(--ink);

        font-size: 13px;

        line-height: 1.5;
      }

      .invoice-total {
        border-top: 2px solid var(--rose);

        padding-top: 12px;
      }

      .invoice-total-row {
        display: flex;

        justify-content: space-between;

        margin: 6px 0;

        font-size: 14px;
      }

      .invoice-total-row.grand {
        font-size: 18px;

        font-weight: 800;

        color: var(--rose);

        margin-top: 12px;

        padding-top: 8px;

        border-top: 1px dashed var(--rose-200);
      }

      .invoice-footer {
        text-align: center;

        margin-top: 20px;

        padding-top: 16px;

        border-top: 1px solid var(--rose-200);

        color: var(--muted);

        font-size: 12px;

        line-height: 1.6;
      }

      .success-icon {
        width: 60px;

        height: 60px;

        margin: 0 auto 16px;

        background: var(--success);

        border-radius: 50%;

        display: flex;

        align-items: center;

        justify-content: center;

        font-size: 32px;

        color: white;
      }

      @keyframes fadeIn {
        from {
          opacity: 0;
        }

        to {
          opacity: 1;
        }
      }

      @keyframes slideUp {
        from {
          opacity: 0;

          transform: translateY(20px);
        }

        to {
          opacity: 1;

          transform: translateY(0);
        }
      }

      @media (max-width: 980px) {
        .grid {
          grid-template-columns: 1fr;
        }

        .cart-head {
          display: none;
        }

        .cart-row {
          grid-template-columns: 1fr;

          gap: 12px;
        }

        .prod {
          flex-direction: column;

          text-align: center;
        }

        .actions {
          flex-direction: column;
        }

        .actions .btn {
          width: 100%;
        }

        .invoice {
          padding: 24px;
        }

        .invoice-info {
          grid-template-columns: 1fr;
        }
      }

      .empty-cart {
        text-align: center;

        padding: 60px 20px;
      }

      .empty-cart-icon {
        font-size: 64px;

        margin-bottom: 16px;
      }

      .print-btn {
        margin-top: 24px;
      }

      @media print {
        body {
          background: white;
        }

        .btn,
        .modal-overlay {
          display: none !important;
        }
      }

      /* AI Card Modal Styles */

      .ai-modal-backdrop {
        position: fixed;

        inset: 0;

        background: rgba(33, 26, 19, 0.45);

        backdrop-filter: saturate(120%) blur(2px);

        display: none;

        z-index: 9998;
      }

      .ai-modal-backdrop.active {
        display: block;
      }

      .ai-modal {
        position: fixed;

        inset: 0;

        display: none;

        place-items: center;

        z-index: 9999;

        padding: 18px;

        overflow-y: auto;
      }

      .ai-modal.active {
        display: grid;
      }

      .ai-card {
        width: min(1080px, 96vw);

        max-height: 88vh;

        overflow: auto;

        background: linear-gradient(180deg, #fff 0%, #fffdfc 50%, #ffffff 100%);

        border: 1px solid #fff;

        border-radius: 26px;

        box-shadow: 0 20px 60px rgba(33, 26, 19, 0.18);

        padding: 18px 18px 22px;
      }

      .ai-head {
        position: sticky;

        top: 0;

        background: linear-gradient(
          180deg,
          #ffffff 70%,
          rgba(255, 255, 255, 0)
        );

        z-index: 1;

        display: flex;

        gap: 10px;

        justify-content: space-between;

        align-items: center;

        margin: -6px -6px 8px;

        padding: 10px 6px 12px;
      }

      .ai-head h3 {
        margin: 0;

        font-family: "Playfair Display", serif;

        font-size: 28px;

        letter-spacing: 0.2px;

        color: var(--ink);
      }

      .ai-close {
        border: 0;

        background: #fff;

        border: 1px solid var(--rose-200);

        width: 38px;

        height: 38px;

        border-radius: 999px;

        cursor: pointer;

        line-height: 38px;

        transition: all 0.2s;
      }

      .ai-close:hover {
        background: var(--rose-200);

        transform: scale(1.05);
      }

      .ai-grid {
        display: grid;

        grid-template-columns: 420px 1fr;

        gap: 18px;

        align-items: start;
      }

      @media (max-width: 1024px) {
        .ai-grid {
          grid-template-columns: 1fr;
        }
      }

      .ai-field {
        display: flex;

        flex-direction: column;

        gap: 6px;

        margin: 8px 0;
      }

      .ai-field label {
        font-size: 13px;

        color: var(--muted);

        font-weight: 500;
      }

      .ai-field input,
      .ai-field select,
      .ai-field textarea {
        padding: 12px 14px;

        border: 1px solid var(--rose-200);

        border-radius: 16px;

        background: #fff;

        font-size: 14px;

        color: var(--ink);

        font-family: inherit;
      }

      .ai-field input:focus,
      .ai-field select:focus,
      .ai-field textarea:focus {
        outline: none;

        border-color: var(--rose);

        box-shadow: 0 0 0 3px var(--ring);
      }

      .ai-row {
        display: grid;

        grid-template-columns: 1fr 1fr;

        gap: 12px;
      }

      .ai-actions {
        display: flex;

        gap: 10px;

        margin-top: 12px;

        flex-wrap: wrap;
      }

      .ai-btn {
        appearance: none;

        border: 0;

        background: var(--rose);

        color: #fff;

        font-weight: 700;

        border-radius: 18px;

        padding: 12px 16px;

        cursor: pointer;

        box-shadow: 0 8px 20px rgba(169, 113, 85, 0.28);

        transition: all 0.3s;
        
        font-size: 14px;
      }

      .ai-btn.primary {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        
        box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
        
        font-size: 16px;
        
        padding: 14px 24px;
      }
      
      .ai-btn.primary:hover {
        transform: translateY(-2px);
        
        box-shadow: 0 12px 30px rgba(102, 126, 234, 0.5);
      }
      
      @keyframes slideIn {
        from {
          transform: translateX(400px);
          opacity: 0;
        }
        to {
          transform: translateX(0);
          opacity: 1;
        }
      }
      
      @keyframes slideOut {
        from {
          transform: translateX(0);
          opacity: 1;
        }
        to {
          transform: translateX(400px);
          opacity: 0;
        }
      }

      .ai-btn:hover {
        background: var(--rose-600);

        transform: translateY(-2px);
      }

      .ai-btn.secondary {
        background: #fff;

        color: var(--ink);

        border: 1px solid var(--rose-200);

        box-shadow: none;
      }

      .ai-btn.secondary:hover {
        background: var(--rose-200);
      }

      .ai-hint {
        color: var(--muted);

        font-size: 12.5px;
      }

      .ai-canvas-wrap {
        background: linear-gradient(180deg, #fff, #fffdfc);

        border: 1px solid #f6e7da;

        border-radius: 18px;

        display: grid;

        place-items: center;

        min-height: 360px;

        padding: 14px;
      }

      canvas.ai-canvas {
        width: 100%;

        height: auto;

        display: block;

        border-radius: 14px;

        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
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
    <script src="${pageContext.request.contextPath}/js/csrf-helper.js"></script>
    
    <link
      href="//cdn.hstatic.net/themes/200000846175/1001403720/14/main-scripts.js?v=245"
      rel="preload"
      as="script"
      type="text/javascript"
    />

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
          "2 giờ trước",
          "15 phút trước",
          "8 phút trước",
          "35 phút trước",
          "14 phút trước",
          "3 giờ trước",
          "1 giờ trước",
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

    <!-- SweetAlert2 CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.5/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.5/dist/sweetalert2.all.min.js"></script>

    <!-- Notification System Utility -->
    <script src="${pageContext.request.contextPath}/js/notification.js"></script>
    
    <!-- AI Card Feature - Modern CSS & JS Modules -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ai-card.css">
  </head>

  <body id="wandave-theme" class="index" data-theme="tbag-fashion">
    <%@ include file="partials/header.jsp" %>

    <div class="container" id="mainContent">
      <h1 class="page-title">Giỏ hàng của bạn</h1>

      <p class="subtitle">
        Hoa tươi mỗi ngày — Đóng gói cẩn thận, giao trong 2–4h nội thành.
      </p>

      <div class="grid">
        <!-- LEFT: CART LIST -->

        <section class="card cart">
          <div class="cart-head">
            <div>Sản phẩm</div>

            <div>Số lượng</div>

            <div>Thành tiền</div>

            <div></div>
          </div>

          <div id="cartItems">
            <!-- Cart items will be inserted here -->
          </div>

          <div class="section-title">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
              <path
                d="M20 7v10a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V7"
                stroke="#a97155"
                stroke-width="1.4"
              />

              <path
                d="M8 7V5a4 4 0 0 1 8 0v2"
                stroke="#a97155"
                stroke-width="1.4"
              />
            </svg>

            Ghi lời chúc kèm bó hoa
          </div>

          <div class="note" style="padding: 0 18px 18px">
            <textarea
              id="giftNote"
              placeholder="VD: Chúc mừng sinh nhật em ✨"
            ></textarea>
          </div>
        </section>

        <!-- RIGHT: Order summary (cart page) -->
        <style>
          /* Order summary improvements: compact items, sticky card, buttons */
          .order-summary { }

          .checkout-card {
            background: var(--card);
            border-radius: 14px;
            box-shadow: var(--shadow);
            overflow: hidden;
            border: 1px solid rgba(0,0,0,0.03);
            position: sticky;
            top: calc(var(--height-head) + 16px);
          }

          .checkout-card .card-header{
            display:flex;
            align-items:center;
            gap:10px;
            padding:14px 18px;
            border-bottom: 1px solid rgba(0,0,0,0.04);
            background: linear-gradient(90deg, rgba(169,113,85,0.03), transparent);
          }

          .checkout-card .card-header h3{ margin:0; font-size:18px; }

          .checkout-card .card-body{ padding:12px 18px; }

          .summary-items .item{ display:flex; gap:12px; align-items:center; margin-bottom:12px; }
          .summary-items .item img{ width:56px; height:56px; object-fit:cover; border-radius:8px; }
          .summary-items .item .meta{ flex:1; }
          .summary-items .item .meta .name{ font-size:14px; color:var(--ink); margin-bottom:4px; }
          .summary-items .item .meta .qty{ color:var(--muted); font-size:13px; }

          .coupon-section .coupon-input{ display:flex; gap:8px; align-items:center; }
          .coupon-section .coupon-input input{ flex:1; padding:10px; border-radius:8px; border:1px solid #eee; }
          .coupon-btn{ background:var(--rose); color:#fff; border:none; padding:9px 12px; border-radius:8px; cursor:pointer; font-weight:600; }

          .summary-totals{ padding:12px 18px; }
          .total-row{ display:flex; justify-content:space-between; padding:6px 0; border-bottom:1px dashed #f3e9e3; }
          .total-row.grand-total{ border-bottom:none; font-weight:700; font-size:16px; }

          .btn{ padding:12px 14px; border-radius:10px; border:none; background:var(--rose); color:#fff; cursor:pointer; font-weight:600; }
          .btn.secondary{ background:#fff; border:1px solid #e6e6e6; color:var(--ink); }

          @media (max-width: 900px){
            .grid{ grid-template-columns: 1fr; }
            .checkout-card{ position: static; top: auto; }
            .order-summary{ margin-top: 18px; }
          }
        </style>

        <aside class="order-summary">
          <div class="checkout-card">
            <div class="card-header">
              <i class="fas fa-shopping-bag"></i>
              <h3>Đơn hàng của bạn</h3>
            </div>
            <div class="card-body">
              <div class="summary-items" id="summaryItems">
                <!-- JS will fill a compact summary of items here -->
              </div>
            </div>

            <!-- Coupon (cart) -->
            <div class="coupon-section" style="padding:12px 18px;">
              <div class="coupon-input" style="display:flex; gap:8px;">
                <input type="text" name="discountCode" id="discountCode" placeholder="Nhập mã giảm giá" style="flex:1; padding:8px; border-radius:8px; border:1px solid #eee;">
                <button type="button" class="coupon-btn" onclick="window.CartUI && window.CartUI.applyDiscount && window.CartUI.applyDiscount()">Áp dụng</button>
              </div>
              <div id="appliedCouponInfo" style="display: none; margin-top:10px; padding: 10px; background: #e8f5e9; border-radius: 8px; border-left: 3px solid #27ae60;">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                  <span style="color: #27ae60; font-weight: 500;"><i class="fas fa-check-circle"></i> Mã <strong id="appliedCouponCode"></strong></span>
                  <button onclick="removeCoupon()" style="background: none; border: none; color: #e74c3c; cursor: pointer; font-size: 14px;"><i class="fas fa-times"></i> Xóa</button>
                </div>
              </div>
            </div>

            <!-- Totals -->
                    <div class="summary-totals" style="padding:12px 18px;">
                      <div class="total-row">
                        <span>Tạm tính</span>
                        <span id="subtotal">0₫</span>
                      </div>
                      <div class="total-note" style="color:var(--muted); font-size:13px; margin-top:8px;">
                        Phí vận chuyển sẽ được tính ở bước thanh toán
                      </div>
                      <div class="total-row discount" id="discountRow" style="display: none;">
                        <span>Giảm giá</span>
                        <span id="discount">-0₫</span>
                      </div>
                      <div class="total-row grand-total" style="margin-top:8px; font-weight:700;">
                        <span>Tổng cộng</span>
                        <span class="amount" id="total">0₫</span>
                      </div>
                    </div>

                    <!-- Hidden fields used by checkout flow -->
                    <input type="hidden" name="subtotal" value="0">
                    <input type="hidden" name="discount" id="discountInput" value="0">
                    <input type="hidden" name="total" id="totalInput" value="0">
                    <input type="hidden" name="appliedCouponCode" id="appliedCouponCodeInput" value="">

            <!-- Actions -->
            <div style="padding:12px 18px; display:flex; gap:8px; flex-direction:column;">
              <button class="btn" onclick="showCheckoutConfirm()">Thanh toán</button>
              <button class="btn secondary" onclick="continueShopping()">Tiếp tục mua</button>
            </div>
          </div>
        </aside>
      </div>
    </div>

    <!-- Confirmation Modal -->

    <div class="modal-overlay" id="confirmModal">
      <div class="modal-content">
        <div class="modal-header">Xác nhận thanh toán</div>

        <div class="modal-body">
          <p>Bạn có chắc chắn muốn thanh toán đơn hàng này không?</p>

          <div
            style="
              margin-top: 16px;
              padding: 16px;
              background: #faf3ea;
              border-radius: 12px;
            "
          >
            <strong
              >Tổng tiền:
              <span id="confirmTotal" style="color: var(--rose)"
                >0₫</span
              ></strong
            >
          </div>
        </div>

        <div class="modal-actions">
          <button class="btn secondary" onclick="closeConfirmModal()">
            Hủy
          </button>

          <button class="btn" onclick="processCheckout()">Đồng ý</button>
        </div>
      </div>
    </div>

    <!-- Invoice Modal -->

    <div class="modal-overlay" id="invoiceModal">
      <div class="modal-content" style="max-width: 700px">
        <div class="invoice" id="invoiceContent">
          <!-- Invoice content will be generated here -->
        </div>

        <div class="modal-actions">
          <button class="btn secondary" onclick="printInvoice()">
            In hóa đơn
          </button>

          <button class="btn" onclick="closeInvoice()">Đóng</button>
        </div>
      </div>
    </div>

    <!-- AI Card Modal -->

    <div class="ai-modal-backdrop" id="aiCardBackdrop"></div>

    <div class="ai-modal" id="aiCardModal">
      <div class="ai-card">
        <div class="ai-head">
          <h3>Tạo thiệp tự động</h3>

          <button class="ai-close" onclick="closeAICardModal()">✕</button>
        </div>

        <div class="ai-grid">
          <!-- LEFT: form -->

          <div>
            <div class="ai-field">
              <label>Người nhận</label>

              <input id="aiTo" placeholder="VD: Em Linh / Ba mẹ / Anh Tuấn" />
            </div>

            <div class="ai-row">
              <div class="ai-field">
                <label>Dịp / Sự kiện</label>

                <select id="aiOccasion">
                  <option value="sinh nhật">Sinh nhật</option>

                  <option value="kỷ niệm">Kỷ niệm</option>

                  <option value="chúc mừng">Chúc mừng</option>

                  <option value="cảm ơn">Cảm ơn</option>

                  <option value="ngày đặc biệt">Ngày đặc biệt</option>

                  <option value="an ủi">An á»§i</option>
                </select>
              </div>

              <div class="ai-field">
                <label>Giọng điệu</label>

                <select id="aiTone">
                  <option value="ấm áp">Ấm áp</option>

                  <option value="hài hước">Hài hước</option>

                  <option value="trang trọng">Trang trọng</option>

                  <option value="ngọt ngào">Ngọt ngào</option>

                  <option value="động viên">Động viên</option>
                </select>
              </div>
            </div>

            <div class="ai-row">
              <div class="ai-field">
                <label>Độ dài</label>

                <select id="aiLength">
                  <option value="ngắn">Ngắn</option>

                  <option value="vừa">Vừa</option>

                  <option value="dài">Dài</option>
                </select>
              </div>

              <div class="ai-field">
                <label>Người gửi (ký tên)</label>

                <input id="aiFrom" placeholder="VD: Tên của bạn" />
              </div>
            </div>

            <div class="ai-field">
              <label>Lời nhắn thành công (tùy chọn)</label>

              <textarea
                id="aiManual"
                rows="3"
                placeholder="Nếu đã ghi lời chúc ở ô 'Ghi lời chúc kèm bó hoa', bấm 'Lấy lời nhắn từ giờ' để dùng lại."
              ></textarea>

              <div class="ai-actions">
                <button class="ai-btn secondary" onclick="grabNoteFromCart()">
                  Lấy lời nhắn từ giờ
                </button>

                <span class="ai-hint"
                  >Mẹo: để trống phần này nếu muốn AI tự sinh toàn bộ.</span
                >
              </div>
            </div>

            <div class="ai-actions">
              <button class="ai-btn primary" onclick="createNewCard()">
                🎨 Tạo thiệp mới
              </button>

              <button class="ai-btn secondary" onclick="downloadCard()">
                📥 Tải PNG
              </button>
            </div>
            
            <p class="ai-hint" style="margin-top: 8px; font-size: 13px;">
              💡 Mẹo: Nhấn "Tạo thiệp mới" để AI sinh câu chúc và tạo ảnh thiệp đẹp tự động!
            </p>
          </div>

          <!-- RIGHT: canvas preview -->

          <div>
            <div class="ai-canvas-wrap">
              <canvas
                id="aiCanvas"
                width="900"
                height="600"
                class="ai-canvas"
              ></canvas>
            </div>

            <p class="ai-hint" style="margin-top: 8px">
              Thiệp dùng tông nâu ấm của trang, kèm hoa 🌸.<br />Hình xuất
              PNG 900×600.
            </p>
          </div>
        </div>
      </div>
    </div>

    <%@ include file="partials/footer.jsp" %>

    <script>
      // Cart UI is implemented in js/cart-components.js for modularity and better UX
      let cartItems = [];
      window.cartItems = cartItems;
      let discountAmount = 0;
      let appliedCouponCode = null;
      const contextPath = '${pageContext.request.contextPath}';

      document.addEventListener('DOMContentLoaded', function() {
        if (window.CartUI && typeof window.CartUI.init === 'function') {
          window.CartUI.init(contextPath);
        }
      });

      function formatPrice(price) {
        return new Intl.NumberFormat("vi-VN", {
          style: "currency",

          currency: "VND",
        }).format(price);
      }
      
      function formatCurrency(amount) {
        return new Intl.NumberFormat("vi-VN", {
          style: "currency",
          currency: "VND",
        }).format(amount);
      }

      function renderCart() {
        const container = document.getElementById("cartItems");

        if (cartItems.length === 0) {
          container.innerHTML = `

          <div class="empty-cart">

            <div class="empty-cart-icon">🛒</div>

            <h3>Giỏ hàng trống</h3>

            <p style="color: var(--muted); margin: 12px 0;">Hãy thêm sản phẩm vào giỏ hàng!</p>

            <button class="btn" onclick="continueShopping()">Mua sắm ngay</button>

          </div>

        `;

          updateSummary();

          return;
        }

        container.innerHTML = cartItems
          .map(
            (item) => `

        <div class="cart-row">

          <div class="prod">

            <div class="photo">

              <img src="${dollar}{item.image}" alt="${dollar}{item.name}">

            </div>

            <div>

              <div class="name">${dollar}{item.name}</div>

              <div class="meta">${dollar}{item.meta}</div>

            </div>

          </div>

          <div>

            <div class="qty-pill">
              <button class="qty-btn" onclick="decreaseQuantity(${dollar}{item.id})" title="Giảm số lượng">−</button>
              <span class="qty-number">${dollar}{item.quantity}</span>
              <button class="qty-btn" onclick="increaseQuantity(${dollar}{item.id})" title="Tăng số lượng">+</button>
            </div>

          </div>

          <div class="price">${dollar}{formatPrice(item.price * item.quantity)}</div>

          <div>

            <div class="remove" onclick="removeItem(${dollar}{
              item.id
            })" title="Xóa">✕</div>

          </div>

        </div>

      `
          )
          .join("");

        updateSummary();
      }

      // Summary updates are handled by the modular CartUI in js/cart-components.js
      // to ensure debounced updates, optimistic UI and no shipping calculation on cart.

      function removeItem(id) {
        // Call API to remove item
        fetch(contextPath + '/api/cart?productId=' + id, {
          method: 'DELETE',
          headers: {
            'X-CSRF-Token': getCsrfToken()
          }
        })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            const remainingItems = cartItems.filter((item) => item.id !== id);
            cartItems.length = 0;
            remainingItems.forEach((item) => cartItems.push(item));
            renderCart();
            updateCartBadge(data.cartCount || data.itemCount || 0);
            showSuccess('Đã xóa sản phẩm khỏi giỏ hàng');
          } else {
            showError('Lỗi: ' + data.message);
          }
        })
        .catch(error => {
          console.error('Error:', error);
          // Fallback to local removal
          const remainingItems = cartItems.filter((item) => item.id !== id);
          cartItems.length = 0;
          remainingItems.forEach((item) => cartItems.push(item));
          renderCart();
        });
      }
      
      function increaseQuantity(id) {
        const item = cartItems.find((item) => item.id === id);
        if (item) {
          const newQuantity = item.quantity + 1;

          fetch(contextPath + '/api/cart', {
            method: 'PUT',
            headers: {
              'Content-Type': 'application/json',
              'X-CSRF-Token': getCsrfToken(),
            },
            body: JSON.stringify({ productId: id, quantity: newQuantity })
          })
          .then(response => response.json())
          .then(data => {
            if (!data.success) {
              showError(data.message || 'Không thể cập nhật số lượng');
              return;
            }
            item.quantity = newQuantity;
            renderCart();
            updateCartBadge(data.cartCount || data.itemCount || 0);
          })
          .catch(error => {
            console.error('Error updating quantity:', error);
            showError('Có lỗi xảy ra khi cập nhật số lượng');
          });
        }
      }
      
      function decreaseQuantity(id) {
        const item = cartItems.find((item) => item.id === id);
        if (item && item.quantity > 0) {
          const newQuantity = item.quantity - 1;

          if (newQuantity < 0) {
            return;
          }

          fetch(contextPath + '/api/cart', {
            method: 'PUT',
            headers: {
              'Content-Type': 'application/json',
              'X-CSRF-Token': getCsrfToken(),
            },
            body: JSON.stringify({ productId: id, quantity: newQuantity })
          })
          .then(response => response.json())
          .then(data => {
            if (!data.success) {
              showError(data.message || 'Không thể cập nhật số lượng');
              return;
            }

            if (newQuantity === 0) {
              const remainingItems = cartItems.filter((cartItem) => cartItem.id !== id);
              cartItems.length = 0;
              remainingItems.forEach((cartItem) => cartItems.push(cartItem));
            } else {
              item.quantity = newQuantity;
            }

            renderCart();
            updateCartBadge(data.cartCount || data.itemCount || 0);
          })
          .catch(error => {
            console.error('Error updating quantity:', error);
            showError('Có lỗi xảy ra khi cập nhật số lượng');
          });
        }
      }

      function updateCartBadge(count) {
        const badgeElements = document.querySelectorAll('.js-number-cart, .number-cart, .cart-count');
        badgeElements.forEach((el) => {
          if (count > 0) {
            el.textContent = count;
            el.style.display = 'inline-block';
          } else {
            el.textContent = '';
            el.style.display = 'none';
          }
        });
      }

      async function applyDiscount() {
        const discountInput = document.getElementById("discountCode");
        const code = discountInput.value.trim();

        if (!code) {
          showWarning("Vui lòng nhập mã giảm giá!");
          return;
        }

        if (cartItems.length === 0) {
          showWarning("Giỏ hàng đang trống, chưa thể áp mã giảm giá.");
          return;
        }

        const _source = (window.cartItems && Array.isArray(window.cartItems)) ? window.cartItems : (typeof cartItems !== 'undefined' ? cartItems : []);
        const subtotal = _source.reduce(
          (sum, item) => sum + item.price * item.quantity,
          0
        );

        try {
          const response = await fetch(contextPath + "/api/coupon/validate", {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              "X-CSRF-Token": getCsrfToken()
            },
            body: JSON.stringify({
              code: code,
              subtotal: subtotal
            })
          });

          const data = await response.json();

          if (response.ok && data.success) {
            discountAmount = parseFloat(data.discountAmount || 0);
            appliedCouponCode = code.toUpperCase();

            document.getElementById("appliedCouponInfo").style.display = "block";
            document.getElementById("appliedCouponCode").textContent = appliedCouponCode;
            discountInput.value = "";
            discountInput.disabled = true;

            updateSummary();
            showSuccess("Áp dụng mã giảm giá thành công! Giảm " + formatCurrency(discountAmount));
          } else {
            discountAmount = 0;
            appliedCouponCode = null;
            updateSummary();
            showError(data.message || "Mã giảm giá không hợp lệ!");
          }
        } catch (error) {
          console.error("Error validating coupon:", error);
          discountAmount = 0;
          appliedCouponCode = null;
          updateSummary();
          showError("Không thể kiểm tra mã giảm giá. Vui lòng thử lại!");
        }
      }

      // Remove applied coupon
      function removeCoupon() {
        discountAmount = 0;
        appliedCouponCode = null;
        
        document.getElementById("appliedCouponInfo").style.display = "none";
        document.getElementById("discountCode").disabled = false;
        document.getElementById("discountCode").value = "";
        
        updateSummary();
        showSuccess("Đã hủy mã giảm giá!");
      }

      function continueShopping() {
        window.location.href = contextPath + "/san-pham";
      }

      function showCheckoutConfirm() {
        if (cartItems.length === 0) {
          showWarning("Giỏ hàng trống!", "Thông báo");
          return;
        }

        // Chuyển đến trang thanh toán
        window.location.href = "${pageContext.request.contextPath}/checkout";
      }

      function closeConfirmModal() {
        document.getElementById("confirmModal").classList.remove("active");
      }

      function processCheckout() {
        closeConfirmModal();
        // Chuyển đến trang thanh toán
        window.location.href = "${pageContext.request.contextPath}/checkout";
      }

      function generateInvoice() {
        const now = new Date();

        const invoiceNumber = "INV" + now.getTime().toString().slice(-8);

        const giftNote = document.getElementById("giftNote").value.trim();

        const subtotal = cartItems.reduce(
          (sum, item) => sum + item.price * item.quantity,
          0
        );

        const total = subtotal - discountAmount; // shipping excluded on cart invoice

        const invoiceHTML = `

        <div class="success-icon">✓</div>

        <div class="invoice-header">

          <h2>Hóa Đơn Thanh Toán</h2>

          <p style="color: var(--muted); font-size: 14px;">Tiệm hoa nhà tớ</p>

        </div>



        <div class="invoice-info">

          <div class="invoice-section">

            <h3>Thông tin đơn hàng</h3>

            <p>

              Mã đơn: <strong>${dollar}{invoiceNumber}</strong><br>

              Ngày: ${dollar}{now.toLocaleDateString("vi-VN")}<br>

              Giờ: ${dollar}{now.toLocaleTimeString("vi-VN")}

            </p>

          </div>

          <div class="invoice-section">

            <h3>Thông tin khách hàng</h3>

            <p>

              Khách hàng VIP<br>

              Giao hàng: 2-4 giờ<br>

              Khu vực: Nội thành

            </p>

          </div>

        </div>



        <div class="invoice-items">

          <h3 style="margin-bottom: 16px; color: var(--ink);">Chi tiết đơn hàng</h3>

          ${dollar}{cartItems
            .map(
              (item) => `

                <div class="invoice-item">

              <div class="invoice-item-info">

                <div class="invoice-item-name">${dollar}{item.name}</div>

                <div class="invoice-item-meta">${dollar}{item.meta} × ${dollar}{
                item.quantity
              }</div>

              </div>

              <div class="invoice-item-price">${dollar}{formatPrice(
                item.price * item.quantity
              )}</div>

            </div>

          `
            )
            .join("")}

        </div>



        ${dollar}{
          giftNote
            ? `

          <div style="background: #faf3ea; padding: 16px; border-radius: 12px; margin-bottom: 24px;">

            <h3 style="font-size: 14px; color: var(--muted); margin-bottom: 8px;">LỜI CHÚC</h3>

            <p style="font-style: italic; color: var(--ink);">"${dollar}{giftNote}"</p>

          </div>

          `
            : ""
        }



        <div class="invoice-total">

          <div class="invoice-total-row">

            <span>Tạm tính</span>

            <span>${dollar}{formatPrice(subtotal)}</span>

          </div>

          <div class="invoice-total-row" style="color:var(--muted); font-size:13px;">
            <span>Phí giao hàng</span>
            <span>Được tính ở bước thanh toán</span>
          </div>

          ${dollar}{
            discountAmount > 0
              ? `

            <div class="invoice-total-row" style="color: var(--success);">

              <span>Giảm giá</span>

              <span>-${dollar}{formatPrice(discountAmount)}</span>

            </div>
              
          `
              : ""
          }

          <div class="invoice-total-row grand">

            <span>TỔNG CỘNG</span>

            <span>${dollar}{formatPrice(total)}</span>

          </div>

        </div>



        <div class="invoice-footer">

          <p>Cảm ơn bạn đã mua hàng tại Tiệm hoa nhà tớ!</p>

          <p style="margin-top: 8px;">Hotline: 0123 456 789 • tiemhoanhato.vn</p>

        </div>

      `;

        document.getElementById("invoiceContent").innerHTML = invoiceHTML;
      }

      function closeInvoice() {
        document.getElementById("invoiceModal").classList.remove("active");

        // Reset cart after closing invoice
        if (window.cartItems && Array.isArray(window.cartItems)) {
          window.cartItems.length = 0;
        }
        window.discountAmount = 0;

        document.getElementById("giftNote").value = "";

        document.getElementById("discountCode").value = "";

        if (window.CartUI && typeof window.CartUI.renderCart === 'function') {
          window.CartUI.renderCart();
        } else if (typeof renderCart === 'function') {
          renderCart();
        }
      }

      function printInvoice() {
        window.print();
      }

      // AI Card Functions - SIMPLIFIED (full logic moved to ai-card-module.js)
      // These functions maintain backward compatibility
      
      function showAICardModal() {
        if (window.aiCardModule) {
          aiCardModule.openModal();
        }
      }

      function closeAICardModal() {
        if (window.aiCardModule) {
          aiCardModule.closeModal();
        }
      }

      function createNewCard() {
        if (window.aiCardModule) {
          aiCardModule.handleCreateCard();
        }
      }

      function downloadCard() {
        if (window.aiCardModule) {
          aiCardModule.handleDownloadCard();
        }
      }
      
      // Legacy function placeholders for compatibility
      function grabNoteFromCart() {
        const note = document.getElementById("giftNote")?.value?.trim();
        if (note && window.aiCardModule?.store) {
          window.aiCardModule.store.updateField('customMessage', note);
        }
      }

      // Close modals when clicking outside

      document.querySelectorAll(".modal-overlay").forEach((modal) => {
        modal.addEventListener("click", (e) => {
          if (e.target === modal) {
            modal.classList.remove("active");
          }
        });
      });

      // Close AI modal when clicking backdrop

      document
        .getElementById("aiCardBackdrop")
        .addEventListener("click", closeAICardModal);

      // Initialize cart

      renderCart();
    </script>
    <script src="${pageContext.request.contextPath}/js/cart-components.js"></script>
    
    <!-- AI Card Feature - Modern JS Modules -->
    <script>
      // Set global contextPath for AI Card API
      const contextPath = '${pageContext.request.contextPath}';
    </script>
    <script src="${pageContext.request.contextPath}/js/ai-card-store.js"></script>
    <script src="${pageContext.request.contextPath}/js/ai-card-api.js"></script>
    <script src="${pageContext.request.contextPath}/js/ai-card-ui.js"></script>
    <script src="${pageContext.request.contextPath}/js/ai-card-module.js"></script>
  </body>
</html>
