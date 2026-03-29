<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page buffer="256kb" autoFlush="true" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="/view/login_1.jsp" />
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cài đặt tài khoản - Tiệm Hoa nhà tớ</title>
    
    <!-- CSRF Token -->
    <meta name="csrf-token" content="${csrfToken}">
    <script>window.csrfToken = '${csrfToken}';</script>
    <link rel="shortcut icon" href="//cdn.hstatic.net/themes/200000846175/1001403720/14/favicon.png?v=245" type="image/x-icon">
    <link href="https://fonts.googleapis.com/css2?family=Crimson+Text:ital,wght@0,400;0,600;0,700;1,400&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS for header/footer from main site -->
    <link href="//cdn.hstatic.net/themes/200000846175/1001403720/14/plugin-style.css?v=245" rel="stylesheet" type="text/css">
    <link href="//cdn.hstatic.net/themes/200000846175/1001403720/14/styles-new.scss.css?v=245" rel="stylesheet" type="text/css">
    
    <style>
        :root {
            /* Header/Footer variables */
            --bgfooter: #ffffff;
            --colorfooter: #000000;
            --height-head: 72px;
            --bgshop: #000000;
            --colorshop: #000000;
            --colorshophover: #212020;
            --colorbgmenumb: #ffffff;
            --colortextmenumb: #000000;
            
            /* Page variables */
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
            --error: #e74c3c;
            --warning: #f39c12;
            --info: #3498db;
            --shadow-sm: 0 2px 8px rgba(60,41,34,0.06);
            --shadow-md: 0 8px 24px rgba(60,41,34,0.1);
            --shadow-lg: 0 16px 48px rgba(60,41,34,0.15);
            --radius-sm: 8px;
            --radius-md: 16px;
            --radius-lg: 24px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        /* Fix: Prevent site-overlay from blocking clicks */
        #site-overlay {
            pointer-events: none !important;
            display: none !important;
        }
        
        /* Force Font Awesome icons to display correctly */
        .main-container i.fas,
        .main-container i.far,
        .main-container i.fab,
        .modal-overlay i.fas,
        .modal-overlay i.far,
        .toast-container i.fas {
            font-family: "Font Awesome 6 Free" !important;
            font-weight: 900 !important;
            font-style: normal !important;
            display: inline-block !important;
        }
        
        .main-container i.far {
            font-weight: 400 !important;
        }
        
        body {
            font-family: 'Poppins', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #faf5ef 0%, #fff9f5 50%, #f5ebe1 100%);
            background-attachment: fixed;
            color: var(--brown-main);
            line-height: 1.6;
            min-height: 100vh;
        }
        
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: 
                radial-gradient(circle at 20% 50%, rgba(201, 147, 102, 0.05) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(201, 147, 102, 0.05) 0%, transparent 50%);
            pointer-events: none;
            z-index: 0;
        }
        
        /* Breadcrumb */
        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
            font-size: 0.9rem;
        }
        
        .breadcrumb a {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            transition: var(--transition);
        }
        .breadcrumb a:hover {
            color: white;
        }
        
        .breadcrumb span {
            color: white;
        }
        
        .breadcrumb i {
            font-size: 0.7rem;
            color: rgba(255,255,255,0.5);
        }
        
        /* Main Container */
        .main-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem;
            margin-top: -2rem;
            position: relative;
            z-index: 10;
            pointer-events: auto;
        }
        
        /* Profile Layout */
        .profile-grid {
            display: grid;
            grid-template-columns: 300px 1fr;
            gap: 2rem;
            pointer-events: auto;
        }
        
        /* Content Card - ensure clickable */
        .content-card,
        .info-card,
        .bio-section,
        .password-card {
            pointer-events: auto !important;
        }
        
        /* Sidebar */
        .sidebar {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.98) 100%);
            backdrop-filter: blur(10px);
            border-radius: var(--radius-lg);
            padding: 1.5rem;
            box-shadow: var(--shadow-md);
            border: 1px solid rgba(201, 147, 102, 0.1);
            height: fit-content;
            position: sticky;
            top: 100px;
            transition: var(--transition);
        }
        
        .sidebar:hover {
            box-shadow: var(--shadow-lg);
            transform: translateY(-2px);
        }
        
        .sidebar-user {
            text-align: center;
            padding-bottom: 1.5rem;
            margin-bottom: 1.5rem;
            border-bottom: 1px solid var(--border-color);
        }
        
        .sidebar-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid var(--primary-light);
            margin-bottom: 1rem;
            transition: var(--transition);
            box-shadow: 0 4px 15px rgba(201, 147, 102, 0.3);
        }
        
        .sidebar-avatar:hover {
            transform: scale(1.05);
            border-color: var(--primary);
            box-shadow: 0 6px 20px rgba(201, 147, 102, 0.4);
        }
        
        .sidebar-name {
            font-family: 'Crimson Text', serif;
            font-size: 1.2rem;
            color: var(--brown-main);
            font-weight: 600;
        }
        
        .sidebar-email {
            font-size: 0.85rem;
            color: var(--text-muted);
        }
        
        .sidebar-menu {
            list-style: none;
        }
        
        .sidebar-menu li {
            margin-bottom: 0.25rem;
        }
        
        .sidebar-menu a {
            display: flex;
            align-items: center;
            gap: 0.875rem;
            padding: 1rem 1.25rem;
            color: var(--brown-soft);
            text-decoration: none;
            border-radius: var(--radius-md);
            transition: var(--transition);
            font-weight: 500;
            position: relative;
            overflow: hidden;
            transform-origin: left center;
        }
        
        .sidebar-menu a:hover {
            transform: translateX(5px);
        }
        
        .sidebar-menu a::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            width: 0;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            border-radius: var(--radius-md);
            transition: var(--transition);
            z-index: -1;
        }
        
        .sidebar-menu a.active {
            color: white;
            background: transparent;
            box-shadow: 0 4px 15px rgba(201, 147, 102, 0.3);
        }
        
        .sidebar-menu a.active::before {
            width: 100%;
        }
        
        .sidebar-menu a.active:hover {
            transform: translateX(8px);
            box-shadow: 0 6px 20px rgba(201, 147, 102, 0.4);
        }
        
        .sidebar-menu i {
            width: 22px;
            text-align: center;
            font-size: 1.1rem;
        }
        
        .menu-badge {
            margin-left: auto;
            background: var(--primary);
            color: white;
            font-size: 0.7rem;
            padding: 0.2rem 0.5rem;
            border-radius: 10px;
            font-weight: 600;
        }
        
        /* Logout Link Style */
        .sidebar-menu .logout-link {
            color: var(--error);
            margin-top: 1rem;
            border-top: 1px solid var(--border-color);
            padding-top: 1rem;
        }
        
        .sidebar-menu .logout-link::before {
            background: linear-gradient(135deg, var(--error) 0%, #c0392b 100%);
        }
        
        .sidebar-menu .logout-link:hover {
            background: rgba(231, 76, 60, 0.1);
            color: var(--error);
        }
        
        /* Content Card */
        .content-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.98) 100%);
            backdrop-filter: blur(10px);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-md);
            border: 1px solid rgba(201, 147, 102, 0.1);
            overflow: hidden;
            transition: var(--transition);
        }
        
        .content-card:hover {
            box-shadow: var(--shadow-lg);
        }
        
        /* Profile Header */
        .profile-header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            padding: 2.5rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
        
        .profile-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            border-radius: 50%;
        }
        
        .avatar-container {
            position: relative;
            display: inline-block;
            z-index: 1;
        }
        
        .avatar {
            width: 130px;
            height: 130px;
            border-radius: 50%;
            border: 5px solid white;
            object-fit: cover;
            background: var(--bg-light);
            box-shadow: var(--shadow-md);
        }
        
        .avatar-edit {
            position: absolute;
            bottom: 8px;
            right: 8px;
            width: 38px;
            height: 38px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: var(--shadow-md);
            border: none;
            color: var(--primary);
            transition: var(--transition);
            font-size: 1rem;
        }
        
        .avatar-edit:hover {
            transform: scale(1.1);
            color: var(--primary-dark);
            background: var(--primary-light);
        }
        
        .profile-name {
            color: white;
            font-family: 'Crimson Text', serif;
            font-size: 1.75rem;
            margin-top: 1.25rem;
            position: relative;
            z-index: 1;
        }
        
        .profile-email {
            color: rgba(255,255,255,0.9);
            font-size: 0.95rem;
            margin-top: 0.25rem;
            position: relative;
            z-index: 1;
        }
        
        /* Profile Body */
        .profile-body {
            padding: 2rem;
        }
        
        .section-title {
            font-family: 'Crimson Text', serif;
            font-size: 1.4rem;
            color: var(--brown-main);
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid var(--primary-light);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .section-title i {
            color: var(--primary);
            font-size: 1.2rem;
        }
        
        /* Info Grid */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.25rem;
        }
        
        .info-card {
            background: var(--bg-cream);
            border-radius: var(--radius-md);
            padding: 1.25rem;
            transition: var(--transition);
            border: 1px solid transparent;
        }
        
        .info-card:hover {
            border-color: var(--primary-light);
            box-shadow: var(--shadow-sm);
        }
        
        .info-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 0.75rem;
        }
        
        .info-card-label {
            font-size: 0.85rem;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .info-card-label i {
            color: var(--primary);
        }
        
        .info-card-value {
            font-size: 1.05rem;
            color: var(--brown-main);
            font-weight: 500;
        }
        
        .info-card-value.placeholder {
            color: var(--text-muted);
            font-style: italic;
            font-weight: 400;
        }
        
        .btn-edit-sm {
            background: transparent !important;
            border: none !important;
            color: var(--primary) !important;
            cursor: pointer !important;
            padding: 0.4rem !important;
            border-radius: 50% !important;
            transition: var(--transition) !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            pointer-events: auto !important;
            position: relative !important;
            z-index: 10 !important;
        }
        
        .btn-edit-sm:hover {
            background: var(--primary-light) !important;
            color: var(--primary-dark) !important;
        }
        
        /* Avatar edit button */
        .avatar-edit {
            pointer-events: auto !important;
            cursor: pointer !important;
            z-index: 10 !important;
        }
        
        /* Bio Section */
        .bio-section {
            margin-top: 1.5rem;
            padding: 1.5rem;
            background: linear-gradient(135deg, var(--bg-cream) 0%, var(--primary-light) 100%);
            border-radius: var(--radius-md);
            border: 1px solid var(--primary-light);
        }
        
        .bio-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }
        
        .bio-title {
            font-weight: 600;
            color: var(--brown-soft);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .bio-title i {
            color: var(--primary);
        }
        
        .bio-content {
            color: var(--brown-main);
            font-style: italic;
            line-height: 1.7;
        }
        
        .bio-content.placeholder {
            color: var(--text-muted);
        }
        
        /* Info Row (for email locked) */
        .info-row-locked {
            grid-column: span 2;
            background: var(--bg-light);
            border-radius: var(--radius-md);
            padding: 1rem 1.25rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .locked-badge {
            background: var(--text-muted);
            color: white;
            font-size: 0.75rem;
            padding: 0.3rem 0.75rem;
            border-radius: 20px;
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }
        
        /* Modal - High z-index to avoid conflicts with external CSS */
        #modalOverlay {
            position: fixed !important;
            top: 0 !important;
            left: 0 !important;
            right: 0 !important;
            bottom: 0 !important;
            background: rgba(60,41,34,0.6) !important;
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            display: none !important;
            align-items: center !important;
            justify-content: center !important;
            z-index: 99999 !important;
            padding: 20px !important;
            overflow-y: auto !important;
        }
        
        #modalOverlay.active {
            display: flex !important;
            opacity: 1 !important;
            visibility: visible !important;
        }
        
        #editModal {
            background: white !important;
            border-radius: var(--radius-lg) !important;
            width: 90% !important;
            max-width: 650px !important;
            max-height: 90vh !important;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25) !important;
            position: relative !important;
            z-index: 100000 !important;
            display: flex !important;
            flex-direction: column !important;
            visibility: visible !important;
            opacity: 1 !important;
            overflow: hidden !important;
            margin: auto !important;
        }
        
        #modalOverlay.active #editModal {
            transform: translateY(0) scale(1) !important;
            display: block !important;
        }
        
        #editModal .modal-header {
            padding: 1.5rem 1.75rem !important;
            border-bottom: 1px solid var(--border-color) !important;
            display: flex !important;
            justify-content: space-between !important;
            align-items: center !important;
            background: var(--bg-cream) !important;
            border-radius: var(--radius-lg) var(--radius-lg) 0 0 !important;
            visibility: visible !important;
            opacity: 1 !important;
        }
        
        #editModal .modal-title,
        #modalTitle {
            font-family: 'Crimson Text', serif !important;
            font-size: 1.35rem !important;
            color: var(--brown-main) !important;
            display: flex !important;
            align-items: center !important;
            gap: 0.5rem !important;
            visibility: visible !important;
            opacity: 1 !important;
            margin: 0 !important;
        }
        
        #editModal .modal-title i {
            color: var(--primary) !important;
        }
        
        #editModal .modal-close {
            background: none !important;
            border: none !important;
            font-size: 1.25rem !important;
            color: var(--text-muted) !important;
            cursor: pointer !important;
            transition: var(--transition) !important;
            width: 36px !important;
            height: 36px !important;
            border-radius: 50% !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            visibility: visible !important;
            opacity: 1 !important;
        }
        
        #editModal .modal-close:hover {
            background: var(--error) !important;
            color: white !important;
        }
        
        #editModal .modal-body,
        #modalBody {
            padding: 1.75rem !important;
            display: block !important;
            visibility: visible !important;
            opacity: 1 !important;
            min-height: 100px !important;
            max-height: calc(90vh - 200px) !important;
            overflow-y: auto !important;
            overflow-x: hidden !important;
            background: white !important;
            flex: 1 !important;
        }
        
        #editModal .modal-body .form-group,
        #modalBody .form-group {
            display: block !important;
            visibility: visible !important;
            opacity: 1 !important;
            margin-bottom: 1rem !important;
        }
        
        #editModal .modal-body .form-label,
        #modalBody .form-label {
            display: block !important;
            visibility: visible !important;
            opacity: 1 !important;
            font-weight: 500 !important;
            color: var(--brown-soft) !important;
            margin-bottom: 0.6rem !important;
            font-size: 0.9rem !important;
        }
        
        .form-group {
            margin-bottom: 1.25rem;
        }
        
        .form-label {
            display: block;
            font-weight: 500;
            color: var(--brown-soft);
            margin-bottom: 0.6rem;
            font-size: 0.9rem;
        }
        
        #modalBody .form-control,
        #modalBody input[type="text"],
        #modalBody input[type="tel"],
        #modalBody input[type="date"],
        #modalBody input[type="url"],
        #modalBody textarea,
        #modalBody select,
        .password-card .form-control {
            width: 100% !important;
            padding: 0.75rem 1rem !important;
            border: 2px solid var(--border-color) !important;
            border-radius: var(--radius-md) !important;
            font-family: inherit !important;
            font-size: 1rem !important;
            color: var(--brown-main) !important;
            transition: var(--transition) !important;
            background: var(--bg-cream) !important;
            display: block !important;
            visibility: visible !important;
            opacity: 1 !important;
            box-sizing: border-box !important;
        }
        
        #modalBody .form-control:focus,
        #modalBody input:focus,
        #modalBody textarea:focus,
        #modalBody select:focus,
        .password-card .form-control:focus {
            outline: none !important;
            border-color: var(--primary) !important;
            background: white !important;
            box-shadow: 0 0 0 4px rgba(201,147,102,0.15) !important;
        }
        
        #modalBody textarea.form-control,
        #modalBody textarea {
            resize: vertical !important;
            min-height: 80px !important;
            max-height: 120px !important;
        }
        
        #modalBody .form-select,
        #modalBody select,
        .form-select {
            width: 100% !important;
            padding: 0.875rem 1.25rem !important;
            border: 2px solid var(--border-color) !important;
            border-radius: var(--radius-md) !important;
            font-family: inherit !important;
            font-size: 1rem !important;
            color: var(--brown-main) !important;
            background: var(--bg-cream) !important;
            cursor: pointer !important;
            transition: var(--transition) !important;
            display: block !important;
            visibility: visible !important;
            opacity: 1 !important;
            -webkit-appearance: menulist !important;
            appearance: menulist !important;
        }
        
        #modalBody .form-select:focus,
        #modalBody select:focus,
        .form-select:focus {
            outline: none !important;
            border-color: var(--primary) !important;
            background: white !important;
        }
        
        #editModal .modal-footer {
            padding: 1.25rem 1.75rem !important;
            border-top: 1px solid var(--border-color) !important;
            display: flex !important;
            justify-content: flex-end !important;
            gap: 0.75rem !important;
            background: var(--bg-light) !important;
            border-radius: 0 0 var(--radius-lg) var(--radius-lg) !important;
            visibility: visible !important;
            opacity: 1 !important;
            flex-shrink: 0 !important;
            min-height: 70px !important;
            align-items: center !important;
        }
        
        /* Responsive Grid for Address Form */
        @media (max-width: 768px) {
            #editModal {
                width: 95% !important;
                max-width: 95% !important;
                max-height: 85vh !important;
            }
            
            #editModal .modal-footer {
                flex-direction: column !important;
                gap: 0.5rem !important;
                padding: 1rem !important;
            }
            
            #editModal .btn {
                width: 100% !important;
                justify-content: center !important;
            }
            
            #modalBody [style*="grid-template-columns: 1fr 1fr"] {
                grid-template-columns: 1fr !important;
            }
            
            #modalBody [style*="grid-template-columns: 1fr 1fr 1fr"] {
                grid-template-columns: 1fr !important;
            }
        }

        /* Order Detail Modal */
        #orderDetailOverlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 100000;
            opacity: 0;
            visibility: hidden;
            transition: var(--transition);
        }
        
        #orderDetailOverlay.show {
            opacity: 1;
            visibility: visible;
        }
        
        #orderDetailOverlay .order-detail-modal {
            background: var(--white);
            border-radius: var(--radius-lg);
            width: 90%;
            max-width: 600px;
            max-height: 90vh;
            overflow-y: auto;
            transform: scale(0.9);
            transition: var(--transition);
        }
        
        #orderDetailOverlay.show .order-detail-modal {
            transform: scale(1);
        }
        
        .order-detail-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid var(--border-color);
            background: var(--bg-cream);
            border-radius: var(--radius-lg) var(--radius-lg) 0 0;
        }
        
        .order-detail-header h3 {
            font-family: 'Crimson Text', serif;
            font-size: 1.25rem;
            color: var(--brown-main);
            margin: 0;
        }
        
        .order-detail-close {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            border: none;
            background: transparent;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: var(--transition);
            color: var(--text-muted);
        }
        
        .order-detail-close:hover {
            background: var(--error);
            color: white;
        }
        
        .order-detail-body {
            padding: 1.5rem;
        }
        
        .order-detail-info p {
            margin: 0.5rem 0;
            font-size: 0.95rem;
        }
        
        .order-detail-info strong {
            color: var(--brown-main);
        }
        
        .order-detail-items {
            margin: 1rem 0;
        }
        
        .order-detail-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 0.75rem 0;
            border-bottom: 1px solid var(--border-color);
        }
        
        .order-detail-item:last-child {
            border-bottom: none;
        }
        
        .order-detail-item .item-image {
            width: 60px;
            height: 60px;
            border-radius: var(--radius-sm);
            overflow: hidden;
            flex-shrink: 0;
        }
        
        .order-detail-item .item-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .order-detail-item .item-info {
            flex: 1;
        }
        
        .order-detail-item .item-name {
            font-weight: 500;
            color: var(--brown-main);
        }
        
        .order-detail-item .item-quantity {
            font-size: 0.9rem;
            color: var(--text-muted);
        }
        
        .order-detail-item .item-price {
            font-weight: 600;
            color: var(--primary-dark);
        }
        
        #editModal .btn,
        .password-card .btn {
            padding: 0.875rem 1.75rem !important;
            border-radius: 50px !important;
            font-family: inherit !important;
            font-size: 0.95rem !important;
            font-weight: 500 !important;
            cursor: pointer !important;
            transition: var(--transition) !important;
            display: inline-flex !important;
            align-items: center !important;
            justify-content: center !important;
            gap: 0.5rem !important;
            visibility: visible !important;
            opacity: 1 !important;
            white-space: nowrap !important;
            min-width: fit-content !important;
            border: none !important;
        }
        
        #editModal .btn-secondary,
        .password-card .btn-secondary {
            background: white !important;
            border: 2px solid var(--border-color) !important;
            color: var(--brown-soft) !important;
            z-index: 1 !important;
        }
        
        #editModal .btn-secondary:hover,
        .password-card .btn-secondary:hover {
            background: var(--bg-light) !important;
            border-color: var(--brown-soft) !important;
        }
        
        #editModal .btn-primary,
        .password-card .btn-primary {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%) !important;
            border: none !important;
            color: white !important;
            box-shadow: 0 4px 15px rgba(201,147,102,0.3) !important;
            z-index: 1 !important;
        }
        
        #editModal .btn-primary:hover,
        .password-card .btn-primary:hover {
            transform: translateY(-2px) !important;
            box-shadow: 0 6px 20px rgba(201,147,102,0.4) !important;
        }

        /* Toast - Highest z-index for notifications */
        .toast-container {
            position: fixed !important;
            top: 1.5rem !important;
            right: 1.5rem !important;
            z-index: 999999 !important;
        }
        
        .toast {
            background: white;
            padding: 1.25rem 1.75rem;
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-lg);
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 0.75rem;
            transform: translateX(120%);
            transition: var(--transition);
            min-width: 300px;
        }
        
        .toast.show {
            transform: translateX(0);
        }
        
        .toast.success {
            border-left: 4px solid var(--success);
        }
        
        .toast.success i {
            color: var(--success);
            font-size: 1.25rem;
        }
        
        .toast.error {
            border-left: 4px solid var(--error);
        }
        
        .toast.error i {
            color: var(--error);
            font-size: 1.25rem;
        }
        
        /* Content Sections */
        .content-section {
            display: none;
            animation: fadeIn 0.3s ease;
        }
        
        .content-section.active {
            display: block;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        /* Order History Styles */
        .orders-filter {
            display: flex;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
        }
        
        .filter-btn {
            padding: 0.6rem 1.25rem;
            border: 2px solid var(--border-color);
            background: white;
            border-radius: 50px;
            color: var(--brown-soft);
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            font-size: 0.9rem;
        }
        
        .filter-btn:hover, .filter-btn.active {
            background: var(--primary);
            border-color: var(--primary);
            color: white;
        }
        
        .order-card {
            background: var(--white);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            margin-bottom: 1.25rem;
            overflow: hidden;
            border: 1px solid var(--border-color);
            transition: var(--transition);
        }
        
        .order-card:hover {
            box-shadow: var(--shadow-md);
            border-color: var(--primary-light);
        }
        
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.25rem 1.5rem;
            background: linear-gradient(135deg, var(--bg-cream) 0%, var(--bg-light) 100%);
            border-bottom: 1px solid var(--border-color);
        }
        
        .order-info {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }
        
        .order-id {
            font-weight: 600;
            color: var(--brown-main);
            font-size: 1.05rem;
        }
        
        .order-date {
            color: var(--text-muted);
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }
        
        .order-status {
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }
        
        .order-status.pending {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeeba 100%);
            color: #856404;
        }
        
        .order-status.processing {
            background: linear-gradient(135deg, #cce5ff 0%, #b8daff 100%);
            color: #004085;
        }
        
        .order-status.shipped {
            background: linear-gradient(135deg, #d1ecf1 0%, #bee5eb 100%);
            color: #0c5460;
        }
        
        .order-status.delivered {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            color: #155724;
        }
        
        .order-status.cancelled {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            color: #721c24;
        }
        
        .order-body {
            padding: 1.25rem 1.5rem;
        }
        
        .order-item {
            display: flex;
            align-items: center;
            gap: 1.25rem;
            padding: 1rem 0;
            border-bottom: 1px solid var(--border-color);
        }
        
        .order-item:last-child {
            border-bottom: none;
        }
        
        .order-item-img {
            width: 70px;
            height: 70px;
            border-radius: var(--radius-md);
            object-fit: cover;
            box-shadow: var(--shadow-sm);
        }
        
        .order-item-info {
            flex: 1;
        }
        
        .order-item-name {
            font-weight: 600;
            color: var(--brown-main);
            margin-bottom: 0.25rem;
        }
        
        .order-item-qty {
            color: var(--text-muted);
            font-size: 0.9rem;
        }
        
        .order-item-price {
            font-weight: 700;
            color: var(--primary-dark);
            font-size: 1.05rem;
        }
        
        .order-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.25rem 1.5rem;
            background: var(--bg-light);
            border-top: 1px solid var(--border-color);
        }
        
        .order-total {
            font-size: 1.1rem;
            color: var(--brown-main);
        }
        
        .order-total span {
            font-weight: 700;
            color: var(--primary-dark);
            font-size: 1.2rem;
        }
        
        /* Address Book Styles */
        .address-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.25rem;
        }
        
        .address-card {
            background: var(--white);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            padding: 1.5rem;
            position: relative;
            border: 2px solid transparent;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            overflow: hidden;
        }
        
        .address-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, var(--primary) 0%, var(--primary-dark) 50%, var(--primary) 100%);
            background-size: 200% 100%;
            transform: translateX(-100%);
            transition: transform 0.4s ease;
        }
        
        .address-card:hover {
            box-shadow: 0 8px 30px rgba(201, 147, 102, 0.2);
            transform: translateY(-4px);
        }
        
        .address-card:hover::before {
            transform: translateX(0);
        }
        
        .address-card.default {
            border-color: var(--primary);
            background: linear-gradient(135deg, 
                rgba(255, 247, 237, 0.6) 0%, 
                rgba(255, 255, 255, 1) 50%,
                rgba(255, 247, 237, 0.3) 100%);
            box-shadow: 0 4px 20px rgba(201, 147, 102, 0.15);
        }
        
        .address-card.default::before {
            transform: translateX(0);
            background: linear-gradient(90deg, 
                var(--primary) 0%, 
                #d4a574 50%, 
                var(--primary) 100%);
            animation: shimmer 2s infinite;
        }
        
        @keyframes shimmer {
            0%, 100% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
        }
        
        .address-default-badge {
            position: absolute;
            top: -8px;
            right: 1rem;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 0.35rem 1rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.3rem;
            box-shadow: var(--shadow-sm);
        }
        
        .address-icon {
            width: 48px;
            height: 48px;
            background: var(--primary-light);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-dark);
            margin-bottom: 1rem;
            font-size: 1.2rem;
        }
        
        .address-name {
            font-weight: 600;
            color: var(--brown-main);
            font-size: 1.1rem;
            margin-bottom: 0.5rem;
        }
        
        .address-phone {
            color: var(--text-muted);
            font-size: 0.9rem;
            margin-bottom: 0.75rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .address-detail {
            color: var(--brown-soft);
            line-height: 1.6;
            font-size: 0.95rem;
        }
        
        .address-actions {
            margin-top: 1.25rem;
            padding-top: 1rem;
            border-top: 1px solid var(--border-color);
            display: flex;
            gap: 0.5rem;
        }
        
        .btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.85rem;
            border-radius: 50px;
        }
        
        .btn-outline {
            background: transparent;
            border: 2px solid var(--border-color);
            color: var(--brown-soft);
        }
        
        .btn-outline:hover {
            background: var(--primary-light);
            border-color: var(--primary);
            color: var(--primary-dark);
        }
        
        .btn-danger {
            background: transparent;
            border: 2px solid var(--error);
            color: var(--error);
        }
        
        .btn-danger:hover {
            background: var(--error);
            color: white;
        }
        
        .add-address-btn {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 1rem;
            padding: 2.5rem;
            background: linear-gradient(135deg, 
                rgba(255, 247, 237, 0.4) 0%, 
                rgba(255, 255, 255, 0.9) 50%,
                rgba(255, 247, 237, 0.4) 100%);
            border: 2px dashed var(--border-color);
            border-radius: var(--radius-lg);
            color: var(--text-muted);
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            min-height: 200px;
            position: relative;
            overflow: hidden;
        }
        
        .add-address-btn::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(201, 147, 102, 0.1) 0%, transparent 70%);
            transform: translate(-50%, -50%);
            transition: width 0.6s ease, height 0.6s ease;
        }
        
        .add-address-btn:hover {
            border-color: var(--primary);
            border-style: solid;
            color: var(--primary);
            background: linear-gradient(135deg, 
                rgba(255, 247, 237, 0.8) 0%, 
                rgba(255, 255, 255, 1) 50%,
                rgba(255, 247, 237, 0.6) 100%);
            transform: translateY(-4px);
            box-shadow: 0 8px 25px rgba(201, 147, 102, 0.15);
        }
        
        .add-address-btn:hover::before {
            width: 300px;
            height: 300px;
        }
        
        .add-address-btn i {
            font-size: 2.5rem;
            opacity: 0.7;
            position: relative;
            z-index: 1;
            transition: all 0.3s ease;
        }
        
        .add-address-btn:hover i {
            opacity: 1;
            transform: scale(1.1) rotate(90deg);
        }
        
        .add-address-btn span {
            font-weight: 500;
            position: relative;
            z-index: 1;
        }
        
        /* Change Password Styles */
        .password-card {
            background: var(--white);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-md);
            overflow: hidden;
        }
        
        .password-header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            padding: 2rem;
            text-align: center;
            position: relative;
        }
        
        .password-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 200px;
            height: 200px;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            border-radius: 50%;
        }
        
        .password-header i {
            font-size: 3rem;
            color: white;
            margin-bottom: 1rem;
            position: relative;
            z-index: 1;
        }
        
        .password-header h3 {
            color: white;
            font-family: 'Crimson Text', serif;
            font-size: 1.5rem;
            position: relative;
            z-index: 1;
        }
        
        .password-header p {
            color: rgba(255,255,255,0.85);
            font-size: 0.95rem;
            margin-top: 0.5rem;
            position: relative;
            z-index: 1;
        }
        
        .password-body {
            padding: 2rem;
        }
        
        .password-form .form-group {
            margin-bottom: 1.5rem;
        }
        
        .password-requirements {
            margin-top: 1.5rem;
            padding: 1.25rem;
            background: linear-gradient(135deg, var(--bg-cream) 0%, var(--primary-light) 100%);
            border-radius: var(--radius-md);
            border: 1px solid var(--primary-light);
        }
        
        .password-requirements h5 {
            font-size: 0.95rem;
            color: var(--brown-main);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .password-requirements h5 i {
            color: var(--primary);
        }
        
        .password-requirements ul {
            list-style: none;
            padding: 0;
            margin: 0;
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 0.75rem;
        }
        
        .password-requirements li {
            font-size: 0.85rem;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 0.75rem;
            background: white;
            border-radius: var(--radius-sm);
            transition: var(--transition);
        }
        
        .password-requirements li i {
            width: 18px;
        }
        
        .password-requirements li.valid {
            color: var(--success);
            background: rgba(39, 174, 96, 0.1);
        }
        
        .password-requirements li.valid i {
            color: var(--success);
        }
        
        .password-requirements li.invalid {
            color: var(--text-muted);
        }
        
        .password-input-wrapper {
            position: relative;
        }
        
        .password-toggle {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--text-muted);
            cursor: pointer;
            padding: 0.5rem;
            transition: var(--transition);
        }
        
        .password-toggle:hover {
            color: var(--primary);
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--text-muted);
        }
        
        .empty-state-icon {
            width: 100px;
            height: 100px;
            background: var(--primary-light);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
        }
        
        .empty-state-icon i {
            font-size: 2.5rem;
            color: var(--primary);
        }
        
        .empty-state h4 {
            color: var(--brown-main);
            font-family: 'Crimson Text', serif;
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
        }
        
        .empty-state p {
            color: var(--text-muted);
            margin-bottom: 1.5rem;
        }
        
        /* Wishlist Styles */
        .wishlist-container {
            min-height: 300px;
        }
        
        .wishlist-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-top: 1.5rem;
        }
        
        .wishlist-item {
            background: white;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            overflow: hidden;
            transition: var(--transition);
            position: relative;
        }
        
        .wishlist-item:hover {
            box-shadow: var(--shadow-md);
            transform: translateY(-5px);
        }
        
        .wishlist-item-image {
            position: relative;
            padding-top: 100%;
            overflow: hidden;
            background: var(--bg-light);
        }
        
        .wishlist-item-image img {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .wishlist-remove-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            width: 36px;
            height: 36px;
            background: white;
            border: none;
            border-radius: 50%;
            color: var(--error);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
            z-index: 10;
        }
        
        .wishlist-remove-btn:hover {
            background: var(--error);
            color: white;
            transform: scale(1.1);
        }
        
        .wishlist-item-content {
            padding: 1rem;
        }
        
        .wishlist-item-name {
            font-size: 0.95rem;
            font-weight: 500;
            color: var(--brown-main);
            margin-bottom: 0.5rem;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .wishlist-item-name a {
            color: inherit;
            text-decoration: none;
        }
        
        .wishlist-item-name a:hover {
            color: var(--primary);
        }
        
        .wishlist-item-price {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--primary);
            margin-bottom: 0.75rem;
        }
        
        .wishlist-item-actions {
            display: flex;
            gap: 0.5rem;
        }
        
        .wishlist-add-cart {
            flex: 1;
            padding: 0.6rem;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: var(--radius-sm);
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 500;
            transition: var(--transition);
        }
        
        .wishlist-add-cart:hover {
            background: var(--primary-dark);
        }
        
        .wishlist-add-cart:disabled {
            background: var(--text-muted);
            cursor: not-allowed;
            opacity: 0.6;
        }
        
        .wishlist-view-detail {
            padding: 0.6rem;
            background: white;
            color: var(--primary);
            border: 1px solid var(--primary);
            border-radius: var(--radius-sm);
            cursor: pointer;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: var(--transition);
        }
        
        .wishlist-view-detail:hover {
            background: var(--primary);
            color: white;
        }
        
        .loading-state {
            text-align: center;
            padding: 4rem 2rem;
        }
        
        .loading-spinner {
            width: 50px;
            height: 50px;
            border: 4px solid var(--primary-light);
            border-top-color: var(--primary);
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto 1rem;
        }
        
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        
        .loading-state p {
            color: var(--text-muted);
        }
        
        /* Responsive */
        @media (max-width: 992px) {
            .profile-grid {
                grid-template-columns: 1fr;
            }
            
            .sidebar {
                position: static;
                order: -1;
            }
            
            .sidebar-menu {
                display: flex;
                flex-wrap: wrap;
                gap: 0.5rem;
            }
            
            .sidebar-menu li {
                margin-bottom: 0;
            }
            
            .sidebar-menu a {
                padding: 0.75rem 1rem;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
            }
            
            .address-grid {
                grid-template-columns: 1fr;
            }
            
            .password-requirements ul {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 768px) {
            .page-hero {
                padding: 2rem 1.5rem;
            }
            
            .page-hero h1 {
                font-size: 1.75rem;
            }
            
            .main-container {
                padding: 1rem;
                margin-top: -1rem;
            }
            
            .order-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.75rem;
            }
            
            .order-footer {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }
            
            .order-footer .btn {
                width: 100%;
                justify-content: center;
            }
            
            .sidebar-user {
                display: none;
            }
        }
    </style>
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
    
    <!-- CSRF Token Helper -->
    <script src="${pageContext.request.contextPath}/fileJS/csrf-token.js"></script>
</head>
<body>
    <%@ include file="partials/header.jsp" %>
    <!-- Main Content -->
    <div class="main-container">
        <div class="profile-grid">
            <!-- Sidebar -->
            <aside class="sidebar">
                <div class="sidebar-user">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user.avatar}">
                            <img src="${sessionScope.user.avatar}" alt="Avatar" class="sidebar-avatar">
                        </c:when>
                        <c:otherwise>
                            <c:set var="displayName" value="${not empty sessionScope.user.fullname ? sessionScope.user.fullname : 'User'}" />
                            <img src="https://ui-avatars.com/api/?name=${displayName}&background=c99366&color=fff&size=80" alt="Avatar" class="sidebar-avatar">
                        </c:otherwise>
                    </c:choose>
                    <div class="sidebar-name">${not empty sessionScope.user.fullname ? sessionScope.user.fullname : 'Chưa cập nhật'}</div>
                    <div class="sidebar-email">${not empty sessionScope.user.email ? sessionScope.user.email : 'Chưa cập nhật'}</div>
                </div>
                <ul class="sidebar-menu">
                    <li>
                        <a href="#" onclick="showSection('profile'); return false;" class="active" data-section="profile">
                            <i class="fas fa-user"></i> Thông tin cá nhân
                        </a>
                    </li>
                    <li>
                        <a href="#" onclick="showSection('orders'); return false;" data-section="orders">
                            <i class="fas fa-shopping-bag"></i> Lịch sử đơn hàng
                        </a>
                    </li>
                    <li>
                        <a href="#" onclick="showSection('address'); return false;" data-section="address">
                            <i class="fas fa-map-marker-alt"></i> Sổ địa chỉ
                        </a>
                    </li>
                    <li>
                        <a href="#" onclick="showSection('wishlist'); return false;" data-section="wishlist">
                            <i class="fas fa-heart"></i> Yêu thích
                        </a>
                    </li>
                    <li>
                        <a href="#" onclick="showSection('password'); return false;" data-section="password">
                            <i class="fas fa-lock"></i> Đổi mật khẩu
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/logout" class="logout-link">
                            <i class="fas fa-sign-out-alt"></i> Đăng xuất
                        </a>
                    </li>
                </ul>
            </aside>
            
            <!-- Profile Card (Section 1: Thông tin cá nhân) -->
            <div class="content-section active" id="section-profile">
                <div class="content-card">
                    <div class="profile-header">
                        <div class="avatar-container">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user.avatar}">
                                    <img src="${sessionScope.user.avatar}" alt="Avatar" class="avatar" id="avatarImg">
                                </c:when>
                                <c:otherwise>
                                    <c:set var="profileName" value="${not empty sessionScope.user.fullname ? sessionScope.user.fullname : 'User'}" />
                                    <img src="https://ui-avatars.com/api/?name=${profileName}&background=c99366&color=fff&size=130" alt="Avatar" class="avatar" id="avatarImg">
                                </c:otherwise>
                            </c:choose>
                            <button class="avatar-edit" onclick="openModal('avatar')">
                                <i class="fas fa-camera"></i>
                            </button>
                        </div>
                        <h2 class="profile-name" id="displayName">${not empty sessionScope.user.fullname ? sessionScope.user.fullname : 'Chưa cập nhật'}</h2>
                        <p class="profile-email">${not empty sessionScope.user.email ? sessionScope.user.email : 'Chưa cập nhật'}</p>
                    </div>
                    
                    <div class="profile-body">
                        <h3 class="section-title"><i class="fas fa-id-card"></i> Thông tin cá nhân</h3>
                        
                        <div class="info-grid">
                            <!-- Họ tên -->
                            <div class="info-card">
                                <div class="info-card-header">
                                    <span class="info-card-label"><i class="fas fa-user"></i> Họ và tên</span>
                                    <button class="btn-edit-sm" onclick="openModal('fullname')">
                                        <i class="fas fa-pen"></i>
                                    </button>
                                </div>
                                <div class="info-card-value ${empty sessionScope.user.fullname ? 'placeholder' : ''}" id="fullnameValue">${not empty sessionScope.user.fullname ? sessionScope.user.fullname : 'Chưa cập nhật'}</div>
                            </div>
                            
                            <!-- Số điện thoại -->
                            <div class="info-card">
                                <div class="info-card-header">
                                    <span class="info-card-label"><i class="fas fa-phone"></i> Điện thoại</span>
                                    <button class="btn-edit-sm" onclick="openModal('phone')">
                                        <i class="fas fa-pen"></i>
                                    </button>
                                </div>
                                <div class="info-card-value ${empty sessionScope.user.phone ? 'placeholder' : ''}" id="phoneValue">
                                    ${not empty sessionScope.user.phone ? sessionScope.user.phone : 'Chưa cập nhật'}
                                </div>
                            </div>
                            
                            <!-- Giới tính -->
                            <div class="info-card">
                                <div class="info-card-header">
                                    <span class="info-card-label"><i class="fas fa-venus-mars"></i> Giới tính</span>
                                    <button class="btn-edit-sm" onclick="openModal('gender')">
                                        <i class="fas fa-pen"></i>
                                    </button>
                                </div>
                                <div class="info-card-value ${empty sessionScope.user.gender ? 'placeholder' : ''}" id="genderValue">
                                    <c:choose>
                                        <c:when test="${sessionScope.user.gender == 'male'}">Nam</c:when>
                                        <c:when test="${sessionScope.user.gender == 'female'}">Nữ</c:when>
                                        <c:when test="${sessionScope.user.gender == 'other'}">Khác</c:when>
                                        <c:otherwise>Chưa cập nhật</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            
                            <!-- Ngày sinh -->
                            <div class="info-card">
                                <div class="info-card-header">
                                    <span class="info-card-label"><i class="fas fa-birthday-cake"></i> Ngày sinh</span>
                                    <button class="btn-edit-sm" onclick="openModal('birthday')">
                                        <i class="fas fa-pen"></i>
                                    </button>
                                </div>
                                <div class="info-card-value ${empty sessionScope.user.birthday ? 'placeholder' : ''}" id="birthdayValue">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.user.birthday}">
                                            <fmt:formatDate value="${sessionScope.user.birthday}" pattern="dd/MM/yyyy"/>
                                        </c:when>
                                        <c:otherwise>Chưa cập nhật</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            
                            <!-- Email (locked) -->
                            <div class="info-row-locked">
                                <div>
                                    <span class="info-card-label"><i class="fas fa-envelope"></i> Email</span>
                                    <div class="info-card-value">${not empty sessionScope.user.email ? sessionScope.user.email : 'Chưa cập nhật'}</div>
                                </div>
                                <span class="locked-badge"><i class="fas fa-lock"></i> Không thể thay đổi</span>
                            </div>
                        </div>
                        
                        <!-- Bio Section -->
                        <div class="bio-section">
                            <div class="bio-header">
                                <div class="bio-title">
                                    <i class="fas fa-quote-left"></i> Giới thiệu bản thân
                                </div>
                                <button class="btn-edit-sm" onclick="openModal('bio')">
                                    <i class="fas fa-pen"></i>
                                </button>
                            </div>
                            <p class="bio-content ${empty sessionScope.user.bio ? 'placeholder' : ''}" id="bioValue">
                                ${not empty sessionScope.user.bio ? sessionScope.user.bio : 'Hãy viết vài dòng giới thiệu về bạn...'}
                            </p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Section 1.5: Wishlist -->
            <div class="content-section" id="section-wishlist">
                <div class="content-card">
                    <div class="profile-body">
                        <h3 class="section-title"><i class="fas fa-heart"></i> Danh sách yêu thích</h3>
                        
                        <div class="wishlist-container" id="wishlistContainer">
                            <div class="loading-state" id="wishlistLoading">
                                <div class="loading-spinner"></div>
                                <p>Đang tải danh sách yêu thích...</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Section 2: Lịch sử đơn hàng -->
            <div class="content-section" id="section-orders">
                <div class="content-card">
                    <div class="profile-body">
                        <h3 class="section-title"><i class="fas fa-shopping-bag"></i> Lịch sử đơn hàng</h3>
                        <div class="orders-filter">
                            <button class="filter-btn active" data-status="all" onclick="filterOrders('all', this)">Tất cả</button>
                            <button class="filter-btn" data-status="pending" onclick="filterOrders('pending', this)">Chờ xác nhận</button>
                            <button class="filter-btn" data-status="confirmed" onclick="filterOrders('confirmed', this)">Đã xác nhận</button>
                            <button class="filter-btn" data-status="shipping" onclick="filterOrders('shipping', this)">Đang giao</button>
                            <button class="filter-btn" data-status="delivered" onclick="filterOrders('delivered', this)">Đã giao</button>
                            <button class="filter-btn" data-status="cancelled" onclick="filterOrders('cancelled', this)">Đã hủy</button>
                        </div>
                        <div id="orderHistoryContent">
                            <!-- Loading state -->
                            <div class="empty-state" id="ordersLoading">
                                <div class="empty-state-icon">
                                    <i class="fas fa-spinner fa-spin"></i>
                                </div>
                                <p>Đang tải...</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Section 3: Sổ địa chỉ -->
            <div class="content-section" id="section-address">
                <div class="content-card">
                    <div class="profile-body">
                        <h3 class="section-title"><i class="fas fa-map-marker-alt"></i> Sổ địa chỉ</h3>
                        <div class="address-grid" id="addressBookContent">
                            <!-- Address cards will be loaded here -->
                        </div>
                        <div class="add-address-btn" onclick="openAddAddressModal()" style="margin-top: 1.25rem;">
                            <i class="fas fa-plus-circle"></i>
                            <span>Thêm địa chỉ mới</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Section 4: Đổi mật khẩu -->
            <div class="content-section" id="section-password">
                <div class="password-card">
                    <div class="password-header">
                        <i class="fas fa-shield-alt"></i>
                        <h3>Bảo mật tài khoản</h3>
                        <p>Cập nhật mật khẩu để bảo vệ tài khoản của bạn</p>
                    </div>
                    <div class="password-body">
                        <form class="password-form" onsubmit="changePassword(event)">
                            <div class="form-group">
                                <label class="form-label"><i class="fas fa-key"></i> Mật khẩu hiện tại</label>
                                <div class="password-input-wrapper">
                                    <input type="password" class="form-control" id="currentPassword" placeholder="Nhập mật khẩu hiện tại" required>
                                    <button type="button" class="password-toggle" onclick="togglePassword('currentPassword')">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label"><i class="fas fa-lock"></i> Mật khẩu mới</label>
                                <div class="password-input-wrapper">
                                    <input type="password" class="form-control" id="newPassword" placeholder="Nhập mật khẩu mới" required oninput="checkPasswordStrength()">
                                    <button type="button" class="password-toggle" onclick="togglePassword('newPassword')">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label"><i class="fas fa-check-circle"></i> Xác nhận mật khẩu mới</label>
                                <div class="password-input-wrapper">
                                    <input type="password" class="form-control" id="confirmPassword" placeholder="Nhập lại mật khẩu mới" required>
                                    <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="password-requirements">
                                <h5><i class="fas fa-info-circle"></i> Yêu cầu mật khẩu:</h5>
                                <ul>
                                    <li id="req-length"><i class="fas fa-circle"></i> Ít nhất 8 ký tự</li>
                                    <li id="req-upper"><i class="fas fa-circle"></i> Ít nhất 1 chữ hoa</li>
                                    <li id="req-lower"><i class="fas fa-circle"></i> Ít nhất 1 chữ thường</li>
                                    <li id="req-number"><i class="fas fa-circle"></i> Ít nhất 1 số</li>
                                </ul>
                            </div>
                            <div style="margin-top: 2rem;">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Đổi mật khẩu
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Modal Overlay -->
    <div class="modal-overlay" id="modalOverlay">
        <div class="modal" id="editModal">
            <div class="modal-header">
                <h4 class="modal-title" id="modalTitle">Chỉnh sửa</h4>
                <button class="modal-close" onclick="closeModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body" id="modalBody">
                <!-- Dynamic content -->
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closeModal()">Hủy</button>
                <button class="btn btn-primary" onclick="saveChanges()">
                    <i class="fas fa-save"></i> Lưu thay đổi
                </button>
            </div>
        </div>
    </div>
    
    <!-- Order Detail Modal -->
    <div id="orderDetailOverlay" onclick="if(event.target===this) closeOrderDetailModal()">
        <div class="order-detail-modal">
            <div class="order-detail-header">
                <h3><i class="fas fa-receipt"></i> Chi tiết đơn hàng</h3>
                <button class="order-detail-close" onclick="closeOrderDetailModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="order-detail-body" id="orderDetailContent">
                <!-- Content loaded dynamically -->
            </div>
        </div>
    </div>
    
    <!-- Toast Container -->
    <div class="toast-container" id="toastContainer"></div>
    
    <script>
        let currentField = '';
        const contextPath = '${pageContext.request.contextPath}';
        
        // ==================== Section Navigation ====================
        function showSection(sectionName) {
            // Hide all sections
            document.querySelectorAll('.content-section').forEach(section => {
                section.classList.remove('active');
            });
            
            // Show selected section
            document.getElementById('section-' + sectionName).classList.add('active');
            
            // Update menu active state
            document.querySelectorAll('.sidebar-menu a').forEach(link => {
                link.classList.remove('active');
            });
            document.querySelector('.sidebar-menu a[data-section="' + sectionName + '"]').classList.add('active');
            
            // Load content for specific sections
            if (sectionName === 'orders') {
                loadOrderHistory();
            } else if (sectionName === 'address') {
                loadAddressBook();
            } else if (sectionName === 'wishlist') {
                loadWishlist();
            }
        }
        
        // ==================== Order History ====================
        let allOrders = [];
        
        function loadOrderHistory() {
            const container = document.getElementById('orderHistoryContent');
            
            // Show loading
            container.innerHTML = '<div class="empty-state"><i class="fas fa-spinner fa-spin"></i><p>Đang tải...</p></div>';
            
            fetch(contextPath + '/orders/detail/0')
                .then(response => response.json())
                .catch(() => {
                    // Fallback: redirect to orders page to get data
                    return fetch(contextPath + '/orders', {
                        headers: { 'Accept': 'text/html' }
                    }).then(() => ({ success: false }));
                })
                .then(data => {
                    // Load real orders via a different approach
                    loadOrdersFromPage();
                })
                .catch(error => {
                    console.error('Error loading orders:', error);
                    loadOrdersFromPage();
                });
        }
        
        function loadOrdersFromPage() {
            // Use AJAX to load orders list
            const container = document.getElementById('orderHistoryContent');
            
            fetch(contextPath + '/api/orders/list')
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.orders && data.orders.length > 0) {
                        allOrders = data.orders;
                        renderOrders(allOrders);
                    } else {
                        container.innerHTML = renderEmptyOrders();
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    container.innerHTML = renderEmptyOrders();
                });
        }
        
        function renderOrders(orders) {
            const container = document.getElementById('orderHistoryContent');
            
            if (!orders || orders.length === 0) {
                container.innerHTML = renderEmptyOrders();
                return;
            }
            
            let html = '';
            orders.forEach(order => {
                html += renderOrderCard(order);
            });
            container.innerHTML = html;
        }
        
        function filterOrders(status, btn) {
            // Update active button
            document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
            if (btn) btn.classList.add('active');
            
            // Filter orders
            if (status === 'all') {
                renderOrders(allOrders);
            } else {
                const filtered = allOrders.filter(o => o.orderStatus === status);
                renderOrders(filtered);
            }
        }
        
        function renderOrderCard(order) {
            const statusMap = {
                'pending': { text: 'Chờ xác nhận', class: 'pending' },
                'confirmed': { text: 'Đã xác nhận', class: 'processing' },
                'shipping': { text: 'Đang giao', class: 'shipped' },
                'delivered': { text: 'Đã giao', class: 'delivered' },
                'cancelled': { text: 'Đã hủy', class: 'cancelled' }
            };
            const status = statusMap[order.orderStatus] || { text: order.orderStatus, class: 'pending' };
            
            let itemsHtml = '';
            const items = order.orderItems || [];
            items.forEach(item => {
                const imgSrc = item.productImage || (contextPath + '/view/default-product.png');
                itemsHtml += `
                    <div class="order-item">
                        <img src="\${imgSrc}" alt="\${item.productName || 'Sản phẩm'}" class="order-item-img">
                        <div class="order-item-info">
                            <div class="order-item-name">\${item.productName || 'Sản phẩm'}</div>
                            <div class="order-item-qty">x\${item.quantity}</div>
                        </div>
                        <div class="order-item-price">\${formatCurrency(item.price || 0)}</div>
                    </div>
                `;
            });
            
            // Format date
            let dateStr = '';
            if (order.createdAt) {
                const date = new Date(order.createdAt);
                dateStr = date.toLocaleDateString('vi-VN') + ' ' + date.toLocaleTimeString('vi-VN', {hour: '2-digit', minute:'2-digit'});
            }
            
            // Actions based on status
            let actionsHtml = `
                <button class="btn btn-outline btn-sm" onclick="viewOrderDetail(\${order.id})">
                    <i class="fas fa-eye"></i> Chi tiết
                </button>
            `;
            
            if (order.orderStatus === 'pending') {
                actionsHtml += `
                    <button class="btn btn-danger btn-sm" onclick="cancelOrder(\${order.id})">
                        <i class="fas fa-times"></i> Hủy
                    </button>
                `;
            }
            
            if (order.orderStatus === 'delivered' || order.orderStatus === 'cancelled') {
                actionsHtml += `
                    <button class="btn btn-primary btn-sm" onclick="reorder(\${order.id})">
                        <i class="fas fa-redo"></i> Mua lại
                    </button>
                `;
            }
            
            return `
                <div class="order-card" data-status="\${order.orderStatus}">
                    <div class="order-header">
                        <div>
                            <span class="order-id">Đơn hàng #\${order.orderCode || order.id}</span>
                            <span class="order-date">\${dateStr}</span>
                        </div>
                        <span class="order-status \${status.class}">\${status.text}</span>
                    </div>
                    <div class="order-body">
                        \${itemsHtml || '<p style="color: #999;">Không có sản phẩm</p>'}
                    </div>
                    <div class="order-footer">
                        <div class="order-total">Tổng cộng: <span>\${formatCurrency(order.total || 0)}</span></div>
                        <div>\${actionsHtml}</div>
                    </div>
                </div>
            `;
        }
        
        function renderEmptyOrders() {
            return `
                <div class="empty-state">
                    <i class="fas fa-shopping-bag"></i>
                    <h4>Chưa có đơn hàng nào</h4>
                    <p>Hãy mua sắm để có đơn hàng đầu tiên!</p>
                    <a href="\${contextPath}/view/product.jsp" class="btn btn-primary" style="margin-top: 1rem;">
                        <i class="fas fa-shopping-cart"></i> Mua sắm ngay
                    </a>
                </div>
            `;
        }
        
        function viewOrderDetail(orderId) {
            // Show order detail modal
            document.getElementById('orderDetailOverlay').classList.add('show');
            document.getElementById('orderDetailContent').innerHTML = 
                '<div style="text-align: center; padding: 2rem;">' +
                '<i class="fas fa-spinner fa-spin" style="font-size: 2rem; color: var(--primary);"></i>' +
                '<p style="margin-top: 1rem;">Đang tải...</p>' +
                '</div>';
            
            fetch(contextPath + '/orders/detail/' + orderId)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const order = data.order;
                        let itemsHtml = '';
                        if (order.orderItems && order.orderItems.length > 0) {
                            order.orderItems.forEach(item => {
                                const imgSrc = item.productImage || (contextPath + '/view/default-product.png');
                                itemsHtml += '<div class="order-detail-item">' +
                                    '<div class="item-image"><img src="' + imgSrc + '" alt="' + (item.productName || 'Sản phẩm') + '"></div>' +
                                    '<div class="item-info">' +
                                    '<div class="item-name">' + (item.productName || 'Sản phẩm') + '</div>' +
                                    '<div class="item-quantity">x' + item.quantity + '</div>' +
                                    '</div>' +
                                    '<div class="item-price">' + formatCurrency(item.total || item.price * item.quantity) + '</div>' +
                                    '</div>';
                            });
                        }
                        
                        // Format date
                        let dateStr = '';
                        if (order.createdAt) {
                            const date = new Date(order.createdAt);
                            dateStr = date.toLocaleDateString('vi-VN') + ' ' + date.toLocaleTimeString('vi-VN', {hour: '2-digit', minute:'2-digit'});
                        }
                        
                        // Status text
                        const statusMap = {
                            'pending': 'Chờ xác nhận',
                            'confirmed': 'Đã xác nhận',
                            'shipping': 'Đang giao',
                            'delivered': 'Đã giao',
                            'cancelled': 'Đã hủy'
                        };
                        
                        document.getElementById('orderDetailContent').innerHTML = 
                            '<div class="order-detail-info">' +
                            '<p><strong>Mã đơn hàng:</strong> ' + (order.orderCode || 'DH' + order.id) + '</p>' +
                            '<p><strong>Ngày đặt:</strong> ' + dateStr + '</p>' +
                            '<p><strong>Trạng thái:</strong> <span style="color: var(--primary);">' + (statusMap[order.orderStatus] || order.orderStatus) + '</span></p>' +
                            '<p><strong>Người nhận:</strong> ' + (order.receiverName || 'N/A') + '</p>' +
                            '<p><strong>Số điện thoại:</strong> ' + (order.receiverPhone || 'N/A') + '</p>' +
                            '<p><strong>Địa chỉ:</strong> ' + (order.shippingAddress || 'N/A') + '</p>' +
                            (order.note ? '<p><strong>Ghi chú:</strong> ' + order.note + '</p>' : '') +
                            '<hr style="margin: 1rem 0; border-color: var(--border-color);">' +
                            '<div class="order-detail-items">' + itemsHtml + '</div>' +
                            '<hr style="margin: 1rem 0; border-color: var(--border-color);">' +
                            '<p><strong>Tạm tính:</strong> ' + formatCurrency(order.subtotal || 0) + '</p>' +
                            '<p><strong>Phí vận chuyển:</strong> ' + formatCurrency(order.shippingFee || 0) + '</p>' +
                            (order.discount > 0 ? '<p><strong>Giảm giá:</strong> -' + formatCurrency(order.discount) + '</p>' : '') +
                            '<p style="font-size: 1.1rem;"><strong>Tổng cộng:</strong> <span style="color: var(--primary-dark); font-weight: 700;">' + formatCurrency(order.total || 0) + '</span></p>' +
                            '</div>';
                    } else {
                        document.getElementById('orderDetailContent').innerHTML = 
                            '<p style="text-align: center; color: var(--error);">' + (data.message || 'Không thể tải chi tiết đơn hàng') + '</p>';
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('orderDetailContent').innerHTML = 
                        '<p style="text-align: center; color: var(--error);">Có lỗi xảy ra khi tải dữ liệu</p>';
                });
        }
        
        function closeOrderDetailModal() {
            document.getElementById('orderDetailOverlay').classList.remove('show');
        }
        
        function cancelOrder(orderId) {
            if (!confirm('Bạn có chắc chắn muốn hủy đơn hàng này?')) {
                return;
            }
            
            fetch(contextPath + '/orders/cancel/' + orderId, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'reason=Khách hàng hủy đơn'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast(data.message, 'success');
                    loadOrdersFromPage(); // Reload orders
                } else {
                    showToast(data.message || 'Không thể hủy đơn hàng', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('Lỗi kết nối', 'error');
            });
        }
        
        function reorder(orderId) {
            fetch(contextPath + '/orders/reorder/' + orderId, {
                method: 'POST'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast(data.message, 'success');
                    // Update cart count
                    if (data.cartCount) {
                        updateCartCount(data.cartCount);
                    }
                } else {
                    showToast(data.message || 'Không thể mua lại', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('Lỗi kết nối', 'error');
            });
        }
        
        function updateCartCount(count) {
            const badge = document.querySelector('.cart-badge, .cart-count');
            if (badge) {
                badge.textContent = count;
            }
        }

        // ==================== Address Book ====================
        let addresses = [];
        
        function loadAddressBook() {
            const container = document.getElementById('addressBookContent');
            
            // Show loading
            container.innerHTML = '<div class="empty-state"><i class="fas fa-spinner fa-spin"></i><p>Đang tải...</p></div>';
            
            fetch(contextPath + '/address/list')
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.addresses && data.addresses.length > 0) {
                        addresses = data.addresses;
                        renderAddressBook();
                    } else {
                        addresses = [];
                        container.innerHTML = renderEmptyAddresses();
                    }
                })
                .catch(error => {
                    console.error('Error loading addresses:', error);
                    container.innerHTML = renderEmptyAddresses();
                });
        }
        
        function renderAddressBook() {
            const container = document.getElementById('addressBookContent');
            let html = '';
            
            addresses.forEach((address, index) => {
                const fullAddress = [
                    address.addressDetail,
                    address.ward,
                    address.district,
                    address.province
                ].filter(x => x && x.trim()).join(', ');
                
                html += `
                    <div class="address-card \${address.default ? 'default' : ''}" data-id="\${address.id}">
                        \${address.default ? '<span class="address-default-badge">Mặc định</span>' : ''}
                        <div class="address-name">\${address.receiverName}</div>
                        <div class="address-phone"><i class="fas fa-phone"></i> \${address.phone}</div>
                        <div class="address-detail">\${fullAddress}</div>
                        \${address.note ? '<div class="address-note"><i class="fas fa-sticky-note"></i> ' + address.note + '</div>' : ''}
                        <div class="address-actions">
                            <button class="btn btn-outline btn-sm" onclick="editAddress(\${index})">
                                <i class="fas fa-edit"></i> Sửa
                            </button>
                            \${!address.default ? '<button class="btn btn-outline btn-sm" onclick="setDefaultAddress(' + address.id + ')"><i class="fas fa-check"></i> Đặt mặc định</button>' : ''}
                            <button class="btn btn-danger btn-sm" onclick="deleteAddress(\${address.id})">
                                <i class="fas fa-trash"></i> Xóa
                            </button>
                        </div>
                    </div>
                `;
            });
            
            container.innerHTML = html;
        }
        
        function renderEmptyAddresses() {
            return `
                <div class="empty-state">
                    <i class="fas fa-map-marker-alt"></i>
                    <h4>Chưa có địa chỉ nào</h4>
                    <p>Thêm địa chỉ để dễ dàng đặt hàng</p>
                </div>
            `;
        }
        
        function editAddress(index) {
            const address = addresses[index];
            currentEditingAddressId = address.id;
            
            // Fill form
            document.getElementById('modalTitle').innerHTML = '<i class="fas fa-edit"></i> Chỉnh sửa địa chỉ';
            document.getElementById('modalBody').innerHTML = getAddressFormHtml(address);
            
            // Show modal footer with save button - set onclick để submit form
            const modalFooter = document.querySelector('#editModal .modal-footer');
            if (modalFooter) {
                modalFooter.style.display = 'flex';
                const saveBtn = modalFooter.querySelector('.btn-primary');
                if (saveBtn) {
                    saveBtn.onclick = function() {
                        const form = document.getElementById('addressForm');
                        if (form) {
                            form.requestSubmit();
                        }
                    };
                }
            }
            
            document.getElementById('modalOverlay').classList.add('active');
        }
        
        function openAddAddressModal() {
            currentEditingAddressId = null;
            
            document.getElementById('modalTitle').innerHTML = '<i class="fas fa-plus"></i> Thêm địa chỉ mới';
            document.getElementById('modalBody').innerHTML = getAddressFormHtml(null);
            
            // Show modal footer with save button - thay đổi onclick để gọi saveAddress
            const modalFooter = document.querySelector('#editModal .modal-footer');
            console.log('Modal footer found:', modalFooter);
            
            if (modalFooter) {
                // Đảm bảo hiển thị
                modalFooter.style.display = 'flex';
                modalFooter.style.visibility = 'visible';
                modalFooter.style.opacity = '1';
                
                const saveBtn = modalFooter.querySelector('.btn-primary');
                console.log('Save button found:', saveBtn);
                
                if (saveBtn) {
                    // Thay đổi onclick để submit form thay vì gọi saveChanges
                    saveBtn.onclick = function() {
                        console.log('Save button clicked');
                        const form = document.getElementById('addressForm');
                        if (form) {
                            console.log('Submitting form...');
                            form.requestSubmit();
                        } else {
                            console.error('Form not found!');
                        }
                    };
                }
            } else {
                console.error('Modal footer not found!');
            }
            
            document.getElementById('modalOverlay').classList.add('active');
        }
        
        function getAddressFormHtml(address) {
            return `
                <form id="addressForm" onsubmit="saveAddress(event)">
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label">Tên người nhận <span style="color: var(--error);">*</span></label>
                            <input type="text" class="form-control" id="addr_receiverName" 
                                value="\${address ? address.receiverName : ''}" placeholder="Nhập tên người nhận" required>
                        </div>
                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label">Số điện thoại <span style="color: var(--error);">*</span></label>
                            <input type="tel" class="form-control" id="addr_phone" 
                                value="\${address ? address.phone : ''}" placeholder="Nhập số điện thoại" required>
                        </div>
                    </div>
                    <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 0.75rem;">
                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label">Tỉnh/Thành</label>
                            <input type="text" class="form-control" id="addr_province" 
                                value="\${address ? (address.province || '') : ''}" placeholder="Tỉnh/Thành">
                        </div>
                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label">Quận/Huyện</label>
                            <input type="text" class="form-control" id="addr_district" 
                                value="\${address ? (address.district || '') : ''}" placeholder="Quận/Huyện">
                        </div>
                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label">Phường/Xã</label>
                            <input type="text" class="form-control" id="addr_ward" 
                                value="\${address ? (address.ward || '') : ''}" placeholder="Phường/Xã">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Địa chỉ chi tiết <span style="color: var(--error);">*</span></label>
                        <input type="text" class="form-control" id="addr_detail" 
                            value="\${address ? address.addressDetail : ''}" placeholder="Số nhà, tên đường..." required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Ghi chú</label>
                        <textarea class="form-control" id="addr_note" rows="2" 
                            placeholder="Ghi chú thêm (không bắt buộc)">\${address ? (address.note || '') : ''}</textarea>
                    </div>
                    <div class="form-group" style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0;">
                        <input type="checkbox" id="addr_isDefault" style="width: auto !important; margin: 0;" \${address && address.default ? 'checked' : ''}>
                        <label for="addr_isDefault" style="margin: 0; cursor: pointer; font-weight: 500;">Đặt làm địa chỉ mặc định</label>
                    </div>
                </form>
            `;
        }
        
        let currentEditingAddressId = null;
        
        function saveAddress(event) {
            if (event) event.preventDefault();
            
            const formData = new URLSearchParams();
            formData.append('receiverName', document.getElementById('addr_receiverName').value);
            formData.append('phone', document.getElementById('addr_phone').value);
            formData.append('province', document.getElementById('addr_province').value);
            formData.append('district', document.getElementById('addr_district').value);
            formData.append('ward', document.getElementById('addr_ward').value);
            formData.append('addressDetail', document.getElementById('addr_detail').value);
            formData.append('note', document.getElementById('addr_note').value);
            formData.append('isDefault', document.getElementById('addr_isDefault').checked);
            
            let url = contextPath + '/address/add';
            if (currentEditingAddressId) {
                url = contextPath + '/address/update';
                formData.append('id', currentEditingAddressId);
            }
            
            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: formData.toString()
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast(data.message, 'success');
                    closeModal();
                    loadAddressBook();
                } else {
                    showToast(data.message || 'Có lỗi xảy ra', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('Có lỗi xảy ra', 'error');
            });
        }
        
        function setDefaultAddress(addressId) {
            fetch(contextPath + '/address/set-default/' + addressId, {
                method: 'POST'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast(data.message, 'success');
                    loadAddressBook();
                } else {
                    showToast(data.message || 'Có lỗi xảy ra', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('Có lỗi xảy ra', 'error');
            });
        }
        
        function deleteAddress(addressId) {
            if (!confirm('Bạn có chắc muốn xóa địa chỉ này?')) {
                return;
            }
            
            fetch(contextPath + '/address/delete/' + addressId, {
                method: 'POST'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast('Đã xóa địa chỉ', 'success');
                    loadAddressBook();
                } else {
                    showToast(data.message || 'Có lỗi xảy ra', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('Có lỗi xảy ra', 'error');
            });
        }
        
        // ==================== Change Password ====================
        function togglePassword(inputId) {
            const input = document.getElementById(inputId);
            const icon = input.nextElementSibling.querySelector('i');
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }
        
        function checkPasswordStrength() {
            const password = document.getElementById('newPassword').value;
            
            // Check length
            const lengthValid = password.length >= 8;
            updateRequirement('req-length', lengthValid);
            
            // Check uppercase
            const upperValid = /[A-Z]/.test(password);
            updateRequirement('req-upper', upperValid);
            
            // Check lowercase
            const lowerValid = /[a-z]/.test(password);
            updateRequirement('req-lower', lowerValid);
            
            // Check number
            const numberValid = /[0-9]/.test(password);
            updateRequirement('req-number', numberValid);
        }
        
        function updateRequirement(id, isValid) {
            const element = document.getElementById(id);
            const icon = element.querySelector('i');
            
            if (isValid) {
                element.classList.add('valid');
                element.classList.remove('invalid');
                icon.classList.remove('fa-circle');
                icon.classList.add('fa-check-circle');
            } else {
                element.classList.remove('valid');
                element.classList.add('invalid');
                icon.classList.remove('fa-check-circle');
                icon.classList.add('fa-circle');
            }
        }
        
        function changePassword(event) {
            event.preventDefault();
            
            const currentPassword = document.getElementById('currentPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            // Validation
            if (newPassword.length < 8) {
                showToast('Mật khẩu phải có ít nhất 8 ký tự', 'error');
                return;
            }
            
            if (!/[A-Z]/.test(newPassword)) {
                showToast('Mật khẩu phải có ít nhất 1 chữ hoa', 'error');
                return;
            }
            
            if (!/[a-z]/.test(newPassword)) {
                showToast('Mật khẩu phải có ít nhất 1 chữ thường', 'error');
                return;
            }
            
            if (!/[0-9]/.test(newPassword)) {
                showToast('Mật khẩu phải có ít nhất 1 số', 'error');
                return;
            }
            
            if (newPassword !== confirmPassword) {
                showToast('Mật khẩu xác nhận không khớp', 'error');
                return;
            }
            
            // Send request
            const formData = new URLSearchParams();
            formData.append('currentPassword', currentPassword);
            formData.append('newPassword', newPassword);
            
            fetch(contextPath + '/profile/changePassword', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: formData.toString()
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast('Đổi mật khẩu thành công!', 'success');
                    // Clear form
                    document.getElementById('currentPassword').value = '';
                    document.getElementById('newPassword').value = '';
                    document.getElementById('confirmPassword').value = '';
                    checkPasswordStrength();
                } else {
                    showToast(data.message || 'Đổi mật khẩu thất bại', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('Có lỗi xảy ra, vui lòng thử lại', 'error');
            });
        }
        
        // ==================== Utility Functions ====================
        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
        }
        
        // Modal templates
        const modalTemplates = {
            fullname: {
                title: 'Chỉnh sửa họ tên',
                content: `
                    <div class="form-group">
                        <label class="form-label">Họ và tên</label>
                        <input type="text" class="form-control" id="inputFullname" 
                               value="${sessionScope.user.fullname != null ? sessionScope.user.fullname : ''}" 
                               placeholder="Nhập họ và tên">
                    </div>
                `
            },
            phone: {
                title: 'Chỉnh sửa số điện thoại',
                content: `
                    <div class="form-group">
                        <label class="form-label">Số điện thoại</label>
                        <input type="tel" class="form-control" id="inputPhone" 
                               value="${sessionScope.user.phone != null ? sessionScope.user.phone : ''}" 
                               placeholder="Nhập số điện thoại">
                    </div>
                `
            },
            gender: {
                title: 'Chỉnh sửa giới tính',
                content: `
                    <div class="form-group">
                        <label class="form-label">Giới tính</label>
                        <select class="form-select" id="inputGender">
                            <option value="">-- Chọn giới tính --</option>
                            <option value="male" ${sessionScope.user.gender == 'male' ? 'selected' : ''}>Nam</option>
                            <option value="female" ${sessionScope.user.gender == 'female' ? 'selected' : ''}>Nữ</option>
                            <option value="other" ${sessionScope.user.gender == 'other' ? 'selected' : ''}>Khác</option>
                        </select>
                    </div>
                `
            },
            birthday: {
                title: 'Chỉnh sửa ngày sinh',
                content: `
                    <div class="form-group">
                        <label class="form-label">Ngày sinh</label>
                        <input type="date" class="form-control" id="inputBirthday" 
                               value="${sessionScope.user.birthday != null ? sessionScope.user.birthday : ''}">
                    </div>
                `
            },
            bio: {
                title: 'Chỉnh sửa giới thiệu',
                content: `
                    <div class="form-group">
                        <label class="form-label">Giới thiệu bản thân</label>
                        <textarea class="form-control" id="inputBio" rows="4" 
                                  placeholder="Viết vài dòng về bạn...">${sessionScope.user.bio != null ? sessionScope.user.bio : ''}</textarea>
                    </div>
                `
            },
            avatar: {
                title: 'Thay đổi ảnh đại diện',
                content: `
                    <div class="form-group">
                        <label class="form-label">URL ảnh đại diện</label>
                        <input type="url" class="form-control" id="inputAvatar" 
                               value="${sessionScope.user.avatar != null ? sessionScope.user.avatar : ''}" 
                               placeholder="Nhập URL ảnh">
                        <small style="color: var(--text-muted); margin-top: 0.5rem; display: block;">
                            Bạn có thể sử dụng URL ảnh từ các dịch vụ như Imgur, Cloudinary,...
                        </small>
                    </div>
                `
            },
            newAddress: {
                title: 'Thêm địa chỉ mới',
                content: `
                    <div class="form-group">
                        <label class="form-label">Họ tên người nhận</label>
                        <input type="text" class="form-control" id="inputAddressName" placeholder="Nhập họ tên">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Số điện thoại</label>
                        <input type="tel" class="form-control" id="inputAddressPhone" placeholder="Nhập số điện thoại">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Tỉnh/Thành phố</label>
                        <input type="text" class="form-control" id="inputCity" placeholder="Nhập tỉnh/thành phố">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Quận/Huyện</label>
                        <input type="text" class="form-control" id="inputDistrict" placeholder="Nhập quận/huyện">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Phường/Xã</label>
                        <input type="text" class="form-control" id="inputWard" placeholder="Nhập phường/xã">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Địa chỉ chi tiết</label>
                        <input type="text" class="form-control" id="inputAddressDetail" placeholder="Số nhà, tên đường...">
                    </div>
                    <div class="form-group">
                        <label style="display: flex; align-items: center; gap: 0.5rem; cursor: pointer;">
                            <input type="checkbox" id="inputSetDefault">
                            <span>Đặt làm địa chỉ mặc định</span>
                        </label>
                    </div>
                `,
                saveAction: 'saveNewAddress'
            }
        };
        
        function openModal(field, data) {
            currentField = field;
            const template = modalTemplates[field];
            if (template) {
                document.getElementById('modalTitle').textContent = template.title;
                document.getElementById('modalBody').innerHTML = template.content;
                
                // Update modal footer based on template
                const saveBtn = document.querySelector('.modal-footer .btn-primary');
                if (template.saveAction) {
                    saveBtn.setAttribute('onclick', template.saveAction + '()');
                } else {
                    saveBtn.setAttribute('onclick', 'saveChanges()');
                }
                
                document.getElementById('modalOverlay').classList.add('active');
                
                // If editing address, populate data
                if (field === 'editAddress' && data) {
                    document.getElementById('inputAddressName').value = data.name || '';
                    document.getElementById('inputAddressPhone').value = data.phone || '';
                    document.getElementById('inputCity').value = data.city || '';
                    document.getElementById('inputDistrict').value = data.district || '';
                    document.getElementById('inputWard').value = data.ward || '';
                    document.getElementById('inputAddressDetail').value = data.detail || '';
                    document.getElementById('inputSetDefault').checked = data.isDefault || false;
                }
            }
        }
        
        function closeModal() {
            document.getElementById('modalOverlay').classList.remove('active');
            currentField = '';
            currentEditingAddressId = null;
        }
        
        function saveChanges() {
            // Check if this is an address form
            const addressForm = document.getElementById('addressForm');
            if (addressForm) {
                saveAddress();
                return;
            }
            
            let value = '';
            
            switch (currentField) {
                case 'fullname':
                    value = document.getElementById('inputFullname').value.trim();
                    if (!value) {
                        showToast('Vui lòng nhập họ tên', 'error');
                        return;
                    }
                    break;
                case 'phone':
                    value = document.getElementById('inputPhone').value.trim();
                    break;
                case 'gender':
                    value = document.getElementById('inputGender').value.trim();
                    if (!value) {
                        showToast('Vui lòng chọn giới tính', 'error');
                        return;
                    }
                    break;
                case 'birthday':
                    value = document.getElementById('inputBirthday').value;
                    break;
                case 'bio':
                    value = document.getElementById('inputBio').value.trim();
                    break;
                case 'avatar':
                    value = document.getElementById('inputAvatar').value.trim();
                    break;
            }
            
            // Gửi request lưu vào database
            const formData = new URLSearchParams();
            formData.append('field', currentField);
            formData.append('value', value);
            
            fetch(contextPath + '/profile', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: formData.toString()
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Cập nhật UI
                    updateUI(currentField, value);
                    showToast('Cập nhật thành công!', 'success');
                    closeModal();
                } else {
                    showToast(data.message || 'Cập nhật thất bại', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('Có lỗi xảy ra, vui lòng thử lại', 'error');
            });
        }
        
        function updateUI(field, value) {
            switch (field) {
                case 'fullname':
                    document.getElementById('fullnameValue').textContent = value;
                    document.getElementById('fullnameValue').classList.remove('placeholder');
                    document.getElementById('displayName').textContent = value;
                    // Update avatar if using default
                    const avatarImg = document.getElementById('avatarImg');
                    if (avatarImg.src.includes('ui-avatars.com')) {
                        avatarImg.src = 'https://ui-avatars.com/api/?name=' + encodeURIComponent(value) + '&background=c99366&color=fff&size=120';
                    }
                    break;
                case 'phone':
                    const phoneEl = document.getElementById('phoneValue');
                    phoneEl.textContent = value || 'Chưa cập nhật';
                    phoneEl.classList.toggle('placeholder', !value);
                    break;
                case 'gender':
                    const genderEl = document.getElementById('genderValue');
                    const genderMap = { 'male': 'Nam', 'female': 'Nữ', 'other': 'Khác', 'Male': 'Nam', 'Female': 'Nữ', 'Other': 'Khác' };
                    const displayGender = genderMap[value] || (value ? value : 'Chưa cập nhật');
                    genderEl.textContent = displayGender;
                    genderEl.classList.toggle('placeholder', !value || value === '');
                    break;
                case 'birthday':
                    const birthdayEl = document.getElementById('birthdayValue');
                    if (value) {
                        const date = new Date(value);
                        birthdayEl.textContent = date.toLocaleDateString('vi-VN');
                        birthdayEl.classList.remove('placeholder');
                    } else {
                        birthdayEl.textContent = 'Chưa cập nhật';
                        birthdayEl.classList.add('placeholder');
                    }
                    break;
                case 'bio':
                    const bioEl = document.getElementById('bioValue');
                    bioEl.textContent = value || 'Hãy viết vài dòng giới thiệu về bạn...';
                    bioEl.classList.toggle('placeholder', !value);
                    break;
                case 'avatar':
                    const avatar = document.getElementById('avatarImg');
                    if (value) {
                        avatar.src = value;
                    } else {
                        const name = document.getElementById('displayName').textContent;
                        avatar.src = 'https://ui-avatars.com/api/?name=' + encodeURIComponent(name) + '&background=c99366&color=fff&size=120';
                    }
                    break;
            }
        }
        
        function showToast(message, type) {
            const container = document.getElementById('toastContainer');
            const toast = document.createElement('div');
            toast.className = 'toast ' + type;
            const iconClass = type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle';
            toast.innerHTML = '<i class="fas ' + iconClass + '"></i><span>' + message + '</span>';
            container.appendChild(toast);
            
            // Show toast
            setTimeout(() => toast.classList.add('show'), 10);
            
            // Remove toast
            setTimeout(() => {
                toast.classList.remove('show');
                setTimeout(() => toast.remove(), 300);
            }, 3000);
        }
        
        // Close modal on overlay click
        document.getElementById('modalOverlay').addEventListener('click', function(e) {
            if (e.target === this) {
                closeModal();
            }
        });
        
        // Close modal on ESC key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeModal();
            }
        });
        
        // Check URL hash on page load
        document.addEventListener('DOMContentLoaded', function() {
            const hash = window.location.hash.replace('#', '');
            if (hash && ['profile', 'orders', 'address', 'wishlist', 'password'].includes(hash)) {
                showSection(hash);
            }
        });
        
        // ==================== Wishlist Functions ====================
        async function loadWishlist() {
            const container = document.getElementById('wishlistContainer');
            const loading = document.getElementById('wishlistLoading');
            
            try {
                const response = await fetch(contextPath + '/api/wishlist');
                const result = await response.json();
                
                console.log('=== WISHLIST DEBUG ===');
                console.log('Full response:', result);
                console.log('Success:', result.success);
                console.log('Data length:', result.data ? result.data.length : 0);
                
                // Clear container first
                container.innerHTML = '';
                
                if (!result.success) {
                    container.innerHTML = `
                        <div class="empty-state">
                            <div class="empty-state-icon">
                                <i class="fas fa-exclamation-circle"></i>
                            </div>
                            <h4>${result.message || 'Không thể tải wishlist'}</h4>
                        </div>
                    `;
                    return;
                }
                
                if (result.data && result.data.length > 0) {
                    console.log('Rendering wishlist items...');
                    
                    const gridHTML = result.data.map(function(item, index) {
                        console.log('Item ' + index + ':', item);
                        
                        const product = item.product;
                        if (!product) {
                            console.error('Product not found in wishlist item:', item);
                            return '';
                        }
                        
                        console.log('Product ' + index + ':', {
                            id: product.id,
                            name: product.name,
                            price: product.price,
                            salePrice: product.salePrice,
                            image: product.image,
                            slug: product.slug,
                            quantity: product.quantity
                        });
                        
                        // Format giá tiền
                        const price = product.salePrice && product.salePrice < product.price 
                            ? product.salePrice 
                            : product.price;
                        const formattedPrice = new Intl.NumberFormat('vi-VN').format(price);
                        const inStock = product.quantity > 0;
                        
                        // Xử lý image path
                        const imagePath = product.image || contextPath + '/uploads/product/default.jpg';
                        
                        console.log('Image path ' + index + ':', imagePath);
                        
                        return '<div class="wishlist-item">' +
                            '<div class="wishlist-item-image">' +
                                '<img src="' + imagePath + '" alt="' + (product.name || 'Product') + '" onerror="this.src=\'' + contextPath + '/uploads/product/default.jpg\'" />' +
                                '<button class="wishlist-remove-btn" onclick="removeFromWishlist(' + product.id + ')">' +
                                    '<i class="fas fa-times"></i>' +
                                '</button>' +
                            '</div>' +
                            '<div class="wishlist-item-content">' +
                                '<h4 class="wishlist-item-name">' +
                                    '<a href="' + contextPath + '/san-pham/' + (product.slug || '') + '">' + (product.name || 'Unnamed Product') + '</a>' +
                                '</h4>' +
                                '<div class="wishlist-item-price">' + formattedPrice + ' ₫</div>' +
                                '<div class="wishlist-item-actions">' +
                                    '<button class="wishlist-add-cart" onclick="addToCartFromWishlist(' + product.id + ')" ' + (!inStock ? 'disabled' : '') + '>' +
                                        '<i class="fas fa-shopping-cart"></i> ' + (inStock ? 'Thêm giỏ' : 'Hết hàng') +
                                    '</button>' +
                                    '<a href="' + contextPath + '/san-pham/' + (product.slug || '') + '" class="wishlist-view-detail">' +
                                        '<i class="fas fa-eye"></i>' +
                                    '</a>' +
                                '</div>' +
                            '</div>' +
                        '</div>';
                    }).join('');
                    
                    container.innerHTML = '<div class="wishlist-grid">' + gridHTML + '</div>';
                    console.log('Wishlist rendered successfully!');
                } else {
                    container.innerHTML = `
                        <div class="empty-state">
                            <div class="empty-state-icon">
                                <i class="far fa-heart"></i>
                            </div>
                            <h4>Danh sách yêu thích trống</h4>
                            <p>Bạn chưa có sản phẩm nào trong danh sách yêu thích</p>
                            <a href="${contextPath}/san-pham" class="btn btn-primary">
                                <i class="fas fa-shopping-bag"></i> Khám phá sản phẩm
                            </a>
                        </div>
                    `;
                }
            } catch (error) {
                console.error('Error loading wishlist:', error);
                container.innerHTML = `
                    <div class="empty-state">
                        <div class="empty-state-icon">
                            <i class="fas fa-exclamation-circle"></i>
                        </div>
                        <h4>Có lỗi xảy ra</h4>
                        <p>Không thể tải danh sách yêu thích</p>
                        <p style="font-size: 0.85rem; color: var(--text-muted);">${error.message}</p>
                    </div>
                `;
            }
        }
        
        async function removeFromWishlist(productId) {
            if (!confirm('Bạn có chắc chắn muốn xóa sản phẩm khỏi danh sách yêu thích?')) {
                return;
            }
            
            try {
                const response = await fetch(contextPath + '/api/wishlist', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        action: 'remove',
                        productId: productId
                    })
                });
                
                const result = await response.json();
                
                if (result.success) {
                    showToast('Đã xóa khỏi yêu thích', 'success');
                    // Reload wishlist
                    document.getElementById('wishlistContainer').innerHTML = `
                        <div class="loading-state" id="wishlistLoading">
                            <div class="loading-spinner"></div>
                            <p>Đang tải danh sách yêu thích...</p>
                        </div>
                    `;
                    loadWishlist();
                } else {
                    showToast(result.message, 'error');
                }
            } catch (error) {
                console.error('Error removing from wishlist:', error);
                showToast('Có lỗi xảy ra', 'error');
            }
        }
        
        async function addToCartFromWishlist(productId) {
            try {
                const response = await fetch(contextPath + '/api/cart/add', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        productId: productId,
                        quantity: 1
                    })
                });
                
                const result = await response.json();
                
                if (result.success) {
                    showToast('Đã thêm vào giỏ hàng', 'success');
                    // Cập nhật cart count nếu có
                    if (result.cartItemCount) {
                        updateCartCount(result.cartItemCount);
                    }
                } else {
                    showToast(result.message || 'Không thể thêm vào giỏ hàng', 'error');
                }
            } catch (error) {
                console.error('Error adding to cart:', error);
                showToast('Có lỗi xảy ra', 'error');
            }
        }
    </script>
    <%@ include file="partials/footer.jsp" %>
</body>
</html>

