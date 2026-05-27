<%@ page contentType="text/html; charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:if test="${empty sessionScope.user or sessionScope.user.role ne 'admin'}">
  <c:redirect url="/view/login_1.jsp" />
</c:if>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Dashboard - Tiệm Hoa nhà tớ</title>
    
    <!-- CSRF Token -->
    <meta name="csrf-token" content="${csrfToken}">
    <script>window.csrfToken = '${csrfToken}';</script>
    <script>
      function getCsrfToken() {
        return window.csrfToken || document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') || '';
      }

      function withCsrfHeaders(headers) {
        const csrfToken = getCsrfToken();
        if (!csrfToken) {
          return headers || {};
        }
        return Object.assign({}, headers || {}, { 'X-CSRF-Token': csrfToken });
      }
    </script>

    <!-- Font Awesome -->
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css" />
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
    
    <!-- CSRF Token Helper -->
    <script src="${pageContext.request.contextPath}/js/csrf-helper.js?v=20260527"></script>

    <!-- SweetAlert2 CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.5/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.5/dist/sweetalert2.all.min.js"></script>

    <!-- Notification System Utility -->
    <script src="${pageContext.request.contextPath}/js/notification.js?v=20260527"></script>
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

        <div class="menu-item" data-target="custom-orders">
          <i class="fas fa-magic"></i>
          <span>Đặt Hàng Tùy Chỉnh</span>
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

        <!-- Custom Orders Section -->
        <div id="custom-orders" class="content-section">
          <div class="section-header">
            <div>
              <h2><i class="fas fa-magic"></i> Nhận Đặt Hàng Tùy Chỉnh</h2>
              <p class="text-muted">Quản lý và xử lý các yêu cầu thiết kế hoa riêng từ khách hàng</p>
            </div>
          </div>

          <!-- Filters -->
          <div class="card">
            <div class="card-body">
              <div class="filters">
                <div class="filter-group" style="max-width: 300px;">
                  <label><i class="fas fa-filter"></i> Trạng thái lọc</label>
                  <select id="customOrderStatusFilter" class="form-input" onchange="displayCustomOrders()">
                    <option value="">Tất cả</option>
                    <option value="pending">Chờ duyệt</option>
                    <option value="confirmed">Đã xác nhận</option>
                    <option value="processing">Đang bó hoa</option>
                    <option value="completed">Đã giao</option>
                    <option value="cancelled">Đã hủy</option>
                  </select>
                </div>
              </div>
            </div>
          </div>

          <!-- Table List -->
          <div class="card">
            <div class="card-body" style="padding: 0;">
              <div class="table-container">
                <table class="admin-table">
                  <thead>
                    <tr>
                      <th style="width: 60px;">ID</th>
                      <th>Khách Hàng</th>
                      <th>Cấu Hình Bó Hoa Tùy Chỉnh</th>
                      <th>Ngân Sách & Dự Tính</th>
                      <th>Ghi Chú Khách Hàng</th>
                      <th>Ngày Đặt</th>
                      <th>Trạng Thái</th>
                      <th>Thao Tác Duyệt</th>
                    </tr>
                  </thead>
                  <tbody id="customOrdersTableBody">
                    <tr>
                      <td colspan="8" class="text-center">
                        <div class="loading"></div>
                      </td>
                    </tr>
                  </tbody>
                </table>
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
              <div class="admin-two-column-grid" style="margin-bottom: 30px;">
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
              <div class="admin-two-column-grid">
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
            <div class="admin-two-column-grid">
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
            type="button"
            class="btn btn-secondary"
            onclick="closeModal('productModal')"
          >
            Hủy
          </button>
          <button type="button" class="btn btn-primary" onclick="saveProduct()">
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
            <div class="admin-two-column-grid admin-two-column-grid-tight">
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
          <div class="admin-two-column-grid" style="margin-bottom: 20px;">
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
            
            <div class="admin-two-column-grid admin-two-column-grid-tight">
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
              <label for="newsContent">Nội Dung <span style="color: rgb(222, 156, 156);">*</span></label>
              <textarea id="newsContent" class="form-input" rows="8" placeholder="Nội dung chi tiết bài viết (hỗ trợ HTML)" required></textarea>
              <small style="color: #666;">Có thể sử dụng HTML tags: &lt;p&gt;, &lt;h3&gt;, &lt;strong&gt;, &lt;ul&gt;, &lt;li&gt;, etc.</small>
            </div>
            
            <div class="form-group">
              <label for="newsImageUrl">URL Hình Ảnh <span style="color: rgb(139, 35, 35);">*</span></label>
              <input type="url" id="newsImageUrl" class="form-input" placeholder="https://example.com/image.jpg" required />
            </div>
            
            <div class="admin-two-column-grid admin-two-column-grid-tight">
              <div class="form-group">
                <label for="newsCategory">Danh Mục <span style="color: rgb(157, 109, 109);">*</span></label>
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
            
            <div class="admin-two-column-grid admin-two-column-grid-tight">
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
         JAVASCRIPT DIRECTIVES
         ============================================ -->
    <script>
      const contextPath = "${pageContext.request.contextPath}";
      window.adminUser = {
        fullname: "<c:out value='${user.fullname}' default='Administrator' />",
        role: "Administrator"
      };
    </script>
    <script src="${pageContext.request.contextPath}/js/admin.js?v=20260527"></script>
  </body>
</html>
