<%@ page contentType="text/html; charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    // Check admin access
    model.User user = (model.User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/view/login_1.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Dashboard - Tiệm Hoa nhà tớ</title>
    
    <!-- CSRF Token -->
    <meta name="csrf-token" content="${csrfToken}">
    <script>window.csrfToken = '${csrfToken}';</script>

    <!-- Font Awesome -->
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
      /* ============================================
           CSS VARIABLES & RESET
           ============================================ */
      :root {
        /* Brand Colors - Matching Home */
        --primary: #c99366;
        --primary-dark: #aa6a3f;
        --primary-light: #f9f5f0;
        --primary-hover: #b58555;
        --secondary: #3c2922;
        --secondary-soft: #6c5845;
        
        /* Background Colors - Warm tones */
        --bg-page: #faf5ef;
        --bg-light: #f9f5f0;
        --bg-card: #ffffff;
        --bg-hover: #fef9f3;
        
        /* Text Colors - Warm browns */
        --text-dark: #3c2922;
        --text-medium: #6c5845;
        --text-light: #a89f94;
        
        /* Border & Shadow - Subtle warm tones */
        --border: #e8dfd5;
        --border-dark: #d4c9bb;
        --shadow-sm: 0 2px 8px rgba(60, 41, 34, 0.08);
        --shadow: 0 4px 16px rgba(60, 41, 34, 0.12);
        --shadow-lg: 0 8px 32px rgba(60, 41, 34, 0.16);
        
        /* Status Colors - Modern & Vibrant */
        --success: #10b981;
        --success-dark: #059669;
        --success-light: #d1fae5;
        --warning: #f59e0b;
        --warning-dark: #d97706;
        --warning-light: #fef3c7;
        --danger: #ef4444;
        --danger-dark: #dc2626;
        --danger-light: #fee2e2;
        --info: #3b82f6;
        --info-dark: #2563eb;
        --info-light: #dbeafe;
        
        /* Layout */
        --sidebar-width: 280px;
        --header-height: 65px;
        --border-radius: 12px;
        --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      }

      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        background-color: var(--bg-page);
        color: var(--text-dark);
        display: flex;
        min-height: 100vh;
        overflow-x: hidden;
      }

      /* ============================================
           SIDEBAR
           ============================================ */
      .sidebar {
        width: var(--sidebar-width);
        background: linear-gradient(
            135deg,
            rgba(201, 147, 102, 0.95) 0%,
            rgba(170, 106, 63, 0.95) 100%
          ),
          url("https://images.unsplash.com/photo-1487070183336-b863922373d4?w=1200")
            center/cover;
        color: white;
        height: 100vh;
        position: fixed;
        left: 0;
        top: 0;
        transition: var(--transition);
        z-index: 1000;
        box-shadow: 2px 0 15px rgba(0, 0, 0, 0.2);
        overflow-y: auto;
        display: flex;
        flex-direction: column;
      }

      .sidebar::-webkit-scrollbar {
        width: 5px;
      }

      .sidebar::-webkit-scrollbar-track {
        background: rgba(0, 0, 0, 0.1);
      }

      .sidebar::-webkit-scrollbar-thumb {
        background: rgba(255, 255, 255, 0.2);
        border-radius: 10px;
      }

      .sidebar::-webkit-scrollbar-thumb:hover {
        background: rgba(255, 255, 255, 0.3);
      }

      .sidebar-header {
        padding: 25px 20px;
        text-align: center;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        background: rgba(0, 0, 0, 0.15);
        flex-shrink: 0;
      }

      .sidebar-header h2 {
        font-size: 1.4rem;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 12px;
        font-weight: 700;
        letter-spacing: 0.5px;
      }

      .sidebar-header h2 i {
        color: var(--primary);
        font-size: 1.6rem;
        filter: drop-shadow(0 2px 4px rgba(201, 147, 102, 0.3));
      }

      .sidebar-menu {
        padding: 20px 0;
        flex: 1;
        overflow-y: auto;
      }

      .menu-item {
        padding: 13px 25px;
        display: flex;
        align-items: center;
        gap: 14px;
        cursor: pointer;
        transition: var(--transition);
        border-left: 3px solid transparent;
        font-size: 0.95rem;
        color: rgba(241, 239, 212, 0.85);
        text-decoration: none;
        margin: 2px 10px;
        border-radius: 8px;
        position: relative;
        overflow: hidden;
      }

      .menu-item::before {
        content: '';
        position: absolute;
        left: 0;
        top: 0;
        height: 100%;
        width: 0;
        background: var(--primary);
        transition: width 0.3s ease;
        z-index: -1;
      }

      .menu-item:hover {
        background-color: rgba(255, 255, 255, 0.1);
        color: rgb(206, 233, 195);
        transform: translateX(5px);
      }

      .menu-item:hover::before {
        width: 4px;
      }

      .menu-item.active {
        background: linear-gradient(90deg, rgba(201, 147, 102, 0.2), transparent);
        border-left-color: var(--primary);
        color: rgb(140, 185, 189);
        font-weight: 600;
      }

      .menu-item.active i {
        color: var(--primary);
      }

      .menu-item i {
        width: 20px;
        text-align: center;
        font-size: 1.05rem;
        transition: var(--transition);
      }

      .menu-item:hover i {
        transform: scale(1.1);
      }

      .menu-divider {
        border-top: 1px solid rgba(255, 255, 255, 0.15);
        margin: 15px 20px;
      }

      /* ============================================
           MAIN CONTENT
           ============================================ */
      .main-content {
        flex: 1;
        margin-left: var(--sidebar-width);
        transition: var(--transition);
        min-height: 100vh;
        display: flex;
        flex-direction: column;
      }

      /* ============================================
           HEADER
           ============================================ */
      .header {
        height: var(--header-height);
        background-color: var(--bg-card);
        box-shadow: var(--shadow-sm);
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 30px;
        position: sticky;
        top: 0;
        z-index: 100;
        border-bottom: 1px solid var(--border);
      }

      .header-left h1 {
        font-size: 1.5rem;
        color: var(--text-dark);
        font-weight: 700;
        display: flex;
        align-items: center;
        gap: 10px;
      }

      .header-right {
        display: flex;
        align-items: center;
        gap: 20px;
      }

      .header-search {
        position: relative;
      }

      .header-search input {
        padding: 10px 40px 10px 16px;
        border: 2px solid var(--border);
        border-radius: 25px;
        width: 320px;
        font-size: 0.9rem;
        transition: var(--transition);
        background: var(--bg-page);
      }

      .header-search input:focus {
        outline: none;
        border-color: var(--primary);
        box-shadow: 0 0 0 4px rgba(201, 147, 102, 0.1);
        background: rgb(170, 228, 238);
      }

      .header-search i {
        position: absolute;
        right: 15px;
        top: 50%;
        transform: translateY(-50%);
        color: var(--text-light);
        pointer-events: none;
      }

      .user-info {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 8px 16px;
        border-radius: 30px;
        background: var(--bg-page);
        transition: var(--transition);
        cursor: pointer;
        border: 2px solid transparent;
      }

      .user-info:hover {
        background: rgb(160, 199, 240);
        border-color: var(--primary);
        box-shadow: var(--shadow-sm);
      }

      .user-info:hover {
        background: var(--primary-light);
      }

      .user-avatar {
        width: 42px;
        height: 42px;
        border-radius: 50%;
        background: linear-gradient(
          135deg,
          var(--primary),
          var(--primary-dark)
        );
        display: flex;
        align-items: center;
        justify-content: center;
        color: rgb(232, 240, 185);
        font-weight: bold;
        font-size: 1.1rem;
        border: 2px solid var(--primary-dark);
        box-shadow: 0 2px 8px var(--shadow);
      }

      .user-details {
        display: flex;
        flex-direction: column;
      }

      .user-name {
        font-weight: 600;
        color: var(--text-dark);
        font-size: 0.95rem;
      }

      .user-role {
        font-size: 0.85rem;
        color: var(--text-medium);
      }

      /* ============================================
           CONTENT AREA
           ============================================ */
      .content {
        padding: 30px;
        flex: 1;
      }

      .content-section {
        display: none;
        animation: fadeIn 0.3s ease;
      }

      .content-section.active {
        display: block;
      }

      @keyframes fadeIn {
        from {
          opacity: 0;
          transform: translateY(10px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }

      /* ============================================
           SECTION HEADERS
           ============================================ */
      .section-header {
        margin-bottom: 30px;
        padding-bottom: 20px;
        border-bottom: 2px solid var(--border);
        display: flex;
        justify-content: space-between;
        align-items: center;
      }

      .section-header h2 {
        font-size: 1.8rem;
        color: var(--text-dark);
        font-weight: 700;
        display: flex;
        align-items: center;
        gap: 12px;
        margin: 0;
      }

      .section-header h2 i {
        color: var(--primary);
        font-size: 1.6rem;
      }

      .section-header .text-muted {
        color: var(--text-medium);
        font-size: 0.95rem;
        margin-top: 5px;
      }

      .section-header .btn {
        white-space: nowrap;
      }

      /* ============================================
           CARDS
           ============================================ */
      .card {
        background-color: var(--bg-card);
        border-radius: 16px;
        box-shadow: 0 6px 20px var(--shadow);
        margin-bottom: 30px;
        overflow: hidden;
        border: 1px solid var(--border);
        transition: var(--transition);
      }

      .card:hover {
        box-shadow: 0 8px 30px var(--shadow);
      }

      .card-header {
        padding: 22px 25px;
        border-bottom: 1px solid var(--border);
        display: flex;
        justify-content: space-between;
        align-items: center;
        background-color: var(--bg-light);
      }

      .card-header h3 {
        font-size: 1.4rem;
        color: var(--text-dark);
        font-weight: 700;
        display: flex;
        align-items: center;
        gap: 10px;
      }

      .card-header h4 {
        font-size: 1.1rem;
        color: var(--text-dark);
        font-weight: 600;
        margin: 0;
      }

      .card-body {
        padding: 25px;
      }

      /* ============================================
           STATS CARDS
           ============================================ */
      .stats-container {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
        gap: 25px;
        margin-bottom: 35px;
      }

      .stat-card {
        background-color: var(--bg-card);
        border-radius: 16px;
        padding: 25px;
        box-shadow: 0 6px 20px var(--shadow);
        display: flex;
        align-items: center;
        gap: 18px;
        transition: var(--transition);
        border: 1px solid var(--border);
        cursor: pointer;
      }

      .stat-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 12px 25px rgba(150, 120, 90, 0.2);
      }

      .stat-icon {
        width: 65px;
        height: 65px;
        border-radius: 14px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.7rem;
        color: white;
        background: linear-gradient(
          135deg,
          var(--primary),
          var(--primary-dark)
        );
        box-shadow: 0 4px 12px var(--shadow);
      }

      .stat-icon.success {
        background: linear-gradient(135deg, #10b981, #059669);
      }
      .stat-icon.warning {
        background: linear-gradient(135deg, #f59e0b, #d97706);
      }
      .stat-icon.danger {
        background: linear-gradient(135deg, #ef4444, #dc2626);
      }
      .stat-icon.info {
        background: linear-gradient(135deg, #3b82f6, #2563eb);
      }

      .stat-info h3 {
        font-size: 1.9rem;
        margin-bottom: 5px;
        font-weight: 700;
        color: var(--text-dark);
      }

      .stat-info p {
        color: var(--text-medium);
        font-size: 0.95rem;
      }

      /* ============================================
           TABLES
           ============================================ */
      .table-container {
        overflow-x: auto;
        border-radius: 12px;
      }

      table {
        width: 100%;
        border-collapse: collapse;
      }

      th,
      td {
        padding: 14px 16px;
        text-align: left;
        border-bottom: 1px solid var(--border);
      }

      th {
        background-color: var(--bg-light);
        font-weight: 700;
        color: var(--text-dark);
        position: sticky;
        top: 0;
        z-index: 10;
      }

      tr:hover {
        background-color: #aca8a3;
      }

      tbody tr:last-child td {
        border-bottom: none;
      }

      /* ============================================
           BADGES & STATUS
           ============================================ */
      .badge {
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 0.85rem;
        font-weight: 600;
        display: inline-block;
        text-align: center;
      }

      .badge-success {
        background-color: rgba(16, 185, 129, 0.15);
        color: #059669;
      }
      .badge-warning {
        background-color: rgba(245, 158, 11, 0.15);
        color: #d97706;
      }
      .badge-danger {
        background-color: rgba(239, 68, 68, 0.15);
        color: #dc2626;
      }
      .badge-info {
        background-color: rgba(59, 130, 246, 0.15);
        color: #2563eb;
      }
      .badge-primary {
        background-color: rgba(201, 147, 102, 0.15);
        color: var(--primary-dark);
      }
      .badge-secondary {
        background-color: rgba(108, 88, 69, 0.15);
        color: var(--secondary-soft);
      }

      /* ============================================
           BUTTONS
           ============================================ */
      .btn {
        padding: 10px 20px;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-weight: 600;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: var(--transition);
        font-size: 0.95rem;
        text-decoration: none;
        white-space: nowrap;
      }

      .btn:disabled {
        opacity: 0.6;
        cursor: not-allowed;
      }

      .btn-sm {
        padding: 7px 14px;
        font-size: 0.85rem;
      }

      .btn-lg {
        padding: 14px 28px;
        font-size: 1.05rem;
      }

      .btn-primary {
        background: linear-gradient(
          135deg,
          var(--primary),
          var(--primary-dark)
        );
        color: white;
        box-shadow: 0 4px 12px rgba(170, 106, 63, 0.3);
      }

      .btn-primary:hover {
        background: linear-gradient(135deg, #b57d4c, #945331);
        box-shadow: 0 6px 16px rgba(170, 106, 63, 0.4);
        transform: translateY(-2px);
      }

      .btn-success {
        background: linear-gradient(135deg, #10b981, #059669);
        color: white;
        box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
      }

      .btn-success:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(16, 185, 129, 0.4);
      }

      .btn-warning {
        background: linear-gradient(135deg, #f59e0b, #d97706);
        color: white;
        box-shadow: 0 4px 12px rgba(245, 158, 11, 0.3);
      }

      .btn-warning:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(245, 158, 11, 0.4);
      }

      .btn-danger {
        background: linear-gradient(135deg, #ef4444, #dc2626);
        color: white;
        box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
      }

      .btn-danger:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(239, 68, 68, 0.4);
      }

      .btn-light {
        background-color: var(--bg-light);
        color: var(--text-medium);
        border: 1px solid var(--border);
      }

      .btn-light:hover {
        background-color: var(--primary-light);
      }

      .action-buttons {
        display: flex;
        gap: 8px;
        justify-content: center;
      }

      /* ============================================
           FILTERS SECTION
           ============================================ */
      .filters {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 20px;
        margin-bottom: 25px;
      }

      .filter-group {
        display: flex;
        flex-direction: column;
        gap: 8px;
      }

      .filter-group label {
        font-weight: 600;
        color: var(--text-dark);
        font-size: 0.9rem;
        display: flex;
        align-items: center;
        gap: 6px;
      }

      .filter-group label i {
        color: var(--primary);
        font-size: 0.85rem;
      }

      .form-input {
        padding: 11px 16px;
        border: 2px solid var(--border);
        border-radius: 10px;
        font-size: 0.95rem;
        transition: all 0.3s ease;
        background-color: var(--bg-card);
        font-family: inherit;
        color: var(--text-dark);
        width: 100%;
      }

      .form-input:focus {
        border-color: var(--primary);
        outline: none;
        background-color: white;
        box-shadow: 0 0 0 4px rgba(201, 147, 102, 0.15);
      }

      .form-input::placeholder {
        color: var(--text-light);
      }

      /* ============================================
           FORMS
           ============================================ */
      .form-row {
        display: flex;
        gap: 25px;
        margin-bottom: 20px;
      }

      .form-group {
        margin-bottom: 22px;
        flex: 1;
      }

      .form-group label {
        display: block;
        margin-bottom: 10px;
        font-weight: 600;
        color: var(--text-dark);
        font-size: 0.95rem;
      }

      .form-label {
        display: block;
        margin-bottom: 10px;
        font-weight: 600;
        color: var(--text-dark);
        font-size: 0.95rem;
      }

      .form-group label .required {
        color: var(--danger);
        margin-left: 3px;
      }

      .form-control {
        width: 100%;
        padding: 12px 18px;
        border: 2px solid var(--border);
        border-radius: 10px;
        font-size: 1rem;
        transition: all 0.3s ease;
        background-color: var(--bg-card);
        font-family: inherit;
        color: var(--text-dark);
      }

      .form-control:focus {
        border-color: var(--primary);
        outline: none;
        background-color: white;
        box-shadow: 0 0 0 4px rgba(201, 147, 102, 0.15);
      }

      textarea.form-control {
        resize: vertical;
        min-height: 100px;
        line-height: 1.6;
      }

      select.form-control {
        cursor: pointer;
        appearance: none;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23c99366' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: right 12px center;
        padding-right: 40px;
      }

      /* Checkbox styling */
      input[type="checkbox"] {
        width: 18px;
        height: 18px;
        cursor: pointer;
        accent-color: var(--primary);
      }

      /* File input styling */
      input[type="file"] {
        padding: 10px;
        border: 2px dashed var(--border);
        border-radius: 10px;
        cursor: pointer;
      }

      input[type="file"]:hover {
        border-color: var(--primary);
        background-color: rgba(201, 147, 102, 0.05);
      }

      /* ============================================
           TABS
           ============================================ */
      .tabs {
        display: flex;
        border-bottom: 2px solid var(--border);
        margin-bottom: 25px;
        background-color: var(--bg-light);
        border-radius: 10px 10px 0 0;
        padding: 0 10px;
        overflow-x: auto;
      }

      .tab {
        padding: 14px 24px;
        cursor: pointer;
        border-bottom: 3px solid transparent;
        transition: var(--transition);
        font-weight: 600;
        color: var(--text-medium);
        white-space: nowrap;
      }

      .tab:hover {
        color: var(--primary-dark);
        background-color: rgba(201, 147, 102, 0.1);
      }

      .tab.active {
        border-bottom-color: var(--primary);
        color: var(--primary-dark);
        background-color: rgba(201, 147, 102, 0.1);
      }

      /* ============================================
           MODAL
           ============================================ */
      .modal-overlay {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: rgba(0, 0, 0, 0.5);
        display: none;
        align-items: center;
        justify-content: center;
        z-index: 2000;
        backdrop-filter: blur(5px);
        animation: fadeIn 0.2s ease;
      }

      .modal-overlay.show {
        display: flex;
      }

      .modal {
        background-color: var(--bg-card);
        border-radius: 16px;
        width: 90%;
        max-width: 700px;
        max-height: 90vh;
        overflow-y: auto;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        animation: slideUp 0.3s ease;
      }

      .modal-lg {
        max-width: 900px;
      }

      .modal-footer {
        padding: 20px 25px;
        border-top: 1px solid var(--border);
        display: flex;
        gap: 12px;
        justify-content: flex-end;
        background-color: var(--bg-light);
      }

      @keyframes slideUp {
        from {
          transform: translateY(50px);
          opacity: 0;
        }
        to {
          transform: translateY(0);
          opacity: 1;
        }
      }

      .modal-header {
        padding: 20px 25px;
        border-bottom: 1px solid var(--border);
        display: flex;
        justify-content: space-between;
        align-items: center;
        background-color: var(--bg-light);
      }

      .modal-header h3 {
        font-size: 1.4rem;
        color: var(--text-dark);
        font-weight: 700;
      }

      .modal-close {
        background: none;
        border: none;
        font-size: 1.8rem;
        cursor: pointer;
        color: var(--text-medium);
        transition: var(--transition);
        width: 35px;
        height: 35px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
      }

      .modal-close:hover {
        background-color: var(--danger);
        color: white;
      }

      .modal-body {
        padding: 25px;
      }

      /* ============================================
           NOTIFICATION
           ============================================ */
      .notification {
        position: fixed;
        top: 90px;
        right: 30px;
        padding: 15px 25px;
        background-color: var(--bg-card);
        border-radius: 12px;
        box-shadow: 0 8px 25px var(--shadow);
        display: flex;
        align-items: center;
        gap: 12px;
        z-index: 2500;
        transform: translateX(150%);
        transition: transform 0.4s ease;
        border-left: 4px solid var(--primary);
        min-width: 300px;
      }

      .notification.show {
        transform: translateX(0);
      }

      .notification.success {
        border-left-color: var(--success);
      }

      .notification.error {
        border-left-color: var(--danger);
      }

      .notification.warning {
        border-left-color: var(--warning);
      }

      .notification i {
        color: var(--primary);
        font-size: 1.3rem;
      }

      .notification.success i {
        color: var(--success);
      }

      .notification.error i {
        color: var(--danger);
      }

      .notification.warning i {
        color: var(--warning);
      }

      .notification-content {
        flex: 1;
      }

      .notification-title {
        font-weight: 600;
        margin-bottom: 3px;
        color: var(--text-dark);
      }

      .notification-message {
        font-size: 0.9rem;
        color: var(--text-medium);
      }

      /* ============================================
           INFO GROUPS
           ============================================ */
      .info-group {
        margin-bottom: 18px;
      }

      .info-group label {
        display: block;
        font-weight: 600;
        color: var(--text-medium);
        font-size: 0.85rem;
        margin-bottom: 6px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
      }

      .info-group p {
        color: var(--text-dark);
        font-size: 1rem;
        margin: 0;
        padding: 10px 14px;
        background-color: var(--bg-light);
        border-radius: 8px;
        border: 1px solid var(--border);
      }

      /* ============================================
           STAT ROWS
           ============================================ */
      .stat-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 12px 16px;
        margin-bottom: 10px;
        background-color: var(--bg-light);
        border-radius: 10px;
        border: 1px solid var(--border);
        transition: var(--transition);
      }

      .stat-row:hover {
        background-color: white;
        box-shadow: var(--shadow-sm);
        transform: translateX(5px);
      }

      .stat-row span {
        display: flex;
        align-items: center;
        gap: 10px;
        color: var(--text-dark);
        font-weight: 500;
      }

      .stat-row strong {
        font-size: 1.1rem;
        color: var(--primary-dark);
        font-weight: 700;
      }

      /* ============================================
           STATS GRID
           ============================================ */
      .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
        gap: 25px;
      }

      .stat-value {
        font-size: 2rem;
        font-weight: 700;
        color: var(--text-dark);
        margin: 8px 0;
      }

      .stat-change {
        display: inline-flex;
        align-items: center;
        gap: 5px;
        font-size: 0.85rem;
        font-weight: 600;
        padding: 4px 10px;
        border-radius: 20px;
      }

      .stat-change.positive {
        background-color: rgba(16, 185, 129, 0.15);
        color: #059669;
      }

      .stat-change.negative {
        background-color: rgba(239, 68, 68, 0.15);
        color: #dc2626;
      }

      .table-responsive {
        overflow-x: auto;
        border-radius: 12px;
        border: 1px solid var(--border);
      }

      .admin-table {
        width: 100%;
        border-collapse: collapse;
      }

      .admin-table th,
      .admin-table td {
        padding: 14px 16px;
        text-align: left;
        border-bottom: 1px solid var(--border);
      }

      .admin-table th {
        background-color: var(--bg-light);
        font-weight: 700;
        color: var(--text-dark);
        position: sticky;
        top: 0;
        z-index: 10;
      }

      .admin-table tbody tr:hover {
        background-color: #fef9f3;
      }

      .text-danger {
        color: var(--danger) !important;
      }

      .text-success {
        color: var(--success) !important;
      }

      .text-warning {
        color: var(--warning) !important;
      }

      .text-muted {
        color: var(--text-medium) !important;
      }

      small {
        font-size: 0.85rem;
        color: var(--text-light);
      }

      /* ============================================
           UTILITIES
           ============================================ */
      .text-center {
        text-align: center;
      }
      .text-right {
        text-align: right;
      }
      .mt-0 {
        margin-top: 0 !important;
      }
      .mt-10 {
        margin-top: 10px;
      }
      .mt-20 {
        margin-top: 20px;
      }
      .mt-30 {
        margin-top: 30px;
      }
      .mb-0 {
        margin-bottom: 0 !important;
      }
      .mb-10 {
        margin-bottom: 10px;
      }
      .mb-20 {
        margin-bottom: 20px;
      }
      .mb-30 {
        margin-bottom: 30px;
      }
      .p-20 {
        padding: 20px;
      }
      .d-flex {
        display: flex;
      }
      .gap-10 {
        gap: 10px;
      }
      .gap-20 {
        gap: 20px;
      }
      .justify-between {
        justify-content: space-between;
      }
      .align-center {
        align-items: center;
      }

      /* ============================================
           RESPONSIVE
           ============================================ */
      @media (max-width: 1024px) {
        .sidebar {
          width: 70px;
        }

        .sidebar-header h2 span,
        .menu-item span {
          display: none;
        }

        .main-content {
          margin-left: 70px;
        }

        .menu-item {
          justify-content: center;
          padding: 16px;
        }

        .menu-item i {
          font-size: 1.3rem;
        }
      }

      @media (max-width: 768px) {
        .header {
          padding: 0 20px;
        }

        .header-search {
          display: none;
        }

        .content {
          padding: 20px;
        }

        .stats-container {
          grid-template-columns: 1fr;
        }

        .form-row {
          flex-direction: column;
          gap: 0;
        }

        .tabs {
          flex-wrap: wrap;
        }

        .modal {
          width: 95%;
          max-width: none;
        }
      }

      /* ============================================
           LOADING SPINNER
           ============================================ */
      .loading {
        display: inline-block;
        width: 20px;
        height: 20px;
        border: 3px solid rgba(255, 255, 255, 0.3);
        border-radius: 50%;
        border-top-color: white;
        animation: spin 1s ease-in-out infinite;
      }

      @keyframes spin {
        to {
          transform: rotate(360deg);
        }
      }

      /* ============================================
           EMPTY STATE
           ============================================ */
      .empty-state {
        text-align: center;
        padding: 60px 20px;
        color: var(--text-medium);
      }

      .empty-state i {
        font-size: 4rem;
        color: var(--text-light);
        margin-bottom: 20px;
      }

      .empty-state h3 {
        font-size: 1.3rem;
        margin-bottom: 10px;
        color: var(--text-dark);
      }

      .empty-state p {
        font-size: 0.95rem;
      }
    </style>
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
    
    <!-- CSRF Token Helper -->
    <script src="${pageContext.request.contextPath}/fileJS/csrf-token.js"></script>
  </head>
  <body>
    <!-- ============================================
         SIDEBAR
         ============================================ -->
    <div class="sidebar">
      <div class="sidebar-header">
        <h2>
          <i class="fas fa-flower"></i>
          <span>Admin Panel</span>
        </h2>
      </div>

      <div class="sidebar-menu">
        <div class="menu-item active" data-target="dashboard">
          <i class="fas fa-tachometer-alt"></i>
          <span>Dashboard</span>
        </div>

        <div class="menu-item" data-target="orders">
          <i class="fas fa-shopping-cart"></i>
          <span>Đơn Hàng</span>
        </div>

        <div class="menu-item" data-target="products">
          <i class="fas fa-box"></i>
          <span>Sản Phẩm</span>
        </div>

        <div class="menu-item" data-target="categories">
          <i class="fas fa-list"></i>
          <span>Danh Mục</span>
        </div>

        <div class="menu-item" data-target="customers">
          <i class="fas fa-users"></i>
          <span>Khách Hàng</span>
        </div>

        <div class="menu-item" data-target="coupons">
          <i class="fas fa-tags"></i>
          <span>Mã Giảm Giá</span>
        </div>

        <div class="menu-item" data-target="contacts">
          <i class="fas fa-envelope"></i>
          <span>Liên Hệ</span>
        </div>
        
        <div class="menu-item" data-target="gallery">
          <i class="fas fa-images"></i>
          <span>Gallery</span>
        </div>
        
        <div class="menu-item" data-target="news">
          <i class="fas fa-newspaper"></i>
          <span>Tin Tức</span>
        </div>

        <div class="menu-item" data-target="analytics">
          <i class="fas fa-chart-bar"></i>
          <span>Thống Kê</span>
        </div>

        <div class="menu-divider"></div>

        <div class="menu-item" data-target="settings">
          <i class="fas fa-cog"></i>
          <span>Cài Đặt</span>
        </div>

        <a
          href="${pageContext.request.contextPath}/logout"
          class="menu-item"
          style="color: white"
        >
          <i class="fas fa-sign-out-alt"></i>
          <span>Đăng Xuất</span>
        </a>
      </div>
    </div>

    <!-- ============================================
         MAIN CONTENT
         ============================================ -->
    <div class="main-content">
      <!-- ============================================
             HEADER
             ============================================ -->
      <div class="header">
        <div class="header-left">
          <h1 id="pageTitle">Dashboard</h1>
        </div>

        <div class="header-right">
          <div class="header-search">
            <input type="text" placeholder="Tìm kiếm..." id="globalSearch" />
            <i class="fas fa-search"></i>
          </div>

          <div class="user-info">
            <div class="user-avatar">
              <c:choose>
                <c:when test="${not empty user.fullname}">
                  ${user.fullname.substring(0,1).toUpperCase()}
                </c:when>
                <c:otherwise>A</c:otherwise>
              </c:choose>
            </div>
            <div class="user-details">
              <div class="user-name">
                <c:out value="${user.fullname}" default="Administrator" />
              </div>
              <div class="user-role">Administrator</div>
            </div>
          </div>
        </div>
      </div>

      <!-- ============================================
             CONTENT
             ============================================ -->
      <div class="content">
        <!-- ============================================
             DASHBOARD SECTION
             ============================================ -->
        <div id="dashboard" class="content-section active">
          <!-- Stats Cards -->
          <div class="stats-container">
            <div class="stat-card">
              <div class="stat-icon">
                <i class="fas fa-shopping-cart"></i>
              </div>
              <div class="stat-info">
                <h3 id="statTotalOrders">0</h3>
                <p>Tổng Đơn Hàng</p>
              </div>
            </div>

            <div class="stat-card">
              <div class="stat-icon success">
                <i class="fas fa-dollar-sign"></i>
              </div>
              <div class="stat-info">
                <h3 id="statTotalRevenue">0đ</h3>
                <p>Tổng Doanh Thu</p>
              </div>
            </div>

            <div class="stat-card">
              <div class="stat-icon warning">
                <i class="fas fa-users"></i>
              </div>
              <div class="stat-info">
                <h3 id="statTotalUsers">0</h3>
                <p>Khách Hàng</p>
              </div>
            </div>

            <div class="stat-card">
              <div class="stat-icon info">
                <i class="fas fa-box"></i>
              </div>
              <div class="stat-info">
                <h3 id="statTotalProducts">0</h3>
                <p>Sản Phẩm</p>
              </div>
            </div>
          </div>

          <!-- Charts and Recent Orders -->
          <div class="form-row">
            <!-- Revenue Chart -->
            <div class="card" style="flex: 2">
              <div class="card-header">
                <h3><i class="fas fa-chart-line"></i> Doanh Thu 7 Ngày Qua</h3>
                <select
                  id="revenueChartPeriod"
                  class="form-control"
                  style="width: 150px"
                >
                  <option value="7">7 ngày</option>
                  <option value="30">30 ngày</option>
                  <option value="90">3 tháng</option>
                </select>
              </div>
              <div class="card-body">
                <canvas id="revenueChart" style="max-height: 300px"></canvas>
              </div>
            </div>

            <!-- Order Status -->
            <div class="card" style="flex: 1">
              <div class="card-header">
                <h3><i class="fas fa-chart-pie"></i> Trạng Thái Đơn Hàng</h3>
              </div>
              <div class="card-body">
                <div
                  class="stat-row"
                  style="
                    margin-bottom: 15px;
                    display: flex;
                    justify-content: space-between;
                  "
                >
                  <span
                    ><i class="fas fa-clock" style="color: var(--warning)"></i>
                    Chờ xử lý</span
                  >
                  <strong id="pendingOrders">0</strong>
                </div>
                <div
                  class="stat-row"
                  style="
                    margin-bottom: 15px;
                    display: flex;
                    justify-content: space-between;
                  "
                >
                  <span
                    ><i class="fas fa-truck" style="color: var(--info)"></i>
                    Đang giao</span
                  >
                  <strong id="shippingOrders">0</strong>
                </div>
                <div
                  class="stat-row"
                  style="
                    margin-bottom: 15px;
                    display: flex;
                    justify-content: space-between;
                  "
                >
                  <span
                    ><i
                      class="fas fa-check-circle"
                      style="color: var(--success)"
                    ></i>
                    Hoàn thành</span
                  >
                  <strong id="deliveredOrders">0</strong>
                </div>
                <div
                  class="stat-row"
                  style="
                    margin-bottom: 15px;
                    display: flex;
                    justify-content: space-between;
                  "
                >
                  <span
                    ><i
                      class="fas fa-times-circle"
                      style="color: var(--danger)"
                    ></i>
                    Đã hủy</span
                  >
                  <strong id="cancelledOrders">0</strong>
                </div>
              </div>
            </div>
          </div>

          <!-- Recent Orders & Top Products -->
          <div class="form-row">
            <!-- Recent Orders -->
            <div class="card" style="flex: 1">
              <div class="card-header">
                <h3><i class="fas fa-clock"></i> Đơn Hàng Gần Đây</h3>
                <button
                  class="btn btn-primary btn-sm"
                  onclick="showSection('orders')"
                >
                  Xem Tất Cả
                </button>
              </div>
              <div class="card-body">
                <div class="table-container">
                  <table id="recentOrdersTable">
                    <thead>
                      <tr>
                        <th>Mã ĐH</th>
                        <th>Khách Hàng</th>
                        <th>Tổng Tiền</th>
                        <th>Trạng Thái</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td colspan="4" class="text-center">
                          <div class="loading"></div>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>

            <!-- Top Products -->
            <div class="card" style="flex: 1">
              <div class="card-header">
                <h3><i class="fas fa-star"></i> Sản Phẩm Bán Chạy</h3>
                <button
                  class="btn btn-primary btn-sm"
                  onclick="showSection('products')"
                >
                  Xem Tất Cả
                </button>
              </div>
              <div class="card-body">
                <div class="table-container">
                  <table id="topProductsTable">
                    <thead>
                      <tr>
                        <th>Sản Phẩm</th>
                        <th>Đã Bán</th>
                        <th>Doanh Thu</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td colspan="3" class="text-center">
                          <div class="loading"></div>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Orders Section -->
        <div id="orders" class="content-section">
          <div class="section-header">
            <div>
              <h2><i class="fas fa-shopping-cart"></i> Quản Lý Đơn Hàng</h2>
              <p class="text-muted">Quản lý và xử lý đơn hàng</p>
            </div>
          </div>

          <!-- Filters -->
          <div class="card">
            <div class="card-body">
              <div class="filters">
                <div class="filter-group">
                  <label>Tìm kiếm</label>
                  <input
                    type="text"
                    id="orderSearchInput"
                    placeholder="Tìm theo mã đơn, khách hàng..."
                    class="form-input"
                  />
                </div>
                <div class="filter-group">
                  <label>Trạng thái</label>
                  <select id="orderStatusFilter" class="form-input">
                    <option value="">Tất cả</option>
                    <option value="pending">Chờ xử lý</option>
                    <option value="shipping">Đang giao</option>
                    <option value="delivered">Đã giao</option>
                    <option value="cancelled">Đã hủy</option>
                  </select>
                </div>
                <div class="filter-group">
                  <label>Từ ngày</label>
                  <input type="date" id="orderDateFrom" class="form-input" />
                </div>
                <div class="filter-group">
                  <label>Đến ngày</label>
                  <input type="date" id="orderDateTo" class="form-input" />
                </div>
                <div class="filter-group" style="align-self: flex-end">
                  <button class="btn btn-primary" onclick="searchOrders()">
                    <i class="fas fa-search"></i> Tìm kiếm
                  </button>
                  <button
                    class="btn btn-secondary"
                    onclick="resetOrderFilters()"
                  >
                    <i class="fas fa-redo"></i> Reset
                  </button>
                </div>
              </div>
            </div>
          </div>

          <!-- Orders Table -->
          <div class="card">
            <div class="card-header">
              <h3><i class="fas fa-list"></i> Danh Sách Đơn Hàng</h3>
              <div>
                <button class="btn btn-success btn-sm" onclick="exportOrders()">
                  <i class="fas fa-file-export"></i> Xuất Excel
                </button>
              </div>
            </div>
            <div class="card-body">
              <div class="table-container">
                <table id="ordersTable">
                  <thead>
                    <tr>
                      <th>Mã ĐH</th>
                      <th>Khách Hàng</th>
                      <th>SĐT</th>
                      <th>Ngày Đặt</th>
                      <th>Tổng Tiền</th>
                      <th>Trạng Thái</th>
                      <th>Thao Tác</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td colspan="7" class="text-center">
                        <div class="loading"></div>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <!-- Pagination -->
              <div class="pagination" id="ordersPagination"></div>
            </div>
          </div>
        </div>

        <!-- Products Section -->
        <div id="products" class="content-section">
          <div class="section-header">
            <div>
              <h2><i class="fas fa-box"></i> Quản Lý Sản Phẩm</h2>
              <p class="text-muted">Quản lý danh sách sản phẩm và kho hàng</p>
            </div>
            <button class="btn btn-primary" onclick="openAddProductModal()">
              <i class="fas fa-plus"></i> Thêm Sản Phẩm
            </button>
          </div>

          <!-- Filters -->
          <div class="card">
            <div class="card-body">
              <div class="filters">
                <div class="filter-group">
                  <label>Tìm kiếm</label>
                  <input
                    type="text"
                    id="productSearchInput"
                    placeholder="Tìm theo tên sản phẩm..."
                    class="form-input"
                  />
                </div>
                <div class="filter-group">
                  <label>Danh mục</label>
                  <select id="productCategoryFilter" class="form-input">
                    <option value="">Tất cả danh mục</option>
                  </select>
                </div>
                <div class="filter-group">
                  <label>Trạng thái</label>
                  <select id="productStatusFilter" class="form-input">
                    <option value="">Tất cả</option>
                    <option value="available">Còn hàng</option>
                    <option value="outofstock">Hết hàng</option>
                  </select>
                </div>
                <div class="filter-group" style="align-self: flex-end">
                  <button class="btn btn-primary" onclick="searchProducts()">
                    <i class="fas fa-search"></i> Tìm kiếm
                  </button>
                  <button
                    class="btn btn-secondary"
                    onclick="resetProductFilters()"
                  >
                    <i class="fas fa-redo"></i> Reset
                  </button>
                </div>
              </div>
            </div>
          </div>

          <!-- Products Table -->
          <div class="card">
            <div class="card-header">
              <h3><i class="fas fa-list"></i> Danh Sách Sản Phẩm</h3>
              <div>
                <button
                  class="btn btn-success btn-sm"
                  onclick="exportProducts()"
                >
                  <i class="fas fa-file-export"></i> Xuất Excel
                </button>
              </div>
            </div>
            <div class="card-body">
              <div class="table-container">
                <table id="productsTable">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Hình Ảnh</th>
                      <th>Tên Sản Phẩm</th>
                      <th>Danh Mục</th>
                      <th>Giá</th>
                      <th>Số Lượng</th>
                      <th>Đã Bán</th>
                      <th>Thao Tác</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td colspan="8" class="text-center">
                        <div class="loading"></div>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <!-- Pagination -->
              <div class="pagination" id="productsPagination"></div>
            </div>
          </div>
        </div>

        <!-- Categories Section -->
        <div id="categories" class="content-section">
          <div class="card">
            <div class="card-header">
              <h3><i class="fas fa-list"></i> Quản Lý Danh Mục</h3>
              <button class="btn btn-primary" onclick="openAddCategoryModal()">
                <i class="fas fa-plus"></i> Thêm Danh Mục
              </button>
            </div>
            <div class="card-body">
              <div class="table-container">
                <table>
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Tên Danh Mục</th>
                      <th>Slug</th>
                      <th>Danh Mục Cha</th>
                      <th>Thứ Tự</th>
                      <th>Trạng Thái</th>
                      <th>Thao Tác</th>
                    </tr>
                  </thead>
                  <tbody id="categoriesTableBody">
                    <tr>
                      <td colspan="7" class="text-center">Đang tải...</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>

        <!-- Customers Section -->
        <div id="customers" class="content-section">
          <div class="card">
            <div class="card-header">
              <h3><i class="fas fa-users"></i> Quản Lý Khách Hàng</h3>
              <div>
                <input
                  type="text"
                  id="customerSearchInput"
                  placeholder="Tìm kiếm khách hàng..."
                  class="form-input"
                  style="width: 300px; display: inline-block; margin-right: 10px;"
                  onkeyup="searchCustomers()"
                />
                <select id="customerStatusFilter" class="form-input" style="width: 150px; display: inline-block;" onchange="filterCustomers()">
                  <option value="">Tất cả trạng thái</option>
                  <option value="active">Hoạt động</option>
                  <option value="inactive">Không hoạt động</option>
                  <option value="banned">Đã cấm</option>
                </select>
              </div>
            </div>
            <div class="card-body">
              <div class="table-container">
                <table>
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Email</th>
                      <th>Họ Tên</th>
                      <th>SĐT</th>
                      <th>Ngày Đăng Ký</th>
                      <th>Trạng Thái</th>
                      <th>Thao Tác</th>
                    </tr>
                  </thead>
                  <tbody id="customersTableBody">
                    <tr>
                      <td colspan="7" class="text-center">Đang tải...</td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <div id="customersPagination" class="pagination-container"></div>
            </div>
          </div>
        </div>

        <!-- Coupons Section -->
        <div id="coupons" class="content-section">
          <div class="card">
            <div class="card-header">
              <h3><i class="fas fa-tags"></i> Quản Lý Mã Giảm Giá</h3>
              <button class="btn btn-primary" onclick="openAddCouponModal()">
                <i class="fas fa-plus"></i> Thêm Mã Giảm Giá
              </button>
            </div>
            <div class="card-body">
              <div class="table-container">
                <table>
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Mã Code</th>
                      <th>Loại</th>
                      <th>Giá Trị</th>
                      <th>Đơn Tối Thiểu</th>
                      <th>Đã Dùng / Giới Hạn</th>
                      <th>Ngày Hết Hạn</th>
                      <th>Trạng Thái</th>
                      <th>Thao Tác</th>
                    </tr>
                  </thead>
                  <tbody id="couponsTableBody">
                    <tr>
                      <td colspan="9" class="text-center">Đang tải...</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>

        <!-- Contacts Section -->
        <div id="contacts" class="content-section">
          <div class="card">
            <div class="card-header">
              <h3><i class="fas fa-envelope"></i> Quản Lý Liên Hệ</h3>
              <select id="contactStatusFilter" class="form-input" style="width: 200px;" onchange="filterContacts()">
                <option value="">Tất cả</option>
                <option value="new">Mới</option>
                <option value="read">Đã đọc</option>
                <option value="replied">Đã trả lời</option>
              </select>
            </div>
            <div class="card-body">
              <div class="table-container">
                <table>
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Tên</th>
                      <th>Email</th>
                      <th>SĐT</th>
                      <th>Tiêu Đề</th>
                      <th>Ngày Gửi</th>
                      <th>Trạng Thái</th>
                      <th>Thao Tác</th>
                    </tr>
                  </thead>
                  <tbody id="contactsTableBody">
                    <tr>
                      <td colspan="8" class="text-center">Đang tải...</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Gallery Section -->
        <div id="gallery" class="content-section">
          <div class="card">
            <div class="card-header">
              <h3><i class="fas fa-images"></i> Quản Lý Gallery</h3>
              <button class="btn btn-primary" onclick="openGalleryModal()">
                <i class="fas fa-plus"></i> Thêm Ảnh
              </button>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="admin-table">
                  <thead>
                    <tr>
                      <th style="width: 80px;">ID</th>
                      <th style="width: 120px;">Ảnh</th>
                      <th>Tiêu Đề</th>
                      <th>Mô Tả</th>
                      <th style="width: 100px;">Thứ Tự</th>
                      <th style="width: 100px;">Trạng Thái</th>
                      <th style="width: 150px;">Thao Tác</th>
                    </tr>
                  </thead>
                  <tbody id="galleryTableBody">
                    <tr>
                      <td colspan="7" style="text-align: center; padding: 40px;">
                        <i class="fas fa-spinner fa-spin" style="font-size: 24px; color: #999;"></i>
                        <p style="margin-top: 10px; color: #999;">Đang tải...</p>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
        
        <!-- News Section -->
        <div id="news" class="content-section">
          <div class="card">
            <div class="card-header">
              <h3><i class="fas fa-newspaper"></i> Quản Lý Tin Tức</h3>
              <button class="btn btn-primary" onclick="openNewsModal()">
                <i class="fas fa-plus"></i> Thêm Tin Tức
              </button>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="admin-table">
                  <thead>
                    <tr>
                      <th style="width: 60px;">ID</th>
                      <th style="width: 100px;">Ảnh</th>
                      <th>Tiêu Đề</th>
                      <th style="width: 120px;">Danh Mục</th>
                      <th style="width: 100px;">Tác Giả</th>
                      <th style="width: 80px;">Lượt Xem</th>
                      <th style="width: 100px;">Trạng Thái</th>
                      <th style="width: 120px;">Ngày Đăng</th>
                      <th style="width: 150px;">Thao Tác</th>
                    </tr>
                  </thead>
                  <tbody id="newsTableBody">
                    <tr>
                      <td colspan="9" style="text-align: center; padding: 40px;">
                        <i class="fas fa-spinner fa-spin" style="font-size: 24px; color: #999;"></i>
                        <p style="margin-top: 10px; color: #999;">Đang tải...</p>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>

        <!-- Analytics Section -->
        <div id="analytics" class="content-section">
          <div class="card">
            <div class="card-header">
              <h3><i class="fas fa-chart-bar"></i> Thống Kê & Báo Cáo</h3>
              <select id="analyticsDateRange" class="form-input" style="width: 200px;" onchange="loadAnalytics()">
                <option value="7">7 ngày qua</option>
                <option value="30">30 ngày qua</option>
                <option value="90">90 ngày qua</option>
                <option value="365">1 năm qua</option>
              </select>
            </div>
            <div class="card-body">
              <!-- Revenue & Order Stats -->
              <div class="stats-grid" style="margin-bottom: 30px;">
                <div class="stat-card">
                  <div class="stat-icon" style="background: linear-gradient(135deg, #c99366, #aa6a3f);">
                    <i class="fas fa-dollar-sign"></i>
                  </div>
                  <div class="stat-info">
                    <h4 style="color: var(--text-dark); font-size: 0.95rem; margin-bottom: 8px;">Tổng Doanh Thu</h4>
                    <p class="stat-value" id="analyticsRevenue">0 đ</p>
                    <span class="stat-change positive" id="analyticsRevenueChange">
                      <i class="fas fa-arrow-up"></i> 0%
                    </span>
                  </div>
                </div>

                <div class="stat-card">
                  <div class="stat-icon info" style="background: linear-gradient(135deg, #3b82f6, #2563eb);">
                    <i class="fas fa-shopping-cart"></i>
                  </div>
                  <div class="stat-info">
                    <h4 style="color: var(--text-dark); font-size: 0.95rem; margin-bottom: 8px;">Đơn Hàng</h4>
                    <p class="stat-value" id="analyticsOrders">0</p>
                    <span class="stat-change positive" id="analyticsOrdersChange">
                      <i class="fas fa-arrow-up"></i> 0%
                    </span>
                  </div>
                </div>

                <div class="stat-card">
                  <div class="stat-icon success" style="background: linear-gradient(135deg, #10b981, #059669);">
                    <i class="fas fa-chart-line"></i>
                  </div>
                  <div class="stat-info">
                    <h4 style="color: var(--text-dark); font-size: 0.95rem; margin-bottom: 8px;">Giá Trị TB</h4>
                    <p class="stat-value" id="analyticsAvgOrder">0 đ</p>
                    <span class="stat-change positive" id="analyticsAvgChange">
                      <i class="fas fa-arrow-up"></i> 0%
                    </span>
                  </div>
                </div>

                <div class="stat-card">
                  <div class="stat-icon warning" style="background: linear-gradient(135deg, #f59e0b, #d97706);">
                    <i class="fas fa-percent"></i>
                  </div>
                  <div class="stat-info">
                    <h4 style="color: var(--text-dark); font-size: 0.95rem; margin-bottom: 8px;">Tỷ Lệ Hoàn Thành</h4>
                    <p class="stat-value" id="analyticsCompleteRate">0%</p>
                    <span class="stat-change positive" id="analyticsRateChange">
                      <i class="fas fa-arrow-up"></i> 0%
                    </span>
                  </div>
                </div>
              </div>

              <!-- Charts Row -->
              <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 30px;">
                <div class="card">
                  <div class="card-header">
                    <h4>Doanh Thu Theo Ngày</h4>
                  </div>
                  <div class="card-body">
                    <div style="height: 300px; position: relative;">
                      <canvas id="revenueByDayChart"></canvas>
                    </div>
                  </div>
                </div>

                <div class="card">
                  <div class="card-header">
                    <h4>Đơn Hàng Theo Trạng Thái</h4>
                  </div>
                  <div class="card-body">
                    <div style="height: 300px; position: relative;">
                      <canvas id="orderStatusChart"></canvas>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Top Products & Categories -->
              <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                <div class="card">
                  <div class="card-header">
                    <h4>Top Sản Phẩm Bán Chạy</h4>
                  </div>
                  <div class="card-body">
                    <div class="table-container">
                      <table>
                        <thead>
                          <tr>
                            <th>Sản Phẩm</th>
                            <th>Đã Bán</th>
                            <th>Doanh Thu</th>
                          </tr>
                        </thead>
                        <tbody id="analyticsTopProducts">
                          <tr><td colspan="3" class="text-center">Đang tải...</td></tr>
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>

                <div class="card">
                  <div class="card-header">
                    <h4>Top Danh Mục</h4>
                  </div>
                  <div class="card-body">
                    <div class="table-container">
                      <table>
                        <thead>
                          <tr>
                            <th>Danh Mục</th>
                            <th>Sản Phẩm</th>
                            <th>Doanh Thu</th>
                          </tr>
                        </thead>
                        <tbody id="analyticsTopCategories">
                          <tr><td colspan="3" class="text-center">Đang tải...</td></tr>
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Settings Section -->
        <div id="settings" class="content-section">
          <div class="card">
            <div class="card-header">
              <h3><i class="fas fa-cog"></i> Cài Đặt Hệ Thống</h3>
            </div>
            <div class="card-body">
              <!-- Website Settings -->
              <div class="card" style="margin-bottom: 20px;">
                <div class="card-header">
                  <h4>Thông Tin Website</h4>
                </div>
                <div class="card-body">
                  <div class="form-group">
                    <label class="form-label">Tên Website</label>
                    <input type="text" class="form-input" id="settingSiteName" value="Tiệm Hoa nhà tớ">
                  </div>
                  <div class="form-group">
                    <label class="form-label">Slogan</label>
                    <input type="text" class="form-input" id="settingSlogan" value="Hoa tươi mỗi ngày">
                  </div>
                  <div class="form-group">
                    <label class="form-label">Email Liên Hệ</label>
                    <input type="email" class="form-input" id="settingEmail" value="contact@flowershop.vn">
                  </div>
                  <div class="form-group">
                    <label class="form-label">Số Điện Thoại</label>
                    <input type="tel" class="form-input" id="settingPhone" value="0123 456 789">
                  </div>
                  <div class="form-group">
                    <label class="form-label">Địa Chỉ</label>
                    <textarea class="form-input" id="settingAddress" rows="2">123 Đường ABC, Quận XYZ, TP.HCM</textarea>
                  </div>
                  <button class="btn btn-primary" onclick="saveWebsiteSettings()">
                    <i class="fas fa-save"></i> Lưu Thông Tin
                  </button>
                </div>
              </div>

              <!-- Order Settings -->
              <div class="card" style="margin-bottom: 20px;">
                <div class="card-header">
                  <h4>Cài Đặt Đơn Hàng</h4>
                </div>
                <div class="card-body">
                  <div class="form-group">
                    <label class="form-label">Phí Vận Chuyển Mặc Định (VNĐ)</label>
                    <input type="number" class="form-input" id="settingShippingFee" value="30000">
                  </div>
                  <div class="form-group">
                    <label class="form-label">Miễn Phí Ship Từ (VNĐ)</label>
                    <input type="number" class="form-input" id="settingFreeShipThreshold" value="500000">
                  </div>
                  <div class="form-group">
                    <label class="form-label">Thời Gian Hủy Đơn Tự Động (giờ)</label>
                    <input type="number" class="form-input" id="settingAutoCancelTime" value="24">
                    <small style="color: var(--text-light);">Đơn hàng pending sẽ tự động hủy sau thời gian này</small>
                  </div>
                  <button class="btn btn-primary" onclick="saveOrderSettings()">
                    <i class="fas fa-save"></i> Lưu Cài Đặt
                  </button>
                </div>
              </div>

              <!-- Payment Methods -->
              <div class="card" style="margin-bottom: 20px;">
                <div class="card-header">
                  <h4>Phương Thức Thanh Toán</h4>
                </div>
                <div class="card-body">
                  <div class="form-group">
                    <label style="display: flex; align-items: center; gap: 10px; cursor: pointer;">
                      <input type="checkbox" id="paymentCOD" checked>
                      <span><i class="fas fa-money-bill-wave"></i> COD - Thanh toán khi nhận hàng</span>
                    </label>
                  </div>
                  <div class="form-group">
                    <label style="display: flex; align-items: center; gap: 10px; cursor: pointer;">
                      <input type="checkbox" id="paymentBank" checked>
                      <span><i class="fas fa-university"></i> Chuyển khoản ngân hàng</span>
                    </label>
                  </div>
                  <div class="form-group">
                    <label style="display: flex; align-items: center; gap: 10px; cursor: pointer;">
                      <input type="checkbox" id="paymentMomo">
                      <span><i class="fas fa-mobile-alt"></i> Ví MoMo</span>
                    </label>
                  </div>
                  <div class="form-group">
                    <label style="display: flex; align-items: center; gap: 10px; cursor: pointer;">
                      <input type="checkbox" id="paymentVNPay">
                      <span><i class="fas fa-credit-card"></i> VNPay</span>
                    </label>
                  </div>
                  <button class="btn btn-primary" onclick="savePaymentSettings()">
                    <i class="fas fa-save"></i> Lưu Cài Đặt
                  </button>
                </div>
              </div>

              <!-- Email Settings -->
              <div class="card">
                <div class="card-header">
                  <h4>Cài Đặt Email</h4>
                </div>
                <div class="card-body">
                  <div class="form-group">
                    <label style="display: flex; align-items: center; gap: 10px; cursor: pointer;">
                      <input type="checkbox" id="emailOrderConfirm" checked>
                      <span>Gửi email xác nhận đơn hàng</span>
                    </label>
                  </div>
                  <div class="form-group">
                    <label style="display: flex; align-items: center; gap: 10px; cursor: pointer;">
                      <input type="checkbox" id="emailOrderStatus" checked>
                      <span>Gửi email khi cập nhật trạng thái</span>
                    </label>
                  </div>
                  <div class="form-group">
                    <label style="display: flex; align-items: center; gap: 10px; cursor: pointer;">
                      <input type="checkbox" id="emailPromotion">
                      <span>Gửi email khuyến mãi</span>
                    </label>
                  </div>
                  <button class="btn btn-primary" onclick="saveEmailSettings()">
                    <i class="fas fa-save"></i> Lưu Cài Đặt
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- ============================================
         MODALS - Order Detail & Update Status
         ============================================ -->
    <!-- Order Detail Modal -->
    <div class="modal-overlay" id="orderDetailModal">
      <div class="modal modal-lg">
        <div class="modal-header">
          <h3>
            <i class="fas fa-receipt"></i> Chi Tiết Đơn Hàng #<span
              id="modalOrderId"
            ></span>
          </h3>
          <button class="modal-close" onclick="closeModal('orderDetailModal')">
            <i class="fas fa-times"></i>
          </button>
        </div>
        <div class="modal-body">
          <!-- Order Info -->
          <div
            style="
              display: grid;
              grid-template-columns: 1fr 1fr;
              gap: 20px;
              margin-bottom: 20px;
            "
          >
            <div>
              <h4 style="margin-bottom: 15px; color: var(--primary)">
                <i class="fas fa-user"></i> Thông Tin Khách Hàng
              </h4>
              <div class="info-group">
                <label>Họ tên:</label>
                <p id="orderDetailCustomerName"></p>
              </div>
              <div class="info-group">
                <label>SĐT:</label>
                <p id="orderDetailPhone"></p>
              </div>
              <div class="info-group">
                <label>Email:</label>
                <p id="orderDetailEmail"></p>
              </div>
              <div class="info-group">
                <label>Địa chỉ:</label>
                <p id="orderDetailAddress"></p>
              </div>
            </div>
            <div>
              <h4 style="margin-bottom: 15px; color: var(--primary)">
                <i class="fas fa-info-circle"></i> Thông Tin Đơn Hàng
              </h4>
              <div class="info-group">
                <label>Ngày đặt:</label>
                <p id="orderDetailDate"></p>
              </div>
              <div class="info-group">
                <label>Trạng thái:</label>
                <p><span id="orderDetailStatus" class="badge"></span></p>
              </div>
              <div class="info-group">
                <label>Phương thức thanh toán:</label>
                <p id="orderDetailPaymentMethod"></p>
              </div>
              <div class="info-group">
                <label>Ghi chú:</label>
                <p id="orderDetailNote"></p>
              </div>
            </div>
          </div>

          <!-- Order Items -->
          <h4 style="margin-bottom: 15px; color: var(--primary)">
            <i class="fas fa-box"></i> Sản Phẩm
          </h4>
          <div class="table-container">
            <table>
              <thead>
                <tr>
                  <th>Sản phẩm</th>
                  <th>Đơn giá</th>
                  <th>SL</th>
                  <th>Thành tiền</th>
                </tr>
              </thead>
              <tbody id="orderDetailItems"></tbody>
            </table>
          </div>

          <!-- Order Total -->
          <div
            style="
              text-align: right;
              margin-top: 20px;
              padding-top: 20px;
              border-top: 2px solid var(--border-color);
            "
          >
            <div style="display: inline-block; text-align: left">
              <div class="info-group" style="margin-bottom: 10px">
                <label style="font-weight: normal">Tạm tính:</label>
                <strong
                  id="orderDetailSubtotal"
                  style="margin-left: 20px"
                ></strong>
              </div>
              <div class="info-group" style="margin-bottom: 10px">
                <label style="font-weight: normal">Phí vận chuyển:</label>
                <strong
                  id="orderDetailShipping"
                  style="margin-left: 20px"
                ></strong>
              </div>
              <div class="info-group" style="margin-bottom: 10px">
                <label style="font-weight: normal">Giảm giá:</label>
                <strong
                  id="orderDetailDiscount"
                  style="margin-left: 20px; color: var(--danger)"
                ></strong>
              </div>
              <div
                class="info-group"
                style="
                  font-size: 1.2em;
                  padding-top: 10px;
                  border-top: 1px solid var(--border-color);
                "
              >
                <label style="font-weight: bold">Tổng cộng:</label>
                <strong
                  id="orderDetailTotal"
                  style="margin-left: 20px; color: var(--primary)"
                ></strong>
              </div>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button
            class="btn btn-secondary"
            onclick="closeModal('orderDetailModal')"
          >
            Đóng
          </button>
          <button class="btn btn-primary" onclick="openUpdateStatusModal()">
            <i class="fas fa-edit"></i> Cập Nhật Trạng Thái
          </button>
        </div>
      </div>
    </div>

    <!-- Update Status Modal -->
    <div class="modal-overlay" id="updateStatusModal">
      <div class="modal">
        <div class="modal-header">
          <h3><i class="fas fa-edit"></i> Cập Nhật Trạng Thái</h3>
          <button class="modal-close" onclick="closeModal('updateStatusModal')">
            <i class="fas fa-times"></i>
          </button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label>Đơn hàng #<span id="updateStatusOrderId"></span></label>
          </div>
          <div class="form-group">
            <label for="newOrderStatus"
              >Trạng thái mới <span class="text-danger">*</span></label
            >
            <select id="newOrderStatus" class="form-input" required>
              <option value="">-- Chọn trạng thái --</option>
              <option value="pending">Chờ xử lý</option>
              <option value="shipping">Đang giao</option>
              <option value="delivered">Đã giao</option>
              <option value="cancelled">Đã hủy</option>
            </select>
          </div>
          <div class="form-group">
            <label for="statusNote">Ghi chú (tùy chọn)</label>
            <textarea
              id="statusNote"
              class="form-input"
              rows="3"
              placeholder="Nhập ghi chú về việc thay đổi trạng thái..."
            ></textarea>
          </div>
        </div>
        <div class="modal-footer">
          <button
            class="btn btn-secondary"
            onclick="closeModal('updateStatusModal')"
          >
            Hủy
          </button>
          <button class="btn btn-primary" onclick="updateOrderStatus()">
            <i class="fas fa-save"></i> Cập Nhật
          </button>
        </div>
      </div>
    </div>

    <!-- Add/Edit Product Modal -->
    <div class="modal-overlay" id="productModal">
      <div class="modal modal-lg">
        <div class="modal-header">
          <h3>
            <i class="fas fa-box"></i>
            <span id="productModalTitle">Thêm Sản Phẩm</span>
          </h3>
          <button class="modal-close" onclick="closeModal('productModal')">
            <i class="fas fa-times"></i>
          </button>
        </div>
        <div class="modal-body">
          <form id="productForm">
            <input type="hidden" id="productId" />
            <div
              style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px"
            >
              <div>
                <div class="form-group">
                  <label for="productName"
                    >Tên sản phẩm <span class="text-danger">*</span></label
                  >
                  <input
                    type="text"
                    id="productName"
                    class="form-input"
                    required
                    placeholder="Nhập tên sản phẩm"
                  />
                </div>
                <div class="form-group">
                  <label for="productCategory"
                    >Danh mục <span class="text-danger">*</span></label
                  >
                  <select id="productCategory" class="form-input" required>
                    <option value="">-- Chọn danh mục --</option>
                  </select>
                </div>
                <div class="form-group">
                  <label for="productPrice"
                    >Giá <span class="text-danger">*</span></label
                  >
                  <input
                    type="number"
                    id="productPrice"
                    class="form-input"
                    required
                    min="0"
                    step="1000"
                    placeholder="Nhập giá"
                  />
                </div>
                <div class="form-group">
                  <label for="productQuantity"
                    >Số lượng <span class="text-danger">*</span></label
                  >
                  <input
                    type="number"
                    id="productQuantity"
                    class="form-input"
                    required
                    min="0"
                    placeholder="Nhập số lượng"
                  />
                </div>
              </div>
              <div>
                <div class="form-group">
                  <label for="productImage">Hình ảnh sản phẩm</label>
                  <div style="margin-bottom: 10px">
                    <input
                      type="file"
                      id="productImageFile"
                      class="form-input"
                      accept="image/*"
                      onchange="handleImageSelect(event)"
                      style="display: none"
                    />
                    <button
                      type="button"
                      class="btn btn-secondary"
                      onclick="document.getElementById('productImageFile').click()"
                    >
                      <i class="fas fa-upload"></i> Chọn ảnh
                    </button>
                    <button
                      type="button"
                      class="btn btn-light"
                      onclick="clearImage()"
                      style="margin-left: 10px"
                    >
                      <i class="fas fa-times"></i> Xóa
                    </button>
                  </div>
                  <input
                    type="text"
                    id="productImage"
                    class="form-input"
                    placeholder="URL hình ảnh (tự động sau khi upload)"
                    readonly
                  />
                  <div
                    id="imagePreview"
                    style="margin-top: 10px; display: none"
                  >
                    <img
                      id="previewImg"
                      src=""
                      style="
                        max-width: 200px;
                        max-height: 200px;
                        border-radius: 8px;
                        border: 1px solid #ddd;
                      "
                    />
                  </div>
                </div>
                <div class="form-group">
                  <label for="productDescription">Mô tả</label>
                  <textarea
                    id="productDescription"
                    class="form-input"
                    rows="8"
                    placeholder="Nhập mô tả sản phẩm"
                  ></textarea>
                </div>
              </div>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button
            class="btn btn-secondary"
            onclick="closeModal('productModal')"
          >
            Hủy
          </button>
          <button class="btn btn-primary" onclick="saveProduct()">
            <i class="fas fa-save"></i> Lưu
          </button>
        </div>
      </div>
    </div>

    <!-- Delete Product Confirmation Modal -->
    <div class="modal-overlay" id="deleteProductModal">
      <div class="modal">
        <div class="modal-header">
          <h3><i class="fas fa-trash"></i> Xác Nhận Xóa</h3>
          <button
            class="modal-close"
            onclick="closeModal('deleteProductModal')"
          >
            <i class="fas fa-times"></i>
          </button>
        </div>
        <div class="modal-body">
          <p>
            Bạn có chắc chắn muốn xóa sản phẩm
            <strong id="deleteProductName"></strong>?
          </p>
          <p class="text-danger">
            <i class="fas fa-exclamation-triangle"></i> Hành động này không thể
            hoàn tác!
          </p>
          <input type="hidden" id="deleteProductId" />
        </div>
        <div class="modal-footer">
          <button
            class="btn btn-secondary"
            onclick="closeModal('deleteProductModal')"
          >
            Hủy
          </button>
          <button class="btn btn-danger" onclick="confirmDeleteProduct()">
            <i class="fas fa-trash"></i> Xóa
          </button>
        </div>
      </div>
    </div>

    <!-- Category Modal -->
    <div class="modal-overlay" id="categoryModal">
      <div class="modal">
        <div class="modal-header">
          <h3><i class="fas fa-list"></i> <span id="categoryModalTitle">Thêm Danh Mục</span></h3>
          <button class="modal-close" onclick="closeModal('categoryModal')">
            <i class="fas fa-times"></i>
          </button>
        </div>
        <div class="modal-body">
          <form id="categoryForm">
            <input type="hidden" id="categoryId" />
            <div class="form-group">
              <label for="categoryName">Tên danh mục <span class="text-danger">*</span></label>
              <input type="text" id="categoryName" class="form-input" required placeholder="Nhập tên danh mục" />
            </div>
            <div class="form-group">
              <label for="categoryParent">Danh mục cha</label>
              <select id="categoryParent" class="form-input">
                <option value="">-- Không có --</option>
              </select>
            </div>
            <div class="form-group">
              <label for="categoryOrder">Thứ tự hiển thị</label>
              <input type="number" id="categoryOrder" class="form-input" value="0" min="0" />
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" onclick="closeModal('categoryModal')">Hủy</button>
          <button class="btn btn-primary" onclick="saveCategory()">
            <i class="fas fa-save"></i> Lưu
          </button>
        </div>
      </div>
    </div>

    <!-- Coupon Modal -->
    <div class="modal-overlay" id="couponModal">
      <div class="modal">
        <div class="modal-header">
          <h3><i class="fas fa-tags"></i> <span id="couponModalTitle">Thêm Mã Giảm Giá</span></h3>
          <button class="modal-close" onclick="closeModal('couponModal')">
            <i class="fas fa-times"></i>
          </button>
        </div>
        <div class="modal-body">
          <form id="couponForm">
            <input type="hidden" id="couponId" />
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px">
              <div class="form-group">
                <label for="couponCode">Mã Code <span class="text-danger">*</span></label>
                <input type="text" id="couponCode" class="form-input" required placeholder="VD: SALE50" style="text-transform: uppercase;" />
              </div>
              <div class="form-group">
                <label for="couponType">Loại giảm giá <span class="text-danger">*</span></label>
                <select id="couponType" class="form-input" required>
                  <option value="percent">Phần trăm (%)</option>
                  <option value="fixed">Số tiền cố định (đ)</option>
                </select>
              </div>
              <div class="form-group">
                <label for="couponValue">Giá trị <span class="text-danger">*</span></label>
                <input type="number" id="couponValue" class="form-input" required min="0" placeholder="VD: 10 hoặc 50000" />
              </div>
              <div class="form-group">
                <label for="couponMinOrder">Đơn tối thiểu</label>
                <input type="number" id="couponMinOrder" class="form-input" min="0" value="0" />
              </div>
              <div class="form-group">
                <label for="couponMaxDiscount">Giảm tối đa (đ)</label>
                <input type="number" id="couponMaxDiscount" class="form-input" min="0" placeholder="Để trống nếu không giới hạn" />
              </div>
              <div class="form-group">
                <label for="couponLimit">Giới hạn số lần dùng</label>
                <input type="number" id="couponLimit" class="form-input" min="0" placeholder="Để trống nếu không giới hạn" />
              </div>
              <div class="form-group">
                <label for="couponStartDate">Ngày bắt đầu</label>
                <input type="date" id="couponStartDate" class="form-input" />
              </div>
              <div class="form-group">
                <label for="couponEndDate">Ngày kết thúc</label>
                <input type="date" id="couponEndDate" class="form-input" />
              </div>
            </div>
            <div class="form-group">
              <label for="couponDescription">Mô tả</label>
              <textarea id="couponDescription" class="form-input" rows="3" placeholder="Mô tả về mã giảm giá"></textarea>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" onclick="closeModal('couponModal')">Hủy</button>
          <button class="btn btn-primary" onclick="saveCoupon()">
            <i class="fas fa-save"></i> Lưu
          </button>
        </div>
      </div>
    </div>

    <!-- Contact Detail Modal -->
    <div class="modal-overlay" id="contactModal">
      <div class="modal modal-lg">
        <div class="modal-header">
          <h3><i class="fas fa-envelope"></i> Chi Tiết Liên Hệ</h3>
          <button class="modal-close" onclick="closeModal('contactModal')">
            <i class="fas fa-times"></i>
          </button>
        </div>
        <div class="modal-body">
          <input type="hidden" id="contactId" />
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px">
            <div>
              <div class="info-group">
                <label>Tên:</label>
                <p id="contactName"></p>
              </div>
              <div class="info-group">
                <label>Email:</label>
                <p id="contactEmail"></p>
              </div>
              <div class="info-group">
                <label>SĐT:</label>
                <p id="contactPhone"></p>
              </div>
            </div>
            <div>
              <div class="info-group">
                <label>Tiêu đề:</label>
                <p id="contactSubject"></p>
              </div>
              <div class="info-group">
                <label>Ngày gửi:</label>
                <p id="contactDate"></p>
              </div>
              <div class="info-group">
                <label>Trạng thái:</label>
                <select id="contactStatus" class="form-input" onchange="updateContactStatus()">
                  <option value="new">Mới</option>
                  <option value="read">Đã đọc</option>
                  <option value="replied">Đã trả lời</option>
                </select>
              </div>
            </div>
          </div>
          <div class="info-group">
            <label>Nội dung:</label>
            <div id="contactMessage" style="padding: 15px; background: var(--bg-light); border-radius: 8px; white-space: pre-wrap;"></div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" onclick="closeModal('contactModal')">Đóng</button>
        </div>
      </div>
    </div>

    <!-- ============================================
         NOTIFICATION TOAST
         ============================================ -->
    <div class="notification" id="notification">
      <i class="fas fa-check-circle"></i>
      <div class="notification-content">
        <div class="notification-title" id="notificationTitle">Thành công!</div>
        <div class="notification-message" id="notificationMessage">
          Thao tác đã được thực hiện
        </div>
      </div>
    </div>
    
    <!-- Gallery Modal -->
    <div class="modal-overlay" id="galleryModal">
      <div class="modal">
        <div class="modal-header">
          <h3><i class="fas fa-images"></i> <span id="galleryModalTitle">Thêm Ảnh Gallery</span></h3>
          <button class="modal-close" onclick="closeModal('galleryModal')">
            <i class="fas fa-times"></i>
          </button>
        </div>
        <div class="modal-body">
          <input type="hidden" id="galleryId" />
          <form id="galleryForm">
            <div class="form-group">
              <label for="galleryImageUrl">URL Hình Ảnh <span style="color: red;">*</span></label>
              <input type="url" id="galleryImageUrl" class="form-input" placeholder="https://example.com/image.jpg" required />
              <small style="color: #666;">Nhập URL hình ảnh hoặc upload lên server</small>
            </div>
            
            <div class="form-group">
              <label for="galleryCaption">Tiêu Đề <span style="color: red;">*</span></label>
              <input type="text" id="galleryCaption" class="form-input" placeholder="Bó hoa đẹp" required />
            </div>
            
            <div class="form-group">
              <label for="galleryDescription">Mô Tả</label>
              <textarea id="galleryDescription" class="form-input" rows="3" placeholder="Mô tả chi tiết về hình ảnh"></textarea>
            </div>
            
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
              <div class="form-group">
                <label for="galleryOrder">Thứ Tự Hiển Thị</label>
                <input type="number" id="galleryOrder" class="form-input" value="0" min="0" />
              </div>
              
              <div class="form-group">
                <label>
                  <input type="checkbox" id="galleryActive" checked />
                  <span>Hiển thị</span>
                </label>
              </div>
            </div>
            
            <!-- Preview image -->
            <div class="form-group" id="galleryPreviewContainer" style="display: none;">
              <label>Xem Trước:</label>
              <img id="galleryPreview" style="max-width: 100%; border-radius: 8px; margin-top: 10px;" />
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" onclick="closeModal('galleryModal')">Hủy</button>
          <button class="btn btn-primary" onclick="saveGallery()">
            <i class="fas fa-save"></i> Lưu
          </button>
        </div>
      </div>
    </div>
    
    <!-- News Modal -->
    <div class="modal-overlay" id="newsModal">
      <div class="modal" style="max-width: 800px;">
        <div class="modal-header">
          <h3><i class="fas fa-newspaper"></i> <span id="newsModalTitle">Thêm Tin Tức</span></h3>
          <button class="modal-close" onclick="closeModal('newsModal')">
            <i class="fas fa-times"></i>
          </button>
        </div>
        <div class="modal-body">
          <input type="hidden" id="newsId" />
          <form id="newsForm">
            <div class="form-group">
              <label for="newsTitle">Tiêu Đề <span style="color: red;">*</span></label>
              <input type="text" id="newsTitle" class="form-input" placeholder="Nhập tiêu đề tin tức" required />
            </div>
            
            <div class="form-group">
              <label for="newsSlug">Slug (URL) <span style="color: red;">*</span></label>
              <input type="text" id="newsSlug" class="form-input" placeholder="tu-dong-tao-hoac-nhap-slug" required />
              <small style="color: #666;">Slug sẽ tự động tạo từ tiêu đề, hoặc bạn có thể tự nhập</small>
            </div>
            
            <div class="form-group">
              <label for="newsExcerpt">Tóm Tắt <span style="color: red;">*</span></label>
              <textarea id="newsExcerpt" class="form-input" rows="2" placeholder="Tóm tắt ngắn gọn về bài viết" required></textarea>
            </div>
            
            <div class="form-group">
              <label for="newsContent">Nội Dung <span style="color: red;">*</span></label>
              <textarea id="newsContent" class="form-input" rows="8" placeholder="Nội dung chi tiết bài viết (hỗ trợ HTML)" required></textarea>
              <small style="color: #666;">Có thể sử dụng HTML tags: &lt;p&gt;, &lt;h3&gt;, &lt;strong&gt;, &lt;ul&gt;, &lt;li&gt;, etc.</small>
            </div>
            
            <div class="form-group">
              <label for="newsImageUrl">URL Hình Ảnh <span style="color: red;">*</span></label>
              <input type="url" id="newsImageUrl" class="form-input" placeholder="https://example.com/image.jpg" required />
            </div>
            
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
              <div class="form-group">
                <label for="newsCategory">Danh Mục <span style="color: red;">*</span></label>
                <select id="newsCategory" class="form-input" required>
                  <option value="">-- Chọn danh mục --</option>
                  <option value="tips">Mẹo chăm hoa</option>
                  <option value="opening">Lễ khai trương</option>
                  <option value="story">Câu chuyện</option>
                  <option value="proposal">Lời cầu hôn</option>
                  <option value="wedding">Đám cưới</option>
                  <option value="birthday">Sinh nhật</option>
                </select>
              </div>
              
              <div class="form-group">
                <label for="newsAuthor">Tác Giả</label>
                <input type="text" id="newsAuthor" class="form-input" placeholder="Nhập tên tác giả" value="Admin" />
              </div>
            </div>
            
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
              <div class="form-group">
                <label for="newsPublishedDate">Ngày Đăng</label>
                <input type="datetime-local" id="newsPublishedDate" class="form-input" />
              </div>
              
              <div class="form-group">
                <label>
                  <input type="checkbox" id="newsPublished" checked />
                  <span>Xuất bản ngay</span>
                </label>
              </div>
            </div>
            
            <!-- Preview image -->
            <div class="form-group" id="newsPreviewContainer" style="display: none;">
              <label>Xem Trước Ảnh:</label>
              <img id="newsPreview" style="max-width: 100%; border-radius: 8px; margin-top: 10px;" />
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" onclick="closeModal('newsModal')">Hủy</button>
          <button class="btn btn-primary" onclick="saveNews()">
            <i class="fas fa-save"></i> Lưu
          </button>
        </div>
      </div>
    </div>

    <!-- ============================================
         JAVASCRIPT - Sẽ thêm ở Bước 10
         ============================================ -->
    <script>
      // Context path
      const contextPath = "${pageContext.request.contextPath}";

      // Basic menu navigation
      document.addEventListener("DOMContentLoaded", function () {
        // Menu items click handler
        document.querySelectorAll(".menu-item[data-target]").forEach((item) => {
          item.addEventListener("click", function () {
            const target = this.getAttribute("data-target");
            showSection(target);

            // Update active menu
            document
              .querySelectorAll(".menu-item")
              .forEach((m) => m.classList.remove("active"));
            this.classList.add("active");
          });
        });
      });

      // Show section function
      function showSection(sectionId) {
        // Hide all sections
        document.querySelectorAll(".content-section").forEach((section) => {
          section.classList.remove("active");
        });

        // Show target section
        const section = document.getElementById(sectionId);
        if (section) {
          section.classList.add("active");
        }

        // Update page title
        const titles = {
          dashboard: "Dashboard",
          orders: "Quản Lý Đơn Hàng",
          products: "Quản Lý Sản Phẩm",
          categories: "Quản Lý Danh Mục",
          customers: "Quản Lý Khách Hàng",
          coupons: "Quản Lý Mã Giảm Giá",
          contacts: "Quản Lý Liên Hệ",
          gallery: "Quản Lý Gallery",
          news: "Quản Lý Tin Tức",
          analytics: "Thống Kê & Báo Cáo",
          settings: "Cài Đặt Hệ Thống",
        };

        const pageTitle = document.getElementById("pageTitle");
        if (pageTitle && titles[sectionId]) {
          pageTitle.textContent = titles[sectionId];
        }
        
        // Load data for specific sections
        if (sectionId === 'gallery') {
          loadGalleries();
        } else if (sectionId === 'news') {
          loadNews();
        } else if (sectionId === 'analytics') {
          console.log("🔄 Switching to analytics section");
          setTimeout(() => loadAnalytics(), 100);
        } else if (sectionId === 'settings') {
          setTimeout(() => loadSettings(), 100);
        }
      }

      // // Basic menu navigation
      // document.addEventListener("DOMContentLoaded", function () {
      //   // Menu items click handler
      //   document.querySelectorAll(".menu-item[data-target]").forEach((item) => {
      //     item.addEventListener("click", function () {
      //       const target = this.getAttribute("data-target");
      //       showSection(target);

      //       // Update active menu
      //       document
      //         .querySelectorAll(".menu-item")
      //         .forEach((m) => m.classList.remove("active"));
      //       this.classList.add("active");
      //     });
      //   });
      // });

      // Show notification function
      function showNotification(title, message, type = "success") {
        const notification = document.getElementById("notification");
        const notificationTitle = document.getElementById("notificationTitle");
        const notificationMessage = document.getElementById(
          "notificationMessage"
        );
        const icon = notification.querySelector("i");

        if (notification && notificationTitle && notificationMessage) {
          // Set content
          notificationTitle.textContent = title;
          notificationMessage.textContent = message;

          // Set type
          notification.className = "notification show " + type;

          // Set icon
          const icons = {
            success: "fa-check-circle",
            error: "fa-exclamation-circle",
            warning: "fa-exclamation-triangle",
            info: "fa-info-circle",
          };
          icon.className = "fas " + (icons[type] || icons.success);

          // Auto hide after 3 seconds
          setTimeout(() => {
            notification.classList.remove("show");
          }, 3000);
        }
      }

      // ============================================
      // DASHBOARD FUNCTIONALITY
      // ============================================

      let revenueChart = null;

      // Format helper functions
      function formatCurrency(amount) {
        return new Intl.NumberFormat("vi-VN", {
          style: "currency",
          currency: "VND",
        }).format(amount);
      }

      
      function formatNumber(num) {
        return new Intl.NumberFormat("vi-VN").format(num);
      }

      function formatDate(dateString) {
        const date = new Date(dateString);
        return date.toLocaleDateString("vi-VN", {
          day: "2-digit",
          month: "2-digit",
          year: "numeric",
        });
      }
      // Load dashboard data
      function loadDashboard() {
        loadStatistics();
        loadRevenueChart();
        loadRecentOrders();
        loadTopProducts();
      }


      function formatDateTime(dateString) {
        const date = new Date(dateString);
        return date.toLocaleString("vi-VN", {
          day: "2-digit",
          month: "2-digit",
          year: "numeric",
          hour: "2-digit",
          minute: "2-digit",
        });
      }

      // Load dashboard data
      function loadDashboard1() {
        loadStatistics();
        loadRevenueChart();
        loadRecentOrders();
        loadTopProducts();
      }

      // Load statistics
      async function loadStatistics() {
        try {
          const response = await fetch(contextPath + "/admin/api/stats");
          if (!response.ok) throw new Error("Failed to load statistics");

          const result = await response.json();
          console.log("📊 Statistics API Response:", result);
          const data = result.data || result;
          console.log("📊 Statistics Data:", data);
          console.log("💰 Total Revenue:", data.totalRevenue, typeof data.totalRevenue);

          // Update stat cards
          document.getElementById("statTotalOrders").textContent = formatNumber(
            data.totalOrders || 0
          );
          document.getElementById("statTotalRevenue").textContent =
            formatCurrency(data.totalRevenue || 0);
          document.getElementById("statTotalUsers").textContent = formatNumber(
            data.totalUsers || 0
          );
          document.getElementById("statTotalProducts").textContent =
            formatNumber(data.totalProducts || 0);

          // Update order status
          document.getElementById("pendingOrders").textContent = formatNumber(
            data.pendingOrders || 0
          );
          document.getElementById("shippingOrders").textContent = formatNumber(
            data.shippingOrders || 0
          );
          document.getElementById("deliveredOrders").textContent = formatNumber(
            data.deliveredOrders || 0
          );
          document.getElementById("cancelledOrders").textContent = formatNumber(
            data.cancelledOrders || 0
          );
        } catch (error) {
          console.error("Error loading statistics:", error);
          showNotification(
            "Lỗi",
            "Không thể tải thống kê: " + error.message,
            "error"
          );
        }
      }

      
      function createSampleChart() {
        const ctx = document.getElementById("revenueChart").getContext("2d");
        const labels = [
          "T1",
          "T2",
          "T3",
          "T4",
          "T5",
          "T6",
          "T7",
          "T8",
          "T9",
          "T10",
          "T11",
          "T12",
        ];
        const revenues = [
          15000000, 18000000, 22000000, 25000000, 28000000, 32000000, 30000000,
          35000000, 38000000, 42000000, 45000000, 48000000,
        ];

        if (revenueChart) {
          revenueChart.destroy();
        }

        revenueChart = new Chart(ctx, {
          type: "line",
          data: {
            labels: labels,
            datasets: [
              {
                label: "Doanh Thu",
                data: revenues,
                borderColor: "#667eea",
                backgroundColor: "rgba(102, 126, 234, 0.1)",
                borderWidth: 3,
                fill: true,
                tension: 0.4,
                pointRadius: 4,
                pointBackgroundColor: "#667eea",
                pointBorderColor: "#fff",
                pointBorderWidth: 2,
                pointHoverRadius: 6,
              },
            ],
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
              legend: {
                display: false,
              },
              tooltip: {
                callbacks: {
                  label: function (context) {
                    return "Doanh thu: " + formatCurrency(context.parsed.y);
                  },
                },
              },
            },
            scales: {
              y: {
                beginAtZero: true,
                ticks: {
                  callback: function (value) {
                    return formatCurrency(value);
                  },
                },
                grid: {
                  color: "rgba(0, 0, 0, 0.05)",
                },
              },
              x: {
                grid: {
                  display: false,
                },
              },
            },
          },
        });
      }

      // Load revenue chart
      async function loadRevenueChart() {
        try {
          const periodSelect = document.getElementById("revenueChartPeriod");
          const period = periodSelect ? periodSelect.value : "7";
          const response = await fetch(
            contextPath + "/admin/api/revenue?period=" + period
          );

          if (!response.ok) {
            throw new Error("Failed to load revenue data");
          }

          const data = await response.json();

          // Prepare chart data
          const labels = data.map((item) => item.label);
          const revenues = data.map((item) => item.revenue);

          // Destroy existing chart if exists
          if (revenueChart) {
            revenueChart.destroy();
          }

          // Create new chart
          const ctx = document.getElementById("revenueChart").getContext("2d");
          revenueChart = new Chart(ctx, {
            type: "line",
            data: {
              labels: labels,
              datasets: [
                {
                  label: "Doanh Thu",
                  data: revenues,
                  borderColor: "#667eea",
                  backgroundColor: "rgba(102, 126, 234, 0.1)",
                  borderWidth: 3,
                  fill: true,
                  tension: 0.4,
                  pointRadius: 4,
                  pointBackgroundColor: "#667eea",
                  pointBorderColor: "#fff",
                  pointBorderWidth: 2,
                  pointHoverRadius: 6,
                },
              ],
            },
            options: {
              responsive: true,
              maintainAspectRatio: false,
              plugins: {
                legend: {
                  display: false,
                },
                tooltip: {
                  callbacks: {
                    label: function (context) {
                      return "Doanh thu: " + formatCurrency(context.parsed.y);
                    },
                  },
                },
              },
              scales: {
                y: {
                  beginAtZero: true,
                  ticks: {
                    callback: function (value) {
                      return formatCurrency(value);
                    },
                  },
                  grid: {
                    color: "rgba(0, 0, 0, 0.05)",
                  },
                },
                x: {
                  grid: {
                    display: false,
                  },
                },
              },
            },
          });
        } catch (error) {
          console.error("Error loading revenue chart:", error);
          // If API endpoint doesn't exist yet, use sample data
          createSampleChart();
        }
      }

      // Create sample chart (fallback)
      function createSampleChart2() {
        const ctx = document.getElementById("revenueChart").getContext("2d");
        const labels = [
          "T1",
          "T2",
          "T3",
          "T4",
          "T5",
          "T6",
          "T7",
          "T8",
          "T9",
          "T10",
          "T11",
          "T12",
        ];
        const revenues = [
          15000000, 18000000, 22000000, 25000000, 28000000, 32000000, 30000000,
          35000000, 38000000, 42000000, 45000000, 48000000,
        ];

        if (revenueChart) {
          revenueChart.destroy();
        }

        revenueChart = new Chart(ctx, {
          type: "line",
          data: {
            labels: labels,
            datasets: [
              {
                label: "Doanh Thu",
                data: revenues,
                borderColor: "#667eea",
                backgroundColor: "rgba(102, 126, 234, 0.1)",
                borderWidth: 3,
                fill: true,
                tension: 0.4,
                pointRadius: 4,
                pointBackgroundColor: "#667eea",
                pointBorderColor: "#fff",
                pointBorderWidth: 2,
                pointHoverRadius: 6,
              },
            ],
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
              legend: {
                display: false,
              },
              tooltip: {
                callbacks: {
                  label: function (context) {
                    return "Doanh thu: " + formatCurrency(context.parsed.y);
                  },
                },
              },
            },
            scales: {
              y: {
                beginAtZero: true,
                ticks: {
                  callback: function (value) {
                    return formatCurrency(value);
                  },
                },
                grid: {
                  color: "rgba(0, 0, 0, 0.05)",
                },
              },
              x: {
                grid: {
                  display: false,
                },
              },
            },
          },
        });
      }

      // Load recent orders
      async function loadRecentOrders() {
        try {
          const response = await fetch(contextPath + "/admin/api/orders");
          if (!response.ok) throw new Error("Failed to load orders");

          const result = await response.json();
          const allOrders = result.data || result;
          const orders = Array.isArray(allOrders) ? allOrders.slice(0, 5) : [];
          const tbody = document.querySelector("#recentOrdersTable tbody");

          if (!orders || orders.length === 0) {
            tbody.innerHTML =
              '<tr><td colspan="4" class="text-center">Chưa có đơn hàng</td></tr>';
            return;
          }

          tbody.innerHTML = orders
            .map((order) => {
              const customerName =
                order.receiverName ||
                order.fullname ||
                (order.user ? order.user.fullname : null) ||
                "N/A";
              return (
                "<tr>" +
                "<td>#" +
                (order.orderCode || order.id) +
                "</td>" +
                "<td>" +
                customerName +
                "</td>" +
                "<td>" +
                formatCurrency(order.total || order.totalPrice || 0) +
                "</td>" +
                "<td>" +
                '<span class="badge badge-' +
                getStatusClass(order.orderStatus || order.status) +
                '">' +
                getStatusText(order.orderStatus || order.status) +
                "</span>" +
                "</td>" +
                "</tr>"
              );
            })
            .join("");
        } catch (error) {
          console.error("Error loading recent orders:", error);
          const tbody = document.querySelector("#recentOrdersTable tbody");
          tbody.innerHTML =
            '<tr><td colspan="4" class="text-center text-danger">Không thể tải dữ liệu</td></tr>';
        }
      }

      // if (!orders || orders.length === 0) {
      //       tbody.innerHTML =
      //         '<tr><td colspan="4" class="text-center">Chưa có đơn hàng</td></tr>';
      //       return;
      //     }


      // Load top products
      async function loadTopProducts() {
        try {
          const response = await fetch(contextPath + "/admin/api/products/top?limit=5");
          if (!response.ok) throw new Error("Failed to load top products");

          const result = await response.json();
          console.log("📦 Top Products Response:", result);
          
          const products = result.data || [];
          const tbody = document.querySelector("#topProductsTable tbody");

          if (!products || products.length === 0) {
            tbody.innerHTML =
              '<tr><td colspan="3" class="text-center">Chưa có dữ liệu</td></tr>';
            return;
          }

          tbody.innerHTML = products
            .map((product) => {
              const soldCount = product.soldCount || 0;
              const price = product.price || 0;
              const revenue = soldCount * price;
              
              return (
                "<tr>" +
                "<td>" +
                (product.name || 'N/A') +
                "</td>" +
                "<td>" +
                formatNumber(soldCount) +
                "</td>" +
                "<td>" +
                formatCurrency(revenue) +
                "</td>" +
                "</tr>"
              );
            })
            .join("");
        } catch (error) {
          console.error("Error loading top products:", error);
          const tbody = document.querySelector("#topProductsTable tbody");
          tbody.innerHTML =
            '<tr><td colspan="3" class="text-center text-danger">Không thể tải dữ liệu</td></tr>';
        }
      }

      // Helper function to get status class
      function getStatusClass(status) {
        const statusMap = {
          pending: "warning",
          shipping: "info",
          delivered: "success",
          cancelled: "danger",
        };
        return statusMap[status?.toLowerCase()] || "secondary";
      }

      // Helper function to get status text
      function getStatusText(status) {
        const statusMap = {
          pending: "Chờ xử lý",
          shipping: "Đang giao",
          delivered: "Đã giao",
          cancelled: "Đã hủy",
        };
        return statusMap[status?.toLowerCase()] || status;
      }

      // Chart period change handler
      document.addEventListener("DOMContentLoaded", function () {
        const chartPeriodSelect = document.getElementById("revenueChartPeriod");
        if (chartPeriodSelect) {
          chartPeriodSelect.addEventListener("change", loadRevenueChart);
        }

        // Analytics date range change handler
        const analyticsDateRange = document.getElementById("analyticsDateRange");
        if (analyticsDateRange) {
          analyticsDateRange.addEventListener("change", function() {
            loadAnalytics();
          });
        }

        // Load dashboard when dashboard section is active
        const dashboardSection = document.getElementById("dashboard");
        if (dashboardSection && dashboardSection.classList.contains("active")) {
          loadDashboard();
        }

        // Load analytics when analytics section is active
        const analyticsSection = document.getElementById("analytics");
        console.log("Analytics section:", analyticsSection);
        console.log("Is active?", analyticsSection?.classList.contains("active"));
        if (analyticsSection && analyticsSection.classList.contains("active")) {
          console.log("🚀 Auto-loading analytics on page load...");
          setTimeout(() => loadAnalytics(), 200);
        }

        // Also reload when switching to dashboard
        const dashboardMenuItem = document.querySelector(
          '.menu-item[data-target="dashboard"]'
        );
        if (dashboardMenuItem) {
          dashboardMenuItem.addEventListener("click", function () {
            setTimeout(loadDashboard, 100);
          });
        }
      });

      // ============================================
      // ORDERS MANAGEMENT FUNCTIONALITY
      // ============================================

      let currentOrders = [];
      let currentOrderId = null;
      let currentPage = 1;
      const ordersPerPage = 10;

      // Load orders
      async function loadOrders(page = 1) {
        try {
          currentPage = page;
          const params = new URLSearchParams();

          // Add filters
          const search = document.getElementById("orderSearchInput")?.value;
          const status = document.getElementById("orderStatusFilter")?.value;
          const dateFrom = document.getElementById("orderDateFrom")?.value;
          const dateTo = document.getElementById("orderDateTo")?.value;

          if (search) params.append("search", search);
          if (status) params.append("status", status);
          if (dateFrom) params.append("dateFrom", dateFrom);
          if (dateTo) params.append("dateTo", dateTo);

          const response = await fetch(
            contextPath + "/admin/api/orders?" + params.toString()
          );
          if (!response.ok) throw new Error("Failed to load orders");

          const result = await response.json();
          currentOrders = result.data || result || [];
          displayOrders();
          displayOrdersPagination();
        } catch (error) {
          console.error("Error loading orders:", error);
          const tbody = document.querySelector("#ordersTable tbody");
          tbody.innerHTML =
            '<tr><td colspan="7" class="text-center text-danger">Không thể tải dữ liệu</td></tr>';
          showNotification("Lỗi", "Không thể tải danh sách đơn hàng", "error");
        }
      }

      // Display orders in table
      function displayOrders() {
        const tbody = document.querySelector("#ordersTable tbody");
        const start = (currentPage - 1) * ordersPerPage;
        const end = start + ordersPerPage;
        const pageOrders = currentOrders.slice(start, end);

        if (pageOrders.length === 0) {
          tbody.innerHTML =
            '<tr><td colspan="7" class="text-center">Không có đơn hàng nào</td></tr>';
          return;
        }

        tbody.innerHTML = pageOrders
          .map((order) => {
            const customerName =
              order.receiverName ||
              order.fullname ||
              (order.user ? order.user.fullname : null) ||
              "N/A";
            const phone =
              order.receiverPhone ||
              order.phone ||
              (order.user ? order.user.phone : null) ||
              "N/A";
            return (
              "<tr>" +
              "<td><strong>#" +
              (order.orderCode || order.id) +
              "</strong></td>" +
              "<td>" +
              customerName +
              "</td>" +
              "<td>" +
              phone +
              "</td>" +
              "<td>" +
              formatDateTime(order.createdAt || order.orderDate) +
              "</td>" +
              "<td><strong>" +
              formatCurrency(order.total || order.totalPrice || 0) +
              "</strong></td>" +
              "<td>" +
              '<span class="badge badge-' +
              getStatusClass(order.orderStatus || order.status) +
              '">' +
              getStatusText(order.orderStatus || order.status) +
              "</span>" +
              "</td>" +
              "<td>" +
              '<button class="btn btn-primary btn-sm" onclick="viewOrderDetail(' +
              order.id +
              ')" title="Xem chi tiết">' +
              '<i class="fas fa-eye"></i>' +
              "</button>" +
              '<button class="btn btn-warning btn-sm" onclick="quickUpdateStatus(' +
              order.id +
              ')" title="Cập nhật">' +
              '<i class="fas fa-edit"></i>' +
              "</button>" +
              "</td>" +
              "</tr>"
            );
          })
          .join("");
      }

      // Display pagination
      function displayOrdersPagination() {
        const totalPages = Math.ceil(currentOrders.length / ordersPerPage);
        const pagination = document.getElementById("ordersPagination");

        if (totalPages <= 1) {
          pagination.innerHTML = "";
          return;
        }

        let html = "";

        // Previous button
        const prevDisabled = currentPage === 1 ? "disabled" : "";
        html +=
          '<button class="pagination-btn" ' +
          prevDisabled +
          ' onclick="loadOrders(' +
          (currentPage - 1) +
          ')">' +
          '<i class="fas fa-chevron-left"></i>' +
          "</button>";

        // Page numbers
        for (let i = 1; i <= totalPages; i++) {
          if (
            i === 1 ||
            i === totalPages ||
            (i >= currentPage - 2 && i <= currentPage + 2)
          ) {
            const activeClass = i === currentPage ? "active" : "";
            html +=
              '<button class="pagination-btn ' +
              activeClass +
              '" onclick="loadOrders(' +
              i +
              ')">' +
              i +
              "</button>";
          } else if (i === currentPage - 3 || i === currentPage + 3) {
            html += '<span class="pagination-dots">...</span>';
          }
        }

        // Next button
        const nextDisabled = currentPage === totalPages ? "disabled" : "";
        html +=
          '<button class="pagination-btn" ' +
          nextDisabled +
          ' onclick="loadOrders(' +
          (currentPage + 1) +
          ')">' +
          '<i class="fas fa-chevron-right"></i>' +
          "</button>";

        pagination.innerHTML = html;
      }

      // Search orders
      function searchOrders() {
        loadOrders(1);
      }

      // Reset filters
      function resetOrderFilters() {
        document.getElementById("orderSearchInput").value = "";
        document.getElementById("orderStatusFilter").value = "";
        document.getElementById("orderDateFrom").value = "";
        document.getElementById("orderDateTo").value = "";
        loadOrders(1);
      }

      // View order detail
      async function viewOrderDetail(orderId) {
        try {
          const response = await fetch(
            contextPath + "/admin/api/order/" + orderId
          );
          if (!response.ok) throw new Error("Failed to load order details");

          const result = await response.json();
          const order = result.data || result;
          currentOrderId = orderId;

          // Populate modal
          document.getElementById("modalOrderId").textContent =
            order.orderCode || order.id;
          document.getElementById("orderDetailCustomerName").textContent =
            order.receiverName || order.fullname || "N/A";
          document.getElementById("orderDetailPhone").textContent =
            order.receiverPhone || order.phone || "N/A";
          document.getElementById("orderDetailEmail").textContent =
            order.receiverEmail ||
            order.email ||
            (order.user ? order.user.email : null) ||
            "N/A";
          document.getElementById("orderDetailAddress").textContent =
            order.shippingAddress || order.address || "N/A";
          document.getElementById("orderDetailDate").textContent =
            formatDateTime(order.createdAt || order.orderDate);

          const statusBadge = document.getElementById("orderDetailStatus");
          statusBadge.textContent = getStatusText(
            order.orderStatus || order.status
          );
          statusBadge.className =
            "badge badge-" + getStatusClass(order.orderStatus || order.status);

          document.getElementById("orderDetailPaymentMethod").textContent =
            getPaymentMethodText(order.paymentMethod) || "COD";
          document.getElementById("orderDetailNote").textContent =
            order.note || "Không có";

          // Order items
          const itemsTable = document.getElementById("orderDetailItems");
          const items = order.orderItems || order.items || [];
          if (items.length > 0) {
            itemsTable.innerHTML = items
              .map((item) => {
                const productName =
                  item.productName ||
                  (item.product ? item.product.name : null) ||
                  "N/A";
                return (
                  "<tr>" +
                  "<td>" +
                  productName +
                  "</td>" +
                  "<td>" +
                  formatCurrency(item.price) +
                  "</td>" +
                  "<td>" +
                  item.quantity +
                  "</td>" +
                  "<td><strong>" +
                  formatCurrency(item.total || item.price * item.quantity) +
                  "</strong></td>" +
                  "</tr>"
                );
              })
              .join("");
          } else {
            itemsTable.innerHTML =
              '<tr><td colspan="4" class="text-center">Không có sản phẩm</td></tr>';
          }

          // Calculate totals
          const subtotal =
            order.subtotal ||
            items.reduce(
              (sum, item) => sum + (item.total || item.price * item.quantity),
              0
            );
          const shipping = order.shippingFee || 30000;
          const discount = order.discount || 0;

          document.getElementById("orderDetailSubtotal").textContent =
            formatCurrency(subtotal);
          document.getElementById("orderDetailShipping").textContent =
            formatCurrency(shipping);
          document.getElementById("orderDetailDiscount").textContent =
            discount > 0 ? "-" + formatCurrency(discount) : formatCurrency(0);
          document.getElementById("orderDetailTotal").textContent =
            formatCurrency(order.total || order.totalPrice || 0);

          // Show modal
          openModal("orderDetailModal");
        } catch (error) {
          console.error("Error loading order details:", error);
          showNotification("Lỗi", "Không thể tải chi tiết đơn hàng", "error");
        }
      }

      // Helper function to get payment method text
      function getPaymentMethodText(method) {
        const methodMap = {
          cod: "Thanh toán khi nhận hàng (COD)",
          bank: "Chuyển khoản ngân hàng",
          momo: "Ví MoMo",
          vnpay: "VNPay",
          zalopay: "ZaloPay",
        };
        return methodMap[method?.toLowerCase()] || method || "COD";
      }

      // Quick update status
      function quickUpdateStatus(orderId) {
        currentOrderId = orderId;
        document.getElementById("updateStatusOrderId").textContent = orderId;
        document.getElementById("newOrderStatus").value = "";
        document.getElementById("statusNote").value = "";
        openModal("updateStatusModal");
      }

      // Open update status modal from detail modal
      function openUpdateStatusModal() {
        closeModal("orderDetailModal");
        document.getElementById("updateStatusOrderId").textContent =
          currentOrderId;
        document.getElementById("newOrderStatus").value = "";
        document.getElementById("statusNote").value = "";
        openModal("updateStatusModal");
      }

      // Update order status
      async function updateOrderStatus() {
        const newStatus = document.getElementById("newOrderStatus").value;
        const note = document.getElementById("statusNote").value;

        if (!newStatus) {
          showNotification(
            "Cảnh báo",
            "Vui lòng chọn trạng thái mới",
            "warning"
          );
          return;
        }

        try {
          const params = new URLSearchParams();
          params.append("id", currentOrderId);
          params.append("status", newStatus);
          if (note) params.append("note", note);

          const response = await fetch(
            contextPath + "/admin/api/order/update-status",
            {
              method: "POST",
              headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
              },
              body: params.toString()
            }
          );

          const result = await response.json();

          if (!result.success) {
            throw new Error(result.message || "Failed to update status");
          }

          showNotification(
            "Thành công",
            "Đã cập nhật trạng thái đơn hàng",
            "success"
          );
          closeModal("updateStatusModal");
          loadOrders(currentPage);
          loadStatistics(); // Refresh statistics
        } catch (error) {
          console.error("Error updating status:", error);
          showNotification(
            "Lỗi",
            error.message || "Không thể cập nhật trạng thái",
            "error"
          );
        }
      }

      // Export orders
      function exportOrders() {
        exportOrdersToExcel();
      }

      // Modal utilities
      function openModal(modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
          modal.classList.add("show");
        }
      }

      function closeModal(modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
          modal.classList.remove("show");
        }
      }

      // Close modal on overlay click
      document.addEventListener("click", function (e) {
        if (e.target.classList.contains("modal-overlay")) {
          e.target.classList.remove("show");
        }
      });

      // Initialize orders section
      document.addEventListener("DOMContentLoaded", function () {
        const ordersMenuItem = document.querySelector(
          '.menu-item[data-target="orders"]'
        );
        if (ordersMenuItem) {
          ordersMenuItem.addEventListener("click", function () {
            setTimeout(() => loadOrders(1), 100);
          });
        }

        // Enter key for search
        const searchInput = document.getElementById("orderSearchInput");
        if (searchInput) {
          searchInput.addEventListener("keypress", function (e) {
            if (e.key === "Enter") {
              searchOrders();
            }
          });
        }
      });

      // ============================================
      // PRODUCTS MANAGEMENT FUNCTIONALITY
      // ============================================

      let currentProducts = [];
      let currentProductPage = 1;
      const productsPerPage = 10;
      let allCategories = [];

      // Load products
      async function loadProducts(page = 1) {
        try {
          currentProductPage = page;
          const params = new URLSearchParams();

          // Add filters
          const search = document.getElementById("productSearchInput")?.value;
          const category = document.getElementById(
            "productCategoryFilter"
          )?.value;
          const status = document.getElementById("productStatusFilter")?.value;

          if (search) params.append("search", search);
          if (category) params.append("categoryId", category);
          if (status) params.append("status", status);

          const response = await fetch(
            contextPath + "/admin/api/products?" + params.toString()
          );
          if (!response.ok) throw new Error("Failed to load products");

          const result = await response.json();
          currentProducts = result.data || result || [];
          displayProducts();
          displayProductsPagination();
        } catch (error) {
          console.error("Error loading products:", error);
          const tbody = document.querySelector("#productsTable tbody");
          tbody.innerHTML =
            '<tr><td colspan="8" class="text-center text-danger">Không thể tải dữ liệu</td></tr>';
          showNotification("Lỗi", "Không thể tải danh sách sản phẩm", "error");
        }
      }

      // Load categories for filter and form
      async function loadCategories() {
        try {
          const response = await fetch(contextPath + "/admin/api/categories");
          if (!response.ok) throw new Error("Failed to load categories");

          const result = await response.json();
          allCategories = result.data || result || [];

          // Populate filter dropdown
          const filterSelect = document.getElementById("productCategoryFilter");
          if (filterSelect) {
            filterSelect.innerHTML =
              '<option value="">Tất cả danh mục</option>' +
              allCategories
                .map(
                  (cat) =>
                    '<option value="' + cat.id + '">' + cat.name + "</option>"
                )
                .join("");
          }

          // Populate form dropdown
          const formSelect = document.getElementById("productCategory");
          if (formSelect) {
            formSelect.innerHTML =
              '<option value="">-- Chọn danh mục --</option>' +
              allCategories
                .map(
                  (cat) =>
                    '<option value="' + cat.id + '">' + cat.name + "</option>"
                )
                .join("");
          }
        } catch (error) {
          console.error("Error loading categories:", error);
        }
      }

      // Display products in table
      function displayProducts() {
        const tbody = document.querySelector("#productsTable tbody");
        const start = (currentProductPage - 1) * productsPerPage;
        const end = start + productsPerPage;
        const pageProducts = currentProducts.slice(start, end);

        if (pageProducts.length === 0) {
          tbody.innerHTML =
            '<tr><td colspan="8" class="text-center">Không có sản phẩm nào</td></tr>';
          return;
        }

        tbody.innerHTML = pageProducts
          .map((product) => {
            // Placeholder SVG cho ảnh không có
            const placeholderImage = 'data:image/svg+xml,%3Csvg xmlns="http://www.w3.org/2000/svg" width="50" height="50" viewBox="0 0 50 50"%3E%3Crect width="50" height="50" fill="%23e0e0e0"/%3E%3Ctext x="25" y="28" font-family="Arial" font-size="12" fill="%23999" text-anchor="middle"%3ENo Image%3C/text%3E%3C/svg%3E';
            const imageUrl = product.image ? (contextPath + "/" + product.image) : placeholderImage;
            const categoryName =
              (product.category ? product.category.name : null) ||
              (allCategories.find((c) => c.id === product.categoryId)
                ? allCategories.find((c) => c.id === product.categoryId).name
                : null) ||
              "N/A";
            const stockStatus =
              product.quantity > 0
                ? '<span class="badge badge-success">Còn hàng</span>'
                : '<span class="badge badge-danger">Hết hàng</span>';

            const productNameEscaped = product.name.replace(/'/g, "\\'");

            return (
              "<tr>" +
              "<td><strong>" +
              product.id +
              "</strong></td>" +
              "<td>" +
              '<img src="' +
              imageUrl +
              '" ' +
              'alt="' +
              product.name +
              '" ' +
              'style="width: 50px; height: 50px; object-fit: cover; border-radius: 4px; border: 1px solid #ddd;" ' +
              'onerror="this.src=\'' + placeholderImage + '\'">' +
              "</td>" +
              "<td>" +
              product.name +
              "</td>" +
              "<td>" +
              categoryName +
              "</td>" +
              "<td><strong>" +
              formatCurrency(product.price) +
              "</strong></td>" +
              "<td>" +
              stockStatus +
              " <strong>" +
              product.quantity +
              "</strong></td>" +
              "<td>" +
              formatNumber(product.soldCount || 0) +
              "</td>" +
              "<td>" +
              '<button class="btn btn-warning btn-sm" onclick="openEditProductModal(' +
              product.id +
              ')" title="Sửa">' +
              '<i class="fas fa-edit"></i>' +
              "</button>" +
              '<button class="btn btn-danger btn-sm" onclick="openDeleteProductModal(' +
              product.id +
              ", '" +
              productNameEscaped +
              '\')" title="Xóa">' +
              '<i class="fas fa-trash"></i>' +
              "</button>" +
              "</td>" +
              "</tr>"
            );
          })
          .join("");
      }

      // Display pagination
      function displayProductsPagination() {
        const totalPages = Math.ceil(currentProducts.length / productsPerPage);
        const pagination = document.getElementById("productsPagination");

        if (totalPages <= 1) {
          pagination.innerHTML = "";
          return;
        }

        let html = "";

        // Previous button
        const prevDisabled = currentProductPage === 1 ? "disabled" : "";
        html +=
          '<button class="pagination-btn" ' +
          prevDisabled +
          ' onclick="loadProducts(' +
          (currentProductPage - 1) +
          ')">' +
          '<i class="fas fa-chevron-left"></i>' +
          "</button>";

        // Page numbers
        for (let i = 1; i <= totalPages; i++) {
          if (
            i === 1 ||
            i === totalPages ||
            (i >= currentProductPage - 2 && i <= currentProductPage + 2)
          ) {
            const activeClass = i === currentProductPage ? "active" : "";
            html +=
              '<button class="pagination-btn ' +
              activeClass +
              '" onclick="loadProducts(' +
              i +
              ')">' +
              i +
              "</button>";
          } else if (
            i === currentProductPage - 3 ||
            i === currentProductPage + 3
          ) {
            html += '<span class="pagination-dots">...</span>';
          }
        }

        // Next button
        const nextDisabled =
          currentProductPage === totalPages ? "disabled" : "";
        html +=
          '<button class="pagination-btn" ' +
          nextDisabled +
          ' onclick="loadProducts(' +
          (currentProductPage + 1) +
          ')">' +
          '<i class="fas fa-chevron-right"></i>' +
          "</button>";

        pagination.innerHTML = html;
      }

      // Search products
      function searchProducts() {
        loadProducts(1);
      }

      // Reset filters
      function resetProductFilters() {
        document.getElementById("productSearchInput").value = "";
        document.getElementById("productCategoryFilter").value = "";
        document.getElementById("productStatusFilter").value = "";
        loadProducts(1);
      }

      // Open add product modal
      function openAddProductModal() {
        document.getElementById("productModalTitle").textContent =
          "Thêm Sản Phẩm";
        document.getElementById("productForm").reset();
        document.getElementById("productId").value = "";
        document.getElementById("imagePreview").style.display = "none";
        openModal("productModal");
      }

      // Handle image file selection
      async function handleImageSelect(event) {
        const file = event.target.files[0];
        if (!file) return;

        // Validate file type
        const validTypes = [
          "image/jpeg",
          "image/jpg",
          "image/png",
          "image/gif",
          "image/webp",
        ];
        if (!validTypes.includes(file.type)) {
          showNotification(
            "Lỗi",
            "Chỉ chấp nhận file ảnh (JPG, PNG, GIF, WEBP)",
            "error"
          );
          event.target.value = "";
          return;
        }

        // Validate file size (max 10MB)
        const maxSize = 10 * 1024 * 1024;
        if (file.size > maxSize) {
          showNotification(
            "Lỗi",
            "Kích thước file không được vượt quá 10MB",
            "error"
          );
          event.target.value = "";
          return;
        }

        // Show preview
        const reader = new FileReader();
        reader.onload = function (e) {
          document.getElementById("previewImg").src = e.target.result;
          document.getElementById("imagePreview").style.display = "block";
        };
        reader.readAsDataURL(file);

        // Upload to server
        await uploadImage(file);
      }

      // Upload image to server
      async function uploadImage(file) {
        const formData = new FormData();
        formData.append("file", file);
        formData.append("type", "product");

        try {
          showNotification(
            "Đang tải...",
            "Đang upload ảnh lên server...",
            "info"
          );

          const response = await fetch(contextPath + "/api/upload-image", {
            method: "POST",
            body: formData,
          });

          const result = await response.json();

          if (result.success) {
            document.getElementById("productImage").value = result.url;
            showNotification("Thành công", "Upload ảnh thành công!", "success");
          } else {
            showNotification(
              "Lỗi",
              result.message || "Upload ảnh thất bại",
              "error"
            );
            clearImage();
          }
        } catch (error) {
          console.error("Error uploading image:", error);
          showNotification(
            "Lỗi",
            "Không thể upload ảnh: " + error.message,
            "error"
          );
          clearImage();
        }
      }

      // Clear image selection
      function clearImage() {
        document.getElementById("productImageFile").value = "";
        document.getElementById("productImage").value = "";
        document.getElementById("imagePreview").style.display = "none";
        document.getElementById("previewImg").src = "";
      }

      // Open edit product modal
      async function openEditProductModal(productId) {
        try {
          const response = await fetch(
            contextPath + "/admin/api/product/" + productId
          );
          if (!response.ok) throw new Error("Failed to load product details");

          const result = await response.json();
          const product = result.data || result;

          document.getElementById("productModalTitle").textContent =
            "Sửa Sản Phẩm";
          document.getElementById("productId").value = product.id;
          document.getElementById("productName").value = product.name;
          document.getElementById("productCategory").value =
            product.categoryId || "";
          document.getElementById("productPrice").value = product.price;
          document.getElementById("productQuantity").value = product.quantity;
          document.getElementById("productImage").value = product.image || "";
          document.getElementById("productDescription").value =
            product.description || "";

          // Show image preview if exists
          if (product.image) {
            document.getElementById("previewImg").src = product.image;
            document.getElementById("imagePreview").style.display = "block";
          } else {
            document.getElementById("imagePreview").style.display = "none";
          }

          openModal("productModal");
        } catch (error) {
          console.error("Error loading product details:", error);
          showNotification("Lỗi", "Không thể tải thông tin sản phẩm", "error");
        }
      }

      // Save product (add or update)
      async function saveProduct() {
        const productId = document.getElementById("productId").value;
        const name = document.getElementById("productName").value.trim();
        const categoryId = document.getElementById("productCategory").value;
        const price = document.getElementById("productPrice").value;
        const quantity = document.getElementById("productQuantity").value;
        const image = document.getElementById("productImage").value.trim();
        const description = document
          .getElementById("productDescription")
          .value.trim();

        // Validation
        if (!name || !price || quantity === "") {
          showNotification(
            "Cảnh báo",
            "Vui lòng điền đầy đủ thông tin bắt buộc",
            "warning"
          );
          return;
        }

        try {
          // Get CSRF token
          const csrfToken = window.csrfToken || document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
          
          const url = productId
            ? contextPath + "/admin/api/product/update"
            : contextPath + "/admin/api/product/add";

          // Build form data
          const params = new URLSearchParams();
          if (productId) params.append("id", productId);
          params.append("name", name);
          if (categoryId) params.append("categoryId", categoryId);
          params.append("price", price);
          params.append("quantity", quantity);
          if (image) params.append("image", image);
          if (description) params.append("description", description);

          console.log("Saving product to:", url, "with CSRF token:", csrfToken);

          const response = await fetch(url, {
            method: "POST",
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              'X-CSRF-Token': csrfToken
            },
            body: params.toString()
          });

          console.log("Response status:", response.status);
          
          if (!response.ok) {
            const errorText = await response.text();
            console.error("Response error:", errorText);
            throw new Error(`Server error: ${response.status}`);
          }

          const result = await response.json();
          console.log("Save result:", result);

          if (!result.success) {
            throw new Error(result.message || "Failed to save product");
          }

          showNotification(
            "Thành công",
            productId ? "Đã cập nhật sản phẩm" : "Đã thêm sản phẩm mới",
            "success"
          );
          closeModal("productModal");
          loadProducts(currentProductPage);
        } catch (error) {
          console.error("Error saving product:", error);
          showNotification(
            "Lỗi",
            error.message || "Không thể lưu sản phẩm",
            "error"
          );
        }
      }

      // Open delete product modal
      function openDeleteProductModal(productId, productName) {
        document.getElementById("deleteProductId").value = productId;
        document.getElementById("deleteProductName").textContent = productName;
        openModal("deleteProductModal");
      }

      // Confirm delete product
      async function confirmDeleteProduct() {
        const productId = document.getElementById("deleteProductId").value;

        try {
          // Get CSRF token
          const csrfToken = window.csrfToken || document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
          
          console.log("Deleting product:", productId, "with CSRF token:", csrfToken);
          
          const response = await fetch(
            contextPath + "/admin/api/product/" + productId,
            {
              method: "DELETE",
              headers: {
                "Content-Type": "application/json",
                "X-CSRF-Token": csrfToken
              }
            }
          );

          console.log("Response status:", response.status);
          
          if (!response.ok) {
            const errorText = await response.text();
            console.error("Response error:", errorText);
            throw new Error(`Server error: ${response.status} - ${errorText}`);
          }

          const result = await response.json();
          console.log("Delete result:", result);

          if (!result.success) {
            throw new Error(result.message || "Failed to delete product");
          }

          showNotification("Thành công", "Đã xóa sản phẩm", "success");
          closeModal("deleteProductModal");
          loadProducts(currentProductPage);
        } catch (error) {
          console.error("Error deleting product:", error);
          showNotification(
            "Lỗi",
            error.message || "Không thể xóa sản phẩm",
            "error"
          );
        }
      }

      // Export products
      function exportProducts() {
        exportProductsToExcel();
      }

      // Initialize products section
      document.addEventListener("DOMContentLoaded", function () {
        const productsMenuItem = document.querySelector(
          '.menu-item[data-target="products"]'
        );
        if (productsMenuItem) {
          productsMenuItem.addEventListener("click", function () {
            setTimeout(() => {
              loadCategories();
              loadProducts(1);
            }, 100);
          });
        }

        // Enter key for search
        const productSearchInput =
          document.getElementById("productSearchInput");
        if (productSearchInput) {
          productSearchInput.addEventListener("keypress", function (e) {
            if (e.key === "Enter") {
              searchProducts();
            }
          });
        }
      });

      // ============================================
      // CUSTOMERS MANAGEMENT
      // ============================================
      let allCustomers = [];
      let currentCustomerPage = 1;
      const customersPerPage = 15;

      async function loadCustomers() {
        try {
          const response = await fetch(contextPath + "/admin/api/users");
          const result = await response.json();

          if (result.success) {
            allCustomers = result.data.filter(u => u.role !== 'admin');
            displayCustomers();
          }
        } catch (error) {
          console.error("Error loading customers:", error);
          document.getElementById("customersTableBody").innerHTML =
            '<tr><td colspan="7" class="text-center text-danger">Lỗi tải dữ liệu</td></tr>';
        }
      }

      function displayCustomers() {
        const tbody = document.getElementById("customersTableBody");
        const search = document.getElementById("customerSearchInput").value.toLowerCase();
        const statusFilter = document.getElementById("customerStatusFilter").value;

        let filtered = allCustomers.filter(customer => {
          const matchSearch = customer.email.toLowerCase().includes(search) ||
                            customer.fullname.toLowerCase().includes(search) ||
                            (customer.phone && customer.phone.includes(search));
          const matchStatus = !statusFilter || customer.status === statusFilter;
          return matchSearch && matchStatus;
        });

        if (filtered.length === 0) {
          tbody.innerHTML = '<tr><td colspan="7" class="text-center">Không có khách hàng nào</td></tr>';
          return;
        }

        tbody.innerHTML = filtered.map(customer => {
          const statusBadge = customer.status === 'active' ? 
            '<span class="badge badge-success">Hoạt động</span>' :
            customer.status === 'banned' ?
            '<span class="badge badge-danger">Đã cấm</span>' :
            '<span class="badge badge-secondary">Không hoạt động</span>';

          return '<tr>' +
            '<td><strong>' + customer.id + '</strong></td>' +
            '<td>' + customer.email + '</td>' +
            '<td>' + (customer.fullname || 'N/A') + '</td>' +
            '<td>' + (customer.phone || 'N/A') + '</td>' +
            '<td>' + (customer.createdAt ? new Date(customer.createdAt).toLocaleDateString('vi-VN') : 'N/A') + '</td>' +
            '<td>' + statusBadge + '</td>' +
            '<td>' +
              (customer.status !== 'banned' ? 
                '<button class="btn btn-warning btn-sm" onclick="banCustomer(' + customer.id + ')" title="Cấm">' +
                  '<i class="fas fa-ban"></i>' +
                '</button>' :
                '<button class="btn btn-success btn-sm" onclick="unbanCustomer(' + customer.id + ')" title="Gỡ cấm">' +
                  '<i class="fas fa-check"></i>' +
                '</button>'
              ) +
              '<button class="btn btn-danger btn-sm" onclick="deleteCustomer(' + customer.id + ', \'' + customer.email + '\')" title="Xóa">' +
                '<i class="fas fa-trash"></i>' +
              '</button>' +
            '</td>' +
          '</tr>';
        }).join('');
      }

      function searchCustomers() {
        displayCustomers();
      }

      function filterCustomers() {
        displayCustomers();
      }


      async function unbanCustomer(userId) {
        try {
          const params = new URLSearchParams({ id: userId, status: 'active' });
          const response = await fetch(
            contextPath + "/admin/api/user/update-status?" + params.toString(),
            { method: "POST" }
          );
          const result = await response.json();
          
          if (result.success) {
            showNotification("Thành công", "Đã gỡ cấm khách hàng", "success");
            loadCustomers();
          } else {
            throw new Error(result.message);
          }
        } catch (error) {
          showNotification("Lỗi", error.message || "Không thể gỡ cấm", "error");
        }
      }

      async function banCustomer(userId) {
        if (!confirm('Bạn có chắc chắn muốn cấm khách hàng này?')) return;
        
        try {
          const params = new URLSearchParams({ id: userId, status: 'banned' });
          const response = await fetch(
            contextPath + "/admin/api/user/update-status?" + params.toString(),
            { method: "POST" }
          );
          const result = await response.json();
          
          if (result.success) {
            showNotification("Thành công", "Đã cấm khách hàng", "success");
            loadCustomers();
          } else {
            throw new Error(result.message);
          }
        } catch (error) {
          showNotification("Lỗi", error.message || "Không thể cấm khách hàng", "error");
        }
      }

      async function deleteCustomer(userId, email) {
        if (!confirm('Bạn có chắc chắn muốn xóa khách hàng ' + email + '?')) return;
        
        try {
          const response = await fetch(
            contextPath + "/admin/api/user/" + userId,
            { method: "DELETE" }
          );
          const result = await response.json();
          
          if (result.success) {
            showNotification("Thành công", "Đã xóa khách hàng", "success");
            loadCustomers();
          } else {
            throw new Error(result.message);
          }
        } catch (error) {
          showNotification("Lỗi", error.message || "Không thể xóa khách hàng", "error");
        }
      }

      // ============================================
      // CATEGORIES MANAGEMENT
      // ============================================
      let allCategoriesData = [];

      async function loadCategoriesTable() {
        try {
          const response = await fetch(contextPath + "/admin/api/categories");
          const result = await response.json();

          if (result.success) {
            allCategoriesData = result.data;
            displayCategories();
            populateCategoryParentSelect();
          }
        } catch (error) {
          console.error("Error loading categories:", error);
        }
      }

      function displayCategories() {
        const tbody = document.getElementById("categoriesTableBody");
        
        if (allCategoriesData.length === 0) {
          tbody.innerHTML = '<tr><td colspan="7" class="text-center">Không có danh mục nào</td></tr>';
          return;
        }

        tbody.innerHTML = allCategoriesData.map(cat => {
          const parentName = cat.parentId ? 
            (allCategoriesData.find(c => c.id === cat.parentId)?.name || 'N/A') : 
            '--';
          const statusBadge = cat.isActive ?
            '<span class="badge badge-success">Hoạt động</span>' :
            '<span class="badge badge-secondary">Ẩn</span>';

          return '<tr>' +
            '<td><strong>' + cat.id + '</strong></td>' +
            '<td>' + cat.name + '</td>' +
            '<td>' + (cat.slug || 'N/A') + '</td>' +
            '<td>' + parentName + '</td>' +
            '<td>' + (cat.displayOrder || 0) + '</td>' +
            '<td>' + statusBadge + '</td>' +
            '<td>' +
              '<button class="btn btn-warning btn-sm" onclick="openEditCategoryModal(' + cat.id + ')" title="Sửa">' +
                '<i class="fas fa-edit"></i>' +
              '</button>' +
              '<button class="btn btn-danger btn-sm" onclick="deleteCategory(' + cat.id + ', \'' + cat.name.replace(/'/g, "\\'") + '\')" title="Xóa">' +
                '<i class="fas fa-trash"></i>' +
              '</button>' +
            '</td>' +
          '</tr>';
        }).join('');
      }

      // async function loadCategoriesTable() {
      //   try {
      //     const response = await fetch(contextPath + "/admin/api/categories");
      //     const result = await response.json();

      //     if (result.success) {
      //       allCategoriesData = result.data;
      //       displayCategories();
      //       populateCategoryParentSelect();
      //     }
      //   } catch (error) {
      //     console.error("Error loading categories:", error);
      //   }
      // }

      function populateCategoryParentSelect() {
        const select = document.getElementById("categoryParent");
        select.innerHTML = '<option value="">-- Không có --</option>';
        allCategoriesData.forEach(cat => {
          select.innerHTML += '<option value="' + cat.id + '">' + cat.name + '</option>';
        });
      }

      function openAddCategoryModal() {
        document.getElementById("categoryModalTitle").textContent = "Thêm Danh Mục";
        document.getElementById("categoryForm").reset();
        document.getElementById("categoryId").value = "";
        populateCategoryParentSelect();
        openModal("categoryModal");
      }

      async function openEditCategoryModal(categoryId) {
        try {
          const category = allCategoriesData.find(c => c.id === categoryId);
          if (!category) throw new Error("Không tìm thấy danh mục");

          document.getElementById("categoryModalTitle").textContent = "Sửa Danh Mục";
          document.getElementById("categoryId").value = category.id;
          document.getElementById("categoryName").value = category.name;
          document.getElementById("categoryOrder").value = category.displayOrder || 0;
          
          populateCategoryParentSelect();
          document.getElementById("categoryParent").value = category.parentId || "";
          
          openModal("categoryModal");
        } catch (error) {
          showNotification("Lỗi", error.message, "error");
        }
      }

      // async function deleteCategory(categoryId, categoryName) {
      //   if (!confirm('Bạn có chắc chắn muốn xóa danh mục "' + categoryName + '"?')) return;

      //   try {
      //     const response = await fetch(
      //       contextPath + "/admin/api/category/" + categoryId,
      //       { method: "DELETE" }
      //     );

      //     const result = await response.json();

      //     if (!result.success) {
      //       throw new Error(result.message || "Failed to delete category");
      //     }

      //     showNotification("Thành công", "Đã xóa danh mục", "success");
      //     loadCategoriesTable();
      //   } catch (error) {
      //     showNotification("Lỗi", error.message || "Không thể xóa danh mục", "error");
      //   }
      // }

      async function saveCategory() {
        const categoryId = document.getElementById("categoryId").value;
        const name = document.getElementById("categoryName").value.trim();
        const parentId = document.getElementById("categoryParent").value;
        const displayOrder = document.getElementById("categoryOrder").value;

        if (!name) {
          showNotification("Cảnh báo", "Vui lòng nhập tên danh mục", "warning");
          return;
        }

        try {
          const params = new URLSearchParams();
          if (categoryId) params.append("id", categoryId);
          params.append("name", name);
          if (parentId) params.append("parentId", parentId);
          params.append("displayOrder", displayOrder);

          const url = categoryId ? 
            contextPath + "/admin/api/category/update" :
            contextPath + "/admin/api/category/add";

          const response = await fetch(url, {
            method: "POST",
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params.toString()
          });

          const result = await response.json();

          if (!result.success) {
            throw new Error(result.message || "Failed to save category");
          }

          showNotification("Thành công", 
            categoryId ? "Đã cập nhật danh mục" : "Đã thêm danh mục mới",
            "success"
          );
          closeModal("categoryModal");
          loadCategoriesTable();
        } catch (error) {
          showNotification("Lỗi", error.message || "Không thể lưu danh mục", "error");
        }
      }

      async function deleteCategory(categoryId, categoryName) {
        if (!confirm('Bạn có chắc chắn muốn xóa danh mục "' + categoryName + '"?')) return;

        try {
          const response = await fetch(
            contextPath + "/admin/api/category/" + categoryId,
            { method: "DELETE" }
          );

          const result = await response.json();

          if (!result.success) {
            throw new Error(result.message || "Failed to delete category");
          }

          showNotification("Thành công", "Đã xóa danh mục", "success");
          loadCategoriesTable();
        } catch (error) {
          showNotification("Lỗi", error.message || "Không thể xóa danh mục", "error");
        }
      }

      // ============================================
      // COUPONS MANAGEMENT
      // ============================================
      let allCoupons = [];

      async function openEditCouponModal(couponId) {
        try {
          const coupon = allCoupons.find(c => c.id === couponId);
          if (!coupon) throw new Error("Không tìm thấy mã giảm giá");

          document.getElementById("couponModalTitle").textContent = "Sửa Mã Giảm Giá";
          document.getElementById("couponId").value = coupon.id;
          document.getElementById("couponCode").value = coupon.code;
          document.getElementById("couponType").value = coupon.discountType;
          document.getElementById("couponValue").value = coupon.discountValue;
          document.getElementById("couponMinOrder").value = coupon.minOrderValue || 0;
          document.getElementById("couponMaxDiscount").value = coupon.maxDiscount || '';
          document.getElementById("couponLimit").value = coupon.usageLimit || '';
          document.getElementById("couponDescription").value = coupon.description || '';
          
          if (coupon.startDate) {
            document.getElementById("couponStartDate").value = coupon.startDate.split('T')[0];
          }
          if (coupon.endDate) {
            document.getElementById("couponEndDate").value = coupon.endDate.split('T')[0];
          }

          openModal("couponModal");
        } catch (error) {
          showNotification("Lỗi", error.message, "error");
        }
      }

      async function loadCoupons() {
        try {
          const response = await fetch(contextPath + "/admin/api/coupons");
          const result = await response.json();

          if (result.success) {
            allCoupons = result.data;
            displayCoupons();
          }
        } catch (error) {
          console.error("Error loading coupons:", error);
        }
      }

      function displayCoupons() {
        const tbody = document.getElementById("couponsTableBody");
        
        if (allCoupons.length === 0) {
          tbody.innerHTML = '<tr><td colspan="9" class="text-center">Không có mã giảm giá nào</td></tr>';
          return;
        }

        tbody.innerHTML = allCoupons.map(coupon => {
          const typeText = coupon.discountType === 'percent' ? '%' : 'đ';
          const statusBadge = coupon.isActive ?
            '<span class="badge badge-success">Hoạt động</span>' :
            '<span class="badge badge-secondary">Tắt</span>';
          const usageText = (coupon.usedCount || 0) + ' / ' + (coupon.usageLimit || '∞');

          return '<tr>' +
            '<td><strong>' + coupon.id + '</strong></td>' +
            '<td><code style="background: var(--primary-light); padding: 4px 8px; border-radius: 4px;">' + coupon.code + '</code></td>' +
            '<td>' + (coupon.discountType === 'percent' ? 'Phần trăm' : 'Cố định') + '</td>' +
            '<td><strong>' + formatNumber(coupon.discountValue) + typeText + '</strong></td>' +
            '<td>' + formatCurrency(coupon.minOrderValue || 0) + '</td>' +
            '<td>' + usageText + '</td>' +
            '<td>' + (coupon.endDate ? new Date(coupon.endDate).toLocaleDateString('vi-VN') : 'Không giới hạn') + '</td>' +
            '<td>' + statusBadge + '</td>' +
            '<td>' +
              '<button class="btn btn-warning btn-sm" onclick="openEditCouponModal(' + coupon.id + ')" title="Sửa">' +
                '<i class="fas fa-edit"></i>' +
              '</button>' +
              '<button class="btn btn-danger btn-sm" onclick="deleteCoupon(' + coupon.id + ', \'' + coupon.code.replace(/'/g, "\\'") + '\')" title="Xóa">' +
                '<i class="fas fa-trash"></i>' +
              '</button>' +
            '</td>' +
          '</tr>';
        }).join('');
      }



      function openAddCouponModal() {
        document.getElementById("couponModalTitle").textContent = "Thêm Mã Giảm Giá";
        document.getElementById("couponForm").reset();
        document.getElementById("couponId").value = "";
        openModal("couponModal");
      }

      // async function loadCoupons() {
      //   try {
      //     const response = await fetch(contextPath + "/admin/api/coupons");
      //     const result = await response.json();

      //     if (result.success) {
      //       allCoupons = result.data;
      //       displayCoupons();
      //     }
      //   } catch (error) {
      //     console.error("Error loading coupons:", error);
      //   }
      // }

      async function saveCoupon() {
        const couponId = document.getElementById("couponId").value;
        const code = document.getElementById("couponCode").value.trim().toUpperCase();
        const type = document.getElementById("couponType").value;
        const value = document.getElementById("couponValue").value;
        const minOrder = document.getElementById("couponMinOrder").value;
        const maxDiscount = document.getElementById("couponMaxDiscount").value;
        const limit = document.getElementById("couponLimit").value;
        const startDate = document.getElementById("couponStartDate").value;
        const endDate = document.getElementById("couponEndDate").value;
        const description = document.getElementById("couponDescription").value;

        if (!code || !value) {
          showNotification("Cảnh báo", "Vui lòng điền đầy đủ thông tin", "warning");
          return;
        }

        try {
          const params = new URLSearchParams();
          if (couponId) params.append("id", couponId);
          params.append("code", code);
          params.append("discountType", type);
          params.append("discountValue", value);
          if (minOrder) params.append("minOrderValue", minOrder);
          if (maxDiscount) params.append("maxDiscount", maxDiscount);
          if (limit) params.append("usageLimit", limit);
          if (startDate) params.append("startDate", startDate);
          if (endDate) params.append("endDate", endDate);
          if (description) params.append("description", description);

          const url = couponId ?
            contextPath + "/admin/api/coupon/update" :
            contextPath + "/admin/api/coupon/add";

          const response = await fetch(url, {
            method: "POST",
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params.toString()
          });

          const result = await response.json();

          if (!result.success) {
            throw new Error(result.message || "Failed to save coupon");
          }

          showNotification("Thành công",
            couponId ? "Đã cập nhật mã giảm giá" : "Đã thêm mã giảm giá mới",
            "success"
          );
          closeModal("couponModal");
          loadCoupons();
        } catch (error) {
          showNotification("Lỗi", error.message || "Không thể lưu mã giảm giá", "error");
        }
      }

      async function deleteCoupon(couponId, couponCode) {
        if (!confirm('Bạn có chắc chắn muốn xóa mã "' + couponCode + '"?')) return;

        try {
          const response = await fetch(
            contextPath + "/admin/api/coupon/" + couponId,
            { method: "DELETE" }
          );

          const result = await response.json();

          if (!result.success) {
            throw new Error(result.message || "Failed to delete coupon");
          }

          showNotification("Thành công", "Đã xóa mã giảm giá", "success");
          loadCoupons();
        } catch (error) {
          showNotification("Lỗi", error.message || "Không thể xóa mã giảm giá", "error");
        }
      }

      // ============================================
      // CONTACTS MANAGEMENT
      // ============================================
      let allContacts = [];

      async function loadContacts() {
        try {
          const response = await fetch(contextPath + "/admin/api/contacts");
          const result = await response.json();

          if (result.success) {
            allContacts = result.data;
            displayContacts();
          }
        } catch (error) {
          console.error("Error loading contacts:", error);
        }
      }

      function displayContacts() {
        const tbody = document.getElementById("contactsTableBody");
        const statusFilter = document.getElementById("contactStatusFilter").value;

        let filtered = allContacts.filter(contact => 
          !statusFilter || contact.status === statusFilter
        );

        if (filtered.length === 0) {
          tbody.innerHTML = '<tr><td colspan="8" class="text-center">Không có liên hệ nào</td></tr>';
          return;
        }

        tbody.innerHTML = filtered.map(contact => {
          const statusBadge = contact.status === 'new' ?
            '<span class="badge badge-primary">Mới</span>' :
            contact.status === 'read' ?
            '<span class="badge badge-info">Đã đọc</span>' :
            '<span class="badge badge-success">Đã trả lời</span>';

          return '<tr>' +
            '<td><strong>' + contact.id + '</strong></td>' +
            '<td>' + contact.name + '</td>' +
            '<td>' + contact.email + '</td>' +
            '<td>' + (contact.phone || 'N/A') + '</td>' +
            '<td>' + (contact.subject || 'N/A') + '</td>' +
            '<td>' + (contact.createdAt ? new Date(contact.createdAt).toLocaleDateString('vi-VN') : 'N/A') + '</td>' +
            '<td>' + statusBadge + '</td>' +
            '<td>' +
              '<button class="btn btn-primary btn-sm" onclick="viewContact(' + contact.id + ')" title="Xem">' +
                '<i class="fas fa-eye"></i>' +
              '</button>' +
              '<button class="btn btn-danger btn-sm" onclick="deleteContact(' + contact.id + ')" title="Xóa">' +
                '<i class="fas fa-trash"></i>' +
              '</button>' +
            '</td>' +
          '</tr>';
        }).join('');
      }

      function filterContacts() {
        displayContacts();
      }

      async function viewContact(contactId) {
        try {
          const contact = allContacts.find(c => c.id === contactId);
          if (!contact) throw new Error("Không tìm thấy liên hệ");

          document.getElementById("contactId").value = contact.id;
          document.getElementById("contactName").textContent = contact.name;
          document.getElementById("contactEmail").textContent = contact.email;
          document.getElementById("contactPhone").textContent = contact.phone || 'N/A';
          document.getElementById("contactSubject").textContent = contact.subject || 'N/A';
          document.getElementById("contactDate").textContent = contact.createdAt ? 
            new Date(contact.createdAt).toLocaleString('vi-VN') : 'N/A';
          document.getElementById("contactMessage").textContent = contact.message;
          document.getElementById("contactStatus").value = contact.status || 'new';

          openModal("contactModal");
        } catch (error) {
          showNotification("Lỗi", error.message, "error");
        }
      }

      async function updateContactStatus() {
        const contactId = document.getElementById("contactId").value;
        const status = document.getElementById("contactStatus").value;

        try {
          const params = new URLSearchParams({ id: contactId, status: status });
          const response = await fetch(
            contextPath + "/admin/api/contact/update-status?" + params.toString(),
            { method: "POST" }
          );

          const result = await response.json();

          if (result.success) {
            showNotification("Thành công", "Đã cập nhật trạng thái", "success");
            loadContacts();
          } else {
            throw new Error(result.message);
          }
        } catch (error) {
          showNotification("Lỗi", error.message || "Không thể cập nhật", "error");
        }
      }

      async function deleteContact(contactId) {
        if (!confirm('Bạn có chắc chắn muốn xóa liên hệ này?')) return;

        try {
          const response = await fetch(
            contextPath + "/admin/api/contact/" + contactId,
            { method: "DELETE" }
          );

          const result = await response.json();

          if (result.success) {
            showNotification("Thành công", "Đã xóa liên hệ", "success");
            loadContacts();
          } else {
            throw new Error(result.message);
          }
        } catch (error) {
          showNotification("Lỗi", error.message || "Không thể xóa liên hệ", "error");
        }
      }

      // Initialize section data when menu clicked
      document.addEventListener("DOMContentLoaded", function () {
        // Customers
        const customersMenuItem = document.querySelector('.menu-item[data-target="customers"]');
        if (customersMenuItem) {
          customersMenuItem.addEventListener("click", () => {
            setTimeout(() => loadCustomers(), 100);
          });
        }

        // Categories
        const categoriesMenuItem = document.querySelector('.menu-item[data-target="categories"]');
        if (categoriesMenuItem) {
          categoriesMenuItem.addEventListener("click", () => {
            setTimeout(() => loadCategoriesTable(), 100);
          });
        }

        // Coupons
        const couponsMenuItem = document.querySelector('.menu-item[data-target="coupons"]');
        if (couponsMenuItem) {
          couponsMenuItem.addEventListener("click", () => {
            setTimeout(() => loadCoupons(), 100);
          });
        }

        // Contacts
        const contactsMenuItem = document.querySelector('.menu-item[data-target="contacts"]');
        if (contactsMenuItem) {
          contactsMenuItem.addEventListener("click", () => {
            setTimeout(() => loadContacts(), 100);
          });
        }

        // Analytics
        const analyticsMenuItem = document.querySelector('.menu-item[data-target="analytics"]');
        if (analyticsMenuItem) {
          analyticsMenuItem.addEventListener("click", () => {
            setTimeout(() => loadAnalytics(), 100);
          });
        }

        // Settings
        const settingsMenuItem = document.querySelector('.menu-item[data-target="settings"]');
        if (settingsMenuItem) {
          settingsMenuItem.addEventListener("click", () => {
            setTimeout(() => loadSettings(), 100);
          });
        }
      });

      // ============================================
      // ANALYTICS FUNCTIONALITY - STEP 9
      // ============================================

      let revenueByDayChart = null;
      let orderStatusChartInstance = null;

      async function loadAnalytics() {
        console.log("🔄 Loading analytics...");
        
        const dateRange = document.getElementById("analyticsDateRange");
        const days = dateRange ? dateRange.value : "7";
        
        try {
          const response = await fetch(contextPath + "/admin/api/analytics?days=" + days);
          if (!response.ok) throw new Error("Failed to load analytics");
          
          const result = await response.json();
          console.log("📊 Analytics API Response:", result);
          
          if (!result.success) {
            throw new Error(result.message || "Failed to load analytics data");
          }
          
          const data = result.data;
          console.log("📊 Analytics Data:", data);
          
          // Update stats
          document.getElementById("analyticsRevenue").textContent = formatCurrency(data.totalRevenue || 0);
          document.getElementById("analyticsOrders").textContent = formatNumber(data.totalOrders || 0);
          document.getElementById("analyticsAvgOrder").textContent = formatCurrency(data.avgOrderValue || 0);
          document.getElementById("analyticsCompleteRate").textContent = (data.completeRate || 0) + "%";
          
          // Note: Change indicators are set to 0 since we don't have comparison data yet
          updateChangeIndicator("analyticsRevenueChange", 0);
          updateChangeIndicator("analyticsOrdersChange", 0);
          updateChangeIndicator("analyticsAvgChange", 0);
          updateChangeIndicator("analyticsRateChange", 0);
          
          // Load charts
          if (data.revenueByDay) {
            const chartData = data.revenueByDay.map(item => ({
              date: formatDateShort(item.date),
              revenue: item.revenue
            }));
            loadRevenueByDayChart(chartData);
          }
          
          if (data.orderStatus) {
            loadOrderStatusChartData(data.orderStatus);
          }
          
          // Load top products
          if (data.topProducts) {
            loadAnalyticsTopProducts(data.topProducts);
          }
          
          // Load sample categories (API doesn't have this yet)
          const sampleCategories = [
            {name: "Hoa Tươi", productCount: 45, revenue: 12000000},
            {name: "Hoa Khai Trương", productCount: 32, revenue: 8500000},
            {name: "Hoa Sinh Nhật", productCount: 28, revenue: 7200000},
            {name: "Hoa Cưới", productCount: 15, revenue: 6800000},
            {name: "Hoa Chia Buồn", productCount: 12, revenue: 4500000}
          ];
          loadAnalyticsTopCategories(sampleCategories);
          
          console.log("✅ Analytics loaded successfully!");
        } catch (error) {
          console.error("❌ Error loading analytics:", error);
          showNotification("Lỗi", "Không thể tải thống kê: " + error.message, "error");
        }
      }
      
      function formatDateShort(dateStr) {
        const date = new Date(dateStr);
        return (date.getDate()) + "/" + (date.getMonth() + 1);
      }

      function updateChangeIndicator(elementId, change) {
        const element = document.getElementById(elementId);
        const isPositive = change >= 0;
        element.className = "stat-change " + (isPositive ? "positive" : "negative");
        element.innerHTML = '<i class="fas fa-arrow-' + (isPositive ? 'up' : 'down') + '"></i> ' + Math.abs(change) + '%';
      }

      function loadRevenueByDayChart(data) {
        const ctx = document.getElementById("revenueByDayChart").getContext("2d");
        
        if (revenueByDayChart) {
          revenueByDayChart.destroy();
        }

        const labels = data.map(item => item.date);
        const revenues = data.map(item => parseFloat(item.revenue) || 0);

        revenueByDayChart = new Chart(ctx, {
          type: "line",
          data: {
            labels: labels,
            datasets: [{
              label: "Doanh Thu",
              data: revenues,
              borderColor: "#c99366",
              backgroundColor: "rgba(201, 147, 102, 0.1)",
              borderWidth: 3,
              fill: true,
              tension: 0.4,
              pointRadius: 5,
              pointBackgroundColor: "#c99366",
              pointBorderColor: "#fff",
              pointBorderWidth: 2,
              pointHoverRadius: 7
            }]
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
              legend: { 
                display: false 
              },
              tooltip: {
                callbacks: {
                  label: function(context) {
                    return "Doanh thu: " + formatCurrency(context.parsed.y);
                  }
                },
                backgroundColor: '#3c2922',
                titleColor: '#fff',
                bodyColor: '#fff',
                borderColor: '#c99366',
                borderWidth: 1,
                padding: 12,
                displayColors: false
              }
            },
            scales: {
              y: {
                beginAtZero: true,
                ticks: {
                  callback: function(value) {
                    return formatCurrency(value);
                  },
                  color: '#6c5845'
                },
                grid: {
                  color: '#e8dfd5'
                }
              },
              x: {
                ticks: {
                  color: '#6c5845'
                },
                grid: {
                  display: false
                }
              }
            }
          }
        });
      }

      function loadOrderStatusChartData(statusData) {
        const ctx = document.getElementById("orderStatusChart").getContext("2d");
        
        if (orderStatusChartInstance) {
          orderStatusChartInstance.destroy();
        }

        const labels = Object.keys(statusData).map(key => getStatusText(key));
        const data = Object.values(statusData);
        const colors = ['#f59e0b', '#3b82f6', '#10b981', '#ef4444'];

        orderStatusChartInstance = new Chart(ctx, {
          type: "doughnut",
          data: {
            labels: labels,
            datasets: [{
              data: data,
              backgroundColor: colors,
              borderWidth: 3,
              borderColor: '#fff',
              hoverBorderWidth: 4,
              hoverBorderColor: '#fff'
            }]
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
              legend: {
                position: 'bottom',
                labels: {
                  padding: 15,
                  font: {
                    size: 13,
                    family: "'Inter', sans-serif"
                  },
                  color: '#3c2922',
                  usePointStyle: true,
                  pointStyle: 'circle'
                }
              },
              tooltip: {
                backgroundColor: '#3c2922',
                titleColor: '#fff',
                bodyColor: '#fff',
                borderColor: '#c99366',
                borderWidth: 1,
                padding: 12,
                displayColors: true
              }
            },
            cutout: '65%'
          }
        });
      }

      function loadAnalyticsTopProducts(products) {
        const tbody = document.getElementById("analyticsTopProducts");
        
        if (!products || products.length === 0) {
          tbody.innerHTML = '<tr><td colspan="3" class="text-center">Chưa có dữ liệu</td></tr>';
          return;
        }

        tbody.innerHTML = products.slice(0, 5).map(product => {
          const soldCount = product.soldCount || product.sold || product.quantity || 0;
          const revenue = product.revenue || (product.price && soldCount ? product.price * soldCount : 0);
          return '<tr>' +
            '<td>' + (product.name || product.productName) + '</td>' +
            '<td>' + formatNumber(soldCount) + '</td>' +
            '<td><strong>' + formatCurrency(revenue) + '</strong></td>' +
          '</tr>';
        }).join('');
      }

      function loadAnalyticsTopCategories(categories) {
        const tbody = document.getElementById("analyticsTopCategories");
        
        if (!categories || categories.length === 0) {
          tbody.innerHTML = '<tr><td colspan="3" class="text-center">Chưa có dữ liệu</td></tr>';
          return;
        }

        tbody.innerHTML = categories.slice(0, 5).map(category => {
          return '<tr>' +
            '<td>' + (category.name || category.categoryName) + '</td>' +
            '<td>' + formatNumber(category.productCount || 0) + '</td>' +
            '<td><strong>' + formatCurrency(category.revenue || 0) + '</strong></td>' +
          '</tr>';
        }).join('');
      }

      function loadSampleAnalytics() {
        console.log("📊 Loading sample analytics data...");
        
        // Sample data for demonstration
        try {
          document.getElementById("analyticsRevenue").textContent = formatCurrency(45000000);
          document.getElementById("analyticsOrders").textContent = formatNumber(156);
          document.getElementById("analyticsAvgOrder").textContent = formatCurrency(288461);
          document.getElementById("analyticsCompleteRate").textContent = "78%";

          updateChangeIndicator("analyticsRevenueChange", 12.5);
          updateChangeIndicator("analyticsOrdersChange", 8.3);
          updateChangeIndicator("analyticsAvgChange", 5.2);
          updateChangeIndicator("analyticsRateChange", 3.1);

          console.log("✅ Stats updated");

          // Sample revenue chart
          const sampleRevenue = [
            {date: "01/01", revenue: 1200000},
            {date: "02/01", revenue: 1500000},
            {date: "03/01", revenue: 1800000},
            {date: "04/01", revenue: 1400000},
            {date: "05/01", revenue: 2100000},
            {date: "06/01", revenue: 1900000},
            {date: "07/01", revenue: 2300000}
          ];
          loadRevenueByDayChart(sampleRevenue);
          console.log("✅ Revenue chart loaded");

          // Sample status chart
          const sampleStatus = {
            pending: 25,
            shipping: 45,
            delivered: 80,
            cancelled: 6
          };
          loadOrderStatusChartData(sampleStatus);
          console.log("✅ Status chart loaded");

          // Sample top products
          const sampleProducts = [
            {name: "Hoa Hồng Đỏ", soldCount: 45, revenue: 4500000},
            {name: "Hoa Tulip", soldCount: 38, revenue: 3800000},
            {name: "Hoa Ly", soldCount: 32, revenue: 3200000},
            {name: "Hoa Cẩm Chướng", soldCount: 28, revenue: 2800000},
            {name: "Hoa Hướng Dương", soldCount: 25, revenue: 2500000}
          ];
          loadAnalyticsTopProducts(sampleProducts);
          console.log("✅ Top products loaded");

          // Sample top categories
          const sampleCategories = [
            {name: "Hoa Tươi", productCount: 45, revenue: 12000000},
            {name: "Hoa Khai Trương", productCount: 32, revenue: 8500000},
            {name: "Hoa Sinh Nhật", productCount: 28, revenue: 7200000},
            {name: "Hoa Cưới", productCount: 15, revenue: 6800000},
            {name: "Hoa Chia Buồn", productCount: 12, revenue: 4500000}
          ];
          loadAnalyticsTopCategories(sampleCategories);
          console.log("✅ Top categories loaded");
          
          console.log("🎉 All sample data loaded successfully!");
        } catch (error) {
          console.error("❌ Error loading sample analytics:", error);
        }
      }

      // ============================================
      // SETTINGS FUNCTIONALITY - STEP 10
      // ============================================

      function loadSettings() {
        // Load current settings from server or localStorage
        try {
          const settings = JSON.parse(localStorage.getItem('adminSettings') || '{}');
          
          if (settings.siteName) document.getElementById("settingSiteName").value = settings.siteName;
          if (settings.slogan) document.getElementById("settingSlogan").value = settings.slogan;
          if (settings.email) document.getElementById("settingEmail").value = settings.email;
          if (settings.phone) document.getElementById("settingPhone").value = settings.phone;
          if (settings.address) document.getElementById("settingAddress").value = settings.address;
          
          if (settings.shippingFee) document.getElementById("settingShippingFee").value = settings.shippingFee;
          if (settings.freeShipThreshold) document.getElementById("settingFreeShipThreshold").value = settings.freeShipThreshold;
          if (settings.autoCancelTime) document.getElementById("settingAutoCancelTime").value = settings.autoCancelTime;
          
          document.getElementById("paymentCOD").checked = settings.paymentCOD !== false;
          document.getElementById("paymentBank").checked = settings.paymentBank !== false;
          document.getElementById("paymentMomo").checked = settings.paymentMomo === true;
          document.getElementById("paymentVNPay").checked = settings.paymentVNPay === true;
          
          document.getElementById("emailOrderConfirm").checked = settings.emailOrderConfirm !== false;
          document.getElementById("emailOrderStatus").checked = settings.emailOrderStatus !== false;
          document.getElementById("emailPromotion").checked = settings.emailPromotion === true;
        } catch (error) {
          console.error("Error loading settings:", error);
        }
      }

      function saveWebsiteSettings() {
        const settings = {
          siteName: document.getElementById("settingSiteName").value,
          slogan: document.getElementById("settingSlogan").value,
          email: document.getElementById("settingEmail").value,
          phone: document.getElementById("settingPhone").value,
          address: document.getElementById("settingAddress").value
        };

        try {
          localStorage.setItem('adminSettings', JSON.stringify(Object.assign(
            JSON.parse(localStorage.getItem('adminSettings') || '{}'),
            settings
          )));
          showNotification("Thành công", "Đã lưu thông tin website", "success");
        } catch (error) {
          showNotification("Lỗi", "Không thể lưu cài đặt", "error");
        }
      }

      function saveOrderSettings() {
        const settings = {
          shippingFee: document.getElementById("settingShippingFee").value,
          freeShipThreshold: document.getElementById("settingFreeShipThreshold").value,
          autoCancelTime: document.getElementById("settingAutoCancelTime").value
        };

        try {
          localStorage.setItem('adminSettings', JSON.stringify(Object.assign(
            JSON.parse(localStorage.getItem('adminSettings') || '{}'),
            settings
          )));
          showNotification("Thành công", "Đã lưu cài đặt đơn hàng", "success");
        } catch (error) {
          showNotification("Lỗi", "Không thể lưu cài đặt", "error");
        }
      }

      function savePaymentSettings() {
        const settings = {
          paymentCOD: document.getElementById("paymentCOD").checked,
          paymentBank: document.getElementById("paymentBank").checked,
          paymentMomo: document.getElementById("paymentMomo").checked,
          paymentVNPay: document.getElementById("paymentVNPay").checked
        };

        try {
          localStorage.setItem('adminSettings', JSON.stringify(Object.assign(
            JSON.parse(localStorage.getItem('adminSettings') || '{}'),
            settings
          )));
          showNotification("Thành công", "Đã lưu phương thức thanh toán", "success");
        } catch (error) {
          showNotification("Lỗi", "Không thể lưu cài đặt", "error");
        }
      }

      function saveEmailSettings() {
        const settings = {
          emailOrderConfirm: document.getElementById("emailOrderConfirm").checked,
          emailOrderStatus: document.getElementById("emailOrderStatus").checked,
          emailPromotion: document.getElementById("emailPromotion").checked
        };

        try {
          localStorage.setItem('adminSettings', JSON.stringify(Object.assign(
            JSON.parse(localStorage.getItem('adminSettings') || '{}'),
            settings
          )));
          showNotification("Thành công", "Đã lưu cài đặt email", "success");
        } catch (error) {
          showNotification("Lỗi", "Không thể lưu cài đặt", "error");
        }
      }

      // Export functions for Step 10
      function exportOrdersToExcel() {
        showNotification("Thông báo", "Đang xuất dữ liệu...", "info");
        
        // Create CSV content
        let csv = "Mã Đơn,Khách Hàng,SĐT,Ngày Đặt,Tổng Tiền,Trạng Thái\n";
        currentOrders.forEach(order => {
          const customerName = order.receiverName || order.fullname || "N/A";
          const phone = order.receiverPhone || order.phone || "N/A";
          const date = formatDate(order.createdAt || order.orderDate);
          const total = order.total || order.totalPrice || 0;
          const status = getStatusText(order.orderStatus || order.status);
          
          csv += '"' + (order.orderCode || order.id) + '",' +
                 '"' + customerName + '",' +
                 '"' + phone + '",' +
                 '"' + date + '",' +
                 '"' + total + '",' +
                 '"' + status + '"\n';
        });

        // Download
        const blob = new Blob(["\uFEFF" + csv], { type: 'text/csv;charset=utf-8;' });
        const link = document.createElement("a");
        link.href = URL.createObjectURL(blob);
        link.download = "orders_" + new Date().getTime() + ".csv";
        link.click();
        
        showNotification("Thành công", "Đã xuất file Excel", "success");
      }

      function exportProductsToExcel() {
        showNotification("Thông báo", "Đang xuất dữ liệu...", "info");
        
        let csv = "ID,Tên Sản Phẩm,Danh Mục,Giá,Số Lượng,Đã Bán\n";
        currentProducts.forEach(product => {
          const categoryName = (product.category ? product.category.name : null) ||
                              (allCategories.find(c => c.id === product.categoryId)?.name) || "N/A";
          
          csv += '"' + product.id + '",' +
                 '"' + product.name + '",' +
                 '"' + categoryName + '",' +
                 '"' + product.price + '",' +
                 '"' + product.quantity + '",' +
                 '"' + (product.soldCount || 0) + '"\n';
        });

        const blob = new Blob(["\uFEFF" + csv], { type: 'text/csv;charset=utf-8;' });
        const link = document.createElement("a");
        link.href = URL.createObjectURL(blob);
        link.download = "products_" + new Date().getTime() + ".csv";
        link.click();
        
        showNotification("Thành công", "Đã xuất file Excel", "success");
      }
      
      // ============================================
      //  GALLERY MANAGEMENT FUNCTIONS
      // ============================================
      
      // Load all galleries
      async function loadGalleries() {
        try {
          const response = await fetch(contextPath + '/api/gallery/all');
          const result = await response.json();
          
          const tbody = document.getElementById('galleryTableBody');
          
          if (result.success && result.data && result.data.length > 0) {
            tbody.innerHTML = result.data.map(gallery => '<tr>' +
              '<td>' + gallery.id + '</td>' +
              '<td><img src="' + gallery.imageUrl + '" alt="' + gallery.caption + '" style="width: 80px; height: 60px; object-fit: cover; border-radius: 4px;" onerror="this.src=\'https://via.placeholder.com/80x60?text=Error\'" /></td>' +
              '<td>' + gallery.caption + '</td>' +
              '<td>' + (gallery.description || '-') + '</td>' +
              '<td>' + gallery.displayOrder + '</td>' +
              '<td>' + (gallery.active ? '<span class="badge badge-success">Hiển thị</span>' : '<span class="badge badge-secondary">Ẩn</span>') + '</td>' +
              '<td>' +
                '<button class="btn btn-sm btn-secondary" onclick="editGallery(' + gallery.id + ')" title="Sửa"><i class="fas fa-edit"></i></button> ' +
                '<button class="btn btn-sm btn-' + (gallery.active ? 'warning' : 'success') + '" onclick="toggleGalleryStatus(' + gallery.id + ', ' + !gallery.active + ')" title="' + (gallery.active ? 'Ẩn' : 'Hiện') + '"><i class="fas fa-eye' + (gallery.active ? '-slash' : '') + '"></i></button> ' +
                '<button class="btn btn-sm btn-danger" onclick="deleteGallery(' + gallery.id + ')" title="Xóa"><i class="fas fa-trash"></i></button>' +
              '</td>' +
            '</tr>').join('');
          } else {
            tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; padding: 40px; color: #999;">Chưa có hình ảnh nào</td></tr>';
          }
        } catch (error) {
          console.error('Error loading galleries:', error);
          document.getElementById('galleryTableBody').innerHTML = '<tr><td colspan="7" style="text-align: center; padding: 40px; color: red;">Lỗi khi tải dữ liệu</td></tr>';
        }
      }
      
      // Open gallery modal for adding
      function openGalleryModal() {
        document.getElementById('galleryModalTitle').textContent = 'Thêm Ảnh Gallery';
        document.getElementById('galleryId').value = '';
        document.getElementById('galleryForm').reset();
        document.getElementById('galleryActive').checked = true;
        document.getElementById('galleryPreviewContainer').style.display = 'none';
        openModal('galleryModal');
      }
      
      // Edit gallery
      async function editGallery(id) {
        try {
          const response = await fetch(contextPath + '/api/gallery/' + id);
          const result = await response.json();
          
          if (result.success && result.data) {
            const gallery = result.data;
            document.getElementById('galleryModalTitle').textContent = 'Sửa Ảnh Gallery';
            document.getElementById('galleryId').value = gallery.id;
            document.getElementById('galleryImageUrl').value = gallery.imageUrl;
            document.getElementById('galleryCaption').value = gallery.caption;
            document.getElementById('galleryDescription').value = gallery.description || '';
            document.getElementById('galleryOrder').value = gallery.displayOrder;
            document.getElementById('galleryActive').checked = gallery.active;
            
            // Show preview
            document.getElementById('galleryPreview').src = gallery.imageUrl;
            document.getElementById('galleryPreviewContainer').style.display = 'block';
            
            openModal('galleryModal');
          }
        } catch (error) {
          console.error('Error loading gallery:', error);
          showNotification('Lỗi', 'Không thể tải thông tin gallery', 'error');
        }
      }
      
      // Save gallery
      async function saveGallery() {
        const id = document.getElementById('galleryId').value;
        const imageUrl = document.getElementById('galleryImageUrl').value.trim();
        const caption = document.getElementById('galleryCaption').value.trim();
        const description = document.getElementById('galleryDescription').value.trim();
        const displayOrder = document.getElementById('galleryOrder').value;
        const isActive = document.getElementById('galleryActive').checked;
        
        if (!imageUrl || !caption) {
          showNotification('Lỗi', 'Vui lòng nhập đầy đủ thông tin bắt buộc', 'error');
          return;
        }
        
        const formData = new URLSearchParams();
        formData.append('action', id ? 'update' : 'add');
        if (id) formData.append('id', id);
        formData.append('imageUrl', imageUrl);
        formData.append('caption', caption);
        formData.append('description', description);
        formData.append('displayOrder', displayOrder);
        formData.append('isActive', isActive);
        
        try {
          const response = await fetch(contextPath + '/api/gallery', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData
          });
          
          const result = await response.json();
          
          if (result.success) {
            showNotification('Thành công', result.message, 'success');
            closeModal('galleryModal');
            loadGalleries();
          } else {
            showNotification('Lỗi', result.message, 'error');
          }
        } catch (error) {
          console.error('Error saving gallery:', error);
          showNotification('Lỗi', 'Không thể lưu gallery', 'error');
        }
      }
      
      // Toggle gallery status
      async function toggleGalleryStatus(id, isActive) {
        const formData = new URLSearchParams();
        formData.append('action', 'updateStatus');
        formData.append('id', id);
        formData.append('isActive', isActive);
        
        try {
          const response = await fetch(contextPath + '/api/gallery', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData
          });
          
          const result = await response.json();
          
          if (result.success) {
            showNotification('Thành công', result.message, 'success');
            loadGalleries();
          } else {
            showNotification('Lỗi', result.message, 'error');
          }
        } catch (error) {
          console.error('Error updating status:', error);
          showNotification('Lỗi', 'Không thể cập nhật trạng thái', 'error');
        }
      }
      
      // Delete gallery
      async function deleteGallery(id) {
        if (!confirm('Bạn có chắc chắn muốn xóa ảnh này?')) return;
        
        try {
          const response = await fetch(contextPath + '/api/gallery/' + id, {
            method: 'DELETE'
          });
          
          const result = await response.json();
          
          if (result.success) {
            showNotification('Thành công', result.message, 'success');
            loadGalleries();
          } else {
            showNotification('Lỗi', result.message, 'error');
          }
        } catch (error) {
          console.error('Error deleting gallery:', error);
          showNotification('Lỗi', 'Không thể xóa gallery', 'error');
        }
      }
      
      // Preview image when URL changes
      document.addEventListener('DOMContentLoaded', function() {
        const imageUrlInput = document.getElementById('galleryImageUrl');
        if (imageUrlInput) {
          imageUrlInput.addEventListener('blur', function() {
            const url = this.value.trim();
            if (url) {
              document.getElementById('galleryPreview').src = url;
              document.getElementById('galleryPreviewContainer').style.display = 'block';
            }
          });
        }
        
        // News image preview
        const newsImageUrlInput = document.getElementById('newsImageUrl');
        if (newsImageUrlInput) {
          newsImageUrlInput.addEventListener('blur', function() {
            const url = this.value.trim();
            if (url) {
              document.getElementById('newsPreview').src = url;
              document.getElementById('newsPreviewContainer').style.display = 'block';
            }
          });
        }
        
        // Auto generate slug from title
        const newsTitleInput = document.getElementById('newsTitle');
        const newsSlugInput = document.getElementById('newsSlug');
        if (newsTitleInput && newsSlugInput) {
          newsTitleInput.addEventListener('input', function() {
            const title = this.value.trim();
            if (title) {
              newsSlugInput.value = generateSlug(title);
            }
          });
        }
      });
      
      // ===== NEWS MANAGEMENT FUNCTIONS =====
      
      // Load all news
      async function loadNews() {
        try {
          const response = await fetch(contextPath + '/api/news/all');
          const result = await response.json();
          
          const tbody = document.getElementById('newsTableBody');
          if (!tbody) return;
          
          if (result.success && result.data && result.data.length > 0) {
            tbody.innerHTML = result.data.map(news => {
              const publishedDate = news.publishedDate ? new Date(news.publishedDate).toLocaleDateString('vi-VN') : 'Chưa đăng';
              const statusBadge = news.published 
                ? '<span style="padding: 4px 12px; background: #6a994e; color: white; border-radius: 12px; font-size: 12px;">Đã xuất bản</span>'
                : '<span style="padding: 4px 12px; background: #999; color: white; border-radius: 12px; font-size: 12px;">Bản nháp</span>';
              
              return '<tr>' +
                '<td>' + news.id + '</td>' +
                '<td><img src="' + (news.imageUrl || '') + '" style="width: 80px; height: 60px; object-fit: cover; border-radius: 4px;" onerror="this.src=\'https://via.placeholder.com/80x60?text=No+Image\'" /></td>' +
                '<td style="max-width: 300px;">' + news.title + '</td>' +
                '<td>' + news.categoryName + '</td>' +
                '<td>' + (news.author || 'Admin') + '</td>' +
                '<td>' + (news.views || 0) + '</td>' +
                '<td>' + statusBadge + '</td>' +
                '<td>' + publishedDate + '</td>' +
                '<td>' +
                  '<button class="btn btn-sm btn-warning" onclick="editNews(' + news.id + ')" title="Sửa">' +
                    '<i class="fas fa-edit"></i>' +
                  '</button> ' +
                  '<button class="btn btn-sm ' + (news.published ? 'btn-secondary' : 'btn-success') + '" onclick="toggleNewsPublish(' + news.id + ', ' + !news.published + ')" title="' + (news.published ? 'Ẩn' : 'Xuất bản') + '">' +
                    '<i class="fas fa-' + (news.published ? 'eye-slash' : 'eye') + '"></i>' +
                  '</button> ' +
                  '<button class="btn btn-sm btn-danger" onclick="deleteNews(' + news.id + ')" title="Xóa">' +
                    '<i class="fas fa-trash"></i>' +
                  '</button>' +
                '</td>' +
              '</tr>';
            }).join('');
          } else {
            tbody.innerHTML = '<tr><td colspan="9" style="text-align: center; padding: 40px; color: #999;">Chưa có tin tức nào</td></tr>';
          }
        } catch (error) {
          console.error('Error loading news:', error);
          document.getElementById('newsTableBody').innerHTML = '<tr><td colspan="9" style="text-align: center; padding: 40px; color: #e76f51;">Lỗi khi tải danh sách tin tức</td></tr>';
        }
      }
      
      // Generate slug from Vietnamese text
      function generateSlug(str) {
        str = str.toLowerCase();
        
        // Remove Vietnamese accents
        const from = "àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ";
        const to = "aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd";
        
        for (let i = 0; i < from.length; i++) {
          str = str.replace(new RegExp(from.charAt(i), 'g'), to.charAt(i));
        }
        
        // Remove special characters and replace spaces with hyphens
        str = str.replace(/[^a-z0-9 -]/g, '')
                 .replace(/\s+/g, '-')
                 .replace(/-+/g, '-')
                 .replace(/^-+|-+$/g, '');
        
        return str;
      }
      
      // Open news modal for adding
      function openNewsModal() {
        document.getElementById('newsModalTitle').textContent = 'Thêm Tin Tức';
        document.getElementById('newsId').value = '';
        document.getElementById('newsForm').reset();
        document.getElementById('newsAuthor').value = 'Admin';
        document.getElementById('newsPublished').checked = true;
        document.getElementById('newsPreviewContainer').style.display = 'none';
        openModal('newsModal');
      }
      
      // Edit news
      async function editNews(id) {
        try {
          const response = await fetch(contextPath + '/api/news/all');
          const result = await response.json();
          
          if (result.success) {
            const news = result.data.find(n => n.id === id);
            if (news) {
              document.getElementById('newsModalTitle').textContent = 'Sửa Tin Tức';
              document.getElementById('newsId').value = news.id;
              document.getElementById('newsTitle').value = news.title;
              document.getElementById('newsSlug').value = news.slug;
              document.getElementById('newsExcerpt').value = news.excerpt || '';
              document.getElementById('newsContent').value = news.content || '';
              document.getElementById('newsImageUrl').value = news.imageUrl || '';
              document.getElementById('newsCategory').value = news.category || '';
              document.getElementById('newsAuthor').value = news.author || 'Admin';
              document.getElementById('newsPublished').checked = news.published || false;
              
              if (news.publishedDate) {
                const date = new Date(news.publishedDate);
                const dateStr = date.toISOString().slice(0, 16);
                document.getElementById('newsPublishedDate').value = dateStr;
              }
              
              if (news.imageUrl) {
                document.getElementById('newsPreview').src = news.imageUrl;
                document.getElementById('newsPreviewContainer').style.display = 'block';
              }
              
              openModal('newsModal');
            }
          }
        } catch (error) {
          console.error('Error loading news:', error);
          showNotification('Lỗi', 'Không thể tải thông tin tin tức', 'error');
        }
      }
      
      // Save news (add or update)
      async function saveNews() {
        const id = document.getElementById('newsId').value;
        const title = document.getElementById('newsTitle').value.trim();
        const slug = document.getElementById('newsSlug').value.trim();
        const excerpt = document.getElementById('newsExcerpt').value.trim();
        const content = document.getElementById('newsContent').value.trim();
        const imageUrl = document.getElementById('newsImageUrl').value.trim();
        const category = document.getElementById('newsCategory').value;
        const author = document.getElementById('newsAuthor').value.trim() || 'Admin';
        const published = document.getElementById('newsPublished').checked;
        const publishedDate = document.getElementById('newsPublishedDate').value;
        
        if (!title || !slug || !excerpt || !content || !imageUrl || !category) {
          showNotification('Lỗi', 'Vui lòng điền đầy đủ các trường bắt buộc', 'warning');
          return;
        }
        
        const data = {
          title: title,
          slug: slug,
          excerpt: excerpt,
          content: content,
          imageUrl: imageUrl,
          category: category,
          author: author,
          published: published,
          publishedDate: publishedDate || null
        };
        
        if (id) {
          data.id = parseInt(id);
        }
        
        try {
          const action = id ? 'update' : 'add';
          const response = await fetch(contextPath + '/api/news?action=' + action, {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
          });
          
          const result = await response.json();
          
          if (result.success) {
            showNotification('Thành công', result.message, 'success');
            closeModal('newsModal');
            loadNews();
          } else {
            showNotification('Lỗi', result.message, 'error');
          }
        } catch (error) {
          console.error('Error saving news:', error);
          showNotification('Lỗi', 'Không thể lưu tin tức', 'error');
        }
      }
      
      // Toggle news publish status
      async function toggleNewsPublish(id, published) {
        try {
          const response = await fetch(contextPath + '/api/news?action=updateStatus', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({
              id: id,
              published: published
            })
          });
          
          const result = await response.json();
          
          if (result.success) {
            showNotification('Thành công', published ? 'Đã xuất bản tin tức' : 'Đã ẩn tin tức', 'success');
            loadNews();
          } else {
            showNotification('Lỗi', result.message, 'error');
          }
        } catch (error) {
          console.error('Error toggling news publish:', error);
          showNotification('Lỗi', 'Không thể cập nhật trạng thái', 'error');
        }
      }
      
      // Delete news
      async function deleteNews(id) {
        if (!confirm('Bạn có chắc chắn muốn xóa tin tức này?')) return;
        
        try {
          const response = await fetch(contextPath + '/api/news?action=delete', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({ id: id })
          });
          
          const result = await response.json();
          
          if (result.success) {
            showNotification('Thành công', result.message, 'success');
            loadNews();
          } else {
            showNotification('Lỗi', result.message, 'error');
          }
        } catch (error) {
          console.error('Error deleting news:', error);
          showNotification('Lỗi', 'Không thể xóa tin tức', 'error');
        }
      }
    </script>
  </body>
</html>
