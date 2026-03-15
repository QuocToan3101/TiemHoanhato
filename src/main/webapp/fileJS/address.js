const addresses = [
    {
        name: "Nguyễn Văn A",
        phone: "0987654321",
        address: "123 Lê Lợi, P. Bến Nghé, Q.1, TP.HCM",
        note: "Nhận hàng buổi sáng"
    },
    {
        name: "Trần Thị B",
        phone: "0901122334",
        address: "45 Trần Hưng Đạo, P.2, TP. Vũng Tàu",
        note: "Giao ngoài giờ hành chính"
    }
];

document.addEventListener("DOMContentLoaded", () => {
    renderAddressList();
    document.getElementById("addressForm").addEventListener("submit", addAddress);
});

function renderAddressList() {
    const container = document.getElementById("addressList");
    container.innerHTML = "";

    addresses.forEach((addr, index) => {
        const div = document.createElement("div");
        div.className = "order-card"; // dùng lại class từ purchaseHistory.css
        div.innerHTML = `
      <div>
        <strong class="order-name">${addr.name}</strong><br>
        <span class="order-price">📞 ${addr.phone}</span><br>
        <span>${addr.address}</span><br>
        <small class="text-muted">${addr.note || ""}</small>
      </div>
      <button class="btn btn-sm btn-outline-danger" onclick="deleteAddress(${index})">
        <i class="bi bi-trash"></i>
      </button>
    `;
        container.appendChild(div);
    });
}

function addAddress(e) {
    e.preventDefault();
    const form = e.target;
    const newAddr = {
        name: form[0].value,
        phone: form[1].value,
        address: form[2].value + ", " + form[3].value + ", " + form[4].value,
        note: form[5].value
    };
    addresses.push(newAddr);
    renderAddressList();
    form.reset();
}

function deleteAddress(index) {
    addresses.splice(index, 1);
    renderAddressList();
}
