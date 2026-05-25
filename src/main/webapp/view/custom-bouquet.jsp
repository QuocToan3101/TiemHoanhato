<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>Thiết kế bó hoa - Tiệm Hoa Nhà Tớ</title>

      <!-- Global JS Error Diagnostic Banner -->
      <script>
        window.addEventListener('error', function (e) {
          const errBanner = document.createElement('div');
          errBanner.style.position = 'fixed';
          errBanner.style.top = '0';
          errBanner.style.left = '0';
          errBanner.style.width = '100%';
          errBanner.style.background = '#e74c3c';
          errBanner.style.color = '#ffffff';
          errBanner.style.padding = '20px';
          errBanner.style.zIndex = '9999999';
          errBanner.style.fontFamily = 'sans-serif';
          errBanner.style.fontSize = '15px';
          errBanner.style.boxShadow = '0 10px 30px rgba(0,0,0,0.5)';
          errBanner.style.maxHeight = '250px';
          errBanner.style.overflowY = 'auto';
          errBanner.innerHTML = '<h3 style="margin:0 0 10px 0; font-size: 16px;">🔴 Phát hiện Lỗi JavaScript:</h3>' +
            '<strong>Lỗi:</strong> ' + e.message + '<br>' +
            '<strong>Tệp:</strong> ' + e.filename + ' (Dòng ' + e.lineno + ', Cột ' + e.colno + ')<br>' +
            (e.error && e.error.stack ? '<pre style="margin-top:10px; padding:10px; background:#c0392b; border-radius:4px; overflow-x:auto; font-family:monospace; color:#fff; font-size:12px; white-space:pre-wrap;">' + e.error.stack + '</pre>' : '');
          document.body.appendChild(errBanner);
          return false;
        });
      </script>

      <!-- CSRF Token -->
      <meta name="csrf-token" content="${csrfToken}">
      <script>window.csrfToken = '${csrfToken}';</script>

      <link rel="shortcut icon" href="//cdn.hstatic.net/themes/200000846175/1001403720/14/favicon.png?v=245"
        type="image/x-icon" />
      <link rel="preconnect" href="https://fonts.googleapis.com" />
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
      <link
        href="https://fonts.googleapis.com/css2?family=Crimson+Text:ital,wght@0,300;0,400;0,500;0,600;0,700;1,400;1,500;1,600;1,700&display=fallback"
        rel="stylesheet" />

      <!-- Theme CSS -->
      <link href="//cdn.hstatic.net/themes/200000846175/1001403720/14/plugin-style.css?v=245" rel="stylesheet" />
      <link href="//cdn.hstatic.net/themes/200000846175/1001403720/14/styles-new.scss.css?v=245" rel="stylesheet" />

      <!-- Font Awesome -->
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

      <!-- jQuery -->
      <script src="https://code.jquery.com/jquery-3.6.0.min.js"
        integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>

      <!-- CSRF Token Helper -->
      <script src="${pageContext.request.contextPath}/fileJS/csrf-token.js"></script>

      <!-- SweetAlert2 CDN -->
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.5/dist/sweetalert2.min.css">
      <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.5/dist/sweetalert2.all.min.js"></script>

      <!-- Notification System Utility -->
      <script src="${pageContext.request.contextPath}/js/notification.js"></script>

      <style>
        :root {
          --bouquet-bg-light: #faf5ef;
          --bouquet-card: rgba(255, 255, 255, 0.95);
          --bouquet-primary: #c99366;
          --bouquet-primary-dark: #aa6a3f;
          --bouquet-brown-main: #3c2922;
          --bouquet-brown-soft: #6c5845;
          --bouquet-muted: #8c7562;
          --bouquet-line: rgba(201, 147, 102, 0.16);
          --bouquet-shadow-sm: 0 4px 12px rgba(79, 48, 30, 0.04);
          --bouquet-shadow-md: 0 8px 24px rgba(79, 48, 30, 0.08);
          --bouquet-shadow-lg: 0 16px 40px rgba(79, 48, 30, 0.12);
          --bouquet-radius-xl: 20px;
          --bouquet-radius-lg: 12px;
          --bouquet-header-height: 72px;
        }

        * {
          box-sizing: border-box;
        }

        html {
          scroll-behavior: smooth;
        }

        body.bouquet-body {
          margin: 0;
          font-family: "Crimson Text", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
          color: var(--bouquet-brown-main);
          background:
            radial-gradient(circle at top left, rgba(213, 171, 131, 0.15), transparent 35%),
            radial-gradient(circle at top right, rgba(201, 147, 102, 0.08), transparent 30%),
            linear-gradient(180deg, #fffaf6 0%, var(--bouquet-bg-light) 100%);
          overflow-x: hidden;
        }

        .bouquet-page-shell {
          min-height: 100vh;
          display: flex;
          flex-direction: column;
        }

        .bouquet-main-container {
          padding-top: 32px !important;
          padding-bottom: 0 !important;
          height: calc(100vh - 72px);
          max-height: calc(100vh - 72px);
          overflow: hidden;
          box-sizing: border-box;
          flex: 1;
          display: flex;
          flex-direction: column;
        }

        .bouquet-main-container>.container {
          height: 100%;
          display: flex;
          flex-direction: column;
          padding-top: 16px;
          padding-bottom: 16px;
          box-sizing: border-box;
          min-height: 0;
        }

        .bouquet-builder-grid {
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: 32px;
          align-items: stretch;
          flex: 1;
          min-height: 0;
          box-sizing: border-box;
        }

        .bouquet-stepper-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          position: relative;
          margin-bottom: 20px;
          padding: 0 12px;
          flex-shrink: 0;
        }

        .bouquet-stepper-progress-line {
          position: absolute;
          top: 18px;
          left: 10%;
          right: 10%;
          height: 3px;
          background: rgba(201, 147, 102, 0.15);
          z-index: 1;
          border-radius: 2px;
        }

        .bouquet-stepper-progress-fill {
          height: 100%;
          background: linear-gradient(90deg, var(--bouquet-primary), var(--bouquet-primary-dark));
          width: 0%;
          transition: width 0.4s cubic-bezier(0.4, 0, 0.2, 1);
          border-radius: 2px;
        }

        .bouquet-stepper-step {
          display: flex;
          flex-direction: column;
          align-items: center;
          position: relative;
          z-index: 2;
          flex: 1;
        }

        .bouquet-stepper-step-node {
          width: 38px;
          height: 38px;
          border-radius: 50%;
          background: white;
          border: 2px solid rgba(201, 147, 102, 0.25);
          display: flex;
          align-items: center;
          justify-content: center;
          font-weight: 700;
          color: var(--bouquet-brown-soft);
          transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
          box-shadow: var(--bouquet-shadow-sm);
          font-size: 0.95rem;
        }

        .bouquet-stepper-step.active .bouquet-stepper-step-node {
          border-color: var(--bouquet-primary);
          background: var(--bouquet-primary);
          color: white;
          box-shadow: 0 0 12px rgba(201, 147, 102, 0.35);
          transform: scale(1.08);
        }

        .bouquet-stepper-step.completed .bouquet-stepper-step-node {
          border-color: var(--bouquet-primary-dark);
          background: var(--bouquet-primary-dark);
          color: white;
        }

        .bouquet-stepper-step-label {
          font-size: 0.9rem;
          font-weight: 600;
          margin-top: 8px;
          color: var(--bouquet-brown-soft);
          text-align: center;
          transition: color 0.3s;
        }

        .bouquet-stepper-step.active .bouquet-stepper-step-label {
          color: var(--bouquet-brown-main);
          font-weight: 700;
        }

        /* Force cards above overlays and transparent headers */
        .bouquet-stepper-card,
        .bouquet-preview-card {
          position: relative !important;
          z-index: 100 !important;
          border: 1px solid var(--bouquet-line);
          border-radius: var(--bouquet-radius-xl);
          background: var(--bouquet-card);
          backdrop-filter: blur(14px);
          -webkit-backdrop-filter: blur(14px);
          box-shadow: var(--bouquet-shadow-lg);
          padding: 24px;
          display: flex;
          flex-direction: column;
          height: 100%;
          min-height: 0;
          box-sizing: border-box;
          transition: transform 0.3s, box-shadow 0.3s;
        }

        .bouquet-stepper-card:hover,
        .bouquet-preview-card:hover {
          box-shadow: 0 20px 48px rgba(79, 48, 30, 0.16);
        }

        #customBouquetForm {
          display: flex;
          flex-direction: column;
          height: 100%;
          min-height: 0;
          position: relative;
          z-index: 102;
        }

        .bouquet-step-sections-wrapper,
        .bouquet-preview-card-body {
          flex: 1;
          overflow-y: auto;
          min-height: 0;
          box-sizing: border-box;
        }

        .bouquet-step-sections-wrapper {
          padding-right: 12px;
          margin-bottom: 12px;
        }

        .bouquet-preview-card-body {
          padding-right: 8px;
          display: flex;
          flex-direction: column;
          gap: 16px;
        }

        .bouquet-step-sections-wrapper::-webkit-scrollbar,
        .bouquet-preview-card-body::-webkit-scrollbar {
          width: 5px;
        }

        .bouquet-step-sections-wrapper::-webkit-scrollbar-track,
        .bouquet-preview-card-body::-webkit-scrollbar-track {
          background: rgba(201, 147, 102, 0.05);
          border-radius: 999px;
        }

        .bouquet-step-sections-wrapper::-webkit-scrollbar-thumb,
        .bouquet-preview-card-body::-webkit-scrollbar-thumb {
          background: rgba(201, 147, 102, 0.25);
          border-radius: 999px;
        }

        .bouquet-step-sections-wrapper::-webkit-scrollbar-thumb:hover,
        .bouquet-preview-card-body::-webkit-scrollbar-thumb:hover {
          background: var(--bouquet-primary);
        }

        .bouquet-step-section {
          display: none;
          animation: bouquetFadeIn 0.3s ease;
        }

        .bouquet-step-section.active {
          display: block;
        }

        @keyframes bouquetFadeIn {
          from {
            opacity: 0;
            transform: translateY(8px);
          }

          to {
            opacity: 1;
            transform: translateY(0);
          }
        }

        .bouquet-step-title {
          font-size: 1.45rem;
          font-weight: 700;
          margin-bottom: 4px;
          color: var(--bouquet-brown-main);
          display: flex;
          align-items: center;
          gap: 10px;
        }

        .bouquet-step-desc {
          color: var(--bouquet-brown-soft);
          font-size: 0.92rem;
          line-height: 1.45;
          margin-bottom: 20px;
        }

        .bouquet-studio-field-title {
          font-size: 1.05rem;
          font-weight: 700;
          margin-bottom: 10px;
          color: var(--bouquet-brown-main);
          display: block;
        }

        .bouquet-option-grid {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(115px, 1fr));
          gap: 10px;
          margin-bottom: 20px;
        }

        /* Force visual options to always capture clicks by completely bypassing children events */
        .bouquet-option-card,
        .bouquet-color-card,
        .bouquet-chip-item {
          position: relative !important;
          z-index: 110 !important;
          pointer-events: auto !important;
          cursor: pointer !important;
        }

        .bouquet-option-card * {
          pointer-events: none !important;
        }

        .bouquet-option-card {
          background: white;
          border: 1px solid rgba(201, 147, 102, 0.15);
          border-radius: var(--bouquet-radius-lg);
          padding: 12px;
          text-align: center;
          transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
          user-select: none;
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: center;
          gap: 6px;
          box-shadow: var(--bouquet-shadow-sm);
          min-height: 80px;
        }

        .bouquet-option-card:hover {
          transform: translateY(-2px);
          border-color: var(--bouquet-primary);
          box-shadow: var(--bouquet-shadow-md);
          background: #faf8f5;
        }

        .bouquet-option-card.active {
          border-color: var(--bouquet-primary-dark);
          background: rgba(201, 147, 102, 0.08);
          color: var(--bouquet-primary-dark);
          font-weight: 700;
          box-shadow: 0 4px 15px rgba(170, 106, 63, 0.15);
          transform: translateY(-1px);
        }

        .bouquet-option-card-icon {
          font-size: 1.5rem;
        }

        .bouquet-option-card-label {
          font-size: 0.9rem;
          line-height: 1.25;
        }

        .bouquet-chip-grid {
          display: flex;
          flex-wrap: wrap;
          gap: 8px;
          margin-bottom: 20px;
        }

        .bouquet-chip-item {
          padding: 8px 14px;
          border-radius: 999px;
          border: 1px solid rgba(201, 147, 102, 0.15);
          background: white;
          cursor: pointer;
          font-weight: 600;
          font-size: 0.88rem;
          user-select: none;
          transition: all 0.2s;
          box-shadow: var(--bouquet-shadow-sm);
        }

        .bouquet-chip-item * {
          pointer-events: none !important;
        }

        .bouquet-chip-item:hover {
          border-color: var(--bouquet-primary);
          background: #faf8f5;
        }

        .bouquet-chip-item.active {
          background: linear-gradient(135deg, rgba(201, 147, 102, 0.14), rgba(170, 106, 63, 0.09));
          border-color: var(--bouquet-primary-dark);
          color: var(--bouquet-primary-dark);
          font-weight: 700;
          box-shadow: 0 2px 8px rgba(170, 106, 63, 0.1);
        }

        .bouquet-color-swatch-grid {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(95px, 1fr));
          gap: 10px;
          margin-bottom: 20px;
        }

        .bouquet-color-card {
          background: white;
          border: 1px solid rgba(201, 147, 102, 0.15);
          border-radius: var(--bouquet-radius-lg);
          padding: 10px;
          display: flex;
          flex-direction: column;
          align-items: center;
          gap: 6px;
          cursor: pointer;
          transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
          box-shadow: var(--bouquet-shadow-sm);
          min-height: 64px;
        }

        .bouquet-color-card * {
          pointer-events: none !important;
        }

        .bouquet-color-card:hover {
          border-color: var(--bouquet-primary);
          transform: translateY(-2px);
          box-shadow: var(--bouquet-shadow-md);
        }

        .bouquet-color-card.active {
          border-color: var(--bouquet-primary-dark);
          background: rgba(201, 147, 102, 0.08);
          font-weight: 700;
          transform: translateY(-1px);
        }

        .bouquet-color-dot {
          width: 22px;
          height: 22px;
          border-radius: 50%;
          border: 1px solid rgba(0, 0, 0, 0.12);
          box-shadow: inset 0 2px 4px rgba(255, 255, 255, 0.4), 0 2px 6px rgba(0, 0, 0, 0.06);
        }

        .bouquet-stepper-actions {
          display: flex;
          justify-content: space-between;
          gap: 16px;
          border-top: 1px solid var(--bouquet-line);
          padding-top: 16px;
          margin-top: auto;
          flex-shrink: 0;
        }

        /* Force high z-index and active state on action buttons */
        .bouquet-btn-primary,
        .bouquet-btn-secondary {
          position: relative !important;
          z-index: 125 !important;
          pointer-events: auto !important;
          display: inline-flex;
          align-items: center;
          justify-content: center;
          gap: 8px;
          min-height: 46px;
          padding: 0 24px;
          border-radius: 999px;
          text-decoration: none;
          cursor: pointer !important;
          transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
          border: none;
          font-weight: 700;
          font-size: 0.98rem;
          outline: none;
        }

        .bouquet-btn-primary {
          color: #fff !important;
          background: linear-gradient(135deg, #d2a37d 0%, var(--bouquet-primary) 54%, var(--bouquet-primary-dark) 100%) !important;
          box-shadow: 0 6px 16px rgba(201, 147, 102, 0.25) !important;
        }

        .bouquet-btn-secondary {
          color: var(--bouquet-brown-main) !important;
          background: rgba(255, 255, 255, 0.95) !important;
          border: 1px solid rgba(201, 147, 102, 0.22) !important;
          box-shadow: var(--bouquet-shadow-sm) !important;
        }

        .bouquet-btn-primary:hover {
          transform: translateY(-2px);
          box-shadow: 0 8px 20px rgba(201, 147, 102, 0.35) !important;
        }

        .bouquet-btn-secondary:hover {
          background: var(--bouquet-bg-light) !important;
          transform: translateY(-2px);
          box-shadow: var(--bouquet-shadow-md) !important;
        }

        .bouquet-range-container {
          margin-bottom: 20px;
        }

        .bouquet-range-slider {
          -webkit-appearance: none;
          width: 100%;
          height: 6px;
          border-radius: 999px;
          background: rgba(201, 147, 102, 0.15);
          outline: none;
          margin: 10px 0;
        }

        .bouquet-range-slider::-webkit-slider-thumb {
          -webkit-appearance: none;
          width: 20px;
          height: 20px;
          border-radius: 50%;
          background: var(--bouquet-primary-dark);
          cursor: pointer;
          box-shadow: 0 3px 8px rgba(79, 48, 30, 0.25);
          transition: transform 0.15s;
        }

        .bouquet-range-slider::-webkit-slider-thumb:hover {
          transform: scale(1.15);
        }

        .bouquet-textarea-field {
          width: 100%;
          border: 1px solid rgba(201, 147, 102, 0.2);
          border-radius: var(--bouquet-radius-lg);
          padding: 12px;
          background: white;
          color: var(--bouquet-brown-main);
          outline: none;
          min-height: 90px;
          resize: none;
          font-family: inherit;
          font-size: 0.95rem;
          line-height: 1.4;
          transition: border-color 0.2s;
        }

        .bouquet-textarea-field:focus {
          border-color: var(--bouquet-primary);
        }

        .bouquet-preview-sticky {
          height: 100%;
          min-height: 0;
        }

        .bouquet-preview-stage {
          position: relative;
          overflow: hidden;
          height: 190px;
          min-height: 190px;
          border-radius: var(--bouquet-radius-lg);
          background:
            linear-gradient(180deg, rgba(255, 255, 255, 0.95) 0%, rgba(255, 249, 243, 0.97) 100%),
            url("https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=500") center/cover;
          border: 1px solid rgba(201, 147, 102, 0.15);
          box-shadow: var(--bouquet-shadow-sm);
          display: grid;
          place-items: center;
          flex-shrink: 0;
        }

        .bouquet-preview-ribbon {
          position: absolute;
          top: 12px;
          left: 12px;
          padding: 5px 12px;
          border-radius: 999px;
          background: rgba(201, 147, 102, 0.12);
          font-weight: 700;
          color: var(--bouquet-primary-dark);
          font-size: 0.82rem;
          letter-spacing: 0.5px;
          text-transform: uppercase;
          box-shadow: var(--bouquet-shadow-sm);
        }

        .bouquet-svg {
          transition: transform 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        .bouquet-preview-stage:hover .bouquet-svg {
          transform: scale(1.05) translateY(-3px) rotate(1deg);
        }

        .bouquet-summary-list {
          display: grid;
          gap: 8px;
        }

        .bouquet-summary-item {
          display: flex;
          justify-content: space-between;
          align-items: center;
          gap: 12px;
          padding: 8px 12px;
          border-radius: var(--bouquet-radius-lg);
          background: rgba(255, 255, 255, 0.85);
          border: 1px solid rgba(201, 147, 102, 0.08);
          font-size: 0.92rem;
          box-shadow: var(--bouquet-shadow-sm);
        }

        .bouquet-summary-item span {
          color: var(--bouquet-muted);
          font-weight: 500;
        }

        .bouquet-summary-item strong {
          text-align: right;
          max-width: 60%;
          color: var(--bouquet-brown-main);
          font-weight: 600;
        }

        .bouquet-summary-price-wrap {
          padding: 12px;
          border-radius: var(--bouquet-radius-lg);
          background: linear-gradient(135deg, rgba(201, 147, 102, 0.12), rgba(170, 106, 63, 0.05));
          border: 1px solid rgba(201, 147, 102, 0.15);
          text-align: center;
          box-shadow: var(--bouquet-shadow-sm);
        }

        .bouquet-summary-price-wrap span {
          font-size: 0.88rem;
          color: var(--bouquet-muted);
          display: block;
          margin-bottom: 4px;
          font-weight: 600;
        }

        .bouquet-summary-price-wrap strong {
          font-size: 1.55rem;
          color: var(--bouquet-primary-dark);
          display: block;
          font-weight: 700;
        }

        .bouquet-budget-compare-alert {
          font-size: 0.85rem;
          line-height: 1.45;
          padding: 8px 12px;
          border-radius: var(--bouquet-radius-lg);
          background: rgba(255, 255, 255, 0.9);
          border: 1px dashed var(--bouquet-primary);
          color: var(--bouquet-brown-soft);
          text-align: center;
          transition: all 0.3s;
        }

        .bouquet-floating-back {
          position: fixed;
          right: 24px;
          bottom: 24px;
          z-index: 999;
          width: 46px;
          height: 46px;
          border-radius: 50%;
          border: none;
          color: white;
          background: linear-gradient(135deg, var(--bouquet-primary), var(--bouquet-primary-dark));
          box-shadow: 0 6px 16px rgba(143, 84, 53, 0.25);
          cursor: pointer;
          display: grid;
          place-items: center;
          font-size: 1.2rem;
          transition: transform 0.2s, box-shadow 0.2s;
        }

        .bouquet-floating-back:hover {
          transform: translateY(-3px);
          box-shadow: 0 8px 20px rgba(143, 84, 53, 0.35);
        }

        @media (max-width: 1024px) {
          body.bouquet-body {
            overflow-y: auto !important;
          }

          .bouquet-main-container {
            height: auto !important;
            max-height: none !important;
            overflow: visible !important;
            padding-bottom: 40px !important;
          }

          .bouquet-main-container>.container {
            height: auto !important;
            display: block !important;
          }

          .bouquet-builder-grid {
            grid-template-columns: 1fr;
            height: auto !important;
          }

          .bouquet-stepper-card,
          .bouquet-preview-card {
            height: auto !important;
          }

          .bouquet-step-sections-wrapper,
          .bouquet-preview-card-body {
            overflow-y: visible !important;
          }

          .bouquet-preview-sticky {
            margin-top: 24px;
          }
        }

        @media (max-width: 768px) {
          .bouquet-stepper-card {
            padding: 18px;
          }

          .bouquet-option-grid {
            grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
          }

          .bouquet-btn-primary,
          .bouquet-btn-secondary {
            flex: 1;
            font-size: 0.92rem;
            padding: 0 16px;
          }
        }
      </style>
    </head>

    <body id="wandave-theme" class="index bouquet-body">
      <div class="bouquet-page-shell">
        <%@ include file="partials/header.jsp" %>

          <main class="bouquet-main-container">
            <div class="container">

              <!-- Stepper Indicator Header -->
              <div class="bouquet-stepper-header">
                <div class="bouquet-stepper-progress-line">
                  <div class="bouquet-stepper-progress-fill"></div>
                </div>
                <div class="bouquet-stepper-step active" id="stepIndicator1">
                  <div class="bouquet-stepper-step-node">1</div>
                  <div class="bouquet-stepper-step-label">Chọn hoa</div>
                </div>
                <div class="bouquet-stepper-step" id="stepIndicator2">
                  <div class="bouquet-stepper-step-node">2</div>
                  <div class="bouquet-stepper-step-label">Phối màu & Gói</div>
                </div>
                <div class="bouquet-stepper-step" id="stepIndicator3">
                  <div class="bouquet-stepper-step-node">3</div>
                  <div class="bouquet-stepper-step-label">Hoàn tất</div>
                </div>
              </div>

              <div class="bouquet-builder-grid">

                <!-- Left Form Workspace (Wizard with internal scrolling) -->
                <div class="bouquet-stepper-card">
                  <form id="customBouquetForm" onsubmit="return false;">
                    <!-- Hidden form inputs synced with visual choices -->
                    <input type="hidden" id="flowerType" value="Hoa tươi mix">
                    <input type="hidden" id="mainFlower" value="Hoa hồng kem">
                    <input type="hidden" id="supportFlower" value="Baby trắng">
                    <input type="hidden" id="quantity" value="15 cành">
                    <input type="hidden" id="wrap" value="Kraft pastel">
                    <input type="hidden" id="occasion" value="Birthday">
                    <input type="hidden" id="color" value="#d8b1a0">

                    <!-- STEP-BY-STEP SECTIONS WRAPPER FOR INTERNAL SCROLL -->
                    <div class="bouquet-step-sections-wrapper">

                      <!-- STEP 1: CHỌN HOA -->
                      <div class="bouquet-step-section active" id="step1">
                        <h2 class="bouquet-step-title">🌸 Thiết kế lớp hoa chính</h2>
                        <p class="bouquet-step-desc">Chọn phong cách phối hoa chính, các loại hoa và số lượng cành chủ
                          đạo của bạn.</p>

                        <span class="bouquet-studio-field-title">Kiểu phối hoa</span>
                        <div class="bouquet-option-grid">
                          <div class="bouquet-option-card active" data-target="flowerType" data-value="Hoa tươi mix">
                            <span class="bouquet-option-card-icon">💐</span>
                            <span class="bouquet-option-card-label">Hoa tươi mix</span>
                          </div>
                          <div class="bouquet-option-card" data-target="flowerType" data-value="Hoa hồng">
                            <span class="bouquet-option-card-icon">🌹</span>
                            <span class="bouquet-option-card-label">Hoa hồng bó</span>
                          </div>
                          <div class="bouquet-option-card" data-target="flowerType" data-value="Tulip">
                            <span class="bouquet-option-card-icon">🌷</span>
                            <span class="bouquet-option-card-label">Bó Tulip</span>
                          </div>
                          <div class="bouquet-option-card" data-target="flowerType" data-value="Cẩm tú cầu">
                            <span class="bouquet-option-card-icon">🌸</span>
                            <span class="bouquet-option-card-label">Cẩm tú cầu</span>
                          </div>
                          <div class="bouquet-option-card" data-target="flowerType" data-value="Mẫu đơn">
                            <span class="bouquet-option-card-icon">🌺</span>
                            <span class="bouquet-option-card-label">Mẫu đơn</span>
                          </div>
                          <div class="bouquet-option-card" data-target="flowerType" data-value="Lan hồ điệp">
                            <span class="bouquet-option-card-icon">💮</span>
                            <span class="bouquet-option-card-label">Lan hồ điệp</span>
                          </div>
                        </div>

                        <span class="bouquet-studio-field-title">Hoa chính chủ đạo</span>
                        <div class="bouquet-option-grid">
                          <div class="bouquet-option-card active" data-target="mainFlower" data-value="Hoa hồng kem">
                            <span class="bouquet-option-card-label">Hồng kem ngọt</span>
                          </div>
                          <div class="bouquet-option-card" data-target="mainFlower" data-value="Hoa hồng đỏ">
                            <span class="bouquet-option-card-label">Hồng đỏ cổ điển</span>
                          </div>
                          <div class="bouquet-option-card" data-target="mainFlower" data-value="Tulip pastel">
                            <span class="bouquet-option-card-label">Tulip kem dâu</span>
                          </div>
                          <div class="bouquet-option-card" data-target="mainFlower" data-value="Mẫu đơn">
                            <span class="bouquet-option-card-label">Mẫu đơn quý phái</span>
                          </div>
                          <div class="bouquet-option-card" data-target="mainFlower" data-value="Cẩm tú cầu">
                            <span class="bouquet-option-card-label">Cẩm tú cầu xanh</span>
                          </div>
                          <div class="bouquet-option-card" data-target="mainFlower" data-value="Hướng dương">
                            <span class="bouquet-option-card-label">Hướng dương rực rỡ</span>
                          </div>
                        </div>

                        <span class="bouquet-studio-field-title">Hoa phụ trang trí</span>
                        <div class="bouquet-option-grid">
                          <div class="bouquet-option-card active" data-target="supportFlower" data-value="Baby trắng">
                            <span class="bouquet-option-card-label">Baby trắng nhí</span>
                          </div>
                          <div class="bouquet-option-card" data-target="supportFlower" data-value="Thanh liễu">
                            <span class="bouquet-option-card-label">Thanh liễu nhã nhặn</span>
                          </div>
                          <div class="bouquet-option-card" data-target="supportFlower" data-value="Lá bạc">
                            <span class="bouquet-option-card-label">Lá táo bạc tròn</span>
                          </div>
                          <div class="bouquet-option-card" data-target="supportFlower" data-value="Lá măng">
                            <span class="bouquet-option-card-label">Lá măng mềm mại</span>
                          </div>
                          <div class="bouquet-option-card" data-target="supportFlower" data-value="Cúc nhí">
                            <span class="bouquet-option-card-label">Cúc cam nhí</span>
                          </div>
                          <div class="bouquet-option-card" data-target="supportFlower" data-value="Không thêm">
                            <span class="bouquet-option-card-label">Không thêm hoa phụ</span>
                          </div>
                        </div>

                        <span class="bouquet-studio-field-title">Số lượng cành chính</span>
                        <div class="bouquet-chip-grid">
                          <div class="bouquet-chip-item" data-target="quantity" data-value="9 cành">9 cành</div>
                          <div class="bouquet-chip-item active" data-target="quantity" data-value="15 cành">15 cành (Đầy
                            đặn)</div>
                          <div class="bouquet-chip-item" data-target="quantity" data-value="19 cành">19 cành</div>
                          <div class="bouquet-chip-item" data-target="quantity" data-value="25 cành">25 cành</div>
                          <div class="bouquet-chip-item" data-target="quantity" data-value="31 cành">31 cành</div>
                          <div class="bouquet-chip-item" data-target="quantity" data-value="51 cành">51 cành (Luxury)
                          </div>
                        </div>
                      </div>

                      <!-- STEP 2: PHỐI MÀU & GIẤY GÓI -->
                      <div class="bouquet-step-section" id="step2">
                        <h2 class="bouquet-step-title">🎨 Phối màu & Giấy gói</h2>
                        <p class="bouquet-step-desc">Tông màu và chất liệu giấy gói định hình phong cách sang trọng, cao
                          cấp cho bó hoa của bạn.</p>

                        <span class="bouquet-studio-field-title">Tông màu chủ đạo</span>
                        <div class="bouquet-color-swatch-grid">
                          <div class="bouquet-color-card active" data-target="color" data-value="#d8b1a0">
                            <span class="bouquet-color-dot" style="background: #d8b1a0;"></span>
                            <span class="bouquet-option-card-label">Hồng kem</span>
                          </div>
                          <div class="bouquet-color-card" data-target="color" data-value="#d9c2a2">
                            <span class="bouquet-color-dot" style="background: #d9c2a2;"></span>
                            <span class="bouquet-option-card-label">Be sữa</span>
                          </div>
                          <div class="bouquet-color-card" data-target="color" data-value="#c96f7c">
                            <span class="bouquet-color-dot" style="background: #c96f7c;"></span>
                            <span class="bouquet-option-card-label">Hồng đậm</span>
                          </div>
                          <div class="bouquet-color-card" data-target="color" data-value="#c8d9c0">
                            <span class="bouquet-color-dot" style="background: #c8d9c0;"></span>
                            <span class="bouquet-option-card-label">Xanh sage</span>
                          </div>
                          <div class="bouquet-color-card" data-target="color" data-value="#d7a36a">
                            <span class="bouquet-color-dot" style="background: #d7a36a;"></span>
                            <span class="bouquet-option-card-label">Cam pastel</span>
                          </div>
                          <div class="bouquet-color-card" data-target="color" data-value="#4f3a33">
                            <span class="bouquet-color-dot" style="background: #4f3a33;"></span>
                            <span class="bouquet-option-card-label">Tone trầm</span>
                          </div>
                        </div>

                        <span class="bouquet-studio-field-title">Giấy gói bên ngoài</span>
                        <div class="bouquet-option-grid">
                          <div class="bouquet-option-card active" data-target="wrap" data-value="Kraft pastel">
                            <span class="bouquet-option-card-icon">📦</span>
                            <span class="bouquet-option-card-label">Kraft pastel</span>
                          </div>
                          <div class="bouquet-option-card" data-target="wrap" data-value="Giấy Hàn Quốc">
                            <span class="bouquet-option-card-icon">✉️</span>
                            <span class="bouquet-option-card-label">Bóng Hàn Quốc</span>
                          </div>
                          <div class="bouquet-option-card" data-target="wrap" data-value="Giấy lụa cao cấp">
                            <span class="bouquet-option-card-icon">🎗️</span>
                            <span class="bouquet-option-card-label">Lụa cao cấp</span>
                          </div>
                          <div class="bouquet-option-card" data-target="wrap" data-value="Giấy bóng mờ">
                            <span class="bouquet-option-card-icon">💎</span>
                            <span class="bouquet-option-card-label">Giấy bóng mờ</span>
                          </div>
                          <div class="bouquet-option-card" data-target="wrap" data-value="Giấy đen sang trọng">
                            <span class="bouquet-option-card-icon">🖤</span>
                            <span class="bouquet-option-card-label">Đen sang trọng</span>
                          </div>
                          <div class="bouquet-option-card" data-target="wrap" data-value="Giấy trắng tối giản">
                            <span class="bouquet-option-card-icon">🤍</span>
                            <span class="bouquet-option-card-label">Trắng tối giản</span>
                          </div>
                        </div>

                        <span class="bouquet-studio-field-title">Phụ kiện đính kèm</span>
                        <div class="bouquet-chip-grid" id="accessorySelection">
                          <div class="bouquet-chip-item active" data-accessory="Nơ lụa">🎀 Nơ lụa</div>
                          <div class="bouquet-chip-item active" data-accessory="Thiệp">✉️ Thiệp chúc</div>
                          <div class="bouquet-chip-item" data-accessory="Ruy băng">🎗️ Ruy băng</div>
                          <div class="bouquet-chip-item" data-accessory="Túi đựng">🛍️ Túi đựng</div>
                          <div class="bouquet-chip-item" data-accessory="Tag tên">🏷️ Tag custom</div>
                        </div>
                      </div>

                      <!-- STEP 3: HOÀN TẤT -->
                      <div class="bouquet-step-section" id="step3">
                        <h2 class="bouquet-step-title">✨ Cân đối ngân sách & Lời nhắn</h2>
                        <p class="bouquet-step-desc">Giúp chúng tôi biết dịp đặc biệt này và lời nhắn gửi đi cùng bó
                          hoa.</p>

                        <span class="bouquet-studio-field-title">Dịp tặng quà</span>
                        <div class="bouquet-option-grid">
                          <div class="bouquet-option-card active" data-target="occasion" data-value="Birthday">
                            <span class="bouquet-option-card-icon">🎂</span>
                            <span class="bouquet-option-card-label">Sinh nhật</span>
                          </div>
                          <div class="bouquet-option-card" data-target="occasion" data-value="Valentine">
                            <span class="bouquet-option-card-icon">💖</span>
                            <span class="bouquet-option-card-label">Valentine</span>
                          </div>
                          <div class="bouquet-option-card" data-target="occasion" data-value="Wedding">
                            <span class="bouquet-option-card-icon">💍</span>
                            <span class="bouquet-option-card-label">Đám cưới / Kỷ niệm</span>
                          </div>
                          <div class="bouquet-option-card" data-target="occasion" data-value="Luxury">
                            <span class="bouquet-option-card-icon">✨</span>
                            <span class="bouquet-option-card-label">Quà tặng VIP</span>
                          </div>
                          <div class="bouquet-option-card" data-target="occasion" data-value="Minimal">
                            <span class="bouquet-option-card-icon">🌿</span>
                            <span class="bouquet-option-card-label">Tối giản tự nhiên</span>
                          </div>
                          <div class="bouquet-option-card" data-target="occasion" data-value="Thank you">
                            <span class="bouquet-option-card-icon">🙏</span>
                            <span class="bouquet-option-card-label">Cảm ơn / Tri ân</span>
                          </div>
                        </div>

                        <div class="bouquet-range-container">
                          <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span class="bouquet-studio-field-title">Ngân sách dự chi</span>
                            <strong style="color: var(--bouquet-primary-dark); font-size: 1.15rem;"
                              id="budgetLabel">900.000 VND</strong>
                          </div>
                          <input id="budget" type="range" min="300" max="3000" step="50" value="900"
                            class="bouquet-range-slider" />
                          <div
                            style="display: flex; justify-content: space-between; font-size: 0.85rem; color: var(--bouquet-muted);">
                            <span>300.000đ</span>
                            <span>3.000.000đ</span>
                          </div>
                        </div>

                        <span class="bouquet-studio-field-title">Ghi chú thêm cho tiệm hoa</span>
                        <textarea id="note" class="bouquet-textarea-field"
                          placeholder="Ví dụ: Shop ghi thiệp giúp mình: 'Mừng sinh nhật mẹ yêu'. Giao hoa lúc 9 giờ sáng nhé!"></textarea>
                      </div>

                    </div>

                    <!-- Navigation Footer (Fixed at the bottom of the card) -->
                    <div class="bouquet-stepper-actions">
                      <button class="bouquet-btn-secondary" type="button" id="btnPrev" style="display: none;"><i
                          class="fa fa-arrow-left"></i> Quay lại</button>
                      <button class="bouquet-btn-primary" type="button" id="btnNext" style="margin-left: auto;">Tiếp tục
                        <i class="fa fa-arrow-right"></i></button>
                    </div>
                  </form>
                </div>

                <!-- Right Fixed Preview Card Panel (Fixed layout) -->
                <div class="bouquet-preview-sticky">
                  <div class="bouquet-preview-card">
                    <h3
                      style="font-size: 1.2rem; font-weight: 700; color: var(--bouquet-brown-main); border-bottom: 1px solid var(--bouquet-line); padding-bottom: 8px; margin: 0 0 16px 0; flex-shrink: 0;">
                      Live Visualizer</h3>

                    <div class="bouquet-preview-card-body">
                      <!-- Gorgeous dynamic inline SVG Visualizer Stage -->
                      <div class="bouquet-preview-stage">
                        <div class="bouquet-preview-ribbon">Bản dựng Bouquet</div>

                        <svg viewBox="0 0 200 200" width="100%" height="100%" class="bouquet-svg"
                          style="max-height: 160px; filter: drop-shadow(0 8px 16px rgba(79,48,30,0.12));">
                          <defs>
                            <!-- 1. ROSE TEMPLATE -->
                            <g id="tpl-rose">
                              <!-- Outer backing circle for volume -->
                              <circle cx="0" cy="0" r="19" fill="var(--flower-light)" stroke="var(--flower-mid)" stroke-width="0.3"/>
                              <!-- Outer sweeping petals -->
                              <path d="M-17,-7 C-21,-15 -5,-20 5,-17 C15,-20 20,-11 17,-3 C20,7 11,18 -2,17 C-15,18 -20,6 -17,-7 Z" fill="var(--flower-light)" stroke="var(--flower-mid)" stroke-width="0.5"/>
                              <path d="M-15,6 C-21,-2 -11,-15 -1,-15 C9,-15 17,-1 11,11 C2,20 -8,18 -15,6 Z" fill="var(--flower-mid)" stroke="var(--flower-base)" stroke-width="0.5" opacity="0.95"/>
                              <!-- Middle layer petals -->
                              <path d="M-11,-9 C-13,-14 -3,-14 4,-11 C11,-11 11,-3 9,4 C6,11 -6,11 -10,4 Z" fill="var(--flower-base)" stroke="var(--flower-dark)" stroke-width="0.5"/>
                              <path d="M-4,-12 C3,-14 11,-10 11,-2 C9,7 -1,9 -9,4 C-9,-4 -7,-10 -4,-12 Z" fill="var(--flower-base)" stroke="var(--flower-dark)" stroke-width="0.5" opacity="0.9"/>
                              <!-- Inner swirling petals -->
                              <path d="M-7,-5 C-7,-10 7,-10 7,-5 C7,3 -7,3 -7,-5 Z" fill="var(--flower-dark)" stroke="var(--flower-deep)" stroke-width="0.5"/>
                              <path d="M-4,-3 C-4,-6 4,-6 4,-3 C4,2 -4,2 -4,-3 Z" fill="var(--flower-deep)" stroke="var(--flower-dark)" stroke-width="0.5"/>
                            </g>

                            <!-- 2. TULIP TEMPLATE -->
                            <g id="tpl-tulip">
                              <!-- Back petal -->
                              <path d="M-7,7 C-13,-4 -7,-16 0,-18 C7,-16 13,-4 7,7 C4,12 -4,12 -7,7 Z" fill="var(--flower-dark)" stroke="var(--flower-deep)" stroke-width="0.5"/>
                              <!-- Left petal -->
                              <path d="M-9,7 C-14,-1 -9,-10 -2,-14 C-5,-9 -5,-1 -2,5 C-4,10 -7,9 -9,7 Z" fill="var(--flower-base)" stroke="var(--flower-dark)" stroke-width="0.5"/>
                              <!-- Right petal -->
                              <path d="M9,7 C14,-1 9,-10 2,-14 C5,-9 5,-1 2,5 C4,10 7,9 9,7 Z" fill="var(--flower-base)" stroke="var(--flower-dark)" stroke-width="0.5"/>
                              <!-- Front foreground petal -->
                              <path d="M-6,8 C-10,0 -4,-10 0,-12 C4,-10 10,0 6,8 C4,10 -4,10 -6,8 Z" fill="var(--flower-light)" stroke="var(--flower-mid)" stroke-width="0.5"/>
                            </g>

                            <!-- 3. PEONY TEMPLATE -->
                            <g id="tpl-peony">
                              <!-- Outer ruffled backing -->
                              <path d="M0,-19 C5,-20 12,-16 16,-11 C20,-5 20,5 16,11 C12,16 5,20 0,19 C-5,20 -12,16 -16,11 C-20,5 -20,-5 -16,-11 C-12,-16 -5,-20 0,-19 Z" fill="var(--flower-light)" stroke="var(--flower-mid)" stroke-width="0.4"/>
                              <!-- Overlapping ruffled middle ring -->
                              <path d="M-9,-13 C-4,-18 4,-18 9,-13 C13,-9 13,4 9,10 C4,13 -4,13 -9,10 C-13,4 -13,-9 -9,-13 Z" fill="var(--flower-mid)" stroke="var(--flower-base)" stroke-width="0.4"/>
                              <!-- Core ruffled clusters -->
                              <path d="M-10,-2 C-13,-7 -7,-13 -1,-10 C1,-13 9,-10 10,-7 C13,-1 7,7 0,7 C-7,7 -9,2 -10,-2 Z" fill="var(--flower-base)" stroke="var(--flower-dark)" stroke-width="0.4"/>
                              <path d="M-5,-5 C-7,-10 7,-10 5,-5 C9,-1 1,5 0,3 C-1,5 -9,-1 -5,-5 Z" fill="var(--flower-dark)" stroke="var(--flower-deep)" stroke-width="0.4"/>
                              <!-- Delicate golden stamens -->
                              <circle cx="-2" cy="-1" r="1.2" fill="#fbc531"/>
                              <circle cx="2" cy="1" r="1.2" fill="#fbc531"/>
                              <circle cx="1" cy="-2" r="1" fill="#e1b12c"/>
                              <circle cx="-1" cy="2" r="0.9" fill="#fbc531"/>
                            </g>

                            <!-- 4. HYDRANGEA FLORET TEMPLATE -->
                            <g id="tpl-hydrangea-floret">
                              <path d="M0,0 C-3,-4 -4,-3 0,-7 C4,-3 3,-4 0,0 Z" fill="var(--flower-mid)" stroke="var(--flower-base)" stroke-width="0.25"/>
                              <path d="M0,0 C-3,4 -4,3 0,7 C4,3 3,4 0,0 Z" fill="var(--flower-mid)" stroke="var(--flower-base)" stroke-width="0.25"/>
                              <path d="M0,0 C-4,-3 -3,-4 -7,0 C-3,4 -4,3 0,0 Z" fill="var(--flower-base)" stroke="var(--flower-dark)" stroke-width="0.25"/>
                              <path d="M0,0 C4,-3 3,-4 7,0 C3,4 4,3 0,0 Z" fill="var(--flower-base)" stroke="var(--flower-dark)" stroke-width="0.25"/>
                              <circle cx="0" cy="0" r="1" fill="var(--flower-light)"/>
                            </g>

                            <!-- 5. HYDRANGEA CLUSTER TEMPLATE -->
                            <g id="tpl-hydrangea">
                              <circle cx="0" cy="0" r="17" fill="var(--flower-dark)" opacity="0.5"/>
                              <!-- Overlapping tiny florets at different coords -->
                              <use href="#tpl-hydrangea-floret" x="-7" y="-7" transform="rotate(10 -7 -7) scale(0.9)"/>
                              <use href="#tpl-hydrangea-floret" x="7" y="-7" transform="rotate(40 7 -7) scale(0.85)"/>
                              <use href="#tpl-hydrangea-floret" x="-8" y="5" transform="rotate(-25 -8 5) scale(0.95)"/>
                              <use href="#tpl-hydrangea-floret" x="6" y="6" transform="rotate(15 6 6) scale(0.9)"/>
                              <use href="#tpl-hydrangea-floret" x="0" y="-10" transform="rotate(55 0 -10) scale(0.85)"/>
                              <use href="#tpl-hydrangea-floret" x="-10" y="0" transform="rotate(-35 -10 0) scale(0.8)"/>
                              <use href="#tpl-hydrangea-floret" x="10" y="0" transform="rotate(20 10 0) scale(0.85)"/>
                              <use href="#tpl-hydrangea-floret" x="0" y="9" transform="rotate(-10 0 9) scale(0.9)"/>
                              <use href="#tpl-hydrangea-floret" x="-2" y="-1" transform="rotate(5 -2 -1) scale(1)"/>
                              <use href="#tpl-hydrangea-floret" x="2" y="2" transform="rotate(30 2 2) scale(1.05)"/>
                            </g>

                            <!-- 6. SUNFLOWER TEMPLATE -->
                            <g id="tpl-sunflower">
                              <!-- Outer Petals Row -->
                              <path d="M0,0 C-3,-6 -2,-15 0,-21 C2,-15 3,-6 0,0 Z" fill="var(--flower-mid)" transform="rotate(0)"/>
                              <path d="M0,0 C-3,-6 -2,-15 0,-21 C2,-15 3,-6 0,0 Z" fill="var(--flower-mid)" transform="rotate(30)"/>
                              <path d="M0,0 C-3,-6 -2,-15 0,-21 C2,-15 3,-6 0,0 Z" fill="var(--flower-mid)" transform="rotate(60)"/>
                              <path d="M0,0 C-3,-6 -2,-15 0,-21 C2,-15 3,-6 0,0 Z" fill="var(--flower-mid)" transform="rotate(90)"/>
                              <path d="M0,0 C-3,-6 -2,-15 0,-21 C2,-15 3,-6 0,0 Z" fill="var(--flower-mid)" transform="rotate(120)"/>
                              <path d="M0,0 C-3,-6 -2,-15 0,-21 C2,-15 3,-6 0,0 Z" fill="var(--flower-mid)" transform="rotate(150)"/>
                              <path d="M0,0 C-3,-6 -2,-15 0,-21 C2,-15 3,-6 0,0 Z" fill="var(--flower-mid)" transform="rotate(180)"/>
                              <path d="M0,0 C-3,-6 -2,-15 0,-21 C2,-15 3,-6 0,0 Z" fill="var(--flower-mid)" transform="rotate(210)"/>
                              <path d="M0,0 C-3,-6 -2,-15 0,-21 C2,-15 3,-6 0,0 Z" fill="var(--flower-mid)" transform="rotate(240)"/>
                              <path d="M0,0 C-3,-6 -2,-15 0,-21 C2,-15 3,-6 0,0 Z" fill="var(--flower-mid)" transform="rotate(270)"/>
                              <path d="M0,0 C-3,-6 -2,-15 0,-21 C2,-15 3,-6 0,0 Z" fill="var(--flower-mid)" transform="rotate(300)"/>
                              <path d="M0,0 C-3,-6 -2,-15 0,-21 C2,-15 3,-6 0,0 Z" fill="var(--flower-mid)" transform="rotate(330)"/>

                              <!-- Inner Petals Row (offset by 15 deg) -->
                              <path d="M0,0 C-2.5,-5 -1.8,-13 0,-18 C1.8,-13 2.5,-5 0,0 Z" fill="var(--flower-light)" transform="rotate(15)"/>
                              <path d="M0,0 C-2.5,-5 -1.8,-13 0,-18 C1.8,-13 2.5,-5 0,0 Z" fill="var(--flower-light)" transform="rotate(45)"/>
                              <path d="M0,0 C-2.5,-5 -1.8,-13 0,-18 C1.8,-13 2.5,-5 0,0 Z" fill="var(--flower-light)" transform="rotate(75)"/>
                              <path d="M0,0 C-2.5,-5 -1.8,-13 0,-18 C1.8,-13 2.5,-5 0,0 Z" fill="var(--flower-light)" transform="rotate(105)"/>
                              <path d="M0,0 C-2.5,-5 -1.8,-13 0,-18 C1.8,-13 2.5,-5 0,0 Z" fill="var(--flower-light)" transform="rotate(135)"/>
                              <path d="M0,0 C-2.5,-5 -1.8,-13 0,-18 C1.8,-13 2.5,-5 0,0 Z" fill="var(--flower-light)" transform="rotate(165)"/>
                              <path d="M0,0 C-2.5,-5 -1.8,-13 0,-18 C1.8,-13 2.5,-5 0,0 Z" fill="var(--flower-light)" transform="rotate(195)"/>
                              <path d="M0,0 C-2.5,-5 -1.8,-13 0,-18 C1.8,-13 2.5,-5 0,0 Z" fill="var(--flower-light)" transform="rotate(225)"/>
                              <path d="M0,0 C-2.5,-5 -1.8,-13 0,-18 C1.8,-13 2.5,-5 0,0 Z" fill="var(--flower-light)" transform="rotate(255)"/>
                              <path d="M0,0 C-2.5,-5 -1.8,-13 0,-18 C1.8,-13 2.5,-5 0,0 Z" fill="var(--flower-light)" transform="rotate(285)"/>
                              <path d="M0,0 C-2.5,-5 -1.8,-13 0,-18 C1.8,-13 2.5,-5 0,0 Z" fill="var(--flower-light)" transform="rotate(315)"/>
                              <path d="M0,0 C-2.5,-5 -1.8,-13 0,-18 C1.8,-13 2.5,-5 0,0 Z" fill="var(--flower-light)" transform="rotate(345)"/>

                              <!-- Dark center seed disk -->
                              <circle cx="0" cy="0" r="9" fill="var(--flower-deep)" stroke="var(--flower-dark)" stroke-width="1.2"/>
                              <circle cx="0" cy="0" r="6" fill="none" stroke="var(--flower-dark)" stroke-dasharray="1.5,1.5" stroke-width="0.8" opacity="0.95"/>
                              <circle cx="0" cy="0" r="3.5" fill="none" stroke="var(--flower-base)" stroke-dasharray="1.2,1.2" stroke-width="0.6" opacity="0.6"/>
                            </g>

                            <!-- 7. ORCHID TEMPLATE -->
                            <g id="tpl-orchid">
                              <!-- 3 outer sepals -->
                              <path d="M0,0 C-4,-8 -7,-15 0,-19 C7,-15 4,-8 0,0 Z" fill="var(--flower-light)" stroke="var(--flower-mid)" stroke-width="0.4"/>
                              <path d="M0,0 C-8,-2 -13,6 -11,11 C-10,16 -4,11 0,0 Z" fill="var(--flower-light)" stroke="var(--flower-mid)" stroke-width="0.4"/>
                              <path d="M0,0 C8,-2 13,6 11,11 C10,16 4,11 0,0 Z" fill="var(--flower-light)" stroke="var(--flower-mid)" stroke-width="0.4"/>
                              <!-- 2 large rounded side wings -->
                              <path d="M0,0 C-10,-6 -19,-5 -19,1 C-19,7 -8,6 0,0 Z" fill="var(--flower-base)" stroke="var(--flower-dark)" stroke-width="0.4"/>
                              <path d="M0,0 C10,-6 19,-5 19,1 C19,7 8,6 0,0 Z" fill="var(--flower-base)" stroke="var(--flower-dark)" stroke-width="0.4"/>
                              <!-- Detailed labellum center lip -->
                              <path d="M-5,1 C-7,6 -3,11 0,9 C3,11 7,6 5,1 C3,3 -3,3 -5,1 Z" fill="#e84393" stroke="#b33939" stroke-width="0.4"/>
                              <circle cx="0" cy="3.5" r="1.2" fill="#fbc531"/>
                            </g>
                          </defs>

                          <!-- Layered Wrapping Paper Backing -->
                          <path id="svg-wrap-back"
                            d="M45,115 C28,65 65,42 90,42 L100,165 Z" fill="var(--wrap-back, #ebd3bd)"
                            stroke="var(--wrap-stroke-back, #ccad91)" stroke-width="0.75" style="transition: fill 0.3s, stroke 0.3s;" />
                          <path id="svg-wrap-back-right"
                            d="M155,115 C172,65 135,42 110,42 L100,165 Z" fill="var(--wrap-back, #ebd3bd)"
                            stroke="var(--wrap-stroke-back, #ccad91)" stroke-width="0.75" style="transition: fill 0.3s, stroke 0.3s;" />

                          <!-- Foliage Leaves (Upgraded beautiful rose leaves) -->
                          <g id="svg-leaves" opacity="0.9">
                            <!-- Left Leaf Group -->
                            <g transform="translate(55, 80) rotate(-35)">
                              <path d="M0,0 C-8,-15 -2,-25 10,-20 C18,-15 15,-5 0,0 Z" fill="#3b5934" stroke="#253a20" stroke-width="0.5"/>
                              <path d="M0,0 Q6,-12 10,-20" stroke="#68965c" stroke-width="0.75" fill="none"/>
                            </g>
                            <!-- Right Leaf Group -->
                            <g transform="translate(145, 80) rotate(35)">
                              <path d="M0,0 C8,-15 2,-25 -10,-20 C-18,-15 -15,-5 0,0 Z" fill="#3b5934" stroke="#253a20" stroke-width="0.5"/>
                              <path d="M0,0 Q-6,-12 -10,-20" stroke="#68965c" stroke-width="0.75" fill="none"/>
                            </g>
                            <!-- Center Background Leaf -->
                            <g transform="translate(100, 52) rotate(10)">
                              <path d="M0,0 C-6,-10 0,-18 6,-18 C12,-18 6,-10 0,0 Z" fill="#2f4829" stroke="#1d3019" stroke-width="0.4"/>
                            </g>
                          </g>

                          <!-- Main Flowers Group -->
                          <g id="svg-flowers">
                            <!-- Flower 1 (Top Left) -->
                            <g id="svg-flower-1-g" transform="translate(82, 72) rotate(-15) scale(0.9)">
                              <use id="svg-flower-1" href="#tpl-rose" x="0" y="0" filter="drop-shadow(0 4px 6px rgba(0,0,0,0.12))"/>
                            </g>
                            <!-- Flower 2 (Top Right) -->
                            <g id="svg-flower-2-g" transform="translate(118, 72) rotate(20) scale(0.95)">
                              <use id="svg-flower-2" href="#tpl-rose" x="0" y="0" filter="drop-shadow(0 4px 6px rgba(0,0,0,0.12))"/>
                            </g>
                            <!-- Flower 3 (Bottom Left) -->
                            <g id="svg-flower-3-g" transform="translate(72, 100) rotate(-10) scale(0.85)">
                              <use id="svg-flower-3" href="#tpl-rose" x="0" y="0" filter="drop-shadow(0 4px 6px rgba(0,0,0,0.12))"/>
                            </g>
                            <!-- Flower 4 (Bottom Right) -->
                            <g id="svg-flower-4-g" transform="translate(128, 100) rotate(15) scale(0.9)">
                              <use id="svg-flower-4" href="#tpl-rose" x="0" y="0" filter="drop-shadow(0 4px 6px rgba(0,0,0,0.12))"/>
                            </g>
                            <!-- Flower Center -->
                            <g id="svg-flower-center-g" transform="translate(100, 86) rotate(5) scale(1.05)">
                              <use id="svg-flower-center" href="#tpl-rose" x="0" y="0" filter="drop-shadow(0 6px 10px rgba(0,0,0,0.15))"/>
                            </g>
                          </g>

                          <!-- Dynamic Support Flowers Group (Toggled by JS) -->
                          <g id="svg-support-flowers" opacity="0.95" style="transition: opacity 0.3s;">
                            <!-- support-baby -->
                            <g id="support-baby" class="support-group" style="display: none;">
                              <path d="M90,130 L95,65 M110,130 L105,65 M80,120 L65,75 M120,120 L135,75 M100,130 L100,50" stroke="#78a070" stroke-width="0.75" fill="none" opacity="0.6"/>
                              <circle cx="100" cy="50" r="2.5" fill="#ffffff" stroke="#d5e0d3" stroke-width="0.3"/>
                              <circle cx="96" cy="48" r="2.2" fill="#ffffff" stroke="#d5e0d3" stroke-width="0.3"/>
                              <circle cx="104" cy="52" r="2" fill="#ffffff" stroke="#d5e0d3" stroke-width="0.3"/>
                              <circle cx="65" cy="75" r="2.5" fill="#ffffff" stroke="#d5e0d3" stroke-width="0.3"/>
                              <circle cx="61" cy="73" r="2" fill="#ffffff" stroke="#d5e0d3" stroke-width="0.3"/>
                              <circle cx="68" cy="77" r="2.2" fill="#ffffff" stroke="#d5e0d3" stroke-width="0.3"/>
                              <circle cx="135" cy="75" r="2.5" fill="#ffffff" stroke="#d5e0d3" stroke-width="0.3"/>
                              <circle cx="131" cy="77" r="2" fill="#ffffff" stroke="#d5e0d3" stroke-width="0.3"/>
                              <circle cx="138" cy="73" r="2.2" fill="#ffffff" stroke="#d5e0d3" stroke-width="0.3"/>
                              <circle cx="78" cy="60" r="2.5" fill="#ffffff" stroke="#d5e0d3" stroke-width="0.3"/>
                              <circle cx="82" cy="58" r="2.2" fill="#ffffff" stroke="#d5e0d3" stroke-width="0.3"/>
                              <circle cx="122" cy="60" r="2.5" fill="#ffffff" stroke="#d5e0d3" stroke-width="0.3"/>
                              <circle cx="118" cy="58" r="2.2" fill="#ffffff" stroke="#d5e0d3" stroke-width="0.3"/>
                            </g>

                            <!-- support-thanhlieu -->
                            <g id="support-thanhlieu" class="support-group" style="display: none;">
                              <path d="M85,120 L75,55 M115,120 L125,55 M100,130 L102,48" stroke="#68805a" stroke-width="1" fill="none" opacity="0.7"/>
                              <g transform="translate(75, 55)">
                                <path d="M0,0 C-3,-3 -5,-1 0,-6 C5,-1 3,-3 0,0 C-3,3 -5,1 0,6 C5,1 3,3 0,0 C-5,-3 -3,-5 -6,0 C-3,5 -5,3 0,0 C5,-3 3,-5 6,0 C3,5 5,3 0,0 Z" fill="#faa2c1" stroke="#f783ac" stroke-width="0.3"/>
                                <circle cx="0" cy="0" r="1.8" fill="#c17897"/>
                              </g>
                              <g transform="translate(125, 55)">
                                <path d="M0,0 C-3,-3 -5,-1 0,-6 C5,-1 3,-3 0,0 C-3,3 -5,1 0,6 C5,1 3,3 0,0 C-5,-3 -3,-5 -6,0 C-3,5 -5,3 0,0 C5,-3 3,-5 6,0 C3,5 5,3 0,0 Z" fill="#faa2c1" stroke="#f783ac" stroke-width="0.3"/>
                                <circle cx="0" cy="0" r="1.8" fill="#c17897"/>
                              </g>
                              <g transform="translate(102, 48)">
                                <path d="M0,0 C-3,-3 -5,-1 0,-6 C5,-1 3,-3 0,0 C-3,3 -5,1 0,6 C5,1 3,3 0,0 C-5,-3 -3,-5 -6,0 C-3,5 -5,3 0,0 C5,-3 3,-5 6,0 C3,5 5,3 0,0 Z" fill="#faa2c1" stroke="#f783ac" stroke-width="0.3"/>
                                <circle cx="0" cy="0" r="1.8" fill="#c17897"/>
                              </g>
                              <circle cx="82" cy="72" r="2.5" fill="#f783ac" stroke="#de3163" stroke-width="0.4"/>
                              <circle cx="118" cy="72" r="2.5" fill="#f783ac" stroke="#de3163" stroke-width="0.4"/>
                            </g>

                            <!-- support-labac -->
                            <g id="support-labac" class="support-group" style="display: none;">
                              <g transform="translate(58, 62) rotate(-25)">
                                <line x1="0" y1="50" x2="0" y2="0" stroke="#718096" stroke-width="1.2"/>
                                <circle cx="-5" cy="30" r="6" fill="#a0aec0" stroke="#718096" stroke-width="0.5" opacity="0.9"/>
                                <circle cx="5" cy="20" r="6.5" fill="#a0aec0" stroke="#718096" stroke-width="0.5" opacity="0.9"/>
                                <circle cx="-6" cy="10" r="5.5" fill="#cbd5e0" stroke="#a0aec0" stroke-width="0.5" opacity="0.9"/>
                                <circle cx="0" cy="0" r="4.5" fill="#edf2f7" stroke="#cbd5e0" stroke-width="0.5" opacity="0.9"/>
                              </g>
                              <g transform="translate(142, 62) rotate(25)">
                                <line x1="0" y1="50" x2="0" y2="0" stroke="#718096" stroke-width="1.2"/>
                                <circle cx="5" cy="30" r="6" fill="#a0aec0" stroke="#718096" stroke-width="0.5" opacity="0.9"/>
                                <circle cx="-5" cy="20" r="6.5" fill="#a0aec0" stroke="#718096" stroke-width="0.5" opacity="0.9"/>
                                <circle cx="6" cy="10" r="5.5" fill="#cbd5e0" stroke="#a0aec0" stroke-width="0.5" opacity="0.9"/>
                                <circle cx="0" cy="0" r="4.5" fill="#edf2f7" stroke="#cbd5e0" stroke-width="0.5" opacity="0.9"/>
                              </g>
                            </g>

                            <!-- support-lamang -->
                            <g id="support-lamang" class="support-group" style="display: none;">
                              <path d="M90,130 Q70,90 60,60 M90,130 Q75,100 68,75 M90,130 Q65,80 50,55" stroke="#48bb78" stroke-width="0.75" stroke-dasharray="1.5,1.5" fill="none" opacity="0.8"/>
                              <path d="M110,130 Q130,90 140,60 M110,130 Q125,100 132,75 M110,130 Q135,80 150,55" stroke="#48bb78" stroke-width="0.75" stroke-dasharray="1.5,1.5" fill="none" opacity="0.8"/>
                              <path d="M100,130 Q100,80 100,40 M100,130 Q92,90 88,55 M100,130 Q108,90 112,55" stroke="#48bb78" stroke-width="0.75" stroke-dasharray="1.5,1.5" fill="none" opacity="0.8"/>
                            </g>

                            <!-- support-cucnhi -->
                            <g id="support-cucnhi" class="support-group" style="display: none;">
                              <path d="M85,120 L66,66 M115,120 L134,66 M100,130 L98,42" stroke="#68805a" stroke-width="0.8" fill="none"/>
                              <g transform="translate(66, 66)">
                                <circle cx="0" cy="0" r="5.5" fill="#ffffff" stroke="#e2e8f0" stroke-width="0.3"/>
                                <circle cx="0" cy="0" r="2.2" fill="#ed8936"/>
                              </g>
                              <g transform="translate(134, 66)">
                                <circle cx="0" cy="0" r="5.5" fill="#ffffff" stroke="#e2e8f0" stroke-width="0.3"/>
                                <circle cx="0" cy="0" r="2.2" fill="#ed8936"/>
                              </g>
                              <g transform="translate(98, 42)">
                                <circle cx="0" cy="0" r="5.5" fill="#ffffff" stroke="#e2e8f0" stroke-width="0.3"/>
                                <circle cx="0" cy="0" r="2.2" fill="#ed8936"/>
                              </g>
                            </g>
                          </g>

                          <!-- Overlapping Wrapping Paper Front Pleated Collars -->
                          <path id="svg-wrap-front-left"
                            d="M60,115 L100,166 L90,120 Z"
                            fill="var(--wrap-front, #ebd3bd)" stroke="var(--wrap-stroke-front, #ccad91)" stroke-width="0.75"
                            style="transition: fill 0.3s, stroke 0.3s;" />
                          <path id="svg-wrap-front-right"
                            d="M140,115 L100,166 L110,120 Z"
                            fill="var(--wrap-front, #ebd3bd)" stroke="var(--wrap-stroke-front, #ccad91)" stroke-width="0.75"
                            style="transition: fill 0.3s, stroke 0.3s;" />
                          <path id="svg-wrap-front"
                            d="M75,125 C90,140 110,140 125,125 C130,145 115,166 100,166 C85,166 70,145 75,125 Z"
                            fill="var(--wrap-front, #ebd3bd)" stroke="var(--wrap-stroke-front, #ccad91)" stroke-width="0.75"
                            style="transition: fill 0.3s, stroke 0.3s;" />

                          <!-- Ribbon Bow (Premium double loops satin ribbon bow) -->
                          <g id="svg-ribbon-group" style="transition: fill 0.3s;">
                            <!-- Shadow -->
                            <path d="M85,162 C73,150 68,170 100,163 C132,170 127,150 115,162 L113,187 L87,187 Z" fill="rgba(0,0,0,0.12)" filter="blur(2px)"/>
                            <!-- Loops -->
                            <path d="M100,160 C80,145 70,162 85,166 C95,168 98,162 100,160 Z" fill="var(--ribbon-color, #aa6a3f)" stroke="var(--ribbon-dark, #8d5630)" stroke-width="0.5"/>
                            <path d="M88,162 C80,158 78,162 85,164 Z" fill="var(--ribbon-dark, #8d5630)" opacity="0.6"/>
                            <path d="M100,160 C120,145 130,162 115,166 C105,168 102,162 100,160 Z" fill="var(--ribbon-color, #aa6a3f)" stroke="var(--ribbon-dark, #8d5630)" stroke-width="0.5"/>
                            <path d="M112,162 C120,158 122,162 115,164 Z" fill="var(--ribbon-dark, #8d5630)" opacity="0.6"/>
                            <!-- Tails -->
                            <path d="M96,163 C94,172 88,185 86,192 L93,191 L96,163 Z" fill="var(--ribbon-color, #aa6a3f)" stroke="var(--ribbon-dark, #8d5630)" stroke-width="0.5"/>
                            <path d="M104,163 C106,172 112,185 114,192 L107,191 L104,163 Z" fill="var(--ribbon-color, #aa6a3f)" stroke="var(--ribbon-dark, #8d5630)" stroke-width="0.5"/>
                            <!-- Knot -->
                            <rect x="96.5" y="157" width="7" height="7" rx="2" fill="var(--ribbon-color, #aa6a3f)" stroke="var(--ribbon-dark, #8d5630)" stroke-width="0.5"/>
                            <path d="M98,160 C100,161 100,161 102,160" stroke="var(--ribbon-light, #d2a37d)" stroke-width="0.5" fill="none"/>
                          </g>
                        </svg>
                      </div>

                      <!-- Specifications List -->
                      <div class="bouquet-summary-list">
                        <div class="bouquet-summary-item">
                          <span>Phong cách phối</span>
                          <strong id="summary-preview-style">Birthday Glow</strong>
                        </div>
                        <div class="bouquet-summary-item">
                          <span>Hoa chủ đạo</span>
                          <strong id="summary-main-flower">Hoa hồng kem</strong>
                        </div>
                        <div class="bouquet-summary-item">
                          <span>Phụ kiện chọn</span>
                          <strong id="summary-accessory">Nơ lụa + Thiệp</strong>
                        </div>
                      </div>

                      <!-- Comparing Estimates price details -->
                      <div class="bouquet-summary-price-wrap">
                        <span>Ước lượng chi phí thực tế</span>
                        <strong id="summary-final-price">890.000 VND</strong>
                      </div>

                      <div class="bouquet-budget-compare-alert" id="summary-estimate-note">
                        Đang cân đối sát với ngân sách dự kiến của bạn.
                      </div>

                      <!-- Quick Presets -->
                      <div
                        style="border-top: 1px solid var(--bouquet-line); padding-top: 12px; margin-top: auto; flex-shrink: 0;">
                        <span class="bouquet-studio-field-title" style="font-size: 0.92rem; margin-bottom: 8px;">Chọn
                          nhanh Mẫu phối sẵn (Presets)</span>
                        <div style="display: flex; gap: 8px; flex-wrap: wrap;">
                          <button type="button" class="preset-btn bouquet-chip-item"
                            style="font-size: 0.85rem; padding: 6px 12px;" data-preset="birthday">🎂 Sinh nhật</button>
                          <button type="button" class="preset-btn bouquet-chip-item"
                            style="font-size: 0.85rem; padding: 6px 12px;" data-preset="wedding">💍 Đám cưới</button>
                          <button type="button" class="preset-btn bouquet-chip-item"
                            style="font-size: 0.85rem; padding: 6px 12px;" data-preset="luxury">👑 VIP</button>
                          <button type="button" class="preset-btn bouquet-chip-item"
                            style="font-size: 0.85rem; padding: 6px 12px;" data-preset="minimal">🌿 Tối giản</button>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

              </div>
            </div>
          </main>
          <%@ include file="partials/footer.jsp" %>
      </div>

      <button class="bouquet-floating-back" type="button"
        onclick="window.scrollTo({ top: 0, behavior: 'smooth' })">↑</button>

      <script>
        // Bulletproof initialization block supporting all readystates to solve non-functional script bugs
        (function () {
          function initBouquetBuilder() {
            try {
              console.log("Initializing namespaced Bouquet Builder JS...");

              let currentStep = 1;
              const totalSteps = 3;

              const steps = {
                1: document.getElementById('step1'),
                2: document.getElementById('step2'),
                3: document.getElementById('step3')
              };

              const stepIndicators = {
                1: document.getElementById('stepIndicator1'),
                2: document.getElementById('stepIndicator2'),
                3: document.getElementById('stepIndicator3')
              };

              const btnPrev = document.getElementById('btnPrev');
              const btnNext = document.getElementById('btnNext');
              const scrollContainer = document.querySelector('.bouquet-step-sections-wrapper');
              const budgetSlider = document.getElementById('budget');
              const budgetLabel = document.getElementById('budgetLabel');

              function updateStepVisibility() {
                try {
                  // Toggle form panels visibility
                  for (let s = 1; s <= totalSteps; s++) {
                    if (steps[s] && stepIndicators[s]) {
                      if (s === currentStep) {
                        steps[s].classList.add('active');
                        stepIndicators[s].classList.add('active');
                      } else {
                        steps[s].classList.remove('active');
                        stepIndicators[s].classList.remove('active');
                      }

                      // Node coloring state for completed steps
                      if (s < currentStep) {
                        stepIndicators[s].classList.add('completed');
                      } else {
                        stepIndicators[s].classList.remove('completed');
                      }
                    }
                  }

                  // Update progress fill bar
                  const fillBar = document.querySelector('.bouquet-stepper-progress-fill');
                  if (fillBar) {
                    const fillPercentage = ((currentStep - 1) / (totalSteps - 1)) * 100;
                    fillBar.style.width = fillPercentage + '%';
                  }

                  // Scroll form wrapper back to top for new step
                  if (scrollContainer) {
                    scrollContainer.scrollTop = 0;
                  }

                  // Back navigation button
                  if (btnPrev) {
                    if (currentStep === 1) {
                      btnPrev.style.display = 'none';
                    } else {
                      btnPrev.style.display = 'inline-flex';
                    }
                  }

                  // Finish/Next label state
                  if (btnNext) {
                    if (currentStep === totalSteps) {
                      btnNext.innerHTML = 'Sao chép & Đặt hàng <i class="fa fa-copy"></i>';
                    } else {
                      btnNext.innerHTML = 'Tiếp tục <i class="fa fa-arrow-right"></i>';
                    }
                  }
                } catch (err) {
                  console.error("updateStepVisibility error:", err);
                }
              }

              // Direct onclick assignments for absolute safety
              if (btnPrev) {
                btnPrev.onclick = function (e) {
                  e.preventDefault();
                  if (currentStep > 1) {
                    currentStep--;
                    updateStepVisibility();
                  }
                };
              }

              if (btnNext) {
                btnNext.onclick = function (e) {
                  e.preventDefault();
                  if (currentStep < totalSteps) {
                    currentStep++;
                    updateStepVisibility();
                  } else {
                    copyConfig();
                  }
                };
              }

              // 1. Direct click registration for Radio Choices (style, main flower, support flower, quantity, color, wrap, occasion)
              console.log("Registering direct event handlers for radio choice cards...");
              document.querySelectorAll('.bouquet-option-card, .bouquet-color-card, .bouquet-chip-item[data-target]').forEach(card => {
                card.onclick = function (e) {
                  e.preventDefault();
                  const targetInputId = this.getAttribute('data-target');
                  const targetValue = this.getAttribute('data-value');
                  console.log("Radio choice card clicked! targetInputId: " + targetInputId + " | targetValue: " + targetValue);

                  if (targetInputId && targetValue) {
                    const targetInput = document.getElementById(targetInputId);
                    if (targetInput) {
                      targetInput.value = targetValue;

                      const siblingsSelector = this.classList.contains('bouquet-chip-item') ? '.bouquet-chip-item' : (this.classList.contains('bouquet-color-card') ? '.bouquet-color-card' : '.bouquet-option-card');
                      const parentGrid = this.parentNode;
                      if (parentGrid) {
                        parentGrid.querySelectorAll(siblingsSelector).forEach(sibling => {
                          sibling.classList.remove('active');
                        });
                      }
                      this.classList.add('active');
                      updateSummary();
                    }
                  }
                };
              });

              // 2. Direct click registration for Checkbox Choices (Accessories Selection)
              const accGrid = document.getElementById('accessorySelection');
              if (accGrid) {
                console.log("Registering direct event handlers for accessory chips...");
                accGrid.querySelectorAll('.bouquet-chip-item').forEach(chip => {
                  chip.onclick = function (e) {
                    e.preventDefault();
                    console.log("Accessory chip clicked! Toggling state...");
                    this.classList.toggle('active');
                    updateSummary();
                  };
                });
              }

              // Budget slider listener
              if (budgetSlider && budgetLabel) {
                budgetSlider.oninput = function () {
                  try {
                    const valFormatted = new Intl.NumberFormat('vi-VN').format(this.value * 1000) + ' VND';
                    budgetLabel.textContent = valFormatted;
                    updateSummary();
                  } catch (err) {
                    console.error("Slider range slider error:", err);
                  }
                };
              }

              // Data modeling tables for pricing and accents
              const quantityBasePrice = {
                '9 cành': 390,
                '15 cành': 550,
                '19 cành': 680,
                '25 cành': 820,
                '31 cành': 980,
                '51 cành': 1450
              };

              const wrapPrice = {
                'Kraft pastel': 0,
                'Giấy Hàn Quốc': 80,
                'Giấy lụa cao cấp': 130,
                'Giấy bóng mờ': 100,
                'Giấy đen sang trọng': 160,
                'Giấy trắng tối giản': 50
              };

              const occasionMeta = {
                Birthday: { accent: 'Birthday Glow', accentColor: '#c96f7c' },
                Valentine: { accent: 'Romantic Heart', accentColor: '#ee5a6f' },
                Wedding: { accent: 'Wedding Whisper', accentColor: '#d9c2a2' },
                Luxury: { accent: 'Luxury VIP Mood', accentColor: '#4f3a33' },
                Minimal: { accent: 'Minimal Sage', accentColor: '#c8d9c0' },
                'Thank you': { accent: 'Warm Thanks', accentColor: '#d7a36a' }
              };

              const presets = {
                birthday: {
                  flowerType: 'Hoa tươi mix',
                  mainFlower: 'Hoa hồng đỏ',
                  supportFlower: 'Baby trắng',
                  quantity: '19 cành',
                  wrap: 'Giấy Hàn Quốc',
                  occasion: 'Birthday',
                  budget: 1200,
                  color: '#c96f7c',
                  accessories: ['Nơ lụa', 'Thiệp chúc', 'Ruy băng'],
                  note: 'Tông màu đỏ hồng rực rỡ, thích hợp tặng sinh nhật mang không khí tươi vui.'
                },
                wedding: {
                  flowerType: 'Hoa hồng',
                  mainFlower: 'Mẫu đơn',
                  supportFlower: 'Lá bạc',
                  quantity: '25 cành',
                  wrap: 'Giấy trắng tối giản',
                  occasion: 'Wedding',
                  budget: 1800,
                  color: '#d9c2a2',
                  accessories: ['Nơ lụa', 'Thiệp chúc'],
                  note: 'Tone trắng kem tinh tế, kiểu bó tròn truyền thống thích hợp làm hoa cưới cầm tay.'
                },
                luxury: {
                  flowerType: 'Lan hồ điệp',
                  mainFlower: 'Cẩm tú cầu',
                  supportFlower: 'Không thêm',
                  quantity: '31 cành',
                  wrap: 'Giấy đen sang trọng',
                  occasion: 'Luxury',
                  budget: 2500,
                  color: '#4f3a33',
                  accessories: ['Nơ lụa', 'Thiệp chúc', 'Tag tên'],
                  note: 'Phối màu huyền bí, đẳng cấp và giấy gói đen dày dặn dành riêng cho quà tặng VIP.'
                },
                minimal: {
                  flowerType: 'Hoa tươi mix',
                  mainFlower: 'Tulip pastel',
                  supportFlower: 'Lá măng',
                  quantity: '15 cành',
                  wrap: 'Giấy lụa cao cấp',
                  occasion: 'Minimal',
                  budget: 900,
                  color: '#c8d9c0',
                  accessories: ['Thiệp chúc'],
                  note: 'Lựa chọn tinh gọn, tone xanh nhạt chủ đạo mát mắt và tối giản.'
                }
              };

              function formatMoney(value) {
                return new Intl.NumberFormat('vi-VN').format(value * 1000) + ' VND';
              }

              function getSelectedAccessories() {
                return Array.from(document.querySelectorAll('#accessorySelection .bouquet-chip-item.active')).map(chip => chip.getAttribute('data-accessory'));
              }

              function estimatePrice() {
                const quantity = document.getElementById('quantity')?.value || '15 cành';
                const wrap = document.getElementById('wrap')?.value || 'Kraft pastel';
                const occasion = document.getElementById('occasion')?.value || 'Birthday';
                const accessoryCount = getSelectedAccessories().length;

                const base = quantityBasePrice[quantity] || 550;
                const wrapCost = wrapPrice[wrap] || 0;
                const occasionCost = occasion === 'Luxury' ? 220 : occasion === 'Wedding' ? 160 : occasion === 'Valentine' ? 130 : occasion === 'Birthday' ? 100 : 70;
                const accessoryCost = Math.max(0, accessoryCount - 1) * 30;

                return (base + wrapCost + occasionCost + accessoryCost) * 1000;
              }

              function updateSummary() {
                try {
                  // Inputs
                  const flowerTypeVal = document.getElementById('flowerType')?.value || 'Hoa tươi mix';
                  const mainFlowerVal = document.getElementById('mainFlower')?.value || 'Hoa hồng kem';
                  const supportFlowerVal = document.getElementById('supportFlower')?.value || 'Baby trắng';
                  const quantityVal = document.getElementById('quantity')?.value || '15 cành';
                  const wrapVal = document.getElementById('wrap')?.value || 'Kraft pastel';
                  const occasionVal = document.getElementById('occasion')?.value || 'Birthday';
                  const colorVal = document.getElementById('color')?.value || '#d8b1a0';
                  const accessories = getSelectedAccessories();

                  // Calculation
                  const estimate = estimatePrice();
                  const budget = budgetSlider ? Number(budgetSlider.value) : 900;

                  // Update Summary Text
                  const summaryMainFlower = document.getElementById('summary-main-flower');
                  if (summaryMainFlower) summaryMainFlower.textContent = mainFlowerVal;

                  const summaryAccessory = document.getElementById('summary-accessory');
                  if (summaryAccessory) summaryAccessory.textContent = accessories.length ? accessories.join(' + ') : 'Không phụ kiện';

                  const occasionInfo = occasionMeta[occasionVal] || occasionMeta.Birthday;
                  const summaryStyle = document.getElementById('summary-preview-style');
                  if (summaryStyle) summaryStyle.textContent = occasionInfo.accent;

                  const summaryFinalPrice = document.getElementById('summary-final-price');
                  if (summaryFinalPrice) summaryFinalPrice.textContent = formatMoney(estimate / 1000);

                  // 1. UPDATE DYNAMIC SVG DOCK COLORS (5-LEVEL SHADING PALETTES)
                  const colorSchemes = {
                    '#d8b1a0': { light: '#ffffff', mid: '#f3d9ce', base: '#d8b1a0', dark: '#b78b77', deep: '#8c5f4c' }, // kem
                    '#d9c2a2': { light: '#ffffff', mid: '#f0e3d2', base: '#d9c2a2', dark: '#bba07a', deep: '#8b704c' }, // be sữa
                    '#c96f7c': { light: '#fdf0f2', mid: '#e8a5b0', base: '#c96f7c', dark: '#a04855', deep: '#731f2b' }, // hồng đậm
                    '#c8d9c0': { light: '#f6faf3', mid: '#dfebda', base: '#c8d9c0', dark: '#a1b498', deep: '#74876b' }, // xanh sage
                    '#d7a36a': { light: '#fef7ef', mid: '#f2cfab', base: '#d7a36a', dark: '#af783f', deep: '#7e4d1b' }, // cam pastel
                    '#4f3a33': { light: '#f3eeed', mid: '#9b827a', base: '#4f3a33', dark: '#38251e', deep: '#21130d' }  // tone trầm
                  };

                  let selectedScheme = colorSchemes[colorVal] || colorSchemes['#d8b1a0'];

                  // SPECIFIC INTRINSIC SPECIES COLORS FOR TOTAL REALISM
                  if (mainFlowerVal === 'Hoa hồng đỏ') {
                    selectedScheme = { light: '#ff7675', mid: '#d63031', base: '#b31b1b', dark: '#801010', deep: '#4d0000' };
                  } else if (mainFlowerVal === 'Hướng dương') {
                    selectedScheme = { light: '#ffeaa7', mid: '#fdcb6e', base: '#f1c40f', dark: '#d35400', deep: '#5d3100' };
                  } else if (mainFlowerVal === 'Cẩm tú cầu xanh') {
                    selectedScheme = { light: '#e0f7fa', mid: '#81d4fa', base: '#29b6f6', dark: '#0288d1', deep: '#01579b' };
                  } else if (mainFlowerVal === 'Tulip pastel' || mainFlowerVal === 'Tulip kem dâu') {
                    selectedScheme = { light: '#fff0f2', mid: '#ffb3c1', base: '#ff85a1', dark: '#c94a66', deep: '#8c1f36' };
                  }

                  const svgEl = document.querySelector('.bouquet-svg');
                  if (svgEl && selectedScheme) {
                    svgEl.style.setProperty('--flower-light', selectedScheme.light);
                    svgEl.style.setProperty('--flower-mid', selectedScheme.mid);
                    svgEl.style.setProperty('--flower-base', selectedScheme.base);
                    svgEl.style.setProperty('--flower-dark', selectedScheme.dark);
                    svgEl.style.setProperty('--flower-deep', selectedScheme.deep);
                  }

                  // 2. DYNAMICALLY MAP FLOWER TEMPLATES
                  let templateId = '#tpl-rose'; // default
                  if (mainFlowerVal === 'Hướng dương') {
                    templateId = '#tpl-sunflower';
                  } else if (mainFlowerVal === 'Mẫu đơn' || mainFlowerVal === 'Mẫu đơn quý phái') {
                    templateId = '#tpl-peony';
                  } else if (mainFlowerVal === 'Cẩm tú cầu xanh' || mainFlowerVal === 'Cẩm tú cầu') {
                    templateId = '#tpl-hydrangea';
                  } else if (mainFlowerVal === 'Tulip pastel' || mainFlowerVal === 'Tulip kem dâu') {
                    templateId = '#tpl-tulip';
                  } else if (flowerTypeVal === 'Lan hồ điệp') {
                    templateId = '#tpl-orchid';
                  } else if (flowerTypeVal === 'Tulip') {
                    templateId = '#tpl-tulip';
                  } else if (flowerTypeVal === 'Cẩm tú cầu') {
                    templateId = '#tpl-hydrangea';
                  } else if (flowerTypeVal === 'Mẫu đơn') {
                    templateId = '#tpl-peony';
                  }

                  const flowersList = [
                    document.getElementById('svg-flower-1'),
                    document.getElementById('svg-flower-2'),
                    document.getElementById('svg-flower-3'),
                    document.getElementById('svg-flower-4'),
                    document.getElementById('svg-flower-center')
                  ];

                  if (flowerTypeVal === 'Hoa tươi mix') {
                    // Mix Roses and Peonies dynamically for standard professional hand-tied look
                    if (flowersList[0]) flowersList[0].setAttribute('href', '#tpl-rose');
                    if (flowersList[1]) flowersList[1].setAttribute('href', '#tpl-peony');
                    if (flowersList[2]) flowersList[2].setAttribute('href', '#tpl-rose');
                    if (flowersList[3]) flowersList[3].setAttribute('href', '#tpl-peony');
                    if (flowersList[4]) flowersList[4].setAttribute('href', '#tpl-rose');
                  } else {
                    flowersList.forEach(flowerEl => {
                      if (flowerEl) {
                        flowerEl.setAttribute('href', templateId);
                      }
                    });
                  }

                  // 3. UPDATE DYNAMIC WRAP PAPER COLORS (STYLING CSS PROPERTIES)
                  const wrapColors = {
                    'Kraft pastel': { back: '#ebd3bd', front: '#ebd3bd', strokeBack: '#dcc0a6', strokeFront: '#ccad91' },
                    'Giấy Hàn Quốc': { back: '#fceef0', front: '#fceef0', strokeBack: '#f7d0d6', strokeFront: '#ebabb5' },
                    'Giấy lụa cao cấp': { back: '#faf6f2', front: '#faf6f2', strokeBack: '#f0e3d6', strokeFront: '#e0c9b3' },
                    'Giấy bóng mờ': { back: '#cbd5e1', front: '#cbd5e1', strokeBack: '#94a3b8', strokeFront: '#64748b' },
                    'Giấy đen sang trọng': { back: '#292524', front: '#292524', strokeBack: '#1c1917', strokeFront: '#0c0a09' },
                    'Giấy trắng tối giản': { back: '#ffffff', front: '#ffffff', strokeBack: '#e5e5e5', strokeFront: '#cccccc' }
                  };
                  const wrapCol = wrapColors[wrapVal] || wrapColors['Kraft pastel'];
                  if (svgEl) {
                    svgEl.style.setProperty('--wrap-back', wrapCol.back);
                    svgEl.style.setProperty('--wrap-front', wrapCol.front);
                    svgEl.style.setProperty('--wrap-stroke-back', wrapCol.strokeBack);
                    svgEl.style.setProperty('--wrap-stroke-front', wrapCol.strokeFront);
                  }

                  // 4. UPDATE DYNAMIC SUPPORT FLOWERS VISIBILITY
                  const supportEl = document.getElementById('svg-support-flowers');
                  if (supportEl) {
                    if (supportFlowerVal === 'Không thêm') {
                      supportEl.style.opacity = '0';
                    } else {
                      supportEl.style.opacity = '1';
                      // Toggle active group elements within support flowers group
                      supportEl.querySelectorAll('.support-group').forEach(g => g.style.display = 'none');
                      
                      let activeSupportId = '';
                      if (supportFlowerVal === 'Baby trắng') activeSupportId = 'support-baby';
                      else if (supportFlowerVal === 'Thanh liễu') activeSupportId = 'support-thanhlieu';
                      else if (supportFlowerVal === 'Lá bạc') activeSupportId = 'support-labac';
                      else if (supportFlowerVal === 'Lá măng') activeSupportId = 'support-lamang';
                      else if (supportFlowerVal === 'Cúc nhí') activeSupportId = 'support-cucnhi';

                      if (activeSupportId) {
                        const activeG = document.getElementById(activeSupportId);
                        if (activeG) activeG.style.display = 'block';
                      }
                    }
                  }

                  // 5. UPDATE PREMIUM RIBBON TONES
                  const ribbonColor = occasionInfo.accentColor || '#aa6a3f';
                  const ribbonColors = {
                    '#c96f7c': { base: '#c96f7c', light: '#f2bdc6', dark: '#a04855' }, // Birthday Glow
                    '#ee5a6f': { base: '#ee5a6f', light: '#ffb3c1', dark: '#b33939' }, // Valentine
                    '#d9c2a2': { base: '#d9c2a2', light: '#f5ebe0', dark: '#aa9273' }, // Wedding
                    '#4f3a33': { base: '#4f3a33', light: '#a08980', dark: '#2b1c18' }, // Luxury
                    '#c8d9c0': { base: '#c8d9c0', light: '#e8f0e5', dark: '#8ba381' }, // Minimal
                    '#d7a36a': { base: '#d7a36a', light: '#f3d6b6', dark: '#ad7637' }  // Thank you
                  };
                  const ribCol = ribbonColors[ribbonColor] || { base: ribbonColor, light: '#ffb3c1', dark: '#8d5630' };
                  if (svgEl) {
                    svgEl.style.setProperty('--ribbon-color', ribCol.base);
                    svgEl.style.setProperty('--ribbon-light', ribCol.light);
                    svgEl.style.setProperty('--ribbon-dark', ribCol.dark);
                  }

                  // Compare estimate vs budget
                  const diff = estimate - budget * 1000;
                  const compareAlert = document.getElementById('summary-estimate-note');

                  if (compareAlert) {
                    if (diff > 0) {
                      compareAlert.style.borderColor = '#e67e22';
                      compareAlert.style.color = '#c0392b';
                      compareAlert.style.background = 'rgba(230, 126, 34, 0.05)';
                      compareAlert.textContent = `Ước tính thực tế cao hơn dự chi khoảng \${formatMoney(diff/1000)}. Hãy thử cân bằng lại số lượng cành hoặc giấy gói nhé.`;
                    } else if (diff < 0) {
                      compareAlert.style.borderColor = '#2ecc71';
                      compareAlert.style.color = '#27ae60';
                      compareAlert.style.background = 'rgba(46, 204, 113, 0.05)';
                      compareAlert.textContent = `Chi phí thực tế đang tiết kiệm hơn dự chi khoảng \${formatMoney(Math.abs(diff)/1000)}! Bạn có thể thêm phụ kiện hoặc đổi giấy gói cao cấp hơn.`;
                    } else {
                      compareAlert.style.borderColor = 'var(--bouquet-primary)';
                      compareAlert.style.color = 'var(--bouquet-primary-dark)';
                      compareAlert.style.background = 'rgba(201, 147, 102, 0.05)';
                      compareAlert.textContent = 'Giá ước lượng đang khớp hoàn hảo với ngân sách mục tiêu!';
                    }
                  }
                } catch (err) {
                  console.error("updateSummary logic error:", err);
                }
              }

              function syncFromPreset(presetKey) {
                try {
                  const preset = presets[presetKey];
                  if (!preset) return;

                  // Update hidden inputs
                  document.getElementById('flowerType').value = preset.flowerType;
                  document.getElementById('mainFlower').value = preset.mainFlower;
                  document.getElementById('supportFlower').value = preset.supportFlower;
                  document.getElementById('quantity').value = preset.quantity;
                  document.getElementById('wrap').value = preset.wrap;
                  document.getElementById('occasion').value = preset.occasion;
                  document.getElementById('color').value = preset.color;

                  // Sync visual chips classes in grids
                  const updateGridState = (inputId, val) => {
                    const grid = document.querySelector(`.bouquet-option-card[data-target="\${inputId}"][data-value="\${val}"], .bouquet-color-card[data-target="\${inputId}"][data-value="\${val}"], .bouquet-chip-item[data-target="\${inputId}"][data-value="\${val}"]`);
                    if (grid) {
                      const siblingsSelector = grid.classList.contains('bouquet-chip-item') ? '.bouquet-chip-item' : (grid.classList.contains('bouquet-color-card') ? '.bouquet-color-card' : '.bouquet-option-card');
                      grid.parentNode.querySelectorAll(siblingsSelector).forEach(el => el.classList.remove('active'));
                      grid.classList.add('active');
                    }
                  };

                  updateGridState('flowerType', preset.flowerType);
                  updateGridState('mainFlower', preset.mainFlower);
                  updateGridState('supportFlower', preset.supportFlower);
                  updateGridState('quantity', preset.quantity);
                  updateGridState('wrap', preset.wrap);
                  updateGridState('occasion', preset.occasion);
                  updateGridState('color', preset.color);

                  // Sync accessories checkboxes chips
                  document.querySelectorAll('#accessorySelection .bouquet-chip-item').forEach(chip => {
                    const acc = chip.getAttribute('data-accessory');
                    chip.classList.toggle('active', preset.accessories.includes(acc));
                  });

                  // Sync slider and note
                  if (budgetSlider) budgetSlider.value = preset.budget;
                  if (budgetLabel) budgetLabel.textContent = formatMoney(preset.budget);
                  const noteInput = document.getElementById('note');
                  if (noteInput) noteInput.value = preset.note;

                  // Update view
                  updateSummary();

                  // Alert user using theme notification system
                  showDialog('Đã áp dụng Preset!', `Đã tự động phối cấu hình mẫu "\${presetKey.toUpperCase()}" thành công.`, 'success');
                } catch (err) {
                  console.error("syncFromPreset error:", err);
                }
              }

              // Click handler for preset buttons using direct onclick
              document.querySelectorAll('.preset-btn').forEach(btn => {
                btn.onclick = function () {
                  try {
                    const presetKey = this.getAttribute('data-preset');
                    if (presetKey) {
                      syncFromPreset(presetKey);
                    }
                  } catch (err) {
                    console.error("Preset button click error:", err);
                  }
                };
              });

              // Defensive Alert Wrapper (Swal fallback to standard alert)
              function showDialog(title, text, icon) {
                if (typeof Swal !== 'undefined') {
                  Swal.fire({
                    title: title,
                    text: text,
                    icon: icon,
                    confirmButtonColor: '#aa6a3f',
                    timer: icon === 'success' ? 1500 : undefined
                  });
                } else {
                  alert(title + "\n" + text);
                }
              }

              function copyConfig() {
                try {
                  const colorVal = document.getElementById('color').value;
                  const colorNames = {
                    '#d8b1a0': 'Hồng kem',
                    '#d9c2a2': 'Be sữa',
                    '#c96f7c': 'Hồng đậm',
                    '#c8d9c0': 'Xanh sage',
                    '#d7a36a': 'Cam pastel',
                    '#4f3a33': 'Tone trầm'
                  };
                  const colorName = colorNames[colorVal] || 'Hồng kem';
                  const accessories = getSelectedAccessories();
                  const noteVal = document.getElementById('note')?.value || 'Không có';
                  const budgetVal = budgetSlider ? budgetSlider.value : 900;
                  const summaryPriceVal = document.getElementById('summary-final-price')?.textContent || '890.000 VND';

                  const text = [
                    `=== CẤU HÌNH BÓ HOA THIẾT KẾ RIÊNG ===`,
                    `- Loại hoa: \${document.getElementById('flowerType').value}`,
                    `- Hoa chính: \${document.getElementById('mainFlower').value}`,
                    `- Hoa phụ: \${document.getElementById('supportFlower').value}`,
                    `- Số lượng: \${document.getElementById('quantity').value}`,
                    `- Giấy gói: \${document.getElementById('wrap').value}`,
                    `- Dịp tặng: \${document.getElementById('occasion').value}`,
                    `- Tông màu: \${colorName}`,
                    `- Phụ kiện: \${accessories.length ? accessories.join(', ') : 'Không có'}`,
                    `- Ngân sách mục tiêu: \${formatMoney(budgetVal)}`,
                    `- Ước tính thực tế: \${summaryPriceVal}`,
                    `- Ghi chú khách hàng: \${noteVal.trim() || 'Không có'}`
                  ].join('\n');

                  if (navigator.clipboard && navigator.clipboard.writeText) {
                    navigator.clipboard.writeText(text).then(() => {
                      showDialog('Sao chép thành công! 💐', 'Đã lưu thông tin bó hoa vào khay nhớ tạm. Hãy dán (Paste) vào tin nhắn gửi Shop để đặt hàng nhanh nhé!', 'success');
                    }).catch(() => {
                      fallbackShowText(text);
                    });
                    return;
                  }

                  fallbackShowText(text);
                } catch (err) {
                  console.error("copyConfig error:", err);
                }
              }

              function fallbackShowText(text) {
                if (typeof Swal !== 'undefined') {
                  Swal.fire({
                    title: 'Cấu hình bó hoa thiết kế',
                    html: `<textarea style="width:100%; height:160px; font-family:monospace; padding:8px; border:1px solid #ddd; border-radius:8px;">\${text}</textarea><p style="font-size:0.9rem; margin-top:8px;">Vui lòng bôi đen và sao chép thủ công đoạn văn bản ở trên.</p>`,
                    confirmButtonColor: '#aa6a3f'
                  });
                } else {
                  prompt("Vui lòng sao chép cấu hình bó hoa dưới đây:", text);
                }
              }

              // Initial load updates
              updateSummary();
              updateStepVisibility();

              console.log("Bouquet Builder loaded successfully!");
            } catch (globalErr) {
              console.error("JSP Inline script bootstrapper crash:", globalErr);
              if (typeof Swal !== 'undefined') {
                Swal.fire({
                  title: "Lỗi khởi tạo hệ thống 🌸",
                  text: "Có lỗi xảy ra khi tải trình thiết kế bó hoa: " + globalErr.message,
                  icon: "error",
                  confirmButtonColor: '#aa6a3f'
                });
              } else {
                alert("Có lỗi xảy ra khi tải trình thiết kế bó hoa: " + globalErr.message);
              }
            }
          }

          // Safe ready-state listener to make sure initialization runs perfectly under any circumstances
          let isInitialized = false;
          function safeInit() {
            if (!isInitialized) {
              isInitialized = true;
              initBouquetBuilder();
            }
          }

          if (document.readyState === "loading") {
            document.addEventListener("DOMContentLoaded", safeInit);
          } else {
            safeInit();
          }

          // Safe defensive fallback - run initBouquetBuilder in 100ms in case DOMContentLoaded was swallowed by errors
          setTimeout(safeInit, 100);
        })();
      </script>
    </body>

    </html>