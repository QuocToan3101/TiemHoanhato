const orders = [
    {
        id: 1,
        name: "Bó hoa Whimsy well",
        price: "910.000 VND",
        img: "img/hoa 1.jpg",
        status: "shipping",
        date: "30/10/2025"
    },
    {
        id: 2,
        name: "Giỏ hoa Bliss charm",
        price: "1.450.000 VND",
        img: "img/giỏ hoa.jpg",
        status: "delivered",
        date: "20/10/2025"
    },
    {
        id: 3,
        name: "Hoa Tulip Everelle",
        price: "1.880.500 VND",
        img: "img/hoa 2.jpg",
        status: "delivered",
        date: "31/10/2025"
    },
    // {
    //     id: 4,
    //     name: "Bó hoa Dreamy Roses",
    //     price: "1.250.000 VND",
    //     img: "img/hoa4.jpg",
    //     status: "cancelled",
    //     date: "10/08/2025"
    // }
];

document.addEventListener("DOMContentLoaded", () => {
    renderOrders(orders);
    updateSidebarStats();
});

// Hiển thị danh sách đơn hàng
function renderOrders(list) {
    const container = document.getElementById("orderList");
    container.innerHTML = "";

    list.forEach(order => {
        const div = document.createElement("div");
        div.className = "order-card";
        div.innerHTML = `
      <div class="order-left">
        <img src="${order.img}" alt="${order.name}" class="order-img">
        <div class="order-info">
          <div class="order-name">${order.name}</div>
          <div class="order-price">${order.price}</div>
          <div class="order-status ${order.status}">
            Trạng thái: ${getStatusText(order.status)}
          </div>
        </div>
      </div>
      <div class="order-date">
        <small>Ngày đặt: ${order.date}</small>
      </div>
    `;
        container.appendChild(div);
    });
}

// Lọc theo trạng thái
function filterOrders() {
    const value = document.getElementById("statusFilter").value;
    const filtered = value === "all" ? orders : orders.filter(o => o.status === value);
    renderOrders(filtered);
}

// Đổi text trạng thái
function getStatusText(status) {
    switch (status) {
        case "delivered": return "Đã giao";
        case "shipping": return "Đang giao";
        case "cancelled": return "Đã hủy";
        default: return "Không xác định";
    }
}

// Cập nhật thống kê sidebar
function updateSidebarStats() {
    const total = orders.length;
    const delivered = orders.filter(o => o.status === "delivered").length;
    const shipping = orders.filter(o => o.status === "shipping").length;
    const cancelled = orders.filter(o => o.status === "cancelled").length;

    document.getElementById("totalOrders").textContent = total;
    document.getElementById("deliveredCount").textContent = delivered;
    document.getElementById("shippingCount").textContent = shipping;
    document.getElementById("cancelledCount").textContent = cancelled;

    const totalSpending = orders
        .filter(o => o.status !== "cancelled")
        .reduce((sum, o) => sum + parseInt(o.price.replace(/\D/g, "")), 0);

    document.getElementById("totalSpending").textContent =
        totalSpending.toLocaleString() + " VND";
}
