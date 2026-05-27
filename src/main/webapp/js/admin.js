/* ==========================================================================
   ADMIN PANEL - PREMIUM JAVASCRIPT CONTROLLER
   Theme: Tiệm Hoa nhà tớ (Warm Gold, Rose Gold & Creamy Cocoa)
   ========================================================================== */

// Global state variables
let revenueChart = null;
let revenueByDayChart = null;
let orderStatusChartInstance = null;

let currentOrders = [];
let currentOrderId = null;
let currentPage = 1;
const ordersPerPage = 10;

let currentProducts = [];
let currentProductPage = 1;
const productsPerPage = 10;
let allCategories = [];

let allCustomers = [];

let allCategoriesData = [];

let allCoupons = [];

let allContacts = [];

let allCustomOrders = [];
let lastFocusedModalElement = null;
let productImageUploadInFlight = false;

function showNotification(title, message, type = "info", options = {}) {
  if (typeof window.showSuccess === "function" &&
      typeof window.showError === "function" &&
      typeof window.showWarning === "function" &&
      typeof window.showInfo === "function") {
    if (type === "success") return window.showSuccess(message, title, options);
    if (type === "error") return window.showError(message, title, options);
    if (type === "warning") return window.showWarning(message, title, options);
    return window.showInfo(message, title, options);
  }

  const fallbackMessage = `${title}: ${message}`;
  if (type === "error") {
    console.error(fallbackMessage);
  } else if (type === "warning") {
    console.warn(fallbackMessage);
  } else {
    console.log(fallbackMessage);
  }

  if (typeof window.alert === "function") {
    window.alert(fallbackMessage);
  }
}

// Basic menu navigation & initialization
document.addEventListener("DOMContentLoaded", function () {
  // Menu items click handler
  document.querySelectorAll(".menu-item[data-target]").forEach((item) => {
    item.setAttribute("role", "button");
    item.setAttribute("tabindex", "0");
    item.addEventListener("click", function () {
      const target = this.getAttribute("data-target");
      showSection(target);

      // Update active menu
      document.querySelectorAll(".menu-item").forEach((m) => m.classList.remove("active"));
      this.classList.add("active");
    });

    item.addEventListener("keydown", function (e) {
      if (e.key === "Enter" || e.key === " ") {
        e.preventDefault();
        this.click();
      }
    });
  });

  const bindFormSubmit = (formId, handler) => {
    const form = document.getElementById(formId);
    if (!form) return;
    form.addEventListener("submit", function (e) {
      e.preventDefault();
      handler();
    });
  };

  bindFormSubmit("productForm", saveProduct);
  bindFormSubmit("galleryForm", saveGallery);
  bindFormSubmit("newsForm", saveNews);

  // Enter key for global search
  const globalSearch = document.getElementById("globalSearch");
  if (globalSearch) {
    globalSearch.addEventListener("keypress", function (e) {
      if (e.key === "Enter") {
        const query = this.value.trim().toLowerCase();
        handleGlobalSearch(query);
      }
    });
  }

  // Load dashboard on initial load
  const dashboardSection = document.getElementById("dashboard");
  if (dashboardSection && dashboardSection.classList.contains("active")) {
    loadDashboard();
  }
});

// Show section function with fluid transition
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
    "custom-orders": "Đặt Hàng Tùy Chỉnh",
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
  if (sectionId === 'dashboard') {
    loadDashboard();
  } else if (sectionId === 'orders') {
    loadOrders(1);
  } else if (sectionId === 'custom-orders') {
    loadCustomOrders();
  } else if (sectionId === 'products') {
    loadCategories();
    loadProducts(1);
  } else if (sectionId === 'categories') {
    loadCategoriesTable();
  } else if (sectionId === 'customers') {
    loadCustomers();
  } else if (sectionId === 'coupons') {
    loadCoupons();
  } else if (sectionId === 'contacts') {
    loadContacts();
  } else if (sectionId === 'gallery') {
    loadGalleries();
  } else if (sectionId === 'news') {
    loadNews();
  } else if (sectionId === 'analytics') {
    setTimeout(() => loadAnalytics(), 100);
  } else if (sectionId === 'settings') {
    setTimeout(() => loadSettings(), 100);
  }
}

// Global search fallback routing
function handleGlobalSearch(query) {
  if (!query) return;
  const activeSection = document.querySelector(".content-section.active");
  if (activeSection) {
    const id = activeSection.getAttribute("id");
    if (id === "orders") {
      const orderSearch = document.getElementById("orderSearchInput");
      if (orderSearch) {
        orderSearch.value = query;
        searchOrders();
      }
    } else if (id === "products") {
      const productSearch = document.getElementById("productSearchInput");
      if (productSearch) {
        productSearch.value = query;
        searchProducts();
      }
    } else if (id === "customers") {
      const customerSearch = document.getElementById("customerSearchInput");
      if (customerSearch) {
        customerSearch.value = query;
        searchCustomers();
      }
    } else {
      showNotification("Tìm kiếm", `Tìm kiếm "${query}" trên phân mục này...`, "info");
    }
  }
}

// ==========================================================================
// FORMATTER UTILITIES
// ==========================================================================
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
  if (!dateString) return "N/A";
  const date = new Date(dateString);
  return date.toLocaleDateString("vi-VN", {
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
  });
}

function formatDateTime(dateString) {
  if (!dateString) return "N/A";
  const date = new Date(dateString);
  return date.toLocaleString("vi-VN", {
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
}

// ==========================================================================
// MODAL UTILITIES
// ==========================================================================
function openModal(modalId) {
  const modal = document.getElementById(modalId);
  if (modal) {
    lastFocusedModalElement = document.activeElement instanceof HTMLElement ? document.activeElement : null;
    modal.classList.add("show");
    document.body.classList.add("modal-open");

    window.requestAnimationFrame(() => {
      const focusTarget = modal.querySelector('input:not([type="hidden"]), select, textarea, button, [tabindex]:not([tabindex="-1"])');
      if (focusTarget && typeof focusTarget.focus === "function") {
        focusTarget.focus();
      }
    });
  }
}

function closeModal(modalId) {
  const modal = document.getElementById(modalId);
  if (modal) {
    modal.classList.remove("show");
    if (!document.querySelector(".modal-overlay.show")) {
      document.body.classList.remove("modal-open");
    }
    if (lastFocusedModalElement && typeof lastFocusedModalElement.focus === "function") {
      lastFocusedModalElement.focus();
      lastFocusedModalElement = null;
    }
  }
}

function getModalPrimaryButton(modalId) {
  const modal = document.getElementById(modalId);
  if (!modal) return null;
  return modal.querySelector(".modal-footer .btn-primary");
}

function setModalPrimaryButtonLoading(modalId, isLoading, loadingText = "Đang xử lý...") {
  const button = getModalPrimaryButton(modalId);
  if (!button) return;

  if (isLoading) {
    if (!button.dataset.originalHtml) {
      button.dataset.originalHtml = button.innerHTML;
    }
    button.disabled = true;
    button.setAttribute("aria-busy", "true");
    button.innerHTML = `<i class="fas fa-spinner fa-spin"></i> ${loadingText}`;
    return;
  }

  if (button.dataset.originalHtml) {
    button.innerHTML = button.dataset.originalHtml;
    delete button.dataset.originalHtml;
  }
  button.disabled = false;
  button.removeAttribute("aria-busy");
}

document.addEventListener("keydown", function (e) {
  if (e.key !== "Escape") return;

  const openModals = Array.from(document.querySelectorAll(".modal-overlay.show"));
  if (!openModals.length) return;

  const topModal = openModals[openModals.length - 1];
  if (topModal && topModal.id) {
    closeModal(topModal.id);
  }
});

// Close modal on overlay click
document.addEventListener("click", function (e) {
  if (e.target.classList.contains("modal-overlay")) {
    e.target.classList.remove("show");
  }
});

// ==========================================================================
// DASHBOARD FUNCTIONALITY
// ==========================================================================
function loadDashboard() {
  loadStatistics();
  loadRevenueChart();
  loadRecentOrders();
  loadTopProducts();
}

async function loadStatistics() {
  try {
    const response = await fetch(contextPath + "/admin/api/stats");
    if (!response.ok) throw new Error("Failed to load statistics");

    const result = await response.json();
    const data = result.data || result;

    // Update stat cards
    document.getElementById("statTotalOrders").textContent = formatNumber(data.totalOrders || 0);
    document.getElementById("statTotalRevenue").textContent = formatCurrency(data.totalRevenue || 0);
    document.getElementById("statTotalUsers").textContent = formatNumber(data.totalUsers || 0);
    document.getElementById("statTotalProducts").textContent = formatNumber(data.totalProducts || 0);

    // Update order status overview
    document.getElementById("pendingOrders").textContent = formatNumber(data.pendingOrders || 0);
    document.getElementById("shippingOrders").textContent = formatNumber(data.shippingOrders || 0);
    document.getElementById("deliveredOrders").textContent = formatNumber(data.deliveredOrders || 0);
    document.getElementById("cancelledOrders").textContent = formatNumber(data.cancelledOrders || 0);
  } catch (error) {
    console.error("Error loading statistics:", error);
    showNotification("Lỗi", "Không thể tải thống kê: " + error.message, "error");
  }
}

async function loadRevenueChart() {
  try {
    const periodSelect = document.getElementById("revenueChartPeriod");
    const period = periodSelect ? periodSelect.value : "7";
    const response = await fetch(contextPath + "/admin/api/revenue?period=" + period);

    if (!response.ok) {
      throw new Error("Failed to load revenue data");
    }

    const data = await response.json();
    const result = data.data || data;

    // Prepare chart data
    const labels = result.map((item) => item.label || item.date);
    const revenues = result.map((item) => parseFloat(item.revenue) || 0);

    // Destroy existing chart if exists
    if (revenueChart) {
      revenueChart.destroy();
    }

    // Create new custom styled chart
    const ctx = document.getElementById("revenueChart").getContext("2d");
    
    // Add golden gradient
    const gradient = ctx.createLinearGradient(0, 0, 0, 300);
    gradient.addColorStop(0, 'rgba(201, 147, 102, 0.4)');
    gradient.addColorStop(1, 'rgba(201, 147, 102, 0.01)');

    revenueChart = new Chart(ctx, {
      type: "line",
      data: {
        labels: labels,
        datasets: [
          {
            label: "Doanh Thu",
            data: revenues,
            borderColor: "#c99366",
            backgroundColor: gradient,
            borderWidth: 3,
            fill: true,
            tension: 0.4,
            pointRadius: 4,
            pointBackgroundColor: "#c99366",
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
            backgroundColor: '#3c2922',
            titleColor: '#fff',
            bodyColor: '#fff',
            borderColor: '#c99366',
            borderWidth: 1,
            padding: 12,
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
              color: '#6c5845',
              font: {
                family: 'Inter'
              }
            },
            grid: {
              color: "rgba(232, 223, 213, 0.5)",
            },
          },
          x: {
            ticks: {
              color: '#6c5845',
              font: {
                family: 'Inter'
              }
            },
            grid: {
              display: false,
            },
          },
        },
      },
    });
  } catch (error) {
    console.error("Error loading revenue chart:", error);
    createSampleChart();
  }
}

// Fallback sample charts
function createSampleChart() {
  const ctx = document.getElementById("revenueChart").getContext("2d");
  const labels = ["T1", "T2", "T3", "T4", "T5", "T6", "T7", "T8", "T9", "T10", "T11", "T12"];
  const revenues = [15000000, 18000000, 22000000, 25000000, 28000000, 32000000, 30000000, 35000000, 38000000, 42000000, 45000000, 48000000];

  if (revenueChart) {
    revenueChart.destroy();
  }

  const gradient = ctx.createLinearGradient(0, 0, 0, 300);
  gradient.addColorStop(0, 'rgba(201, 147, 102, 0.4)');
  gradient.addColorStop(1, 'rgba(201, 147, 102, 0.01)');

  revenueChart = new Chart(ctx, {
    type: "line",
    data: {
      labels: labels,
      datasets: [
        {
          label: "Doanh Thu",
          data: revenues,
          borderColor: "#c99366",
          backgroundColor: gradient,
          borderWidth: 3,
          fill: true,
          tension: 0.4,
          pointRadius: 4,
          pointBackgroundColor: "#c99366",
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
          backgroundColor: '#3c2922',
          titleColor: '#fff',
          bodyColor: '#fff',
          borderColor: '#c99366',
          borderWidth: 1,
          padding: 12,
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
            color: '#6c5845'
          },
          grid: {
            color: "rgba(232, 223, 213, 0.5)",
          },
        },
        x: {
          ticks: {
            color: '#6c5845'
          },
          grid: {
            display: false,
          },
        },
      },
    },
  });
}

async function loadRecentOrders() {
  try {
    const response = await fetch(contextPath + "/admin/api/orders");
    if (!response.ok) throw new Error("Failed to load orders");

    const result = await response.json();
    const allOrders = result.data || result;
    const orders = Array.isArray(allOrders) ? allOrders.slice(0, 5) : [];
    const tbody = document.querySelector("#recentOrdersTable tbody");

    if (!orders || orders.length === 0) {
      tbody.innerHTML = '<tr><td colspan="4" class="text-center">Chưa có đơn hàng nào</td></tr>';
      return;
    }

    tbody.innerHTML = orders
      .map((order) => {
        const customerName = order.receiverName || order.fullname || (order.user ? order.user.fullname : null) || "N/A";
        return (
          "<tr>" +
          "<td><strong>#" + (order.orderCode || order.id) + "</strong></td>" +
          "<td>" + customerName + "</td>" +
          "<td><strong>" + formatCurrency(order.total || order.totalPrice || 0) + "</strong></td>" +
          "<td>" +
          '<span class="badge badge-' + getStatusClass(order.orderStatus || order.status) + '">' +
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
    tbody.innerHTML = '<tr><td colspan="4" class="text-center text-danger">Không thể tải dữ liệu</td></tr>';
  }
}

async function loadTopProducts() {
  try {
    const response = await fetch(contextPath + "/admin/api/products/top?limit=5");
    if (!response.ok) throw new Error("Failed to load top products");

    const result = await response.json();
    const products = result.data || [];
    const tbody = document.querySelector("#topProductsTable tbody");

    if (!products || products.length === 0) {
      tbody.innerHTML = '<tr><td colspan="3" class="text-center">Chưa có dữ liệu</td></tr>';
      return;
    }

    tbody.innerHTML = products
      .map((product) => {
        const soldCount = product.soldCount || 0;
        const price = product.price || 0;
        const revenue = soldCount * price;
        
        return (
          "<tr>" +
          "<td>" + (product.name || 'N/A') + "</td>" +
          "<td><strong>" + formatNumber(soldCount) + "</strong></td>" +
          "<td><strong>" + formatCurrency(revenue) + "</strong></td>" +
          "</tr>"
        );
      })
      .join("");
  } catch (error) {
    console.error("Error loading top products:", error);
    const tbody = document.querySelector("#topProductsTable tbody");
    tbody.innerHTML = '<tr><td colspan="3" class="text-center text-danger">Không thể tải dữ liệu</td></tr>';
  }
}

function getStatusClass(status) {
  const statusMap = {
    pending: "warning",
    shipping: "info",
    delivered: "success",
    cancelled: "danger",
    processing: "primary",
    confirmed: "info",
    new: "primary",
    read: "info",
    replied: "success",
    active: "success",
    banned: "danger",
  };
  return statusMap[status?.toLowerCase()] || "secondary";
}

function getStatusText(status) {
  const statusMap = {
    pending: "Chờ xử lý",
    shipping: "Đang giao",
    delivered: "Đã giao",
    cancelled: "Đã hủy",
    processing: "Đang xử lý",
    confirmed: "Đã xác nhận",
    new: "Mới",
    read: "Đã đọc",
    replied: "Đã trả lời",
    active: "Hoạt động",
    banned: "Đã khóa",
  };
  return statusMap[status?.toLowerCase()] || status;
}

// Chart period change handler binding
document.addEventListener("DOMContentLoaded", function () {
  const chartPeriodSelect = document.getElementById("revenueChartPeriod");
  if (chartPeriodSelect) {
    chartPeriodSelect.addEventListener("change", loadRevenueChart);
  }
});

// ==========================================================================
// ORDERS MANAGEMENT FUNCTIONALITY
// ==========================================================================
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

    const response = await fetch(contextPath + "/admin/api/orders?" + params.toString());
    if (!response.ok) throw new Error("Failed to load orders");

    const result = await response.json();
    currentOrders = result.data || result || [];
    displayOrders();
    displayOrdersPagination();
  } catch (error) {
    console.error("Error loading orders:", error);
    const tbody = document.querySelector("#ordersTable tbody");
    tbody.innerHTML = '<tr><td colspan="7" class="text-center text-danger">Không thể tải dữ liệu</td></tr>';
    showNotification("Lỗi", "Không thể tải danh sách đơn hàng", "error");
  }
}

function displayOrders() {
  const tbody = document.querySelector("#ordersTable tbody");
  const start = (currentPage - 1) * ordersPerPage;
  const end = start + ordersPerPage;
  const pageOrders = currentOrders.slice(start, end);

  if (pageOrders.length === 0) {
    tbody.innerHTML = '<tr><td colspan="7" class="text-center">Không có đơn hàng nào</td></tr>';
    return;
  }

  tbody.innerHTML = pageOrders
    .map((order) => {
      const customerName = order.receiverName || order.fullname || (order.user ? order.user.fullname : null) || "N/A";
      const phone = order.receiverPhone || order.phone || (order.user ? order.user.phone : null) || "N/A";
      return (
        "<tr>" +
        "<td><strong>#" + (order.orderCode || order.id) + "</strong></td>" +
        "<td>" + customerName + "</td>" +
        "<td>" + phone + "</td>" +
        "<td>" + formatDateTime(order.createdAt || order.orderDate) + "</td>" +
        "<td><strong>" + formatCurrency(order.total || order.totalPrice || 0) + "</strong></td>" +
        "<td>" +
        '<span class="badge badge-' + getStatusClass(order.orderStatus || order.status) + '">' +
        getStatusText(order.orderStatus || order.status) +
        "</span>" +
        "</td>" +
        "<td>" +
        '<div class="action-buttons">' +
        '<button class="btn btn-light btn-sm" onclick="viewOrderDetail(' + order.id + ')" title="Xem chi tiết">' +
        '<i class="fas fa-eye" style="color: var(--primary);"></i>' +
        "</button>" +
        '<button class="btn btn-light btn-sm" onclick="quickUpdateStatus(' + order.id + ')" title="Cập nhật trạng thái">' +
        '<i class="fas fa-edit" style="color: var(--warning-dark);"></i>' +
        "</button>" +
        "</div>" +
        "</td>" +
        "</tr>"
      );
    })
    .map((html) => html.replace(/class="btn btn-warning btn-sm"/g, 'class="btn btn-light btn-sm"').replace(/class="btn btn-primary btn-sm"/g, 'class="btn btn-light btn-sm"'))
    .join("");
}

function displayOrdersPagination() {
  const totalPages = Math.ceil(currentOrders.length / ordersPerPage);
  const pagination = document.getElementById("ordersPagination");

  if (totalPages <= 1) {
    pagination.innerHTML = "";
    return;
  }

  let html = "";
  const prevDisabled = currentPage === 1 ? "disabled" : "";
  html += `<button class="pagination-btn" ${prevDisabled} onclick="loadOrders(${currentPage - 1})"><i class="fas fa-chevron-left"></i></button>`;

  for (let i = 1; i <= totalPages; i++) {
    if (i === 1 || i === totalPages || (i >= currentPage - 2 && i <= currentPage + 2)) {
      const activeClass = i === currentPage ? "active" : "";
      html += `<button class="pagination-btn ${activeClass}" onclick="loadOrders(${i})">${i}</button>`;
    } else if (i === currentPage - 3 || i === currentPage + 3) {
      html += '<span class="pagination-dots">...</span>';
    }
  }

  const nextDisabled = currentPage === totalPages ? "disabled" : "";
  html += `<button class="pagination-btn" ${nextDisabled} onclick="loadOrders(${currentPage + 1})"><i class="fas fa-chevron-right"></i></button>`;

  pagination.innerHTML = html;
}

function searchOrders() {
  loadOrders(1);
}

function resetOrderFilters() {
  document.getElementById("orderSearchInput").value = "";
  document.getElementById("orderStatusFilter").value = "";
  document.getElementById("orderDateFrom").value = "";
  document.getElementById("orderDateTo").value = "";
  loadOrders(1);
}

async function viewOrderDetail(orderId) {
  try {
    const response = await fetch(contextPath + "/admin/api/order/" + orderId);
    if (!response.ok) throw new Error("Failed to load order details");

    const result = await response.json();
    const order = result.data || result;
    currentOrderId = orderId;

    // Populate modal details
    document.getElementById("modalOrderId").textContent = order.orderCode || order.id;
    document.getElementById("orderDetailCustomerName").textContent = order.receiverName || order.fullname || "N/A";
    document.getElementById("orderDetailPhone").textContent = order.receiverPhone || order.phone || "N/A";
    document.getElementById("orderDetailEmail").textContent = order.receiverEmail || order.email || (order.user ? order.user.email : null) || "N/A";
    document.getElementById("orderDetailAddress").textContent = order.shippingAddress || order.address || "N/A";
    document.getElementById("orderDetailDate").textContent = formatDateTime(order.createdAt || order.orderDate);

    const statusBadge = document.getElementById("orderDetailStatus");
    statusBadge.textContent = getStatusText(order.orderStatus || order.status);
    statusBadge.className = "badge badge-" + getStatusClass(order.orderStatus || order.status);

    document.getElementById("orderDetailPaymentMethod").textContent = getPaymentMethodText(order.paymentMethod);
    document.getElementById("orderDetailNote").textContent = order.note || "Không có";

    // Itemized table load
    const itemsTable = document.getElementById("orderDetailItems");
    const items = order.orderItems || order.items || [];
    if (items.length > 0) {
      itemsTable.innerHTML = items
        .map((item) => {
          const productName = item.productName || (item.product ? item.product.name : null) || "N/A";
          return (
            "<tr>" +
            "<td>" + productName + "</td>" +
            "<td>" + formatCurrency(item.price) + "</td>" +
            "<td>" + item.quantity + "</td>" +
            "<td><strong>" + formatCurrency(item.total || item.price * item.quantity) + "</strong></td>" +
            "</tr>"
          );
        })
        .join("");
    } else {
      itemsTable.innerHTML = '<tr><td colspan="4" class="text-center">Không có sản phẩm nào</td></tr>';
    }

    // Totals calculations
    const subtotal = order.subtotal || items.reduce((sum, item) => sum + (item.total || item.price * item.quantity), 0);
    const shipping = order.shippingFee || 30000;
    const discount = order.discount || 0;

    document.getElementById("orderDetailSubtotal").textContent = formatCurrency(subtotal);
    document.getElementById("orderDetailShipping").textContent = formatCurrency(shipping);
    document.getElementById("orderDetailDiscount").textContent = discount > 0 ? "-" + formatCurrency(discount) : formatCurrency(0);
    document.getElementById("orderDetailTotal").textContent = formatCurrency(order.total || order.totalPrice || 0);

    openModal("orderDetailModal");
  } catch (error) {
    console.error("Error loading order details:", error);
    showNotification("Lỗi", "Không thể tải chi tiết đơn hàng", "error");
  }
}

function getPaymentMethodText(method) {
  const methodMap = {
    cod: "Thanh toán khi nhận hàng (COD)",
    bank: "Chuyển khoản ngân hàng",
    vnpay: "Thanh toán trực tuyến (VNPay)",
    zalopay: "ZaloPay",
  };
  return methodMap[method?.toLowerCase()] || method || "COD";
}

function quickUpdateStatus(orderId) {
  currentOrderId = orderId;
  document.getElementById("updateStatusOrderId").textContent = orderId;
  document.getElementById("newOrderStatus").value = "";
  document.getElementById("statusNote").value = "";
  openModal("updateStatusModal");
}

function openUpdateStatusModal() {
  closeModal("orderDetailModal");
  document.getElementById("updateStatusOrderId").textContent = currentOrderId;
  document.getElementById("newOrderStatus").value = "";
  document.getElementById("statusNote").value = "";
  openModal("updateStatusModal");
}

async function updateOrderStatus() {
  const newStatus = document.getElementById("newOrderStatus").value;
  const note = document.getElementById("statusNote").value;

  if (!newStatus) {
    showNotification("Cảnh báo", "Vui lòng chọn trạng thái mới", "warning");
    return;
  }

  try {
    setModalPrimaryButtonLoading("updateStatusModal", true, "Đang cập nhật...");
    const params = new URLSearchParams();
    params.append("id", currentOrderId);
    params.append("status", newStatus);
    if (note) params.append("note", note);

    const response = await fetch(contextPath + "/admin/api/order/update-status", {
      method: "POST",
      headers: withCsrfHeaders({
        'Content-Type': 'application/x-www-form-urlencoded'
      }),
      body: params.toString()
    });

    const result = await response.json();
    if (!result.success) throw new Error(result.message || "Failed to update status");

    showNotification("Thành công", "Đã cập nhật trạng thái đơn hàng!", "success");
    const updatedOrder = currentOrders.find((order) => String(order.id) === String(currentOrderId));
    if (updatedOrder) {
      updatedOrder.status = newStatus;
      updatedOrder.orderStatus = newStatus;
    }
    displayOrders();
    displayOrdersPagination();
    closeModal("updateStatusModal");
    await loadStatistics();
  } catch (error) {
    console.error("Error updating status:", error);
    showNotification("Lỗi", error.message || "Không thể cập nhật trạng thái", "error");
  } finally {
    setModalPrimaryButtonLoading("updateStatusModal", false);
  }
}

function exportOrders() {
  exportOrdersToExcel();
}

// Order listener binding for pagination search
document.addEventListener("DOMContentLoaded", function () {
  const ordersMenuItem = document.querySelector('.menu-item[data-target="orders"]');
  if (ordersMenuItem) {
    ordersMenuItem.addEventListener("click", () => {
      setTimeout(() => loadOrders(1), 100);
    });
  }

  const searchInput = document.getElementById("orderSearchInput");
  if (searchInput) {
    searchInput.addEventListener("keypress", function (e) {
      if (e.key === "Enter") searchOrders();
    });
  }
});

// ==========================================================================
// PRODUCTS MANAGEMENT FUNCTIONALITY
// ==========================================================================
async function loadProducts(page = 1) {
  try {
    currentProductPage = page;
    const params = new URLSearchParams();

    const search = document.getElementById("productSearchInput")?.value;
    const category = document.getElementById("productCategoryFilter")?.value;
    const status = document.getElementById("productStatusFilter")?.value;

    if (search) params.append("search", search);
    if (category) params.append("categoryId", category);
    if (status) params.append("status", status);

    const response = await fetch(contextPath + "/admin/api/products?" + params.toString());
    if (!response.ok) throw new Error("Failed to load products");

    const result = await response.json();
    currentProducts = result.data || result || [];
    displayProducts();
    displayProductsPagination();
  } catch (error) {
    console.error("Error loading products:", error);
    const tbody = document.querySelector("#productsTable tbody");
    tbody.innerHTML = '<tr><td colspan="8" class="text-center text-danger">Không thể tải dữ liệu</td></tr>';
    showNotification("Lỗi", "Không thể tải danh sách sản phẩm", "error");
  }
}

async function loadCategories() {
  try {
    const response = await fetch(contextPath + "/admin/api/categories");
    if (!response.ok) throw new Error("Failed to load categories");

    const result = await response.json();
    allCategories = result.data || result || [];

    const filterSelect = document.getElementById("productCategoryFilter");
    if (filterSelect) {
      filterSelect.innerHTML = '<option value="">Tất cả danh mục</option>' +
        allCategories.map(cat => `<option value="${cat.id}">${cat.name}</option>`).join("");
    }

    const formSelect = document.getElementById("productCategory");
    if (formSelect) {
      formSelect.innerHTML = '<option value="">-- Chọn danh mục --</option>' +
        allCategories.map(cat => `<option value="${cat.id}">${cat.name}</option>`).join("");
    }
  } catch (error) {
    console.error("Error loading categories:", error);
  }
}

function displayProducts() {
  const tbody = document.querySelector("#productsTable tbody");
  const start = (currentProductPage - 1) * productsPerPage;
  const end = start + productsPerPage;
  const pageProducts = currentProducts.slice(start, end);

  if (pageProducts.length === 0) {
    tbody.innerHTML = '<tr><td colspan="8" class="text-center">Không có sản phẩm nào</td></tr>';
    return;
  }

  tbody.innerHTML = pageProducts
    .map((product) => {
      const placeholderImage = 'data:image/svg+xml,%3Csvg xmlns="http://www.w3.org/2000/svg" width="50" height="50" viewBox="0 0 50 50"%3E%3Crect width="50" height="50" fill="%23f7ede2"/%3E%3Ctext x="25" y="28" font-family="Outfit" font-size="10" fill="%23c99366" text-anchor="middle"%3ENo Image%3C/text%3E%3C/svg%3E';
      const imageUrl = product.image ? (contextPath + "/" + product.image) : placeholderImage;
      const categoryName = (product.category ? product.category.name : null) ||
        (allCategories.find((c) => c.id === product.categoryId)?.name) || "N/A";
      
      const stockStatus = product.quantity > 0
        ? '<span class="badge badge-success">Còn hàng</span>'
        : '<span class="badge badge-danger">Hết hàng</span>';

      const productNameEscaped = product.name.replace(/'/g, "\\'");

      return (
        "<tr>" +
        "<td><strong>" + product.id + "</strong></td>" +
        "<td>" +
        '<img src="' + imageUrl + '" ' +
        'alt="' + product.name + '" ' +
        'style="width: 44px; height: 44px; object-fit: cover; border-radius: 8px; border: 1px solid var(--border);" ' +
        'onerror="this.src=\'' + placeholderImage + '\'">' +
        "</td>" +
        "<td>" + product.name + "</td>" +
        "<td>" + categoryName + "</td>" +
        "<td><strong>" + formatCurrency(product.price) + "</strong></td>" +
        "<td>" + stockStatus + " <strong>(" + product.quantity + ")</strong></td>" +
        "<td>" + formatNumber(product.soldCount || 0) + "</td>" +
        "<td>" +
        '<div class="action-buttons">' +
        '<button class="btn btn-light btn-sm" onclick="openEditProductModal(' + product.id + ')" title="Sửa">' +
        '<i class="fas fa-edit" style="color: var(--primary);"></i>' +
        "</button>" +
        '<button class="btn btn-light btn-sm" onclick="openDeleteProductModal(' + product.id + ", '" + productNameEscaped + '\')" title="Xóa">' +
        '<i class="fas fa-trash" style="color: var(--danger);"></i>' +
        "</button>" +
        '</div>' +
        "</td>" +
        "</tr>"
      );
    })
    .join("");
}

function displayProductsPagination() {
  const totalPages = Math.ceil(currentProducts.length / productsPerPage);
  const pagination = document.getElementById("productsPagination");

  if (totalPages <= 1) {
    pagination.innerHTML = "";
    return;
  }

  let html = "";
  const prevDisabled = currentProductPage === 1 ? "disabled" : "";
  html += `<button class="pagination-btn" ${prevDisabled} onclick="loadProducts(${currentProductPage - 1})"><i class="fas fa-chevron-left"></i></button>`;

  for (let i = 1; i <= totalPages; i++) {
    if (i === 1 || i === totalPages || (i >= currentProductPage - 2 && i <= currentProductPage + 2)) {
      const activeClass = i === currentProductPage ? "active" : "";
      html += `<button class="pagination-btn ${activeClass}" onclick="loadProducts(${i})">${i}</button>`;
    } else if (i === currentProductPage - 3 || i === currentProductPage + 3) {
      html += '<span class="pagination-dots">...</span>';
    }
  }

  const nextDisabled = currentProductPage === totalPages ? "disabled" : "";
  html += `<button class="pagination-btn" ${nextDisabled} onclick="loadProducts(${currentProductPage + 1})"><i class="fas fa-chevron-right"></i></button>`;

  pagination.innerHTML = html;
}

function searchProducts() {
  loadProducts(1);
}

function resetProductFilters() {
  document.getElementById("productSearchInput").value = "";
  document.getElementById("productCategoryFilter").value = "";
  document.getElementById("productStatusFilter").value = "";
  loadProducts(1);
}

function openAddProductModal() {
  document.getElementById("productModalTitle").textContent = "Thêm Sản Phẩm";
  document.getElementById("productForm").reset();
  document.getElementById("productId").value = "";
  document.getElementById("imagePreview").style.display = "none";
  openModal("productModal");
}

async function handleImageSelect(event) {
  const file = event.target.files[0];
  if (!file) return;

  const validTypes = ["image/jpeg", "image/jpg", "image/png", "image/gif", "image/webp"];
  if (!validTypes.includes(file.type)) {
    showNotification("Lỗi", "Chỉ chấp nhận file ảnh (JPG, PNG, GIF, WEBP)", "error");
    event.target.value = "";
    return;
  }

  const maxSize = 10 * 1024 * 1024;
  if (file.size > maxSize) {
    showNotification("Lỗi", "Kích thước file không được vượt quá 10MB", "error");
    event.target.value = "";
    return;
  }

  const reader = new FileReader();
  reader.onload = function (e) {
    document.getElementById("previewImg").src = e.target.result;
    document.getElementById("imagePreview").style.display = "block";
  };
  reader.readAsDataURL(file);

  await uploadImage(file);
}

async function uploadImage(file) {
  const formData = new FormData();
  formData.append("file", file);
  formData.append("type", "product");

  const csrfToken = window.csrfToken || document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
  if (csrfToken) formData.append("csrfToken", csrfToken);

  productImageUploadInFlight = true;
  try {
    showNotification("Đang tải...", "Đang upload ảnh lên server...", "info");

    const response = await fetch(contextPath + "/api/upload-image", {
      method: "POST",
      headers: csrfToken ? { 'X-CSRF-Token': csrfToken } : {},
      body: formData,
    });

    const contentType = response.headers.get("content-type") || "";
    const result = contentType.includes("application/json")
      ? await response.json()
      : { success: false, message: await response.text() };

    if (!response.ok && !result.message) {
      throw new Error(`Upload failed with status ${response.status}`);
    }

    if (result.success) {
      document.getElementById("productImage").value = result.url;
      showNotification("Thành công", "Upload ảnh thành công!", "success");
    } else {
      showNotification("Lỗi", result.message || "Upload ảnh thất bại", "error");
      clearImage();
    }
  } catch (error) {
    console.error("Error uploading image:", error);
    showNotification("Lỗi", "Không thể upload ảnh: " + error.message, "error");
    clearImage();
  } finally {
    productImageUploadInFlight = false;
  }
}

function clearImage() {
  document.getElementById("productImageFile").value = "";
  document.getElementById("productImage").value = "";
  document.getElementById("imagePreview").style.display = "none";
  document.getElementById("previewImg").src = "";
  productImageUploadInFlight = false;
}

async function openEditProductModal(productId) {
  try {
    const response = await fetch(contextPath + "/admin/api/product/" + productId);
    if (!response.ok) throw new Error("Failed to load product details");

    const result = await response.json();
    const product = result.data || result;

    document.getElementById("productModalTitle").textContent = "Sửa Sản Phẩm";
    document.getElementById("productId").value = product.id;
    document.getElementById("productName").value = product.name;
    document.getElementById("productCategory").value = product.categoryId || "";
    document.getElementById("productPrice").value = product.price;
    document.getElementById("productQuantity").value = product.quantity;
    document.getElementById("productImage").value = product.image || "";
    document.getElementById("productDescription").value = product.description || "";

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

async function saveProduct() {
  const productId = document.getElementById("productId").value;
  const name = document.getElementById("productName").value.trim();
  const categoryId = document.getElementById("productCategory").value;
  const price = document.getElementById("productPrice").value;
  const quantity = document.getElementById("productQuantity").value;
  const image = document.getElementById("productImage").value.trim();
  const description = document.getElementById("productDescription").value.trim();
  
  const currentProduct = productId ? currentProducts.find((p) => String(p.id) === String(productId)) : null;

  if (!name || !price || quantity === "") {
    showNotification("Cảnh báo", "Vui lòng điền đầy đủ thông tin bắt buộc", "warning");
    return;
  }

  if (!categoryId) {
    showNotification("Cảnh báo", "Vui lòng chọn danh mục sản phẩm", "warning");
    return;
  }

  if (productImageUploadInFlight) {
    showNotification("Cảnh báo", "Ảnh đang được tải lên. Vui lòng đợi hoàn tất trước khi lưu.", "warning");
    return;
  }

  try {
    setModalPrimaryButtonLoading("productModal", true, "Đang lưu sản phẩm...");
    const csrfToken = window.csrfToken || document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
    const url = productId ? contextPath + "/admin/api/product/update" : contextPath + "/admin/api/product/add";

    const params = new URLSearchParams();
    if (productId) params.append("id", productId);
    params.append("name", name);
    if (categoryId) params.append("categoryId", categoryId);
    params.append("price", price);
    params.append("quantity", quantity);
    if (image) params.append("image", image);
    if (description) params.append("description", description);
    
    if (productId && currentProduct) {
      if (currentProduct.slug) params.append("slug", currentProduct.slug);
      if (currentProduct.salePrice !== null && currentProduct.salePrice !== undefined) {
        params.append("salePrice", currentProduct.salePrice);
      }
      if (currentProduct.shortDescription) {
        params.append("shortDescription", currentProduct.shortDescription);
      }
      if (currentProduct.isFeatured !== null && currentProduct.isFeatured !== undefined) {
        params.append("isFeatured", currentProduct.isFeatured ? "true" : "false");
      }
    }
    if (csrfToken) params.append("csrfToken", csrfToken);

    const response = await fetch(url, {
      method: "POST",
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-CSRF-Token': csrfToken
      },
      body: params.toString()
    });

    if (!response.ok) throw new Error(`Server error: ${response.status}`);

    const result = await response.json();
    if (!result.success) throw new Error(result.message || "Failed to save product");

    showNotification("Thành công", productId ? "Đã cập nhật sản phẩm!" : "Đã thêm sản phẩm mới!", "success");
    closeModal("productModal");
    try {
      await loadProducts(currentProductPage);
      await loadStatistics();
    } catch (refreshError) {
      console.warn("Product refresh failed after save:", refreshError);
    }
  } catch (error) {
    console.error("Error saving product:", error);
    showNotification("Lỗi", error.message || "Không thể lưu sản phẩm", "error");
  } finally {
    setModalPrimaryButtonLoading("productModal", false);
  }
}

function openDeleteProductModal(productId, productName) {
  document.getElementById("deleteProductId").value = productId;
  document.getElementById("deleteProductName").textContent = productName;
  openModal("deleteProductModal");
}

async function confirmDeleteProduct() {
  const productId = document.getElementById("deleteProductId").value;

  try {
    const csrfToken = window.csrfToken || document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
    
    const response = await fetch(contextPath + "/admin/api/product/" + productId, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken
      }
    });

    if (!response.ok) throw new Error(`Server error: ${response.status}`);

    const result = await response.json();
    if (!result.success) throw new Error(result.message || "Failed to delete product");

    showNotification("Thành công", "Đã xóa sản phẩm thành công!", "success");
    closeModal("deleteProductModal");
    try {
      await loadProducts(currentProductPage);
      await loadStatistics();
    } catch (refreshError) {
      console.warn("Product refresh failed after delete:", refreshError);
    }
  } catch (error) {
    console.error("Error deleting product:", error);
    showNotification("Lỗi", error.message || "Không thể xóa sản phẩm", "error");
  }
}

function exportProducts() {
  exportProductsToExcel();
}

// Product search binding
document.addEventListener("DOMContentLoaded", function () {
  const productsMenuItem = document.querySelector('.menu-item[data-target="products"]');
  if (productsMenuItem) {
    productsMenuItem.addEventListener("click", () => {
      setTimeout(() => {
        loadCategories();
        loadProducts(1);
      }, 100);
    });
  }

  const productSearchInput = document.getElementById("productSearchInput");
  if (productSearchInput) {
    productSearchInput.addEventListener("keypress", function (e) {
      if (e.key === "Enter") searchProducts();
    });
  }
});

// ==========================================================================
// CUSTOMERS MANAGEMENT
// ==========================================================================
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
      '<span class="badge badge-danger">Đã khóa</span>' :
      '<span class="badge badge-secondary">Ẩn</span>';

    return '<tr>' +
      '<td><strong>' + customer.id + '</strong></td>' +
      '<td>' + customer.email + '</td>' +
      '<td>' + (customer.fullname || 'N/A') + '</td>' +
      '<td>' + (customer.phone || 'N/A') + '</td>' +
      '<td>' + formatDate(customer.createdAt) + '</td>' +
      '<td>' + statusBadge + '</td>' +
      '<td>' +
        '<div class="action-buttons">' +
        (customer.status !== 'banned' ? 
          '<button class="btn btn-light btn-sm" onclick="banCustomer(' + customer.id + ')" title="Khóa tài khoản">' +
            '<i class="fas fa-ban" style="color: var(--warning-dark);"></i>' +
          '</button>' :
          '<button class="btn btn-light btn-sm" onclick="unbanCustomer(' + customer.id + ')" title="Mở khóa tài khoản">' +
            '<i class="fas fa-check" style="color: var(--success-dark);"></i>' +
          '</button>'
        ) +
        '<button class="btn btn-light btn-sm" onclick="deleteCustomer(' + customer.id + ', \'' + customer.email + '\')" title="Xóa tài khoản">' +
          '<i class="fas fa-trash" style="color: var(--danger);"></i>' +
        '</button>' +
        '</div>' +
      '</td>' +
    '</tr>';
  }).join("");
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
    const response = await fetch(contextPath + "/admin/api/user/update-status?" + params.toString(), {
      method: "POST",
      headers: withCsrfHeaders()
    });
    const result = await response.json();
    
    if (result.success) {
      showNotification("Thành công", "Đã mở khóa tài khoản khách hàng!", "success");
      loadCustomers();
    } else {
      throw new Error(result.message);
    }
  } catch (error) {
    showNotification("Lỗi", error.message || "Không thể gỡ cấm", "error");
  }
}

async function banCustomer(userId) {
  showConfirm('Bạn có chắc chắn muốn khóa tài khoản khách hàng này?', async function() {
    try {
      const params = new URLSearchParams({ id: userId, status: 'banned' });
      const response = await fetch(contextPath + "/admin/api/user/update-status?" + params.toString(), {
        method: "POST",
        headers: withCsrfHeaders()
      });
      const result = await response.json();

      if (result.success) {
        showNotification("Thành công", "Đã khóa tài khoản khách hàng!", "success");
        loadCustomers();
      } else {
        throw new Error(result.message);
      }
    } catch (error) {
      showNotification("Lỗi", error.message || "Không thể cấm khách hàng", "error");
    }
  });
}

async function deleteCustomer(userId, email) {
  showConfirm('Bạn có chắc chắn muốn xóa tài khoản của khách hàng ' + email + '?', async function() {
    try {
      const response = await fetch(contextPath + "/admin/api/user/" + userId, {
        method: "DELETE",
        headers: withCsrfHeaders()
      });
      const result = await response.json();

      if (result.success) {
        showNotification("Thành công", "Đã xóa tài khoản khách hàng thành công!", "success");
        loadCustomers();
      } else {
        throw new Error(result.message);
      }
    } catch (error) {
      showNotification("Lỗi", error.message || "Không thể xóa khách hàng", "error");
    }
  });
}

// ==========================================================================
// CATEGORIES MANAGEMENT
// ==========================================================================
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
    console.error("Error loading categories table:", error);
  }
}

function displayCategories() {
  const tbody = document.getElementById("categoriesTableBody");
  if (!tbody) return;
  
  if (allCategoriesData.length === 0) {
    tbody.innerHTML = '<tr><td colspan="7" class="text-center">Không có danh mục nào</td></tr>';
    return;
  }

  tbody.innerHTML = allCategoriesData.map(cat => {
    const parentName = cat.parentId ? (allCategoriesData.find(c => c.id === cat.parentId)?.name || 'N/A') : '--';
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
        '<div class="action-buttons">' +
        '<button class="btn btn-light btn-sm" onclick="openEditCategoryModal(' + cat.id + ')" title="Sửa">' +
          '<i class="fas fa-edit" style="color: var(--primary);"></i>' +
        '</button>' +
        '<button class="btn btn-light btn-sm" onclick="deleteCategory(' + cat.id + ', \'' + cat.name.replace(/'/g, "\\'") + '\')" title="Xóa">' +
          '<i class="fas fa-trash" style="color: var(--danger);"></i>' +
        '</button>' +
        '</div>' +
      '</td>' +
    '</tr>';
  }).join('');
}

function populateCategoryParentSelect() {
  const select = document.getElementById("categoryParent");
  if (!select) return;
  select.innerHTML = '<option value="">-- Không có --</option>';
  allCategoriesData.forEach(cat => {
    select.innerHTML += `<option value="${cat.id}">${cat.name}</option>`;
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

    const url = categoryId ? contextPath + "/admin/api/category/update" : contextPath + "/admin/api/category/add";

    const response = await fetch(url, {
      method: "POST",
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-CSRF-Token': getCsrfToken(),
      },
      body: params.toString()
    });

    const result = await response.json();
    if (!result.success) throw new Error(result.message || "Failed to save category");

    showNotification("Thành công", categoryId ? "Đã cập nhật danh mục!" : "Đã thêm danh mục mới!", "success");
    closeModal("categoryModal");
    await loadCategoriesTable();
  } catch (error) {
    showNotification("Lỗi", error.message || "Không thể lưu danh mục", "error");
  }
}

async function deleteCategory(categoryId, categoryName) {
  showConfirm('Bạn có chắc chắn muốn xóa danh mục "' + categoryName + '"?', async function() {
    try {
      const response = await fetch(contextPath + "/admin/api/category/" + categoryId, {
        method: "DELETE",
        headers: withCsrfHeaders()
      });

      const result = await response.json();
      if (!result.success) throw new Error(result.message || "Failed to delete category");

      showNotification("Thành công", "Đã xóa danh mục thành công!", "success");
      await loadCategoriesTable();
    } catch (error) {
      showNotification("Lỗi", error.message || "Không thể xóa danh mục", "error");
    }
  });
}

// ==========================================================================
// COUPONS MANAGEMENT
// ==========================================================================
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
  if (!tbody) return;
  
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
      '<td><code style="background: var(--primary-light); padding: 4px 8px; border-radius: 4px; color: var(--primary-dark); font-weight:600;">' + coupon.code + '</code></td>' +
      '<td>' + (coupon.discountType === 'percent' ? 'Phần trăm' : 'Cố định') + '</td>' +
      '<td><strong>' + formatNumber(coupon.discountValue) + typeText + '</strong></td>' +
      '<td>' + formatCurrency(coupon.minOrderValue || 0) + '</td>' +
      '<td>' + usageText + '</td>' +
      '<td>' + (coupon.endDate ? formatDate(coupon.endDate) : 'Không giới hạn') + '</td>' +
      '<td>' + statusBadge + '</td>' +
      '<td>' +
        '<div class="action-buttons">' +
        '<button class="btn btn-light btn-sm" onclick="openEditCouponModal(' + coupon.id + ')" title="Sửa">' +
          '<i class="fas fa-edit" style="color: var(--primary);"></i>' +
        '</button>' +
        '<button class="btn btn-light btn-sm" onclick="deleteCoupon(' + coupon.id + ', \'' + coupon.code.replace(/'/g, "\\'") + '\')" title="Xóa">' +
          '<i class="fas fa-trash" style="color: var(--danger);"></i>' +
        '</button>' +
        '</div>' +
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

    const url = couponId ? contextPath + "/admin/api/coupon/update" : contextPath + "/admin/api/coupon/add";

    const response = await fetch(url, {
      method: "POST",
      headers: withCsrfHeaders({
        'Content-Type': 'application/x-www-form-urlencoded'
      }),
      body: params.toString()
    });

    const result = await response.json();
    if (!result.success) throw new Error(result.message || "Failed to save coupon");

    showNotification("Thành công", couponId ? "Đã cập nhật mã giảm giá!" : "Đã thêm mã giảm giá mới!", "success");
    closeModal("couponModal");
    loadCoupons();
  } catch (error) {
    showNotification("Lỗi", error.message || "Không thể lưu mã giảm giá", "error");
  }
}

async function deleteCoupon(couponId, couponCode) {
  showConfirm('Bạn có chắc chắn muốn xóa mã "' + couponCode + '"?', async function() {
    try {
      const response = await fetch(contextPath + "/admin/api/coupon/" + couponId, {
        method: "DELETE",
        headers: withCsrfHeaders()
      });

      const result = await response.json();
      if (!result.success) throw new Error(result.message || "Failed to delete coupon");

      showNotification("Thành công", "Đã xóa mã giảm giá thành công!", "success");
      loadCoupons();
    } catch (error) {
      showNotification("Lỗi", error.message || "Không thể xóa mã giảm giá", "error");
    }
  });
}

// ==========================================================================
// CONTACTS MANAGEMENT
// ==========================================================================
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
  if (!tbody) return;
  
  const statusFilter = document.getElementById("contactStatusFilter").value;
  let filtered = allContacts.filter(c => !statusFilter || c.status === statusFilter);

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
      '<td>' + formatDate(contact.createdAt) + '</td>' +
      '<td>' + statusBadge + '</td>' +
      '<td>' +
        '<div class="action-buttons">' +
        '<button class="btn btn-light btn-sm" onclick="viewContact(' + contact.id + ')" title="Xem">' +
          '<i class="fas fa-eye" style="color: var(--primary);"></i>' +
        '</button>' +
        '<button class="btn btn-light btn-sm" onclick="deleteContact(' + contact.id + ')" title="Xóa">' +
          '<i class="fas fa-trash" style="color: var(--danger);"></i>' +
        '</button>' +
        '</div>' +
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
    document.getElementById("contactDate").textContent = formatDateTime(contact.createdAt);
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
    const response = await fetch(contextPath + "/admin/api/contact/update-status?" + params.toString(), {
      method: "POST", headers: withCsrfHeaders()
    });

    const result = await response.json();
    if (result.success) {
      showNotification("Thành công", "Đã cập nhật trạng thái liên hệ!", "success");
      loadContacts();
    } else {
      throw new Error(result.message);
    }
  } catch (error) {
    showNotification("Lỗi", error.message || "Không thể cập nhật", "error");
  }
}

async function deleteContact(contactId) {
  showConfirm('Bạn có chắc chắn muốn xóa liên hệ này?', async function() {
    try {
      const response = await fetch(contextPath + "/admin/api/contact/" + contactId, {
        method: "DELETE", headers: withCsrfHeaders()
      });

      const result = await response.json();
      if (result.success) {
        showNotification("Thành công", "Đã xóa liên hệ thành công!", "success");
        loadContacts();
      } else {
        throw new Error(result.message);
      }
    } catch (error) {
      showNotification("Lỗi", error.message || "Không thể xóa liên hệ", "error");
    }
  });
}

// ==========================================================================
// CUSTOM ORDERS MANAGEMENT
// ==========================================================================
async function loadCustomOrders() {
  try {
    const response = await fetch(contextPath + "/admin/api/custom-orders");
    const result = await response.json();

    if (result.success) {
      allCustomOrders = result.data;
      displayCustomOrders();
    }
  } catch (error) {
    console.error("Error loading custom orders:", error);
  }
}

function displayCustomOrders() {
  const tbody = document.getElementById("customOrdersTableBody");
  if (!tbody) return;
  
  const statusFilter = document.getElementById("customOrderStatusFilter").value;
  let filtered = allCustomOrders.filter(order => !statusFilter || order.status === statusFilter);

  if (filtered.length === 0) {
    tbody.innerHTML = '<tr><td colspan="8" class="text-center">Không có yêu cầu đặt hoa tùy chỉnh nào</td></tr>';
    return;
  }

  tbody.innerHTML = filtered.map(order => {
    const statusBadge = order.status === 'pending' ?
      '<span class="badge badge-warning">Chờ duyệt</span>' :
      order.status === 'confirmed' ?
      '<span class="badge badge-info">Đã xác nhận</span>' :
      order.status === 'processing' ?
      '<span class="badge badge-primary">Đang bó hoa</span>' :
      order.status === 'completed' ?
      '<span class="badge badge-success">Đã giao</span>' :
      '<span class="badge badge-danger">Đã hủy</span>';

    const colorBox = '<div style="display:inline-flex; align-items:center; gap:8px;">' +
      '<span style="display:inline-block; width:16px; height:16px; border-radius:50%; background:' + order.colorTone + '; border:1px solid #ddd;"></span>' +
      '<span>' + order.colorTone + '</span>' +
      '</div>';

    return '<tr>' +
      '<td><strong>' + order.id + '</strong></td>' +
      '<td>' +
        '<strong>' + order.userFullname + '</strong><br>' +
        '<small class="text-muted"><i class="fas fa-envelope"></i> ' + order.userEmail + '</small><br>' +
        '<small class="text-muted"><i class="fas fa-phone"></i> ' + (order.userPhone || 'N/A') + '</small>' +
      '</td>' +
      '<td>' +
        '<ul style="margin:0; padding-left:14px; font-size:13px; color:var(--text-medium);">' +
          '<li>Kiểu: <strong>' + order.flowerType + '</strong></li>' +
          '<li>Chính: ' + order.mainFlower + '</li>' +
          '<li>Phụ: ' + order.supportFlower + '</li>' +
          '<li>Lượng: ' + order.quantity + '</li>' +
          '<li>Giấy gói: ' + order.wrapPaper + '</li>' +
          '<li>Tông màu: ' + colorBox + '</li>' +
          '<li>Phụ kiện: ' + (order.accessories || 'Không') + '</li>' +
          '<li>Dịp: ' + order.occasion + '</li>' +
        '</ul>' +
      '</td>' +
      '<td>' +
        'Dự chi: <strong>' + formatCurrency(order.budget) + '</strong><br>' +
        'Ước tính: <strong class="text-success">' + formatCurrency(order.estimatedPrice) + '</strong>' +
      '</td>' +
      '<td style="max-width:200px; white-space:normal; font-size:13px;">' + (order.customerNote || '<em class="text-muted">Không có ghi chú</em>') + '</td>' +
      '<td>' + formatDate(order.createdAt) + '</td>' +
      '<td>' + statusBadge + '</td>' +
      '<td>' +
        '<select class="form-control form-control-sm" style="width:130px; font-size:12px; margin-bottom:5px;" onchange="updateCustomOrderStatus(' + order.id + ', this.value)">' +
          '<option value="pending"' + (order.status === 'pending' ? ' selected' : '') + '>Chờ duyệt</option>' +
          '<option value="confirmed"' + (order.status === 'confirmed' ? ' selected' : '') + '>Xác nhận</option>' +
          '<option value="processing"' + (order.status === 'processing' ? ' selected' : '') + '>Đang bó</option>' +
          '<option value="completed"' + (order.status === 'completed' ? ' selected' : '') + '>Đã giao</option>' +
          '<option value="cancelled"' + (order.status === 'cancelled' ? ' selected' : '') + '>Hủy</option>' +
        '</select>' +
      '</td>' +
    '</tr>';
  }).join('');
}

async function updateCustomOrderStatus(orderId, status) {
  try {
    const params = new URLSearchParams({ id: orderId, status: status });
    const response = await fetch(contextPath + "/admin/api/custom-order/update-status?" + params.toString(), {
      method: "POST", headers: withCsrfHeaders()
    });

    const result = await response.json();
    if (result.success) {
      showNotification("Thành công", "Đã cập nhật trạng thái đặt hoa tùy chỉnh thành công!", "success");
      loadCustomOrders();
    } else {
      throw new Error(result.message);
    }
  } catch (error) {
    showNotification("Lỗi", error.message || "Không thể cập nhật", "error");
  }
}

// ==========================================================================
// ANALYTICS FUNCTIONALITY
// ==========================================================================
async function loadAnalytics() {
  const dateRange = document.getElementById("analyticsDateRange");
  const days = dateRange ? dateRange.value : "7";
  
  try {
    const response = await fetch(contextPath + "/admin/api/analytics?days=" + days);
    if (!response.ok) throw new Error("Failed to load analytics");
    
    const result = await response.json();
    if (!result.success) throw new Error(result.message || "Failed to load analytics data");
    
    const data = result.data;
    
    // Update stats elements
    document.getElementById("analyticsRevenue").textContent = formatCurrency(data.totalRevenue || 0);
    document.getElementById("analyticsOrders").textContent = formatNumber(data.totalOrders || 0);
    document.getElementById("analyticsAvgOrder").textContent = formatCurrency(data.avgOrderValue || 0);
    document.getElementById("analyticsCompleteRate").textContent = (data.completeRate || 0) + "%";
    
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
    
    if (data.topProducts) {
      loadAnalyticsTopProducts(data.topProducts);
    }
    
    // Categories fallback loading
    const sampleCategories = [
      {name: "Hoa Tươi Thiết Kế", productCount: 45, revenue: 12000000},
      {name: "Hoa Khai Trương", productCount: 32, revenue: 8500000},
      {name: "Hoa Sinh Nhật", productCount: 28, revenue: 7200000},
      {name: "Bó Hoa Cưới", productCount: 15, revenue: 6800000},
      {name: "Hoa Chia Buồn", productCount: 12, revenue: 4500000}
    ];
    loadAnalyticsTopCategories(sampleCategories);
  } catch (error) {
    console.error("❌ Error loading analytics:", error);
    showNotification("Lỗi", "Không thể tải thống kê: " + error.message, "error");
    loadSampleAnalytics(); // Load fallbacks
  }
}

function formatDateShort(dateStr) {
  const date = new Date(dateStr);
  return (date.getDate()) + "/" + (date.getMonth() + 1);
}

function updateChangeIndicator(elementId, change) {
  const element = document.getElementById(elementId);
  if (!element) return;
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

  const gradient = ctx.createLinearGradient(0, 0, 0, 300);
  gradient.addColorStop(0, 'rgba(201, 147, 102, 0.4)');
  gradient.addColorStop(1, 'rgba(201, 147, 102, 0.01)');

  revenueByDayChart = new Chart(ctx, {
    type: "line",
    data: {
      labels: labels,
      datasets: [{
        label: "Doanh Thu",
        data: revenues,
        borderColor: "#c99366",
        backgroundColor: gradient,
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
        legend: { display: false },
        tooltip: {
          backgroundColor: '#3c2922',
          titleColor: '#fff',
          bodyColor: '#fff',
          borderColor: '#c99366',
          borderWidth: 1,
          padding: 12,
          displayColors: false,
          callbacks: {
            label: function(context) {
              return "Doanh thu: " + formatCurrency(context.parsed.y);
            }
          }
        }
      },
      scales: {
        y: {
          beginAtZero: true,
          ticks: {
            callback: function(value) { return formatCurrency(value); },
            color: '#6c5845'
          },
          grid: { color: 'rgba(232, 223, 213, 0.5)' }
        },
        x: {
          ticks: { color: '#6c5845' },
          grid: { display: false }
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
  const colors = ['#ffb703', '#457b9d', '#2ec4b6', '#e63946'];

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
            font: { size: 12, family: "'Inter', sans-serif" },
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
          padding: 12
        }
      },
      cutout: '65%'
    }
  });
}

function loadAnalyticsTopProducts(products) {
  const tbody = document.getElementById("analyticsTopProducts");
  if (!tbody) return;
  
  if (!products || products.length === 0) {
    tbody.innerHTML = '<tr><td colspan="3" class="text-center">Chưa có dữ liệu</td></tr>';
    return;
  }

  tbody.innerHTML = products.slice(0, 5).map(product => {
    const soldCount = product.soldCount || product.sold || product.quantity || 0;
    const revenue = product.revenue || (product.price && soldCount ? product.price * soldCount : 0);
    return '<tr>' +
      '<td>' + (product.name || product.productName) + '</td>' +
      '<td><strong>' + formatNumber(soldCount) + '</strong></td>' +
      '<td><strong>' + formatCurrency(revenue) + '</strong></td>' +
    '</tr>';
  }).join('');
}

function loadAnalyticsTopCategories(categories) {
  const tbody = document.getElementById("analyticsTopCategories");
  if (!tbody) return;
  
  if (!categories || categories.length === 0) {
    tbody.innerHTML = '<tr><td colspan="3" class="text-center">Chưa có dữ liệu</td></tr>';
    return;
  }

  tbody.innerHTML = categories.slice(0, 5).map(category => {
    return '<tr>' +
      '<td>' + (category.name || category.categoryName) + '</td>' +
      '<td><strong>' + formatNumber(category.productCount || 0) + '</strong></td>' +
      '<td><strong>' + formatCurrency(category.revenue || 0) + '</strong></td>' +
    '</tr>';
  }).join('');
}

function loadSampleAnalytics() {
  try {
    document.getElementById("analyticsRevenue").textContent = formatCurrency(45000000);
    document.getElementById("analyticsOrders").textContent = formatNumber(156);
    document.getElementById("analyticsAvgOrder").textContent = formatCurrency(288461);
    document.getElementById("analyticsCompleteRate").textContent = "78%";

    updateChangeIndicator("analyticsRevenueChange", 12.5);
    updateChangeIndicator("analyticsOrdersChange", 8.3);
    updateChangeIndicator("analyticsAvgChange", 5.2);
    updateChangeIndicator("analyticsRateChange", 3.1);

    const sampleRevenue = [
      {date: "2026-05-20", label: "20/5", revenue: 1200000},
      {date: "2026-05-21", label: "21/5", revenue: 1500000},
      {date: "2026-05-22", label: "22/5", revenue: 1800000},
      {date: "2026-05-23", label: "23/5", revenue: 1400000},
      {date: "2026-05-24", label: "24/5", revenue: 2100000},
      {date: "2026-05-25", label: "25/5", revenue: 1900000},
      {date: "2026-05-26", label: "26/5", revenue: 2300000}
    ].map(item => ({ date: item.label, revenue: item.revenue }));
    loadRevenueByDayChart(sampleRevenue);

    const sampleStatus = { pending: 25, shipping: 45, delivered: 80, cancelled: 6 };
    loadOrderStatusChartData(sampleStatus);

    const sampleProducts = [
      {name: "Bó Hồng Pastel Kiêu Sa", soldCount: 45, revenue: 4500000},
      {name: "Tulip Trắng Sang Trọng", soldCount: 38, revenue: 3800000},
      {name: "Lẵng Cát Tường Quyến Rũ", soldCount: 32, revenue: 3200000},
      {name: "Bó Cẩm Chướng Vintage", soldCount: 28, revenue: 2800000},
      {name: "Hướng Dương Rạng Rỡ", soldCount: 25, revenue: 2500000}
    ];
    loadAnalyticsTopProducts(sampleProducts);
  } catch (error) {
    console.error("❌ Error loading sample analytics:", error);
  }
}

// Bind period changes for analytics
document.addEventListener("DOMContentLoaded", function () {
  const analyticsDateRange = document.getElementById("analyticsDateRange");
  if (analyticsDateRange) {
    analyticsDateRange.addEventListener("change", () => loadAnalytics());
  }
});

// ==========================================================================
// SETTINGS FUNCTIONALITY
// ==========================================================================
function loadSettings() {
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
    showNotification("Thành công", "Đã lưu cài đặt thông tin website!", "success");
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
    showNotification("Thành công", "Đã lưu cài đặt đơn hàng thành công!", "success");
  } catch (error) {
    showNotification("Lỗi", "Không thể lưu cài đặt", "error");
  }
}

function savePaymentSettings() {
  const settings = {
    paymentCOD: document.getElementById("paymentCOD").checked,
    paymentBank: document.getElementById("paymentBank").checked,
    paymentVNPay: document.getElementById("paymentVNPay").checked
  };

  try {
    localStorage.setItem('adminSettings', JSON.stringify(Object.assign(
      JSON.parse(localStorage.getItem('adminSettings') || '{}'),
      settings
    )));
    showNotification("Thành công", "Đã cập nhật cổng thanh toán thành công!", "success");
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
    showNotification("Thành công", "Đã cập nhật thiết lập gửi email tự động!", "success");
  } catch (error) {
    showNotification("Lỗi", "Không thể lưu cài đặt", "error");
  }
}

// ==========================================================================
// EXPORT EXCEL UTILITY (CSV COMPATIBLE WITH VIETNAMESE ACCENTS)
// ==========================================================================
function exportOrdersToExcel() {
  showNotification("Thông báo", "Đang xuất dữ liệu đơn hàng...", "info");
  
  let csv = "Mã Đơn,Khách Hàng,SĐT,Ngày Đặt,Tổng Tiền,Trạng Thái\n";
  currentOrders.forEach(order => {
    const customerName = order.receiverName || order.fullname || "N/A";
    const phone = order.receiverPhone || order.phone || "N/A";
    const date = formatDate(order.createdAt || order.orderDate);
    const total = order.total || order.totalPrice || 0;
    const status = getStatusText(order.orderStatus || order.status);
    
    csv += `"${order.orderCode || order.id}","${customerName}","${phone}","${date}","${total}","${status}"\n`;
  });

  const blob = new Blob(["\uFEFF" + csv], { type: 'text/csv;charset=utf-8;' });
  const link = document.createElement("a");
  link.href = URL.createObjectURL(blob);
  link.download = "orders_export_" + new Date().getTime() + ".csv";
  link.click();
  
  showNotification("Thành công", "Đã xuất dữ liệu Excel thành công!", "success");
}

function exportProductsToExcel() {
  showNotification("Thông báo", "Đang xuất dữ liệu sản phẩm...", "info");
  
  let csv = "ID,Tên Sản Phẩm,Danh Mục,Giá,Số Lượng,Đã Bán\n";
  currentProducts.forEach(product => {
    const categoryName = (product.category ? product.category.name : null) ||
                         (allCategories.find(c => c.id === product.categoryId)?.name) || "N/A";
    
    csv += `"${product.id}","${product.name}","${categoryName}","${product.price}","${product.quantity}","${product.soldCount || 0}"\n`;
  });

  const blob = new Blob(["\uFEFF" + csv], { type: 'text/csv;charset=utf-8;' });
  const link = document.createElement("a");
  link.href = URL.createObjectURL(blob);
  link.download = "products_export_" + new Date().getTime() + ".csv";
  link.click();
  
  showNotification("Thành công", "Đã xuất dữ liệu Excel thành công!", "success");
}

// ==========================================================================
// GALLERY MANAGEMENT FUNCTIONS
// ==========================================================================
async function loadGalleries() {
  try {
    const response = await fetch(contextPath + '/api/gallery/all');
    const result = await response.json();
    const tbody = document.getElementById('galleryTableBody');
    if (!tbody) return;
    
    if (result.success && result.data && result.data.length > 0) {
      tbody.innerHTML = result.data.map(gallery => '<tr>' +
        '<td>' + gallery.id + '</td>' +
        '<td><img src="' + gallery.imageUrl + '" alt="' + gallery.caption + '" style="width: 72px; height: 54px; object-fit: cover; border-radius: var(--border-radius-sm);" onerror="this.src=\'https://via.placeholder.com/80x60?text=Error\'" /></td>' +
        '<td>' + gallery.caption + '</td>' +
        '<td>' + (gallery.description || '-') + '</td>' +
        '<td>' + gallery.displayOrder + '</td>' +
        '<td>' + (gallery.active ? '<span class="badge badge-success">Hiển thị</span>' : '<span class="badge badge-secondary">Ẩn</span>') + '</td>' +
        '<td>' +
          '<div class="action-buttons">' +
          '<button class="btn btn-light btn-sm" onclick="editGallery(' + gallery.id + ')" title="Sửa"><i class="fas fa-edit" style="color: var(--primary);"></i></button> ' +
          '<button class="btn btn-light btn-sm" onclick="toggleGalleryStatus(' + gallery.id + ', ' + !gallery.active + ')" title="' + (gallery.active ? 'Ẩn' : 'Hiện') + '"><i class="fas fa-eye' + (gallery.active ? '-slash' : '') + '" style="color: var(--warning-dark);"></i></button> ' +
          '<button class="btn btn-light btn-sm" onclick="deleteGallery(' + gallery.id + ')" title="Xóa"><i class="fas fa-trash" style="color: var(--danger);"></i></button>' +
          '</div>' +
        '</td>' +
      '</tr>').join('');
    } else {
      tbody.innerHTML = '<tr><td colspan="7" class="text-center text-muted" style="padding: 40px;">Chưa có hình ảnh nào trong Gallery</td></tr>';
    }
  } catch (error) {
    console.error('Error loading galleries:', error);
    document.getElementById('galleryTableBody').innerHTML = '<tr><td colspan="7" class="text-center text-danger" style="padding: 40px;">Lỗi khi tải dữ liệu Gallery</td></tr>';
  }
}

function openGalleryModal() {
  document.getElementById('galleryModalTitle').textContent = 'Thêm Ảnh Gallery';
  document.getElementById('galleryId').value = '';
  document.getElementById('galleryForm').reset();
  document.getElementById('galleryActive').checked = true;
  document.getElementById('galleryPreviewContainer').style.display = 'none';
  openModal('galleryModal');
}

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
      
      document.getElementById('galleryPreview').src = gallery.imageUrl;
      document.getElementById('galleryPreviewContainer').style.display = 'block';
      
      openModal('galleryModal');
    }
  } catch (error) {
    console.error('Error loading gallery:', error);
    showNotification('Lỗi', 'Không thể tải thông tin gallery', 'error');
  }
}

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
  
  try {
    setModalPrimaryButtonLoading('galleryModal', true, 'Đang lưu gallery...');
    const formData = new URLSearchParams();
    formData.append('action', id ? 'update' : 'add');
    if (id) formData.append('id', id);
    formData.append('imageUrl', imageUrl);
    formData.append('caption', caption);
    formData.append('description', description);
    formData.append('displayOrder', displayOrder);
    formData.append('isActive', isActive);

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
    showNotification('Lỗi', 'Không thể lưu hình ảnh Gallery', 'error');
  } finally {
    setModalPrimaryButtonLoading('galleryModal', false);
  }
}

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
      showNotification('Thành công', "Đã thay đổi trạng thái hiển thị hình ảnh Gallery!", "success");
      loadGalleries();
    } else {
      showNotification('Lỗi', result.message, 'error');
    }
  } catch (error) {
    console.error('Error updating status:', error);
    showNotification('Lỗi', 'Không thể cập nhật trạng thái', 'error');
  }
}

async function deleteGallery(id) {
  showConfirm('Bạn có chắc chắn muốn xóa hình ảnh này khỏi Gallery?', async function() {
    try {
      const response = await fetch(contextPath + '/api/gallery/' + id, {
        method: 'DELETE'
      });
      const result = await response.json();

      if (result.success) {
        showNotification('Thành công', "Đã xóa ảnh Gallery thành công!", "success");
        loadGalleries();
      } else {
        showNotification('Lỗi', result.message, 'error');
      }
    } catch (error) {
      console.error('Error deleting gallery:', error);
      showNotification('Lỗi', 'Không thể xóa hình ảnh', 'error');
    }
  });
}

// ==========================================================================
// NEWS MANAGEMENT FUNCTIONS
// ==========================================================================
async function loadNews() {
  try {
    const response = await fetch(contextPath + '/api/news/all');
    const result = await response.json();
    const tbody = document.getElementById('newsTableBody');
    if (!tbody) return;
    
    if (result.success && result.data && result.data.length > 0) {
      tbody.innerHTML = result.data.map(news => {
        const publishedDate = news.publishedDate ? formatDate(news.publishedDate) : 'Chưa đăng';
        const statusBadge = news.published 
          ? '<span class="badge badge-success">Đã xuất bản</span>'
          : '<span class="badge badge-secondary">Bản nháp</span>';
        
        return '<tr>' +
          '<td>' + news.id + '</td>' +
          '<td><img src="' + (news.imageUrl || '') + '" style="width: 72px; height: 54px; object-fit: cover; border-radius: var(--border-radius-sm);" onerror="this.src=\'https://via.placeholder.com/80x60?text=No+Image\'" /></td>' +
          '<td style="max-width: 250px; font-weight:600;">' + news.title + '</td>' +
          '<td>' + news.categoryName + '</td>' +
          '<td>' + (news.author || 'Admin') + '</td>' +
          '<td><strong>' + (news.views || 0) + '</strong></td>' +
          '<td>' + statusBadge + '</td>' +
          '<td>' + publishedDate + '</td>' +
          '<td>' +
            '<div class="action-buttons">' +
            '<button class="btn btn-light btn-sm" onclick="editNews(' + news.id + ')" title="Sửa bài viết"><i class="fas fa-edit" style="color: var(--primary);"></i></button> ' +
            '<button class="btn btn-light btn-sm" onclick="toggleNewsPublish(' + news.id + ', ' + !news.published + ')" title="' + (news.published ? 'Gỡ bài viết' : 'Xuất bản bài viết') + '"><i class="fas fa-' + (news.published ? 'eye-slash' : 'eye') + '" style="color: var(--warning-dark);"></i></button> ' +
            '<button class="btn btn-light btn-sm" onclick="deleteNews(' + news.id + ')" title="Xóa bài viết"><i class="fas fa-trash" style="color: var(--danger);"></i></button>' +
            '</div>' +
          '</td>' +
        '</tr>';
      }).join('');
    } else {
      tbody.innerHTML = '<tr><td colspan="9" class="text-center text-muted" style="padding: 40px;">Chưa có bài viết tin tức nào</td></tr>';
    }
  } catch (error) {
    console.error('Error loading news:', error);
    document.getElementById('newsTableBody').innerHTML = '<tr><td colspan="9" class="text-center text-danger" style="padding: 40px;">Lỗi khi tải danh sách tin tức</td></tr>';
  }
}

// Generate friendly slug from Vietnamese unicode
function generateSlug(str) {
  str = str.toLowerCase();
  const from = "àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ";
  const to = "aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd";
  
  for (let i = 0; i < from.length; i++) {
    str = str.replace(new RegExp(from.charAt(i), 'g'), to.charAt(i));
  }
  
  str = str.replace(/[^a-z0-9 -]/g, '')
           .replace(/\s+/g, '-')
           .replace(/-+/g, '-')
           .replace(/^-+|-+$/g, '');
  
  return str;
}

function openNewsModal() {
  document.getElementById('newsModalTitle').textContent = 'Thêm Tin Tức';
  document.getElementById('newsId').value = '';
  document.getElementById('newsForm').reset();
  document.getElementById('newsAuthor').value = 'Admin';
  document.getElementById('newsPublished').checked = true;
  document.getElementById('newsPreviewContainer').style.display = 'none';
  openModal('newsModal');
}

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
    console.error('Error loading news details:', error);
    showNotification('Lỗi', 'Không thể tải thông tin bài viết', 'error');
  }
}

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
    setModalPrimaryButtonLoading('newsModal', true, 'Đang lưu bài viết...');
    const action = id ? 'update' : 'add';
    const response = await fetch(contextPath + '/api/news?action=' + action, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
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
    showNotification('Lỗi', 'Không thể lưu bài viết tin tức', 'error');
  } finally {
    setModalPrimaryButtonLoading('newsModal', false);
  }
}

async function toggleNewsPublish(id, published) {
  try {
    const response = await fetch(contextPath + '/api/news?action=updateStatus', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ id: id, published: published })
    });
    
    const result = await response.json();
    if (result.success) {
      showNotification('Thành công', published ? 'Đã xuất bản tin tức thành công!' : 'Đã gỡ ẩn tin tức thành công!', 'success');
      loadNews();
    } else {
      showNotification('Lỗi', result.message, 'error');
    }
  } catch (error) {
    console.error('Error toggling news publish:', error);
    showNotification('Lỗi', 'Không thể cập nhật trạng thái', 'error');
  }
}

async function deleteNews(id) {
  showConfirm('Bạn có chắc chắn muốn xóa tin tức này?', async function() {
    try {
      const response = await fetch(contextPath + '/api/news?action=delete', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id: id })
      });
      const result = await response.json();

      if (result.success) {
        showNotification('Thành công', "Đã xóa bài viết thành công!", "success");
        loadNews();
      } else {
        showNotification('Lỗi', result.message, 'error');
      }
    } catch (error) {
      console.error('Error deleting news:', error);
      showNotification('Lỗi', 'Không thể xóa tin tức', 'error');
    }
  });
}

// Bind blur inputs for gallery and news preview triggers
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
