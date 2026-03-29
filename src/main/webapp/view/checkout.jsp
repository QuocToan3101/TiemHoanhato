<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán - Tiệm Hoa nhà tớ</title>
    
    <!-- CSRF Token -->
    <meta name="csrf-token" content="${csrfToken}">
    <script>window.csrfToken = '${csrfToken}';</script>
    
    <link rel="shortcut icon" href="//cdn.hstatic.net/themes/200000846175/1001403720/14/favicon.png?v=245" type="image/x-icon">
    <link rel="icon" href="//cdn.hstatic.net/themes/200000846175/1001403720/14/favicon.png?v=245" type="image/png">
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Inter:wght@400;500;600;700&family=Crimson+Text:ital,wght@0,400;0,600;0,700;1,400&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Main Site CSS -->
    <link href="//cdn.hstatic.net/themes/200000846175/1001403720/14/plugin-style.css?v=245" rel="stylesheet" type="text/css">
    <link href="//cdn.hstatic.net/themes/200000846175/1001403720/14/styles-new.scss.css?v=245" rel="stylesheet" type="text/css">
    
    <style>
        :root {
            /* Main colors */
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
            
            /* Shadows */
            --shadow-sm: 0 2px 8px rgba(60,41,34,0.06);
            --shadow-md: 0 8px 24px rgba(60,41,34,0.1);
            --shadow-lg: 0 16px 48px rgba(60,41,34,0.15);
            
            /* Border radius */
            --radius-sm: 8px;
            --radius-md: 16px;
            --radius-lg: 24px;
            
            /* Transitions */
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            
            /* Header */
            --height-head: 72px;
            --bgfooter: #ffffff;
            --colorfooter: #000000;
        }
        
        /* Font Awesome fix */
        .fas, .far, .fab, .fa {
            font-family: "Font Awesome 6 Free" !important;
            font-weight: 900;
        }
        .far { font-weight: 400; }
        .fab { font-family: "Font Awesome 6 Brands" !important; }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, var(--bg-light) 0%, var(--bg-cream) 100%);
            color: var(--brown-main);
            line-height: 1.6;
            min-height: 100vh;
        }
        
        /* Checkout Container */
        .checkout-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
            margin-top: calc(var(--height-head) + 20px);
        }
        
        /* Page Header */
        .checkout-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .checkout-header h1 {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            color: var(--brown-main);
            margin-bottom: 0.5rem;
        }
        
        .checkout-header p {
            color: var(--text-muted);
            font-size: 1rem;
        }
        
        /* Breadcrumb */
        .checkout-breadcrumb {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 1rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }
        
        .breadcrumb-step {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--text-muted);
            font-size: 0.9rem;
        }
        
        .breadcrumb-step.active {
            color: var(--primary);
            font-weight: 600;
        }
        
        .breadcrumb-step.completed {
            color: var(--success);
        }
        
        .breadcrumb-step .step-number {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: var(--border-color);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.85rem;
            font-weight: 600;
        }
        
        .breadcrumb-step.active .step-number {
            background: var(--primary);
            color: white;
        }
        
        .breadcrumb-step.completed .step-number {
            background: var(--success);
            color: white;
        }
        
        .breadcrumb-divider {
            width: 40px;
            height: 2px;
            background: var(--border-color);
        }
        
        /* Main Grid Layout */
        .checkout-grid {
            display: grid;
            grid-template-columns: 1fr 420px;
            gap: 2rem;
        }
        
        @media (max-width: 968px) {
            .checkout-grid {
                grid-template-columns: 1fr;
            }
        }
        
        /* Card Style */
        .checkout-card {
            background: var(--white);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-md);
            overflow: hidden;
        }
        
        .card-header {
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .card-header i {
            color: var(--primary);
            font-size: 1.2rem;
        }
        
        .card-header h3 {
            font-family: 'Crimson Text', serif;
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--brown-main);
        }
        
        .card-body {
            padding: 1.5rem;
        }
        
        /* Form Styles */
        .form-group {
            margin-bottom: 1.25rem;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }
        
        @media (max-width: 576px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }
        
        .form-label {
            display: block;
            font-size: 0.9rem;
            font-weight: 500;
            color: var(--brown-soft);
            margin-bottom: 0.5rem;
        }
        
        .form-label .required {
            color: var(--error);
        }
        
        .form-control {
            width: 100%;
            padding: 0.875rem 1rem;
            border: 1.5px solid var(--border-color);
            border-radius: var(--radius-sm);
            font-size: 0.95rem;
            color: var(--brown-main);
            background: var(--white);
            transition: var(--transition);
        }
        
        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(201, 147, 102, 0.15);
        }
        
        .form-control::placeholder {
            color: var(--text-muted);
        }
        
        .form-control.error {
            border-color: var(--error);
        }
        
        textarea.form-control {
            resize: vertical;
            min-height: 100px;
        }
        
        select.form-control {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%236c5845' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 1rem center;
            padding-right: 2.5rem;
        }
        
        .error-message {
            color: var(--error);
            font-size: 0.8rem;
            margin-top: 0.25rem;
            display: none;
        }
        
        .form-control.error + .error-message {
            display: block;
        }
        
        /* Saved Addresses */
        .saved-addresses {
            margin-bottom: 1.5rem;
        }
        
        .address-option {
            display: flex;
            align-items: flex-start;
            gap: 1rem;
            padding: 1rem;
            border: 2px solid var(--border-color);
            border-radius: var(--radius-sm);
            margin-bottom: 0.75rem;
            cursor: pointer;
            transition: var(--transition);
        }
        
        .address-option:hover {
            border-color: var(--primary-light);
        }
        
        .address-option.selected {
            border-color: var(--primary);
            background: rgba(201, 147, 102, 0.05);
        }
        
        .address-option input[type="radio"] {
            margin-top: 0.25rem;
            accent-color: var(--primary);
        }
        
        .address-info {
            flex: 1;
        }
        
        .address-name {
            font-weight: 600;
            color: var(--brown-main);
            margin-bottom: 0.25rem;
        }
        
        .address-detail {
            font-size: 0.9rem;
            color: var(--text-muted);
            line-height: 1.5;
        }
        
        .address-default {
            display: inline-block;
            padding: 0.2rem 0.5rem;
            background: var(--primary-light);
            color: var(--primary-dark);
            font-size: 0.75rem;
            border-radius: 4px;
            margin-top: 0.5rem;
        }
        
        .new-address-toggle {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--primary);
            font-size: 0.9rem;
            cursor: pointer;
            padding: 0.5rem 0;
            transition: var(--transition);
        }
        
        .new-address-toggle:hover {
            color: var(--primary-dark);
        }
        
        .new-address-form {
            display: none;
            padding-top: 1rem;
            border-top: 1px solid var(--border-color);
            margin-top: 1rem;
        }
        
        .new-address-form.show {
            display: block;
        }
        
        /* Payment Methods */
        .payment-methods {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
        }
        
        .payment-option {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem 1.25rem;
            border: 2px solid var(--border-color);
            border-radius: var(--radius-sm);
            cursor: pointer;
            transition: var(--transition);
        }
        
        .payment-option:hover {
            border-color: var(--primary-light);
        }
        
        .payment-option.selected {
            border-color: var(--primary);
            background: rgba(201, 147, 102, 0.05);
        }
        
        .payment-option input[type="radio"] {
            accent-color: var(--primary);
        }
        
        .payment-icon {
            width: 48px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--bg-light);
            border-radius: 6px;
            font-size: 1.2rem;
            color: var(--primary);
        }
        
        .payment-info {
            flex: 1;
        }
        
        .payment-name {
            font-weight: 600;
            color: var(--brown-main);
            font-size: 0.95rem;
        }
        
        .payment-desc {
            font-size: 0.8rem;
            color: var(--text-muted);
        }
        
        .payment-detail {
            display: none;
            padding: 1rem;
            background: var(--bg-light);
            border-radius: var(--radius-sm);
            margin-top: 0.75rem;
            font-size: 0.9rem;
            color: var(--brown-soft);
        }
        
        .payment-option.selected .payment-detail {
            display: block;
        }
        
        .bank-info {
            background: var(--white);
            padding: 1rem;
            border-radius: var(--radius-sm);
            margin-top: 0.75rem;
        }
        
        .bank-info p {
            margin-bottom: 0.5rem;
        }
        
        .bank-info strong {
            color: var(--brown-main);
        }
        
        /* Order Summary */
        .order-summary {
            position: sticky;
            top: calc(var(--height-head) + 20px);
        }
        
        .summary-items {
            max-height: 300px;
            overflow-y: auto;
            padding-right: 0.5rem;
        }
        
        .summary-items::-webkit-scrollbar {
            width: 4px;
        }
        
        .summary-items::-webkit-scrollbar-track {
            background: var(--bg-light);
            border-radius: 2px;
        }
        
        .summary-items::-webkit-scrollbar-thumb {
            background: var(--primary-light);
            border-radius: 2px;
        }
        
        .summary-item {
            display: flex;
            gap: 1rem;
            padding: 1rem 0;
            border-bottom: 1px solid var(--border-color);
        }
        
        .summary-item:last-child {
            border-bottom: none;
        }
        
        .item-image {
            width: 70px;
            height: 70px;
            border-radius: var(--radius-sm);
            overflow: hidden;
            flex-shrink: 0;
            position: relative;
        }
        
        .item-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .item-quantity {
            position: absolute;
            top: -8px;
            right: -8px;
            width: 22px;
            height: 22px;
            background: var(--primary);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: 600;
        }
        
        .item-info {
            flex: 1;
        }
        
        .item-name {
            font-weight: 600;
            color: var(--brown-main);
            font-size: 0.95rem;
            margin-bottom: 0.25rem;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .item-variant {
            font-size: 0.8rem;
            color: var(--text-muted);
        }
        
        .item-price {
            font-weight: 600;
            color: var(--primary-dark);
            white-space: nowrap;
        }
        
        /* Coupon */
        .coupon-section {
            padding: 1rem 1.5rem;
            border-top: 1px solid var(--border-color);
        }
        
        .coupon-input {
            display: flex;
            gap: 0.5rem;
        }
        
        .coupon-input input {
            flex: 1;
            padding: 0.75rem 1rem;
            border: 1.5px solid var(--border-color);
            border-radius: var(--radius-sm);
            font-size: 0.9rem;
        }
        
        .coupon-input input:focus {
            outline: none;
            border-color: var(--primary);
        }
        
        .coupon-btn {
            padding: 0.75rem 1.25rem;
            background: var(--brown-main);
            color: white;
            border: none;
            border-radius: var(--radius-sm);
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
        }
        
        .coupon-btn:hover {
            background: var(--brown-soft);
        }
        
        .coupon-applied {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0.75rem 1rem;
            background: rgba(39, 174, 96, 0.1);
            border-radius: var(--radius-sm);
            margin-top: 0.75rem;
        }
        
        .coupon-applied .coupon-code {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--success);
            font-weight: 600;
        }
        
        .coupon-applied .remove-coupon {
            color: var(--text-muted);
            cursor: pointer;
            padding: 0.25rem;
        }
        
        .coupon-applied .remove-coupon:hover {
            color: var(--error);
        }
        
        /* Summary Totals */
        .summary-totals {
            padding: 1rem 1.5rem;
            border-top: 1px solid var(--border-color);
        }
        
        .total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 0;
            font-size: 0.95rem;
        }
        
        .total-row.discount {
            color: var(--success);
        }
        
        .total-row.grand-total {
            padding-top: 1rem;
            margin-top: 0.5rem;
            border-top: 2px solid var(--border-color);
            font-size: 1.1rem;
            font-weight: 700;
        }
        
        .total-row.grand-total .amount {
            color: var(--primary-dark);
            font-size: 1.3rem;
        }
        
        /* Submit Button */
        .checkout-submit {
            padding: 1rem 1.5rem;
            border-top: 1px solid var(--border-color);
        }
        
        .btn-checkout {
            width: 100%;
            padding: 1rem 2rem;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            border: none;
            border-radius: var(--radius-sm);
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            transition: var(--transition);
        }
        
        .btn-checkout:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(201, 147, 102, 0.4);
        }
        
        .btn-checkout:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }
        
        .btn-checkout .spinner {
            width: 20px;
            height: 20px;
            border: 2px solid rgba(255,255,255,0.3);
            border-top-color: white;
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
            display: none;
        }
        
        .btn-checkout.loading .spinner {
            display: block;
        }
        
        .btn-checkout.loading .btn-text {
            display: none;
        }
        
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        
        .secure-note {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            margin-top: 1rem;
            font-size: 0.8rem;
            color: var(--text-muted);
        }
        
        .secure-note i {
            color: var(--success);
        }
        
        /* Back Link */
        .back-to-cart {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--text-muted);
            text-decoration: none;
            font-size: 0.9rem;
            margin-bottom: 1.5rem;
            transition: var(--transition);
        }
        
        .back-to-cart:hover {
            color: var(--primary);
        }
        
        /* Empty Cart */
        .empty-cart {
            text-align: center;
            padding: 4rem 2rem;
        }
        
        .empty-cart i {
            font-size: 4rem;
            color: var(--border-color);
            margin-bottom: 1.5rem;
        }
        
        .empty-cart h3 {
            font-family: 'Crimson Text', serif;
            font-size: 1.5rem;
            color: var(--brown-main);
            margin-bottom: 0.5rem;
        }
        
        .empty-cart p {
            color: var(--text-muted);
            margin-bottom: 1.5rem;
        }
        
        .btn-shop {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.875rem 2rem;
            background: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: var(--radius-sm);
            font-weight: 600;
            transition: var(--transition);
        }
        
        .btn-shop:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
        }
        
        /* Toast Notification */
        .toast-container {
            position: fixed;
            top: calc(var(--height-head) + 20px);
            right: 20px;
            z-index: 9999;
        }
        
        .toast {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 1rem 1.5rem;
            background: var(--white);
            border-radius: var(--radius-sm);
            box-shadow: var(--shadow-lg);
            margin-bottom: 0.75rem;
            animation: slideIn 0.3s ease;
            max-width: 350px;
        }
        
        .toast.success {
            border-left: 4px solid var(--success);
        }
        
        .toast.error {
            border-left: 4px solid var(--error);
        }
        
        .toast i {
            font-size: 1.25rem;
        }
        
        .toast.success i {
            color: var(--success);
        }
        
        .toast.error i {
            color: var(--error);
        }
        
        .toast-message {
            flex: 1;
            font-size: 0.9rem;
        }
        
        .toast-close {
            cursor: pointer;
            color: var(--text-muted);
            padding: 0.25rem;
        }
        
        @keyframes slideIn {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        /* Loading Overlay */
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(255,255,255,0.9);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            z-index: 10000;
            display: none;
        }
        
        .loading-overlay.show {
            display: flex;
        }
        
        .loading-spinner {
            width: 50px;
            height: 50px;
            border: 4px solid var(--border-color);
            border-top-color: var(--primary);
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
            margin-bottom: 1rem;
        }
        
        .loading-text {
            color: var(--brown-main);
            font-weight: 500;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .checkout-container {
                padding: 1rem;
                margin-top: calc(var(--height-head) + 10px);
            }
            
            .checkout-header h1 {
                font-size: 1.75rem;
            }
            
            .checkout-breadcrumb {
                gap: 0.5rem;
            }
            
            .breadcrumb-divider {
                width: 20px;
            }
            
            .card-body {
                padding: 1rem;
            }
            
            .order-summary {
                position: static;
            }
        }
    </style>
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
</head>
<body>
    <!-- Header -->
    <%@ include file="partials/header.jsp" %>
    
    <!-- Toast Container -->
    <div class="toast-container" id="toastContainer"></div>
    
    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner"></div>
        <div class="loading-text">Đang xử lý đơn hàng...</div>
    </div>
    
    <div class="checkout-container">
        <!-- Back Link -->
        <a href="cart.jsp" class="back-to-cart">
            <i class="fas fa-arrow-left"></i>
            Quay lại giỏ hàng
        </a>
        
        <!-- Page Header -->
        <div class="checkout-header">
            <h1>Thanh toán</h1>
            <p>Hoàn tất đơn hàng của bạn</p>
        </div>
        
        <!-- Breadcrumb Steps -->
        <div class="checkout-breadcrumb">
            <div class="breadcrumb-step completed">
                <span class="step-number"><i class="fas fa-check"></i></span>
                <span>Giỏ hàng</span>
            </div>
            <div class="breadcrumb-divider"></div>
            <div class="breadcrumb-step active">
                <span class="step-number">2</span>
                <span>Thanh toán</span>
            </div>
            <div class="breadcrumb-divider"></div>
            <div class="breadcrumb-step">
                <span class="step-number">3</span>
                <span>Hoàn tất</span>
            </div>
        </div>
        
        <!-- Check if cart is empty -->
        <c:choose>
            <c:when test="${empty cartItems}">
                <!-- Empty Cart -->
                <div class="checkout-card">
                    <div class="empty-cart">
                        <i class="fas fa-shopping-bag"></i>
                        <h3>Giỏ hàng trống</h3>
                        <p>Bạn chưa có sản phẩm nào trong giỏ hàng</p>
                        <a href="${pageContext.request.contextPath}/san-pham" class="btn-shop">
                            <i class="fas fa-shopping-basket"></i>
                            Tiếp tục mua sắm
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <form id="checkoutForm" action="${pageContext.request.contextPath}/checkout" method="POST">
                    <div class="checkout-grid">
                        <!-- Left Column - Form -->
                        <div class="checkout-form">
                            <!-- Shipping Information -->
                            <div class="checkout-card" style="margin-bottom: 1.5rem;">
                                <div class="card-header">
                                    <i class="fas fa-truck"></i>
                                    <h3>Thông tin giao hàng</h3>
                                </div>
                                <div class="card-body">
                                    <!-- Saved Addresses -->
                                    <c:if test="${not empty addresses}">
                                        <div class="saved-addresses">
                                            <c:forEach var="addr" items="${addresses}" varStatus="status">
                                                <label class="address-option ${addr.isDefault ? 'selected' : ''}" data-address-id="${addr.id}">
                                                    <input type="radio" name="addressId" value="${addr.id}" ${addr.isDefault ? 'checked' : ''}>
                                                    <div class="address-info">
                                                        <div class="address-name">${addr.receiverName} - ${addr.phone}</div>
                                                        <div class="address-detail">${addr.fullAddress}</div>
                                                        <c:if test="${addr.isDefault}">
                                                            <span class="address-default">Mặc định</span>
                                                        </c:if>
                                                    </div>
                                                </label>
                                            </c:forEach>
                                        </div>
                                        <div class="new-address-toggle" onclick="toggleNewAddressForm()">
                                            <i class="fas fa-plus-circle"></i>
                                            <span>Giao đến địa chỉ khác</span>
                                        </div>
                                    </c:if>
                                    
                                    <!-- New Address Form -->
                                    <div class="new-address-form ${empty addresses ? 'show' : ''}" id="newAddressForm">
                                        <div class="form-row">
                                            <div class="form-group">
                                                <label class="form-label">Họ và tên <span class="required">*</span></label>
                                                <input type="text" name="receiverName" class="form-control" 
                                                       value="${sessionScope.user.fullname}" placeholder="Nhập họ tên người nhận" required>
                                                <div class="error-message">Vui lòng nhập họ tên</div>
                                            </div>
                                            <div class="form-group">
                                                <label class="form-label">Số điện thoại <span class="required">*</span></label>
                                                <input type="tel" name="receiverPhone" class="form-control" 
                                                       value="${sessionScope.user.phone}" placeholder="Nhập số điện thoại" required>
                                                <div class="error-message">Vui lòng nhập số điện thoại hợp lệ</div>
                                            </div>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label class="form-label">Email</label>
                                            <input type="email" name="receiverEmail" class="form-control" 
                                                   value="${sessionScope.user.email}" placeholder="Nhập email nhận thông báo">
                                        </div>
                                        
                                        <div class="form-group">
                                            <label class="form-label">Địa chỉ giao hàng <span class="required">*</span></label>
                                            <textarea name="addressDetail" class="form-control" rows="3"
                                                      placeholder="Nhập địa chỉ đầy đủ (Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành phố)" required></textarea>
                                            <div class="error-message">Vui lòng nhập địa chỉ giao hàng</div>
                                        </div>
                                        
                                        <!-- Hidden fields for backward compatibility -->
                                        <input type="hidden" name="province" value="">
                                        <input type="hidden" name="district" value="">
                                        <input type="hidden" name="ward" value="">
                                        
                                        <div class="form-group">
                                            <label class="form-label">Ghi chú</label>
                                            <textarea name="note" class="form-control" 
                                                      placeholder="Ghi chú thêm (thời gian giao, hướng dẫn giao hàng...)"></textarea>
                                        </div>
                                        
                                        <!-- Greeting Card Option -->
                                        <c:if test="${not empty sessionScope.greetingCardImage and not empty sessionScope.greetingCardMessage}">
                                        <div class="form-group mt-4">
                                            <div class="greeting-card-section" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 20px; border-radius: 10px; color: white;">
                                                <div style="display: flex; align-items: center; gap: 15px;">
                                                    <i class="fas fa-envelope-open-text" style="font-size: 40px;"></i>
                                                    <div style="flex: 1;">
                                                        <h5 style="margin: 0; color: white;">🎁 Bạn đã tạo thiệp chúc mừng AI!</h5>
                                                        <p style="margin: 5px 0 0 0; opacity: 0.9; font-size: 14px;">Thiệp đẹp đã được tạo từ AI với nội dung cá nhân hóa</p>
                                                    </div>
                                                </div>
                                                <div class="form-check mt-3" style="background: rgba(255,255,255,0.15); padding: 15px; border-radius: 8px;">
                                                    <input type="checkbox" class="form-check-input" id="attachGreetingCard" name="attachGreetingCard" checked style="width: 20px; height: 20px;">
                                                    <label class="form-check-label" for="attachGreetingCard" style="cursor: pointer; margin-left: 10px; color: white; font-weight: 500;">
                                                        ✨ Đính kèm thiệp này vào email xác nhận đơn hàng
                                                    </label>
                                                </div>
                                                <div class="form-check mt-2" style="background: rgba(255,255,255,0.15); padding: 15px; border-radius: 8px;">
                                                    <input type="checkbox" class="form-check-input" id="printGreetingCard" name="printGreetingCard" style="width: 20px; height: 20px;">
                                                    <label class="form-check-label" for="printGreetingCard" style="cursor: pointer; margin-left: 10px; color: white; font-weight: 500;">
                                                        🌸 Kèm thiệp in khi nhận hoa (Admin sẽ nhận thông báo)
                                                    </label>
                                                </div>
                                                <small style="display: block; margin-top: 10px; opacity: 0.8;">
                                                    💌 Email: Thiệp đính kèm email ngay lập tức<br>
                                                    🖨️ In thiệp: Admin sẽ in thiệp và gửi kèm hoa đến người nhận
                                                </small>
                                            </div>
                                        </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Payment Method -->
                            <div class="checkout-card">
                                <div class="card-header">
                                    <i class="fas fa-credit-card"></i>
                                    <h3>Phương thức thanh toán</h3>
                                </div>
                                <div class="card-body">
                                    <div class="payment-methods">
                                        <!-- COD -->
                                        <label class="payment-option selected">
                                            <input type="radio" name="paymentMethod" value="cod" checked>
                                            <div class="payment-icon">
                                                <i class="fas fa-money-bill-wave"></i>
                                            </div>
                                            <div class="payment-info">
                                                <div class="payment-name">Thanh toán khi nhận hàng (COD)</div>
                                                <div class="payment-desc">Thanh toán bằng tiền mặt khi nhận hàng</div>
                                            </div>
                                        </label>
                                        
                                        <!-- Bank Transfer -->
                                        <label class="payment-option">
                                            <input type="radio" name="paymentMethod" value="bank_transfer">
                                            <div class="payment-icon">
                                                <i class="fas fa-university"></i>
                                            </div>
                                            <div class="payment-info">
                                                <div class="payment-name">Chuyển khoản ngân hàng</div>
                                                <div class="payment-desc">Chuyển khoản trực tiếp đến tài khoản ngân hàng</div>
                                                <div class="payment-detail">
                                                    <p>Vui lòng chuyển khoản đến:</p>
                                                    <div class="bank-info">
                                                        <p><strong>Ngân hàng:</strong> Vietcombank</p>
                                                        <p><strong>Số tài khoản:</strong> 1234567890</p>
                                                        <p><strong>Chủ tài khoản:</strong> TIỆM HOA NHÀ TỚ</p>
                                                        <p><strong>Nội dung:</strong> [Mã đơn hàng] - [SĐT]</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </label>
                                        
                                        <!-- VNPay -->
                                        <label class="payment-option">
                                            <input type="radio" name="paymentMethod" value="vnpay">
                                            <div class="payment-icon">
                                                <i class="fas fa-qrcode"></i>
                                            </div>
                                            <div class="payment-info">
                                                <div class="payment-name">VNPay</div>
                                                <div class="payment-desc">Thanh toán qua ví điện tử VNPay</div>
                                                <div class="payment-detail">
                                                    <p>Bạn sẽ được chuyển đến trang VNPay để hoàn tất thanh toán sau khi đặt hàng.</p>
                                                </div>
                                            </div>
                                        </label>
                                        
                                        <!-- MoMo -->
                                        <label class="payment-option">
                                            <input type="radio" name="paymentMethod" value="momo">
                                            <div class="payment-icon">
                                                <i class="fas fa-mobile-alt"></i>
                                            </div>
                                            <div class="payment-info">
                                                <div class="payment-name">Ví MoMo</div>
                                                <div class="payment-desc">Thanh toán qua ví điện tử MoMo</div>
                                                <div class="payment-detail">
                                                    <p>Bạn sẽ được chuyển đến trang MoMo để hoàn tất thanh toán sau khi đặt hàng.</p>
                                                </div>
                                            </div>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Right Column - Order Summary -->
                        <div class="order-summary">
                            <div class="checkout-card">
                                <div class="card-header">
                                    <i class="fas fa-shopping-bag"></i>
                                    <h3>Đơn hàng của bạn (${cartCount} sản phẩm)</h3>
                                </div>
                                <div class="card-body">
                                    <div class="summary-items">
                                        <c:forEach var="item" items="${cartItems}">
                                            <div class="summary-item">
                                                <div class="item-image">
                                                    <img src="${item.product.image}" alt="${item.product.name}">
                                                    <span class="item-quantity">${item.quantity}</span>
                                                </div>
                                                <div class="item-info">
                                                    <div class="item-name">${item.product.name}</div>
                                                    <div class="item-variant">
                                                        <fmt:formatNumber value="${item.product.displayPrice}" type="number" groupingUsed="true"/>₫ x ${item.quantity}
                                                    </div>
                                                </div>
                                                <div class="item-price">
                                                    <fmt:formatNumber value="${item.subtotal}" type="number" groupingUsed="true"/>₫
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                                
                                <!-- Coupon -->
                                <div class="coupon-section">
                                    <div class="coupon-input">
                                        <input type="text" name="couponCode" id="couponCode" placeholder="Nhập mã giảm giá">
                                        <button type="button" class="coupon-btn" onclick="applyCoupon()">Áp dụng</button>
                                    </div>
                                    <div class="coupon-applied" id="couponApplied" style="display: none;">
                                        <div class="coupon-code">
                                            <i class="fas fa-tag"></i>
                                            <span id="appliedCouponCode"></span>
                                        </div>
                                        <span class="remove-coupon" onclick="removeCoupon()">
                                            <i class="fas fa-times"></i>
                                        </span>
                                    </div>
                                </div>
                                
                                <!-- Totals -->
                                <div class="summary-totals">
                                    <div class="total-row">
                                        <span>Tạm tính</span>
                                        <span><fmt:formatNumber value="${cartTotal}" type="number" groupingUsed="true"/>₫</span>
                                    </div>
                                    <div class="total-row">
                                        <span>Phí vận chuyển</span>
                                        <span id="shippingFee">30,000₫</span>
                                    </div>
                                    <div class="total-row discount" id="discountRow" style="display: none;">
                                        <span>Giảm giá</span>
                                        <span id="discountAmount">-0₫</span>
                                    </div>
                                    <div class="total-row grand-total">
                                        <span>Tổng cộng</span>
                                        <span class="amount" id="grandTotal">
                                            <fmt:formatNumber value="${cartTotal + 30000}" type="number" groupingUsed="true"/>₫
                                        </span>
                                    </div>
                                </div>
                                
                                <!-- Hidden fields -->
                                <input type="hidden" name="subtotal" value="${cartTotal}">
                                <input type="hidden" name="shippingFee" id="shippingFeeInput" value="30000">
                                <input type="hidden" name="discount" id="discountInput" value="0">
                                <input type="hidden" name="total" id="totalInput" value="${cartTotal + 30000}">
                                <input type="hidden" name="appliedCouponCode" id="appliedCouponCodeInput" value="">
                                
                                <!-- Submit -->
                                <div class="checkout-submit">
                                    <button type="submit" class="btn-checkout" id="btnCheckout">
                                        <span class="btn-text">
                                            <i class="fas fa-lock"></i>
                                            Đặt hàng
                                        </span>
                                        <span class="spinner"></span>
                                    </button>
                                    <div class="secure-note">
                                        <i class="fas fa-shield-alt"></i>
                                        Thông tin của bạn được bảo mật an toàn
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </c:otherwise>
        </c:choose>
    </div>
    
    <!-- Footer -->
    <%@ include file="partials/footer.jsp" %>
    
    <!-- Scripts -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/axios/1.6.0/axios.min.js"></script>
    
    <!-- CSRF Token Helper - Phải load SAU axios -->
    <script src="${pageContext.request.contextPath}/fileJS/csrf-token.js"></script>
    
    <script>
        // Variables
        let provinces = [];
        let districts = [];
        let wards = [];
        let appliedCoupon = null;
        const subtotal = <c:out value="${cartTotal != null ? cartTotal : 0}"/>;
        let shippingFee = 30000;
        let discount = 0;
        
        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            initPaymentMethods();
            initAddressOptions();
        });
        
        // Toggle new address form
        function toggleNewAddressForm() {
            const form = document.getElementById('newAddressForm');
            form.classList.toggle('show');
            
            // Deselect saved addresses
            if (form.classList.contains('show')) {
                document.querySelectorAll('.address-option input[type="radio"]').forEach(radio => {
                    radio.checked = false;
                });
                document.querySelectorAll('.address-option').forEach(opt => {
                    opt.classList.remove('selected');
                });
            }
        }
        
        // Initialize address options
        function initAddressOptions() {
            document.querySelectorAll('.address-option').forEach(option => {
                option.addEventListener('click', function() {
                    document.querySelectorAll('.address-option').forEach(opt => {
                        opt.classList.remove('selected');
                    });
                    this.classList.add('selected');
                    this.querySelector('input[type="radio"]').checked = true;
                    
                    // Hide new address form
                    document.getElementById('newAddressForm')?.classList.remove('show');
                });
            });
        }
        
        // Initialize payment methods
        function initPaymentMethods() {
            document.querySelectorAll('.payment-option').forEach(option => {
                option.addEventListener('click', function() {
                    document.querySelectorAll('.payment-option').forEach(opt => {
                        opt.classList.remove('selected');
                    });
                    this.classList.add('selected');
                    this.querySelector('input[type="radio"]').checked = true;
                });
            });
        }
        
        // Apply coupon
        async function applyCoupon() {
            const code = document.getElementById('couponCode').value.trim();
            if (!code) {
                showToast('Vui lòng nhập mã giảm giá', 'error');
                return;
            }
            
            try {
                const response = await axios.post('${pageContext.request.contextPath}/api/coupon/validate', {
                    code: code,
                    subtotal: subtotal
                });
                
                if (response.data.success) {
                    appliedCoupon = response.data.coupon;
                    discount = response.data.discountAmount;
                    
                    document.getElementById('couponApplied').style.display = 'flex';
                    document.getElementById('appliedCouponCode').textContent = code.toUpperCase();
                    document.getElementById('appliedCouponCodeInput').value = code.toUpperCase();
                    document.getElementById('couponCode').value = '';
                    document.getElementById('couponCode').disabled = true;
                    
                    updateTotals();
                    showToast('Áp dụng mã giảm giá thành công!', 'success');
                } else {
                    showToast(response.data.message || 'Mã giảm giá không hợp lệ', 'error');
                }
            } catch (error) {
                showToast('Không thể kiểm tra mã giảm giá lúc này. Vui lòng thử lại!', 'error');
            }
        }
        
        // Remove coupon
        function removeCoupon() {
            appliedCoupon = null;
            discount = 0;
            shippingFee = 30000;
            
            document.getElementById('couponApplied').style.display = 'none';
            document.getElementById('couponCode').disabled = false;
            document.getElementById('appliedCouponCodeInput').value = '';
            
            updateTotals();
            showToast('Đã hủy mã giảm giá', 'success');
        }
        
        // Update totals
        function updateTotals() {
            const total = subtotal + shippingFee - discount;
            
            document.getElementById('shippingFee').textContent = formatCurrency(shippingFee);
            document.getElementById('shippingFeeInput').value = shippingFee;
            
            if (discount > 0) {
                document.getElementById('discountRow').style.display = 'flex';
                document.getElementById('discountAmount').textContent = '-' + formatCurrency(discount);
                document.getElementById('discountInput').value = discount;
            } else {
                document.getElementById('discountRow').style.display = 'none';
            }
            
            document.getElementById('grandTotal').textContent = formatCurrency(total);
            document.getElementById('totalInput').value = total;
        }
        
        // Format currency
        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN').format(amount) + '₫';
        }
        
        // Form validation
        document.getElementById('checkoutForm')?.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Check if using saved address or new address
            const savedAddress = document.querySelector('.address-option.selected input[type="radio"]:checked');
            const newAddressForm = document.getElementById('newAddressForm');
            
            if (!savedAddress && newAddressForm) {
                // Validate new address form
                const requiredFields = newAddressForm.querySelectorAll('[required]');
                let isValid = true;
                
                requiredFields.forEach(field => {
                    if (!field.value.trim()) {
                        field.classList.add('error');
                        isValid = false;
                    } else {
                        field.classList.remove('error');
                    }
                });
                
                // Validate phone
                const phoneField = newAddressForm.querySelector('input[name="receiverPhone"]');
                if (phoneField && !/^[0-9]{10,11}$/.test(phoneField.value.replace(/\s/g, ''))) {
                    phoneField.classList.add('error');
                    isValid = false;
                }
                
                if (!isValid) {
                    showToast('Vui lòng điền đầy đủ thông tin giao hàng', 'error');
                    return;
                }
            }
            
            // Validate payment method
            const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked');
            if (!paymentMethod) {
                showToast('Vui lòng chọn phương thức thanh toán', 'error');
                return;
            }
            
            // Submit form
            submitOrder();
        });
        
        // Submit order
        async function submitOrder() {
            const btn = document.getElementById('btnCheckout');
            const overlay = document.getElementById('loadingOverlay');
            
            btn.classList.add('loading');
            btn.disabled = true;
            if (overlay) overlay.classList.add('show');
            
            try {
                const form = document.getElementById('checkoutForm');
                const formData = new FormData(form);
                
                // Convert FormData to URLSearchParams for proper serialization
                const params = new URLSearchParams();
                for (const [key, value] of formData.entries()) {
                    params.append(key, value);
                }
                
                console.log('Submitting order with params:', params.toString());
                
                const response = await axios.post('${pageContext.request.contextPath}/checkout', params, {
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    }
                });
                
                console.log('Response:', response.data);
                
                if (response.data.success) {
                    // Check if need to redirect to payment gateway
                    if (response.data.redirectUrl) {
                        // VNPay or MoMo payment - redirect to payment page
                        showToast(response.data.message || 'Đang chuyển đến trang thanh toán...', 'success');
                        setTimeout(() => {
                            window.location.href = response.data.redirectUrl;
                        }, 1000);
                    } else {
                        // COD or Bank Transfer - redirect to success page
                        window.location.href = '${pageContext.request.contextPath}/order-success?orderCode=' + response.data.orderCode;
                    }
                } else {
                    showToast(response.data.message || 'Có lỗi xảy ra, vui lòng thử lại', 'error');
                }
            } catch (error) {
                console.error('Checkout error:', error);
                if (error.response) {
                    console.error('Error response:', error.response.data);
                }
                showToast('Có lỗi xảy ra khi đặt hàng. Vui lòng thử lại!', 'error');
            } finally {
                btn.classList.remove('loading');
                btn.disabled = false;
                if (overlay) overlay.classList.remove('show');
            }
        }
        
        // Show toast notification
        function showToast(message, type = 'success') {
            const container = document.getElementById('toastContainer');
            const toast = document.createElement('div');
            toast.className = 'toast ' + type;
            const icon = type === 'success' ? 'check-circle' : 'exclamation-circle';
            toast.innerHTML = '<i class="fas fa-' + icon + '"></i>' +
                '<span class="toast-message">' + message + '</span>' +
                '<span class="toast-close" onclick="this.parentElement.remove()">' +
                '<i class="fas fa-times"></i></span>';
            container.appendChild(toast);
            
            setTimeout(() => {
                toast.remove();
            }, 4000);
        }
        
        // Remove error class on input
        document.querySelectorAll('.form-control').forEach(input => {
            input.addEventListener('input', function() {
                this.classList.remove('error');
            });
        });
    </script>
</body>
</html>
