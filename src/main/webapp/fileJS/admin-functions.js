// Admin Dashboard JavaScript
// FlowerStore Admin Panel

const contextPath = document.querySelector('script[src*="admin-functions"]')?.getAttribute('data-context') || '';

// Global State
let allProducts = [];
let allCategories = [];
let allOrders = [];
let allCoupons = [];
let allCustomers = [];
let allContacts = [];
let revenueChart = null;

// ==============================================
// DASHBOARD FUNCTIONS
// ==============================================

async function loadDashboard() {
    await Promise.all([
        loadStatistics(),
        loadRevenueChart(),
        loadRecentOrders()
    ]);
}

async function loadStatistics() {
    try {
        const response = await fetch(contextPath + "/admin/api/stats");
        const result = await response.json();
        const data = result.data || result;

        document.getElementById("statTotalOrders").textContent = formatNumber(data.totalOrders || 0);
        document.getElementById("statTotalRevenue").textContent = formatCurrency(data.totalRevenue || 0);
        document.getElementById("statTotalUsers").textContent = formatNumber(data.totalUsers || 0);
        document.getElementById("statTotalProducts").textContent = formatNumber(data.totalProducts || 0);
    } catch (error) {
        console.error("Error loading statistics:", error);
    }
}

async function loadRevenueChart() {
    try {
        const response = await fetch(contextPath + "/admin/api/revenue?period=week");
        const result = await response.json();
        const data = result.data || [];

        const ctx = document.getElementById('revenueChart');
        if (!ctx) return;

        if (revenueChart) {
            revenueChart.destroy();
        }

        revenueChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: data.map(d => formatDate(d.date)),
                datasets: [{
                    label: 'Doanh Thu',
                    data: data.map(d => d.revenue),
                    borderColor: '#8b5cf6',
                    backgroundColor: 'rgba(139, 92, 246, 0.1)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return formatCurrency(value);
                            }
                        }
                    }
                }
            }
        });
    } catch (error) {
        console.error("Error loading revenue chart:", error);
    }
}

async function loadRecentOrders() {
    try {
        const response = await fetch(contextPath + "/admin/api/orders/recent?limit=5");
        const result = await response.json();
        const orders = result.data || [];

        const container = document.getElementById('recentOrdersList');
        if (!container) return;

        if (orders.length === 0) {
            container.innerHTML = '<p style="text-align: center; color: var(--gray-500);">Chưa có đơn hàng</p>';
            return;
        }

        container.innerHTML = orders.map(order => `
            <div style="padding: 0.75rem 0; border-bottom: 1px solid var(--gray-200);">
                <div style="display: flex; justify-content: space-between; margin-bottom: 0.25rem;">
                    <span style="font-weight: 600;">${order.orderCode}</span>
                    <span class="badge badge-${getOrderStatusClass(order.orderStatus)}">${getOrderStatusText(order.orderStatus)}</span>
                </div>
                <div style="font-size: 0.875rem; color: var(--gray-600);">${formatCurrency(order.total)}</div>
            </div>
        `).join('');
    } catch (error) {
        console.error("Error loading recent orders:", error);
    }
}

// ==============================================
// ORDERS FUNCTIONS
// ==============================================

async function loadOrders() {
    try {
        const response = await fetch(contextPath + "/admin/api/orders");
        const result = await response.json();
        allOrders = result.data || [];
        
        displayOrders(allOrders);
    } catch (error) {
        console.error("Error loading orders:", error);
        showToast("Không thể tải danh sách đơn hàng", "error");
    }
}

function displayOrders(orders) {
    const tbody = document.getElementById('ordersTableBody');
    if (!tbody) return;

    if (orders.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; padding: 3rem; color: var(--gray-500);">Không có đơn hàng nào</td></tr>';
        return;
    }

    tbody.innerHTML = orders.map(order => `
        <tr>
            <td><strong>${order.orderCode}</strong></td>
            <td>${order.receiverName}</td>
            <td><strong>${formatCurrency(order.total)}</strong></td>
            <td><span class="badge badge-${getOrderStatusClass(order.orderStatus)}">${getOrderStatusText(order.orderStatus)}</span></td>
            <td><span class="badge badge-${getPaymentStatusClass(order.paymentStatus)}">${getPaymentStatusText(order.paymentStatus)}</span></td>
            <td>${formatDateTime(order.createdAt)}</td>
            <td>
                <button class="btn btn-sm btn-primary" onclick="viewOrderDetail(${order.id})" title="Xem chi tiết">
                    <i class="fas fa-eye"></i>
                </button>
                ${order.orderStatus === 'pending' ? `
                    <button class="btn btn-sm btn-success" onclick="updateOrderStatus(${order.id}, 'confirmed')" title="Xác nhận">
                        <i class="fas fa-check"></i>
                    </button>
                ` : ''}
            </td>
        </tr>
    `).join('');
}

async function viewOrderDetail(orderId) {
    try {
        const response = await fetch(contextPath + "/admin/api/order/" + orderId);
        const result = await response.json();
        const order = result.data;

        if (!order) {
            showToast("Không tìm thấy đơn hàng", "error");
            return;
        }

        const content = document.getElementById('orderDetailContent');
        content.innerHTML = `
            <div style="display: grid; gap: 1.5rem;">
                <div>
                    <h4 style="margin-bottom: 1rem;">Thông Tin Đơn Hàng</h4>
                    <table style="width: 100%;">
                        <tr>
                            <td style="padding: 0.5rem 0; font-weight: 600;">Mã đơn:</td>
                            <td>${order.orderCode}</td>
                        </tr>
                        <tr>
                            <td style="padding: 0.5rem 0; font-weight: 600;">Người nhận:</td>
                            <td>${order.receiverName}</td>
                        </tr>
                        <tr>
                            <td style="padding: 0.5rem 0; font-weight: 600;">Điện thoại:</td>
                            <td>${order.receiverPhone}</td>
                        </tr>
                        <tr>
                            <td style="padding: 0.5rem 0; font-weight: 600;">Địa chỉ:</td>
                            <td>${order.shippingAddress}</td>
                        </tr>
                        <tr>
                            <td style="padding: 0.5rem 0; font-weight: 600;">Trạng thái:</td>
                            <td><span class="badge badge-${getOrderStatusClass(order.orderStatus)}">${getOrderStatusText(order.orderStatus)}</span></td>
                        </tr>
                        <tr>
                            <td style="padding: 0.5rem 0; font-weight: 600;">Thanh toán:</td>
                            <td><span class="badge badge-${getPaymentStatusClass(order.paymentStatus)}">${getPaymentStatusText(order.paymentStatus)}</span></td>
                        </tr>
                    </table>
                </div>
                
                <div>
                    <h4 style="margin-bottom: 1rem;">Chi Tiết Sản Phẩm</h4>
                    ${order.items ? order.items.map(item => `
                        <div style="display: flex; justify-content: space-between; padding: 0.75rem 0; border-bottom: 1px solid var(--gray-200);">
                            <div>
                                <div style="font-weight: 600;">${item.productName}</div>
                                <div style="font-size: 0.875rem; color: var(--gray-600);">Số lượng: ${item.quantity}</div>
                            </div>
                            <div style="text-align: right;">
                                <div style="font-weight: 600;">${formatCurrency(item.price * item.quantity)}</div>
                                <div style="font-size: 0.875rem; color: var(--gray-600);">${formatCurrency(item.price)}/sp</div>
                            </div>
                        </div>
                    `).join('') : '<p>Không có thông tin sản phẩm</p>'}
                </div>
                
                <div style="border-top: 2px solid var(--gray-300); padding-top: 1rem;">
                    <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                        <span>Tạm tính:</span>
                        <strong>${formatCurrency(order.subtotal || 0)}</strong>
                    </div>
                    <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                        <span>Phí ship:</span>
                        <strong>${formatCurrency(order.shippingFee || 0)}</strong>
                    </div>
                    ${order.discount > 0 ? `
                        <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem; color: var(--success);">
                            <span>Giảm giá:</span>
                            <strong>-${formatCurrency(order.discount)}</strong>
                        </div>
                    ` : ''}
                    <div style="display: flex; justify-content: space-between; font-size: 1.25rem; font-weight: 700; color: var(--primary);">
                        <span>Tổng cộng:</span>
                        <span>${formatCurrency(order.total)}</span>
                    </div>
                </div>
            </div>
        `;

        openModal('orderDetailModal');
    } catch (error) {
        console.error("Error viewing order detail:", error);
        showToast("Không thể tải chi tiết đơn hàng", "error");
    }
}

async function updateOrderStatus(orderId, newStatus) {
    if (!confirm('Bạn có chắc chắn muốn cập nhật trạng thái đơn hàng?')) return;

    try {
        const response = await fetch(contextPath + `/admin/api/order/update-status?id=${orderId}&status=${newStatus}`, {
            method: 'POST'
        });
        const result = await response.json();

        if (result.success) {
            showToast("Cập nhật trạng thái thành công");
            loadOrders();
            loadDashboard();
        } else {
            showToast(result.message || "Cập nhật thất bại", "error");
        }
    } catch (error) {
        console.error("Error updating order status:", error);
        showToast("Không thể cập nhật trạng thái", "error");
    }
}

// ==============================================
// PRODUCTS FUNCTIONS
// ==============================================

async function loadProducts() {
    try {
        const response = await fetch(contextPath + "/admin/api/products");
        const result = await response.json();
        allProducts = result.data || [];
        
        displayProducts(allProducts);
        
        // Load categories for filter
        if (allCategories.length === 0) {
            await loadCategoriesForSelect();
        }
    } catch (error) {
        console.error("Error loading products:", error);
        showToast("Không thể tải danh sách sản phẩm", "error");
    }
}

function displayProducts(products) {
    const tbody = document.getElementById('productsTableBody');
    if (!tbody) return;

    if (products.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; padding: 3rem; color: var(--gray-500);">Không có sản phẩm nào</td></tr>';
        return;
    }

    tbody.innerHTML = products.map(product => `
        <tr>
            <td>
                <img src="${product.image || '/placeholder.jpg'}" alt="${product.name}" 
                     style="width: 60px; height: 60px; object-fit: cover; border-radius: 0.5rem;">
            </td>
            <td><strong>${product.name}</strong></td>
            <td>${product.categoryName || 'N/A'}</td>
            <td><strong>${formatCurrency(product.price)}</strong></td>
            <td>${product.stockQuantity}</td>
            <td><span class="badge badge-${product.isActive ? 'success' : 'secondary'}">${product.isActive ? 'Hoạt động' : 'Ẩn'}</span></td>
            <td>
                <button class="btn btn-sm btn-warning" onclick="editProduct(${product.id})" title="Sửa">
                    <i class="fas fa-edit"></i>
                </button>
                <button class="btn btn-sm btn-danger" onclick="deleteProduct(${product.id}, '${product.name.replace(/'/g, "\\'")}'))" title="Xóa">
                    <i class="fas fa-trash"></i>
                </button>
            </td>
        </tr>
    `).join('');
}

function openProductModal() {
    document.getElementById('productModalTitle').textContent = 'Thêm Sản Phẩm Mới';
    document.getElementById('productForm').reset();
    document.getElementById('productId').value = '';
    loadCategoriesForSelect();
    openModal('productModal');
}

async function editProduct(productId) {
    try {
        const product = allProducts.find(p => p.id === productId);
        if (!product) {
            showToast("Không tìm thấy sản phẩm", "error");
            return;
        }

        document.getElementById('productModalTitle').textContent = 'Sửa Sản Phẩm';
        document.getElementById('productId').value = product.id;
        document.getElementById('productName').value = product.name;
        document.getElementById('productCategory').value = product.categoryId || '';
        document.getElementById('productPrice').value = product.price;
        document.getElementById('productStock').value = product.stockQuantity;
        document.getElementById('productDescription').value = product.description || '';
        document.getElementById('productImage').value = product.image || '';
        document.getElementById('productActive').value = product.isActive ? 'true' : 'false';

        await loadCategoriesForSelect();
        openModal('productModal');
    } catch (error) {
        console.error("Error editing product:", error);
        showToast("Không thể tải thông tin sản phẩm", "error");
    }
}

async function saveProduct() {
    const productId = document.getElementById('productId').value;
    const name = document.getElementById('productName').value.trim();
    const categoryId = document.getElementById('productCategory').value;
    const price = document.getElementById('productPrice').value;
    const stock = document.getElementById('productStock').value;
    const description = document.getElementById('productDescription').value.trim();
    const image = document.getElementById('productImage').value.trim();
    const isActive = document.getElementById('productActive').value === 'true';

    if (!name || !categoryId || !price || !stock) {
        showToast("Vui lòng điền đầy đủ thông tin bắt buộc", "error");
        return;
    }

    try {
        const params = new URLSearchParams({
            name,
            categoryId,
            price,
            stockQuantity: stock,
            description,
            image,
            isActive
        });

        if (productId) params.append('id', productId);

        const url = productId ? '/admin/api/product/update' : '/admin/api/product/add';
        const response = await fetch(contextPath + url + '?' + params.toString(), {
            method: 'POST'
        });

        const result = await response.json();

        if (result.success) {
            showToast(productId ? "Cập nhật sản phẩm thành công" : "Thêm sản phẩm thành công");
            closeModal('productModal');
            loadProducts();
            loadDashboard();
        } else {
            showToast(result.message || "Lưu thất bại", "error");
        }
    } catch (error) {
        console.error("Error saving product:", error);
        showToast("Không thể lưu sản phẩm", "error");
    }
}

async function deleteProduct(productId, productName) {
    if (!confirm(`Bạn có chắc chắn muốn xóa sản phẩm "${productName}"?`)) return;

    try {
        const response = await fetch(contextPath + "/admin/api/product/" + productId, {
            method: 'DELETE'
        });

        const result = await response.json();

        if (result.success) {
            showToast("Xóa sản phẩm thành công");
            loadProducts();
            loadDashboard();
        } else {
            showToast(result.message || "Xóa thất bại", "error");
        }
    } catch (error) {
        console.error("Error deleting product:", error);
        showToast("Không thể xóa sản phẩm", "error");
    }
}

// ==============================================
// CATEGORIES FUNCTIONS
// ==============================================

async function loadCategories() {
    try {
        const response = await fetch(contextPath + "/admin/api/categories");
        const result = await response.json();
        allCategories = result.data || [];
        
        displayCategories(allCategories);
    } catch (error) {
        console.error("Error loading categories:", error);
        showToast("Không thể tải danh sách danh mục", "error");
    }
}

function displayCategories(categories) {
    const tbody = document.getElementById('categoriesTableBody');
    if (!tbody) return;

    if (categories.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; padding: 3rem; color: var(--gray-500);">Không có danh mục nào</td></tr>';
        return;
    }

    tbody.innerHTML = categories.map(cat => {
        const parentName = cat.parentId ? 
            (categories.find(c => c.id === cat.parentId)?.name || 'N/A') : 
            '--';
        
        return `
            <tr>
                <td><strong>${cat.id}</strong></td>
                <td>${cat.name}</td>
                <td>${cat.slug || 'N/A'}</td>
                <td>${parentName}</td>
                <td>${cat.displayOrder || 0}</td>
                <td><span class="badge badge-${cat.isActive ? 'success' : 'secondary'}">${cat.isActive ? 'Hoạt động' : 'Ẩn'}</span></td>
                <td>
                    <button class="btn btn-sm btn-warning" onclick="editCategory(${cat.id})" title="Sửa">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn btn-sm btn-danger" onclick="deleteCategory(${cat.id}, '${cat.name.replace(/'/g, "\\'")}'))" title="Xóa">
                        <i class="fas fa-trash"></i>
                    </button>
                </td>
            </tr>
        `;
    }).join('');
}

function openCategoryModal() {
    document.getElementById('categoryModalTitle').textContent = 'Thêm Danh Mục Mới';
    document.getElementById('categoryForm').reset();
    document.getElementById('categoryId').value = '';
    populateCategoryParentSelect();
    openModal('categoryModal');
}

function editCategory(categoryId) {
    const category = allCategories.find(c => c.id === categoryId);
    if (!category) {
        showToast("Không tìm thấy danh mục", "error");
        return;
    }

    document.getElementById('categoryModalTitle').textContent = 'Sửa Danh Mục';
    document.getElementById('categoryId').value = category.id;
    document.getElementById('categoryName').value = category.name;
    document.getElementById('categoryOrder').value = category.displayOrder || 0;
    document.getElementById('categoryDescription').value = category.description || '';
    
    populateCategoryParentSelect();
    document.getElementById('categoryParent').value = category.parentId || '';
    
    openModal('categoryModal');
}

async function saveCategory() {
    const categoryId = document.getElementById('categoryId').value;
    const name = document.getElementById('categoryName').value.trim();
    const parentId = document.getElementById('categoryParent').value;
    const displayOrder = document.getElementById('categoryOrder').value;
    const description = document.getElementById('categoryDescription').value.trim();

    if (!name) {
        showToast("Vui lòng nhập tên danh mục", "error");
        return;
    }

    try {
        const params = new URLSearchParams({
            name,
            displayOrder,
            description
        });

        if (categoryId) params.append('id', categoryId);
        if (parentId) params.append('parentId', parentId);

        const url = categoryId ? '/admin/api/category/update' : '/admin/api/category/add';
        const response = await fetch(contextPath + url + '?' + params.toString(), {
            method: 'POST'
        });

        const result = await response.json();

        if (result.success) {
            showToast(categoryId ? "Cập nhật danh mục thành công" : "Thêm danh mục thành công");
            closeModal('categoryModal');
            loadCategories();
        } else {
            showToast(result.message || "Lưu thất bại", "error");
        }
    } catch (error) {
        console.error("Error saving category:", error);
        showToast("Không thể lưu danh mục", "error");
    }
}

async function deleteCategory(categoryId, categoryName) {
    if (!confirm(`Bạn có chắc chắn muốn xóa danh mục "${categoryName}"?`)) return;

    try {
        const response = await fetch(contextPath + "/admin/api/category/" + categoryId, {
            method: 'DELETE'
        });

        const result = await response.json();

        if (result.success) {
            showToast("Xóa danh mục thành công");
            loadCategories();
        } else {
            showToast(result.message || "Xóa thất bại", "error");
        }
    } catch (error) {
        console.error("Error deleting category:", error);
        showToast("Không thể xóa danh mục", "error");
    }
}

function populateCategoryParentSelect() {
    const select = document.getElementById('categoryParent');
    if (!select) return;

    select.innerHTML = '<option value="">Không có</option>';
    allCategories.forEach(cat => {
        select.innerHTML += `<option value="${cat.id}">${cat.name}</option>`;
    });
}

async function loadCategoriesForSelect() {
    if (allCategories.length === 0) {
        const response = await fetch(contextPath + "/admin/api/categories");
        const result = await response.json();
        allCategories = result.data || [];
    }

    const selects = [
        document.getElementById('productCategory'),
        document.getElementById('productCategoryFilter')
    ];

    selects.forEach(select => {
        if (select) {
            const currentValue = select.value;
            select.innerHTML = '<option value="">Chọn danh mục</option>';
            allCategories.forEach(cat => {
                select.innerHTML += `<option value="${cat.id}">${cat.name}</option>`;
            });
            select.value = currentValue;
        }
    });
}

// ==============================================
// CUSTOMERS FUNCTIONS
// ==============================================

async function loadCustomers() {
    try {
        const response = await fetch(contextPath + "/admin/api/users");
        const result = await response.json();
        allCustomers = result.data || [];
        
        displayCustomers(allCustomers);
    } catch (error) {
        console.error("Error loading customers:", error);
        showToast("Không thể tải danh sách khách hàng", "error");
    }
}

function displayCustomers(customers) {
    const tbody = document.getElementById('customersTableBody');
    if (!tbody) return;

    if (customers.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" style="text-align: center; padding: 3rem; color: var(--gray-500);">Không có khách hàng nào</td></tr>';
        return;
    }

    tbody.innerHTML = customers.map(customer => `
        <tr>
            <td><strong>${customer.id}</strong></td>
            <td>${customer.email}</td>
            <td>${customer.fullname || 'N/A'}</td>
            <td>${customer.phone || 'N/A'}</td>
            <td><span class="badge badge-${customer.status === 'active' ? 'success' : 'secondary'}">${customer.status === 'active' ? 'Hoạt động' : 'Khóa'}</span></td>
            <td>${formatDateTime(customer.createdAt)}</td>
        </tr>
    `).join('');
}

// ==============================================
// COUPONS FUNCTIONS
// ==============================================

async function loadCoupons() {
    try {
        const response = await fetch(contextPath + "/admin/api/coupons");
        const result = await response.json();
        allCoupons = result.data || [];
        
        displayCoupons(allCoupons);
    } catch (error) {
        console.error("Error loading coupons:", error);
        showToast("Không thể tải danh sách mã giảm giá", "error");
    }
}

function displayCoupons(coupons) {
    const tbody = document.getElementById('couponsTableBody');
    if (!tbody) return;

    if (coupons.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" style="text-align: center; padding: 3rem; color: var(--gray-500);">Không có mã giảm giá nào</td></tr>';
        return;
    }

    tbody.innerHTML = coupons.map(coupon => {
        const discount = coupon.discountType === 'percentage' ? 
            `${coupon.discountValue}%` : 
            formatCurrency(coupon.discountValue);
        
        const isActive = new Date(coupon.endDate) > new Date();
        
        return `
            <tr>
                <td><strong>${coupon.code}</strong></td>
                <td>${discount}</td>
                <td>${formatDate(coupon.startDate)}</td>
                <td>${formatDate(coupon.endDate)}</td>
                <td>${coupon.maxUsage}</td>
                <td>${coupon.usedCount || 0}</td>
                <td><span class="badge badge-${isActive ? 'success' : 'secondary'}">${isActive ? 'Hoạt động' : 'Hết hạn'}</span></td>
                <td>
                    <button class="btn btn-sm btn-warning" onclick="editCoupon(${coupon.id})" title="Sửa">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn btn-sm btn-danger" onclick="deleteCoupon(${coupon.id}, '${coupon.code}')" title="Xóa">
                        <i class="fas fa-trash"></i>
                    </button>
                </td>
            </tr>
        `;
    }).join('');
}

function openCouponModal() {
    document.getElementById('couponModalTitle').textContent = 'Thêm Mã Giảm Giá';
    document.getElementById('couponForm').reset();
    document.getElementById('couponId').value = '';
    openModal('couponModal');
}

function editCoupon(couponId) {
    const coupon = allCoupons.find(c => c.id === couponId);
    if (!coupon) {
        showToast("Không tìm thấy mã giảm giá", "error");
        return;
    }

    document.getElementById('couponModalTitle').textContent = 'Sửa Mã Giảm Giá';
    document.getElementById('couponId').value = coupon.id;
    document.getElementById('couponCode').value = coupon.code;
    document.getElementById('couponType').value = coupon.discountType;
    document.getElementById('couponValue').value = coupon.discountValue;
    document.getElementById('couponStartDate').value = coupon.startDate.split('T')[0];
    document.getElementById('couponEndDate').value = coupon.endDate.split('T')[0];
    document.getElementById('couponQuantity').value = coupon.maxUsage;
    document.getElementById('couponMinOrder').value = coupon.minOrderValue || '';
    
    openModal('couponModal');
}

async function saveCoupon() {
    const couponId = document.getElementById('couponId').value;
    const code = document.getElementById('couponCode').value.trim();
    const type = document.getElementById('couponType').value;
    const value = document.getElementById('couponValue').value;
    const startDate = document.getElementById('couponStartDate').value;
    const endDate = document.getElementById('couponEndDate').value;
    const quantity = document.getElementById('couponQuantity').value;
    const minOrder = document.getElementById('couponMinOrder').value;

    if (!code || !value || !startDate || !endDate || !quantity) {
        showToast("Vui lòng điền đầy đủ thông tin bắt buộc", "error");
        return;
    }

    try {
        const params = new URLSearchParams({
            code,
            discountType: type,
            discountValue: value,
            startDate,
            endDate,
            maxUsage: quantity,
            minOrderValue: minOrder || 0
        });

        if (couponId) params.append('id', couponId);

        const url = couponId ? '/admin/api/coupon/update' : '/admin/api/coupon/add';
        const response = await fetch(contextPath + url + '?' + params.toString(), {
            method: 'POST'
        });

        const result = await response.json();

        if (result.success) {
            showToast(couponId ? "Cập nhật mã giảm giá thành công" : "Thêm mã giảm giá thành công");
            closeModal('couponModal');
            loadCoupons();
        } else {
            showToast(result.message || "Lưu thất bại", "error");
        }
    } catch (error) {
        console.error("Error saving coupon:", error);
        showToast("Không thể lưu mã giảm giá", "error");
    }
}

async function deleteCoupon(couponId, couponCode) {
    if (!confirm(`Bạn có chắc chắn muốn xóa mã "${couponCode}"?`)) return;

    try {
        const response = await fetch(contextPath + "/admin/api/coupon/" + couponId, {
            method: 'DELETE'
        });

        const result = await response.json();

        if (result.success) {
            showToast("Xóa mã giảm giá thành công");
            loadCoupons();
        } else {
            showToast(result.message || "Xóa thất bại", "error");
        }
    } catch (error) {
        console.error("Error deleting coupon:", error);
        showToast("Không thể xóa mã giảm giá", "error");
    }
}

// ==============================================
// CONTACTS FUNCTIONS
// ==============================================

async function loadContacts() {
    try {
        const response = await fetch(contextPath + "/admin/api/contacts");
        const result = await response.json();
        allContacts = result.data || [];
        
        displayContacts(allContacts);
    } catch (error) {
        console.error("Error loading contacts:", error);
        showToast("Không thể tải danh sách liên hệ", "error");
    }
}

function displayContacts(contacts) {
    const tbody = document.getElementById('contactsTableBody');
    if (!tbody) return;

    if (contacts.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; padding: 3rem; color: var(--gray-500);">Không có liên hệ nào</td></tr>';
        return;
    }

    tbody.innerHTML = contacts.map(contact => {
        const statusClass = {
            'new': 'info',
            'read': 'warning',
            'replied': 'success'
        }[contact.status] || 'secondary';

        const statusText = {
            'new': 'Mới',
            'read': 'Đã đọc',
            'replied': 'Đã trả lời'
        }[contact.status] || contact.status;

        return `
            <tr>
                <td><strong>${contact.id}</strong></td>
                <td>${contact.name}</td>
                <td>${contact.email}</td>
                <td>${contact.subject}</td>
                <td><span class="badge badge-${statusClass}">${statusText}</span></td>
                <td>${formatDateTime(contact.createdAt)}</td>
                <td>
                    <button class="btn btn-sm btn-primary" onclick="viewContactMessage(${contact.id})" title="Xem">
                        <i class="fas fa-eye"></i>
                    </button>
                    <button class="btn btn-sm btn-danger" onclick="deleteContact(${contact.id})" title="Xóa">
                        <i class="fas fa-trash"></i>
                    </button>
                </td>
            </tr>
        `;
    }).join('');
}

async function viewContactMessage(contactId) {
    const contact = allContacts.find(c => c.id === contactId);
    if (!contact) return;

    alert(`Từ: ${contact.name} (${contact.email})\nTiêu đề: ${contact.subject}\n\nNội dung:\n${contact.message}`);

    // Update status to read if new
    if (contact.status === 'new') {
        try {
            await fetch(contextPath + `/admin/api/contact/status?id=${contactId}&status=read`, {
                method: 'POST'
            });
            loadContacts();
        } catch (error) {
            console.error("Error updating contact status:", error);
        }
    }
}

async function deleteContact(contactId) {
    if (!confirm('Bạn có chắc chắn muốn xóa liên hệ này?')) return;

    try {
        const response = await fetch(contextPath + "/admin/api/contact/" + contactId, {
            method: 'DELETE'
        });

        const result = await response.json();

        if (result.success) {
            showToast("Xóa liên hệ thành công");
            loadContacts();
        } else {
            showToast(result.message || "Xóa thất bại", "error");
        }
    } catch (error) {
        console.error("Error deleting contact:", error);
        showToast("Không thể xóa liên hệ", "error");
    }
}

// ==============================================
// HELPER FUNCTIONS
// ==============================================

function getOrderStatusClass(status) {
    const map = {
        'pending': 'warning',
        'confirmed': 'info',
        'shipping': 'info',
        'delivered': 'success',
        'cancelled': 'danger'
    };
    return map[status] || 'secondary';
}

function getOrderStatusText(status) {
    const map = {
        'pending': 'Chờ xác nhận',
        'confirmed': 'Đã xác nhận',
        'processing': 'Đang xử lý',
        'shipping': 'Đang giao',
        'delivered': 'Đã giao',
        'cancelled': 'Đã hủy'
    };
    return map[status] || status;
}

function getPaymentStatusClass(status) {
    const map = {
        'pending': 'warning',
        'paid': 'success',
        'failed': 'danger',
        'refunded': 'info'
    };
    return map[status] || 'secondary';
}

function getPaymentStatusText(status) {
    const map = {
        'pending': 'Chờ thanh toán',
        'paid': 'Đã thanh toán',
        'failed': 'Thất bại',
        'refunded': 'Đã hoàn tiền'
    };
    return map[status] || status;
}

// ==============================================
// FILTERS & SEARCH
// ==============================================

// Order search & filter
document.getElementById('orderSearch')?.addEventListener('input', function(e) {
    const searchTerm = e.target.value.toLowerCase();
    const filtered = allOrders.filter(order => 
        order.orderCode.toLowerCase().includes(searchTerm) ||
        order.receiverName.toLowerCase().includes(searchTerm)
    );
    displayOrders(filtered);
});

document.getElementById('orderStatusFilter')?.addEventListener('change', function(e) {
    const status = e.target.value;
    const filtered = status ? allOrders.filter(order => order.orderStatus === status) : allOrders;
    displayOrders(filtered);
});

// Product search & filter
document.getElementById('productSearch')?.addEventListener('input', function(e) {
    const searchTerm = e.target.value.toLowerCase();
    const filtered = allProducts.filter(product => 
        product.name.toLowerCase().includes(searchTerm)
    );
    displayProducts(filtered);
});

document.getElementById('productCategoryFilter')?.addEventListener('change', function(e) {
    const categoryId = parseInt(e.target.value);
    const filtered = categoryId ? allProducts.filter(product => product.categoryId === categoryId) : allProducts;
    displayProducts(filtered);
});
