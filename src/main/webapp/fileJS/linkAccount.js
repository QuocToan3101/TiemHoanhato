/* assets/linkedAccount.js
   Logic: render UI, modal, lưu trạng thái vào localStorage
*/
const accounts = [
    { id: "bank", name: "Liên kết Ngân hàng", icon: "bank" }, // dùng icon font
    { id: "momo", name: "Ví MoMo", icon:"img/MOMO-Logo-App.png" },
    { id: "zalopay", name: "ZaloPay", icon: "img/Logo FA-13.png" },
    { id: "viettelpay", name: "ViettelPay", icon: "img/Logo-Viettelpay.jpg" }
];

let selectedAccount = null;

document.addEventListener("DOMContentLoaded", () => {
    renderAccounts();
    const modal = document.getElementById("linkModal");
    if (modal) {
        modal.addEventListener("click", (e) => {
            if (e.target === modal) closeModal();
        });
    }
});

function renderAccounts() {
    const container = document.getElementById("accountList");
    container.innerHTML = "";

    accounts.forEach((acc) => {
        const linked = localStorage.getItem(`linked_${acc.id}`) === "true";

        const item = document.createElement("div");
        item.className = "linked-item";
        item.dataset.id = acc.id;

        const left = document.createElement("div");
        left.className = "left";

        if (acc.icon === "bank") {
            const i = document.createElement("i");
            i.className = "bi bi-bank icon-bank";
            left.appendChild(i);
        } else {
            const img = document.createElement("img");
            img.className = "icon";
            img.src = acc.icon;
            img.alt = acc.name;
            img.onerror = () => (img.style.display = "none");
            left.appendChild(img);
        }

        const name = document.createElement("div");
        name.className = "link-name";
        name.textContent = acc.name;
        left.appendChild(name);

        const status = document.createElement("div");
        status.className = "status " + (linked ? "linked" : "not-linked");
        status.textContent = linked ? "Đã liên kết" : "Chưa liên kết";

        item.appendChild(left);
        item.appendChild(status);

        item.addEventListener("click", () => showAccountDetail(acc, linked));
        container.appendChild(item);
    });
}

function openModal(account, isLinked) {
    selectedAccount = account;
    const modal = document.getElementById("linkModal");
    const title = document.getElementById("linkTitle");
    const msg = document.getElementById("linkMessage");
    const confirmBtn = document.getElementById("confirmBtn");

    title.textContent = isLinked
        ? `Hủy liên kết ${account.name}`
        : `Liên kết ${account.name}`;
    msg.textContent = isLinked
        ? `Bạn có chắc muốn hủy liên kết với ${account.name}?`
        : `Bạn có chắc muốn liên kết với ${account.name}?`;

    confirmBtn.textContent = isLinked ? "Hủy liên kết" : "Liên kết";
    confirmBtn.onclick = () => confirmLink(account, isLinked);

    modal.setAttribute("aria-hidden", "false");
}

function closeModal() {
    document.getElementById("linkModal").setAttribute("aria-hidden", "true");
}

function confirmLink(account, wasLinked) {
    const key = `linked_${account.id}`;
    const newState = !wasLinked;
    localStorage.setItem(key, newState ? "true" : "false");
    closeModal();
    renderAccounts();
    showToast(newState ? `Đã liên kết ${account.name}` : `Đã hủy liên kết ${account.name}`);
}

/* ====== Toast thông báo ====== */
function showToast(message) {
    const toast = document.createElement("div");
    toast.className = "toast-msg";
    toast.textContent = message;
    document.body.appendChild(toast);
    setTimeout(() => toast.classList.add("show"), 10);
    setTimeout(() => {
        toast.classList.remove("show");
        setTimeout(() => toast.remove(), 300);
    }, 2000);
}
function showAccountDetail(account, linked) {
    const detail = document.getElementById("accountDetail");
    const icon = document.getElementById("detailIcon");
    const name = document.getElementById("detailName");
    const status = document.getElementById("detailStatus");
    const desc = document.getElementById("detailDesc");

    // Gán icon
    if (account.icon === "bank") {
        icon.src = "https://cdn-icons-png.flaticon.com/512/684/684908.png";
    } else {
        icon.src = account.icon;
    }

    name.textContent = account.name;
    status.textContent = linked ? "Đã liên kết" : "Chưa liên kết";
    status.className = "detail-status " + (linked ? "linked" : "not-linked");
    desc.textContent = linked
        ? "Tài khoản này hiện đang được kết nối để sử dụng thanh toán hoặc rút tiền."
        : "Bạn có thể liên kết tài khoản này để trải nghiệm thanh toán nhanh chóng hơn.";

    detail.classList.remove("hidden");

    // Cuộn đến phần chi tiết (mượt)
    detail.scrollIntoView({ behavior: "smooth", block: "center" });
}

function closeDetail() {
    document.getElementById("accountDetail").classList.add("hidden");
}
