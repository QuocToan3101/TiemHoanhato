<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <title>Chi tiết khách hàng - Admin | Tiệm Hoa nhà tớ</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!-- CSRF Token -->
    <meta name="csrf-token" content="${csrfToken}">
    <script>window.csrfToken = '${csrfToken}';</script>

    <link rel="shortcut icon" href="//cdn.hstatic.net/themes/200000846175/1001403720/14/favicon.png?v=245" type="image/x-icon" />

    <!-- Font -->
    <link href="https://fonts.googleapis.com/css2?family=Crimson+Text:wght@400;600;700&display=swap" rel="stylesheet" />

    <!-- CSS theme -->
    <link href="//cdn.hstatic.net/themes/200000846175/1001403720/14/plugin-style.css?v=245" rel="stylesheet" />
    <link href="//cdn.hstatic.net/themes/200000846175/1001403720/14/styles-new.scss.css?v=245" rel="stylesheet" />

    <%@ include file="partials/head-icons.jsp" %>

    <!-- SweetAlert2 CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.5/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.5/dist/sweetalert2.all.min.js"></script>
    <!-- Core Notification System & CSS Components -->
    <script src="${pageContext.request.contextPath}/js/notification.js"></script>

    <style>
        .fas, .far, .fab { font-family: "Font Awesome 6 Free" !important; font-weight: 900; }
        .far { font-weight: 400; }

        :root {
            --bg-page: #faf5ef;
            --brown-main: #3c2922;
            --brown-soft: #6c5845;
            --accent: #c99366;
            --accent-dark: #aa6a3f;
            --header-height: 72px;
        }

        *, *::before, *::after { box-sizing: border-box; }

        body {
            background: #faf5ef;
            font-family: 'Crimson Text', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            margin: 0; padding: 0;
        }

        main { padding-top: var(--header-height); min-height: calc(100vh - var(--header-height)); }

        #header, .site-header {
            position: fixed !important; top: 0; left: 0; right: 0;
            z-index: 1000; background: #fff;
        }

        /* HERO */
        .detail-hero {
            background: linear-gradient(135deg, rgba(201,147,102,0.95) 0%, rgba(170,106,63,0.95) 100%),
                        url("https://images.unsplash.com/photo-1487070183336-b863922373d4?w=1200") center/cover;
            color: #fff;
            padding: 3rem 1.5rem 5rem;
            text-align: center;
            position: relative; overflow: hidden;
        }

        .detail-hero::before {
            content: ""; position: absolute;
            top: -50%; right: -8%;
            width: 420px; height: 420px;
            background: radial-gradient(circle, rgba(255,255,255,0.15) 0%, transparent 70%);
            border-radius: 50%;
        }

        .detail-hero-inner { position: relative; z-index: 1; max-width: 780px; margin: 0 auto; }
        .detail-hero h1 { font-size: 2.4rem; font-weight: 700; margin: 0.5rem 0 0.5rem; text-shadow: 0 2px 12px rgba(0,0,0,0.18); }
        .detail-hero p { font-size: 1rem; opacity: 0.9; font-style: italic; }

        /* Breadcrumb */
        .breadcrumb-section { background: #fff; padding: 1rem 0; border-bottom: 1px solid #e8ddd4; }
        .breadcrumb {
            max-width: 1200px; margin: 0 auto; padding: 0 1.5rem;
            display: flex; align-items: center; gap: 0.5rem; font-size: 0.9rem;
        }
        .breadcrumb a { color: var(--brown-soft); text-decoration: none; }
        .breadcrumb a:hover { color: var(--accent-dark); }
        .breadcrumb span { color: var(--brown-main); }

        /* WRAPPER */
        .detail-wrapper {
            max-width: 1200px; margin: -3rem auto 3.5rem;
            padding: 0 1.5rem;
            position: relative; z-index: 5;
        }

        /* LAYOUT GRID */
        .detail-grid {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 24px;
            align-items: start;
        }

        @media (max-width: 900px) {
            .detail-grid { grid-template-columns: 1fr; }
        }

        /* CARD BASE */
        .card {
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(60,41,34,0.09);
            border: 1px solid rgba(210,180,160,0.3);
            overflow: hidden;
        }

        .card-header {
            padding: 1.2rem 1.5rem;
            border-bottom: 1px solid #f0e6db;
            display: flex; align-items: center; justify-content: space-between;
        }

        .card-header h3 {
            font-size: 1.1rem; font-weight: 700;
            color: var(--brown-main); margin: 0;
            display: flex; align-items: center; gap: 8px;
        }

        .card-header h3 i { color: var(--accent); font-size: 1rem; }

        .card-body { padding: 1.5rem; }

        /* PROFILE CARD */
        .profile-avatar-wrap {
            display: flex; flex-direction: column; align-items: center;
            padding: 2rem 1.5rem 1.5rem; text-align: center;
        }

        .profile-avatar {
            width: 100px; height: 100px; border-radius: 50%;
            object-fit: cover;
            border: 4px solid var(--accent);
            box-shadow: 0 4px 16px rgba(201,147,102,0.3);
            margin-bottom: 1rem;
        }

        .profile-avatar-placeholder {
            width: 100px; height: 100px; border-radius: 50%;
            background: linear-gradient(135deg, var(--accent), var(--accent-dark));
            display: flex; align-items: center; justify-content: center;
            font-size: 2.5rem; color: #fff; font-weight: 700;
            border: 4px solid rgba(201,147,102,0.3);
            box-shadow: 0 4px 16px rgba(201,147,102,0.3);
            margin-bottom: 1rem;
        }

        .profile-name {
            font-size: 1.35rem; font-weight: 700; color: var(--brown-main); margin-bottom: 4px;
        }

        .profile-email { font-size: 0.9rem; color: var(--brown-soft); margin-bottom: 12px; }

        /* Status Badge */
        .badge {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 4px 14px; border-radius: 999px; font-size: 0.8rem; font-weight: 600;
        }
        .badge-active   { background: #e8f5e9; color: #2e7d32; }
        .badge-inactive { background: #fafafa; color: #757575; border: 1px solid #e0e0e0; }
        .badge-banned   { background: #ffebee; color: #c62828; }
        .badge-pending  { background: #fff8e1; color: #f57f17; }

        /* Info List */
        .info-list { list-style: none; padding: 0; margin: 0; }
        .info-list li {
            display: flex; align-items: flex-start; gap: 12px;
            padding: 11px 0;
            border-bottom: 1px solid #f5ede4;
            font-size: 0.95rem;
        }
        .info-list li:last-child { border-bottom: none; }
        .info-list .info-icon {
            width: 32px; height: 32px; border-radius: 8px;
            background: #faf3ea;
            display: flex; align-items: center; justify-content: center;
            color: var(--accent-dark); font-size: 0.85rem; flex-shrink: 0;
        }
        .info-list .info-label {
            font-size: 0.78rem; color: var(--brown-soft);
            text-transform: uppercase; letter-spacing: 0.06em; font-weight: 600;
            margin-bottom: 2px;
        }
        .info-list .info-value { color: var(--brown-main); font-weight: 600; }

        /* Action Buttons */
        .action-buttons { display: flex; flex-direction: column; gap: 8px; }

        .btn {
            display: inline-flex; align-items: center; justify-content: center; gap: 8px;
            padding: 9px 18px; border-radius: 999px; border: none;
            font-size: 0.88rem; font-weight: 600; cursor: pointer;
            transition: all 0.2s; text-decoration: none;
        }
        .btn-primary {
            background: linear-gradient(135deg, var(--accent), var(--accent-dark));
            color: #fff;
        }
        .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 4px 14px rgba(170,106,63,0.35); }

        .btn-danger { background: #ffebee; color: #c62828; }
        .btn-danger:hover { background: #c62828; color: #fff; }

        .btn-warning { background: #fff8e1; color: #e65100; }
        .btn-warning:hover { background: #e65100; color: #fff; }

        .btn-success { background: #e8f5e9; color: #2e7d32; }
        .btn-success:hover { background: #2e7d32; color: #fff; }

        .btn-secondary { background: #f5f5f5; color: #555; }
        .btn-secondary:hover { background: #e0e0e0; }

        /* STATS ROW */
        .stats-row {
            display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px;
            margin-bottom: 24px;
        }

        .stat-card {
            background: #fff; border-radius: 16px;
            padding: 1.1rem 1rem; text-align: center;
            box-shadow: 0 4px 16px rgba(60,41,34,0.07);
            border: 1px solid rgba(210,180,160,0.25);
        }

        .stat-icon {
            width: 40px; height: 40px; border-radius: 10px;
            background: linear-gradient(135deg, var(--accent), var(--accent-dark));
            display: flex; align-items: center; justify-content: center;
            color: #fff; font-size: 1rem; margin: 0 auto 8px;
        }

        .stat-value { font-size: 1.5rem; font-weight: 700; color: var(--brown-main); }
        .stat-label { font-size: 0.78rem; color: var(--brown-soft); text-transform: uppercase; letter-spacing: 0.05em; }

        /* TABLE */
        .table-wrap { overflow-x: auto; }

        table {
            width: 100%; border-collapse: collapse; font-size: 0.9rem;
        }

        thead th {
            background: #faf3ea; color: var(--brown-soft);
            font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.08em;
            font-weight: 700; padding: 10px 14px; text-align: left;
            border-bottom: 2px solid #f0e6db;
        }

        tbody td {
            padding: 12px 14px; border-bottom: 1px solid #f5ede4;
            color: var(--brown-main); vertical-align: middle;
        }

        tbody tr:last-child td { border-bottom: none; }

        tbody tr:hover td { background: #fdfaf6; }

        .order-code {
            font-weight: 700; color: var(--accent-dark);
            font-family: monospace; font-size: 0.88rem;
        }

        /* Order status badges */
        .order-status {
            display: inline-block; padding: 3px 10px;
            border-radius: 999px; font-size: 0.78rem; font-weight: 600;
        }
        .status-pending    { background: #fff8e1; color: #f57f17; }
        .status-confirmed  { background: #e3f2fd; color: #1565c0; }
        .status-shipping   { background: #e8eaf6; color: #3949ab; }
        .status-delivered  { background: #e8f5e9; color: #2e7d32; }
        .status-cancelled  { background: #ffebee; color: #c62828; }

        /* Empty state */
        .empty-state {
            text-align: center; padding: 3rem 1rem; color: var(--brown-soft);
        }
        .empty-state i { font-size: 3rem; color: var(--accent); opacity: 0.5; margin-bottom: 1rem; }
        .empty-state p { font-size: 1rem; }

        /* Back button */
        .back-btn {
            display: inline-flex; align-items: center; gap: 6px;
            background: rgba(255,255,255,0.25); color: #fff;
            padding: 7px 16px; border-radius: 999px;
            font-size: 0.88rem; font-weight: 600;
            text-decoration: none; margin-bottom: 1rem;
            transition: background 0.2s;
        }
        .back-btn:hover { background: rgba(255,255,255,0.4); color: #fff; }

        /* Toast */
        #toast {
            display: none; position: fixed; bottom: 30px; right: 30px;
            background: #27ae60; color: #fff;
            padding: 15px 25px; border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15); z-index: 9999; font-weight: 600;
        }

        @media (max-width: 640px) {
            .detail-hero h1 { font-size: 1.8rem; }
            .stats-row { grid-template-columns: repeat(2, 1fr); }
            .detail-wrapper { padding: 0 1rem; }
        }
    </style>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"
            integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
    <script src="${pageContext.request.contextPath}/js/csrf-helper.js"></script>
</head>

<body id="wandave-theme" class="index">
    <!-- HEADER -->
    <%@ include file="partials/header.jsp" %>

    <main>
        <!-- HERO -->
        <section class="detail-hero">
            <div class="detail-hero-inner">
                <a href="${pageContext.request.contextPath}/admin/users" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Quay lại danh sách
                </a>
                <h1><i class="fas fa-user-circle" style="font-size:1.8rem; margin-right:10px;"></i>Chi tiết khách hàng</h1>
                <p>Xem thông tin và lịch sử đơn hàng của khách hàng</p>
            </div>
        </section>

        <!-- Breadcrumb -->
        <div class="breadcrumb-section">
            <nav class="breadcrumb">
                <a href="${pageContext.request.contextPath}/admin">Admin</a>
                <span>/</span>
                <a href="${pageContext.request.contextPath}/admin/users">Khách hàng</a>
                <span>/</span>
                <span>${user.fullname}</span>
            </nav>
        </div>

        <div class="detail-wrapper">

            <!-- STATS ROW -->
            <div class="stats-row">
                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-shopping-bag"></i></div>
                    <div class="stat-value">${orders != null ? orders.size() : 0}</div>
                    <div class="stat-label">Tổng đơn hàng</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-check-circle"></i></div>
                    <div class="stat-value">
                        <c:set var="deliveredCount" value="0"/>
                        <c:forEach var="o" items="${orders}">
                            <c:if test="${o.status == 'delivered'}">
                                <c:set var="deliveredCount" value="${deliveredCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${deliveredCount}
                    </div>
                    <div class="stat-label">Đã giao</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-calendar-alt"></i></div>
                    <div class="stat-value">
                        <c:choose>
                            <c:when test="${user.createdAt != null}">
                                <fmt:formatDate value="${user.createdAt}" pattern="MM/yyyy"/>
                            </c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="stat-label">Ngày tham gia</div>
                </div>
            </div>

            <!-- MAIN GRID -->
            <div class="detail-grid">

                <!-- LEFT: Profile Card -->
                <div style="display:flex; flex-direction:column; gap:20px;">

                    <!-- Avatar + Name -->
                    <div class="card">
                        <div class="profile-avatar-wrap">
                            <c:choose>
                                <c:when test="${not empty user.avatar}">
                                    <img class="profile-avatar"
                                         src="${user.avatar}"
                                         alt="${user.fullname}"
                                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                                    <div class="profile-avatar-placeholder" style="display:none;">
                                        ${user.fullname != null ? user.fullname.substring(0,1).toUpperCase() : 'U'}
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="profile-avatar-placeholder">
                                        ${user.fullname != null ? user.fullname.substring(0,1).toUpperCase() : 'U'}
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <div class="profile-name">${user.fullname}</div>
                            <div class="profile-email">${user.email}</div>

                            <c:choose>
                                <c:when test="${user.status == 'active'}">
                                    <span class="badge badge-active"><i class="fas fa-circle" style="font-size:0.5rem;"></i> Hoạt động</span>
                                </c:when>
                                <c:when test="${user.status == 'banned'}">
                                    <span class="badge badge-banned"><i class="fas fa-ban"></i> Đã cấm</span>
                                </c:when>
                                <c:when test="${user.status == 'inactive'}">
                                    <span class="badge badge-inactive"><i class="fas fa-times-circle"></i> Đã xóa</span>
                                </c:when>
                                <c:when test="${user.status == 'pending'}">
                                    <span class="badge badge-pending"><i class="fas fa-clock"></i> Chờ xác thực</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-inactive">${user.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Thông tin chi tiết -->
                    <div class="card">
                        <div class="card-header">
                            <h3><i class="fas fa-id-card"></i> Thông tin cá nhân</h3>
                        </div>
                        <div class="card-body">
                            <ul class="info-list">
                                <li>
                                    <div class="info-icon"><i class="fas fa-phone"></i></div>
                                    <div>
                                        <div class="info-label">Số điện thoại</div>
                                        <div class="info-value">${not empty user.phone ? user.phone : '—'}</div>
                                    </div>
                                </li>
                                <li>
                                    <div class="info-icon"><i class="fas fa-venus-mars"></i></div>
                                    <div>
                                        <div class="info-label">Giới tính</div>
                                        <div class="info-value">
                                            <c:choose>
                                                <c:when test="${user.gender == 'male'}">Nam</c:when>
                                                <c:when test="${user.gender == 'female'}">Nữ</c:when>
                                                <c:when test="${user.gender == 'other'}">Khác</c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="info-icon"><i class="fas fa-birthday-cake"></i></div>
                                    <div>
                                        <div class="info-label">Ngày sinh</div>
                                        <div class="info-value">
                                            <c:choose>
                                                <c:when test="${user.birthday != null}">
                                                    <fmt:formatDate value="${user.birthday}" pattern="dd/MM/yyyy"/>
                                                </c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="info-icon"><i class="fas fa-shield-alt"></i></div>
                                    <div>
                                        <div class="info-label">Vai trò</div>
                                        <div class="info-value">
                                            <c:choose>
                                                <c:when test="${user.role == 'admin'}">Quản trị viên</c:when>
                                                <c:otherwise>Khách hàng</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="info-icon"><i class="fas fa-clock"></i></div>
                                    <div>
                                        <div class="info-label">Ngày tham gia</div>
                                        <div class="info-value">
                                            <c:choose>
                                                <c:when test="${user.createdAt != null}">
                                                    <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </li>
                                <c:if test="${not empty user.bio}">
                                <li>
                                    <div class="info-icon"><i class="fas fa-align-left"></i></div>
                                    <div>
                                        <div class="info-label">Giới thiệu</div>
                                        <div class="info-value">${user.bio}</div>
                                    </div>
                                </li>
                                </c:if>
                            </ul>
                        </div>
                    </div>

                    <!-- Thao tác -->
                    <c:if test="${user.status != 'inactive'}">
                    <div class="card">
                        <div class="card-header">
                            <h3><i class="fas fa-cog"></i> Thao tác</h3>
                        </div>
                        <div class="card-body">
                            <div class="action-buttons">
                                <c:choose>
                                    <c:when test="${user.status == 'active'}">
                                        <button class="btn btn-warning" data-user-id="${user.id}" onclick="updateStatus(this.dataset.userId, 'banned')">
                                            <i class="fas fa-ban"></i> Cấm tài khoản
                                        </button>
                                        <button class="btn btn-danger" data-user-id="${user.id}" onclick="confirmDelete(this.dataset.userId)">
                                            <i class="fas fa-trash"></i> Xóa tài khoản
                                        </button>
                                    </c:when>
                                    <c:when test="${user.status == 'banned'}">
                                        <button class="btn btn-success" data-user-id="${user.id}" onclick="updateStatus(this.dataset.userId, 'active')">
                                            <i class="fas fa-check-circle"></i> Gỡ cấm
                                        </button>
                                        <button class="btn btn-danger" data-user-id="${user.id}" onclick="confirmDelete(this.dataset.userId)">
                                            <i class="fas fa-trash"></i> Xóa tài khoản
                                        </button>
                                    </c:when>
                                    <c:when test="${user.status == 'pending'}">
                                        <button class="btn btn-primary" data-user-id="${user.id}" onclick="updateStatus(this.dataset.userId, 'active')">
                                            <i class="fas fa-check"></i> Kích hoạt tài khoản
                                        </button>
                                        <button class="btn btn-danger" data-user-id="${user.id}" onclick="confirmDelete(this.dataset.userId)">
                                            <i class="fas fa-trash"></i> Xóa tài khoản
                                        </button>
                                    </c:when>
                                </c:choose>
                                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Quay lại
                                </a>
                            </div>
                        </div>
                    </div>
                    </c:if>

                </div><!-- /LEFT -->

                <!-- RIGHT: Order History -->
                <div class="card">
                    <div class="card-header">
                        <h3><i class="fas fa-history"></i> Lịch sử đơn hàng</h3>
                        <span style="font-size:0.85rem; color:var(--brown-soft); font-weight:600;">
                            ${orders != null ? orders.size() : 0} đơn
                        </span>
                    </div>
                    <div class="card-body" style="padding: 0;">
                        <c:choose>
                            <c:when test="${empty orders}">
                                <div class="empty-state">
                                    <i class="fas fa-shopping-bag"></i>
                                    <p>Khách hàng chưa có đơn hàng nào.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-wrap">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>Mã đơn</th>
                                                <th>Ngày đặt</th>
                                                <th>Người nhận</th>
                                                <th>Tổng tiền</th>
                                                <th>Trạng thái</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="order" items="${orders}">
                                                <tr>
                                                    <td>
                                                        <span class="order-code">#${order.orderCode}</span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${order.createdAt != null}">
                                                                <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy"/>
                                                                <br>
                                                                <small style="color:var(--brown-soft);">
                                                                    <fmt:formatDate value="${order.createdAt}" pattern="HH:mm"/>
                                                                </small>
                                                            </c:when>
                                                            <c:otherwise>—</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div style="font-weight:600;">${order.receiverName}</div>
                                                        <small style="color:var(--brown-soft);">${order.receiverPhone}</small>
                                                    </td>
                                                    <td style="font-weight:700; color:var(--accent-dark);">
                                                        <c:choose>
                                                            <c:when test="${order.totalAmount != null}">
                                                                <fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/> ₫
                                                            </c:when>
                                                            <c:otherwise>—</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${order.status == 'pending'}">
                                                                <span class="order-status status-pending">Chờ xác nhận</span>
                                                            </c:when>
                                                            <c:when test="${order.status == 'confirmed'}">
                                                                <span class="order-status status-confirmed">Đã xác nhận</span>
                                                            </c:when>
                                                            <c:when test="${order.status == 'shipping'}">
                                                                <span class="order-status status-shipping">Đang giao</span>
                                                            </c:when>
                                                            <c:when test="${order.status == 'delivered'}">
                                                                <span class="order-status status-delivered">Đã giao</span>
                                                            </c:when>
                                                            <c:when test="${order.status == 'cancelled'}">
                                                                <span class="order-status status-cancelled">Đã hủy</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="order-status status-pending">${order.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div><!-- /RIGHT -->

            </div><!-- /detail-grid -->
        </div><!-- /detail-wrapper -->
    </main>

    <!-- FOOTER -->
    <%@ include file="partials/footer.jsp" %>

    <script>
        const contextPath = '${pageContext.request.contextPath}';

        function updateStatus(userId, newStatus) {
            const labels = { active: 'kích hoạt', banned: 'cấm', inactive: 'vô hiệu hóa' };
            const statusLabel = labels[newStatus] || newStatus;
            
            showConfirm(
                `Bạn có chắc chắn muốn <strong>${statusLabel}</strong> tài khoản của khách hàng này?`,
                function() {
                    showLoading("Đang cập nhật trạng thái...");
                    fetch(contextPath + '/admin/api/user/update-status', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: 'id=' + userId + '&status=' + newStatus + '&_csrf=' + (window.csrfToken || '')
                    })
                    .then(r => r.json())
                    .then(data => {
                        hideLoading();
                        if (data.success) {
                            showToast('Cập nhật trạng thái thành công!', 'success');
                            setTimeout(() => location.reload(), 1200);
                        } else {
                            showToast(data.message || 'Cập nhật thất bại', 'error');
                        }
                    })
                    .catch((err) => {
                        hideLoading();
                        console.error(err);
                        showToast('Có lỗi xảy ra khi thực hiện yêu cầu!', 'error');
                    });
                },
                null,
                "Xác nhận thay đổi trạng thái",
                "Xác nhận",
                "Hủy"
            );
        }

        function confirmDelete(userId) {
            const userName = "${user.fullname}";
            showConfirm(
                `Bạn có chắc chắn muốn xóa tài khoản của <strong>${userName}</strong>?<br/>Tài khoản này sẽ bị vô hiệu hóa trên hệ thống.`,
                function() {
                    showLoading("Đang vô hiệu hóa tài khoản...");
                    fetch(contextPath + '/admin/api/user/' + userId, {
                        method: 'DELETE',
                        headers: { 'X-CSRF-Token': window.csrfToken || '' }
                    })
                    .then(r => r.json())
                    .then(data => {
                        hideLoading();
                        if (data.success) {
                            showSuccess('Đã vô hiệu hóa tài khoản thành công!', 'Xóa thành công').then(() => {
                                window.location.href = contextPath + '/admin/users';
                            });
                        } else {
                            showToast(data.message || 'Xóa thất bại', 'error');
                        }
                    })
                    .catch((err) => {
                        hideLoading();
                        console.error(err);
                        showToast('Có lỗi xảy ra khi thực hiện yêu cầu!', 'error');
                    });
                },
                null,
                "Xác nhận xóa tài khoản",
                "Vô hiệu hóa ngay",
                "Hủy"
            );
        }
    </script>
</body>
</html>
