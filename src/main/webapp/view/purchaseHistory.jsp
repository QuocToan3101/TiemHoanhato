<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử đơn hàng - Tiệm Hoa nhà tớ</title>
    
    <!-- CSRF Token -->
    <meta name="csrf-token" content="${csrfToken}">
    <script>window.csrfToken = '${csrfToken}';</script>
    
    <link rel="shortcut icon" href="//cdn.hstatic.net/themes/200000846175/1001403720/14/favicon.png?v=245" type="image/x-icon">
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
            --radius-sm: 8px;
            --radius-md: 16px;
            --radius-lg: 24px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            --height-head: 72px;
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
        
        .orders-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 2rem;
            margin-top: calc(var(--height-head) + 20px);
        }
        
        .page-header {
            margin-bottom: 2rem;
        }
        
        .page-header h1 {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            color: var(--brown-main);
            margin-bottom: 0.5rem;
        }
        
        .page-header p {
            color: var(--text-muted);
        }
        
        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
            font-size: 0.9rem;
        }
        
        .breadcrumb a {
            color: var(--text-muted);
            text-decoration: none;
        }
        
        .breadcrumb a:hover {
            color: var(--primary);
        }
        
        .breadcrumb span {
            color: var(--brown-main);
        }
        
        /* Filter Tabs */
        .filter-tabs {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
        }
        
        .filter-tab {
            padding: 0.5rem 1rem;
            background: var(--white);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            font-size: 0.85rem;
            color: var(--brown-soft);
            cursor: pointer;
            transition: var(--transition);
        }
        
        .filter-tab:hover {
            border-color: var(--primary);
            color: var(--primary);
        }
        
        .filter-tab.active {
            background: var(--primary);
            border-color: var(--primary);
            color: white;
        }
        
        /* Order Card */
        .order-card {
            background: var(--white);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-md);
            margin-bottom: 1.5rem;
            overflow: hidden;
        }
        
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 1.5rem;
            background: var(--bg-light);
            border-bottom: 1px solid var(--border-color);
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        .order-code {
            font-weight: 600;
            color: var(--brown-main);
        }
        
        .order-code i {
            color: var(--primary);
            margin-right: 0.5rem;
        }
        
        .order-date {
            font-size: 0.85rem;
            color: var(--text-muted);
        }
        
        .order-status {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.35rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .order-status.pending {
            background: rgba(243, 156, 18, 0.1);
            color: #f39c12;
        }
        
        .order-status.confirmed {
            background: rgba(52, 152, 219, 0.1);
            color: #3498db;
        }
        
        .order-status.processing {
            background: rgba(155, 89, 182, 0.1);
            color: #9b59b6;
        }
        
        .order-status.shipping {
            background: rgba(52, 152, 219, 0.1);
            color: #3498db;
        }
        
        .order-status.delivered {
            background: rgba(39, 174, 96, 0.1);
            color: #27ae60;
        }
        
        .order-status.cancelled {
            background: rgba(231, 76, 60, 0.1);
            color: #e74c3c;
        }
        
        .order-body {
            padding: 1.5rem;
        }
        
        .order-items {
            border-bottom: 1px dashed var(--border-color);
            padding-bottom: 1rem;
            margin-bottom: 1rem;
        }
        
        .order-item {
            display: flex;
            gap: 1rem;
            padding: 0.75rem 0;
        }
        
        .order-item:not(:last-child) {
            border-bottom: 1px solid var(--border-color);
        }
        
        .item-image {
            width: 60px;
            height: 60px;
            border-radius: var(--radius-sm);
            overflow: hidden;
            flex-shrink: 0;
        }
        
        .item-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .item-info {
            flex: 1;
        }
        
        .item-name {
            font-weight: 500;
            color: var(--brown-main);
            margin-bottom: 0.25rem;
        }
        
        .item-quantity {
            font-size: 0.85rem;
            color: var(--text-muted);
        }
        
        .item-price {
            font-weight: 600;
            color: var(--primary-dark);
            white-space: nowrap;
        }
        
        .order-summary {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        .order-total {
            font-size: 1.1rem;
        }
        
        .order-total .label {
            color: var(--text-muted);
            margin-right: 0.5rem;
        }
        
        .order-total .amount {
            font-weight: 700;
            color: var(--primary-dark);
        }
        
        .order-actions {
            display: flex;
            gap: 0.75rem;
        }
        
        .btn {
            padding: 0.5rem 1rem;
            border-radius: var(--radius-sm);
            font-size: 0.85rem;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            border: none;
        }
        
        .btn-outline {
            background: white;
            border: 1px solid var(--border-color);
            color: var(--brown-main);
        }
        
        .btn-outline:hover {
            border-color: var(--primary);
            color: var(--primary);
        }
        
        .btn-primary {
            background: var(--primary);
            color: white;
        }
        
        .btn-primary:hover {
            background: var(--primary-dark);
        }
        
        .btn-danger {
            background: rgba(231, 76, 60, 0.1);
            color: #e74c3c;
        }
        
        .btn-danger:hover {
            background: #e74c3c;
            color: white;
        }
        
        /* Empty State */
        .empty-orders {
            text-align: center;
            padding: 4rem 2rem;
            background: var(--white);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-md);
        }
        
        .empty-orders i {
            font-size: 4rem;
            color: var(--border-color);
            margin-bottom: 1.5rem;
        }
        
        .empty-orders h3 {
            font-family: 'Crimson Text', serif;
            font-size: 1.5rem;
            color: var(--brown-main);
            margin-bottom: 0.5rem;
        }
        
        .empty-orders p {
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
        }
        
        /* Order Detail Modal */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 10000;
            opacity: 0;
            visibility: hidden;
            transition: var(--transition);
        }
        
        .modal-overlay.show {
            opacity: 1;
            visibility: visible;
        }
        
        .modal-content {
            background: var(--white);
            border-radius: var(--radius-lg);
            width: 90%;
            max-width: 600px;
            max-height: 90vh;
            overflow-y: auto;
            transform: scale(0.9);
            transition: var(--transition);
        }
        
        .modal-overlay.show .modal-content {
            transform: scale(1);
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid var(--border-color);
        }
        
        .modal-header h3 {
            font-family: 'Crimson Text', serif;
            font-size: 1.25rem;
        }
        
        .modal-close {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            border: none;
            background: var(--bg-light);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: var(--transition);
        }
        
        .modal-close:hover {
            background: var(--border-color);
        }
        
        .modal-body {
            padding: 1.5rem;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .orders-container {
                padding: 1rem;
            }
            
            .order-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .order-summary {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .order-actions {
                width: 100%;
            }
            
            .order-actions .btn {
                flex: 1;
                justify-content: center;
            }
        }
    </style>
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
    
    <!-- CSRF Token Helper -->
    <script src="${pageContext.request.contextPath}/fileJS/csrf-token.js"></script>
</head>
<body>
    <!-- Header -->
    <%@ include file="partials/header.jsp" %>
    
    <div class="orders-container">
        <!-- Breadcrumb -->
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/view/home.jsp"><i class="fas fa-home"></i></a>
            <i class="fas fa-chevron-right" style="font-size: 0.7rem; color: var(--text-muted);"></i>
            <a href="${pageContext.request.contextPath}/profile">Tài khoản</a>
            <i class="fas fa-chevron-right" style="font-size: 0.7rem; color: var(--text-muted);"></i>
            <span>Đơn hàng của tôi</span>
        </div>
        
        <!-- Page Header -->
        <div class="page-header">
            <h1>Đơn hàng của tôi</h1>
            <p>Quản lý và theo dõi đơn hàng của bạn</p>
        </div>
        
        <!-- Filter Tabs -->
        <div class="filter-tabs">
            <button class="filter-tab active" data-status="all">Tất cả</button>
            <button class="filter-tab" data-status="pending">Chờ xác nhận</button>
            <button class="filter-tab" data-status="confirmed">Đã xác nhận</button>
            <button class="filter-tab" data-status="shipping">Đang giao</button>
            <button class="filter-tab" data-status="delivered">Đã giao</button>
            <button class="filter-tab" data-status="cancelled">Đã hủy</button>
        </div>
        
        <!-- Orders List -->
        <div id="ordersList">
            <c:choose>
                <c:when test="${not empty orders}">
                    <c:forEach var="order" items="${orders}">
                        <div class="order-card" data-status="${order.orderStatus}">
                            <div class="order-header">
                                <div>
                                    <div class="order-code">
                                        <i class="fas fa-receipt"></i>
                                        ${order.orderCode}
                                    </div>
                                    <div class="order-date">
                                        <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                </div>
                                <span class="order-status ${order.orderStatus}">
                                    <c:choose>
                                        <c:when test="${order.orderStatus == 'pending'}">
                                            <i class="fas fa-clock"></i> Chờ xác nhận
                                        </c:when>
                                        <c:when test="${order.orderStatus == 'confirmed'}">
                                            <i class="fas fa-check"></i> Đã xác nhận
                                        </c:when>
                                        <c:when test="${order.orderStatus == 'processing'}">
                                            <i class="fas fa-box"></i> Đang xử lý
                                        </c:when>
                                        <c:when test="${order.orderStatus == 'shipping'}">
                                            <i class="fas fa-truck"></i> Đang giao
                                        </c:when>
                                        <c:when test="${order.orderStatus == 'delivered'}">
                                            <i class="fas fa-check-circle"></i> Đã giao
                                        </c:when>
                                        <c:when test="${order.orderStatus == 'cancelled'}">
                                            <i class="fas fa-times-circle"></i> Đã hủy
                                        </c:when>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="order-body">
                                <div class="order-items">
                                    <c:forEach var="item" items="${order.orderItems}" varStatus="status">
                                        <c:if test="${status.index < 2}">
                                            <div class="order-item">
                                                <div class="item-image">
                                                    <img src="${item.productImage}" alt="${item.productName}">
                                                </div>
                                                <div class="item-info">
                                                    <div class="item-name">${item.productName}</div>
                                                    <div class="item-quantity">x${item.quantity}</div>
                                                </div>
                                                <div class="item-price">
                                                    <fmt:formatNumber value="${item.total}" type="number" groupingUsed="true"/>₫
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${fn:length(order.orderItems) > 2}">
                                        <div style="text-align: center; color: var(--text-muted); font-size: 0.85rem; padding-top: 0.5rem;">
                                            Và ${fn:length(order.orderItems) - 2} sản phẩm khác
                                        </div>
                                    </c:if>
                                </div>
                                <div class="order-summary">
                                    <div class="order-total">
                                        <span class="label">Tổng tiền:</span>
                                        <span class="amount">
                                            <fmt:formatNumber value="${order.total}" type="number" groupingUsed="true"/>₫
                                        </span>
                                    </div>
                                    <div class="order-actions">
                                        <button class="btn btn-outline" onclick="viewOrderDetail('${order.id}')">
                                            <i class="fas fa-eye"></i> Chi tiết
                                        </button>
                                        <c:if test="${order.orderStatus == 'pending'}">
                                            <button class="btn btn-danger" onclick="cancelOrder('${order.id}')">
                                                <i class="fas fa-times"></i> Hủy đơn
                                            </button>
                                        </c:if>
                                        <c:if test="${order.orderStatus == 'delivered'}">
                                            <button class="btn btn-primary" onclick="reorder('${order.id}')">
                                                <i class="fas fa-redo"></i> Mua lại
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-orders">
                        <i class="fas fa-shopping-bag"></i>
                        <h3>Chưa có đơn hàng nào</h3>
                        <p>Bạn chưa có đơn hàng nào. Hãy bắt đầu mua sắm ngay!</p>
                        <a href="${pageContext.request.contextPath}/san-pham" class="btn-shop">
                            <i class="fas fa-shopping-basket"></i>
                            Mua sắm ngay
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <!-- Order Detail Modal -->
    <div class="modal-overlay" id="orderDetailModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Chi tiết đơn hàng</h3>
                <button class="modal-close" onclick="closeModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body" id="orderDetailContent">
                <!-- Content loaded dynamically -->
            </div>
        </div>
    </div>
    
    <!-- Footer -->
    <%@ include file="partials/footer.jsp" %>
    
    <script>
        // Filter tabs
        document.querySelectorAll('.filter-tab').forEach(tab => {
            tab.addEventListener('click', function() {
                document.querySelectorAll('.filter-tab').forEach(t => t.classList.remove('active'));
                this.classList.add('active');
                
                const status = this.dataset.status;
                filterOrders(status);
            });
        });
        
        function filterOrders(status) {
            document.querySelectorAll('.order-card').forEach(card => {
                if (status === 'all' || card.dataset.status === status) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        }
        
        function viewOrderDetail(orderId) {
            // Load order detail via AJAX
            document.getElementById('orderDetailModal').classList.add('show');
            document.getElementById('orderDetailContent').innerHTML = 
                '<div style="text-align: center; padding: 2rem;">' +
                '<i class="fas fa-spinner fa-spin" style="font-size: 2rem; color: var(--primary);"></i>' +
                '<p style="margin-top: 1rem;">Đang tải...</p>' +
                '</div>';
            
            fetch('${pageContext.request.contextPath}/orders/detail/' + orderId)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const order = data.order;
                        let itemsHtml = '';
                        order.orderItems.forEach(item => {
                            itemsHtml += '<div class="order-item">' +
                                '<div class="item-image"><img src="' + item.productImage + '" alt="' + item.productName + '"></div>' +
                                '<div class="item-info">' +
                                '<div class="item-name">' + item.productName + '</div>' +
                                '<div class="item-quantity">x' + item.quantity + '</div>' +
                                '</div>' +
                                '<div class="item-price">' + formatCurrency(item.total) + '</div>' +
                                '</div>';
                        });
                        
                        document.getElementById('orderDetailContent').innerHTML = 
                            '<div class="order-detail-info">' +
                            '<p><strong>Mã đơn hàng:</strong> ' + order.orderCode + '</p>' +
                            '<p><strong>Người nhận:</strong> ' + order.receiverName + '</p>' +
                            '<p><strong>Số điện thoại:</strong> ' + order.receiverPhone + '</p>' +
                            '<p><strong>Địa chỉ:</strong> ' + order.shippingAddress + '</p>' +
                            (order.note ? '<p><strong>Ghi chú:</strong> ' + order.note + '</p>' : '') +
                            '<hr style="margin: 1rem 0; border-color: var(--border-color);">' +
                            '<div class="order-items">' + itemsHtml + '</div>' +
                            '<hr style="margin: 1rem 0; border-color: var(--border-color);">' +
                            '<p><strong>Tạm tính:</strong> ' + formatCurrency(order.subtotal) + '</p>' +
                            '<p><strong>Phí vận chuyển:</strong> ' + formatCurrency(order.shippingFee) + '</p>' +
                            (order.discount > 0 ? '<p><strong>Giảm giá:</strong> -' + formatCurrency(order.discount) + '</p>' : '') +
                            '<p style="font-size: 1.1rem;"><strong>Tổng cộng:</strong> <span style="color: var(--primary-dark); font-weight: 700;">' + formatCurrency(order.total) + '</span></p>' +
                            '</div>';
                    } else {
                        document.getElementById('orderDetailContent').innerHTML = 
                            '<p style="text-align: center; color: var(--error);">' + data.message + '</p>';
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('orderDetailContent').innerHTML = 
                        '<p style="text-align: center; color: var(--error);">Có lỗi xảy ra khi tải dữ liệu</p>';
                });
        }
        
        function closeModal() {
            document.getElementById('orderDetailModal').classList.remove('show');
        }
        
        function cancelOrder(orderId) {
            if (confirm('Bạn có chắc chắn muốn hủy đơn hàng này?')) {
                fetch('${pageContext.request.contextPath}/orders/cancel/' + orderId, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'reason=Khách hàng hủy đơn'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Đã hủy đơn hàng thành công');
                        location.reload();
                    } else {
                        alert(data.message || 'Không thể hủy đơn hàng');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra');
                });
            }
        }
        
        function reorder(orderId) {
            fetch('${pageContext.request.contextPath}/orders/reorder/' + orderId, {
                method: 'POST'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(data.message);
                    window.location.href = '${pageContext.request.contextPath}/cart';
                } else {
                    alert(data.message || 'Không thể thêm sản phẩm vào giỏ');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra');
            });
        }
        
        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN').format(amount) + '₫';
        }
        
        // Close modal on outside click
        document.getElementById('orderDetailModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeModal();
            }
        });
    </script>
</body>
</html>