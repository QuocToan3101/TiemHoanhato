// Mở modal
function openModalById(id) {
  const modal = document.getElementById(id);
  if (!modal) return;

  modal.style.display = "flex";
  modal.setAttribute("aria-hidden", "false");

  // Thiết lập trạng thái label .active cho input có sẵn value
  const controls = modal.querySelectorAll(
    ".form-outline input, .form-outline textarea, .form-outline select"
  );
  controls.forEach((ctrl) => {
    const parent = ctrl.closest(".form-outline");
    if (!parent) return;

    if (ctrl.value && ctrl.value.trim() !== "") {
      parent.classList.add("active");
    } else {
      parent.classList.remove("active");
    }

    if (!ctrl.dataset.fpInit) {
      ctrl.addEventListener("focus", () => parent.classList.add("active"));
      ctrl.addEventListener("blur", () => {
        if (!ctrl.value || ctrl.value.trim() === "")
          parent.classList.remove("active");
      });
      ctrl.dataset.fpInit = "1";
    }
  });
}

// Đóng modal
function closeModal(id) {
  const modal = document.getElementById(id);
  if (!modal) return;
  modal.style.display = "none";
  modal.setAttribute("aria-hidden", "true");
}

// Lưu dữ liệu
function saveField(modalId, label, inputId) {
  const modal = document.getElementById(modalId);
  const input = document.getElementById(inputId);
  if (!modal || !input) return;

  const value = input.value.trim();
  if (value) {
    const row = document.querySelector(
      `.profile-item[data-modal="${modalId}"]`
    );
    if (row) {
      let right = row.querySelector(".action");
      if (!right) {
        right = document.createElement("span");
        right.className = "action";
        row.appendChild(right);
      }
      right.innerText = value;
      right.style.color = "#4b2e05";
    }
  }
  closeModal(modalId);
}

// Sự kiện khởi tạo
document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".profile-item[data-modal]").forEach((item) => {
    item.addEventListener("click", () =>
      openModalById(item.getAttribute("data-modal"))
    );
  });

  // Đóng modal khi click ngoài vùng
  document.querySelectorAll(".custom-modal").forEach((modal) => {
    modal.addEventListener("click", (e) => {
      if (e.target === modal) closeModal(modal.id);
    });
  });

  // Xem trước ảnh đại diện
  const avatarInput = document.getElementById("avatarInput");
  if (avatarInput) {
    avatarInput.addEventListener("change", (event) => {
      const file = event.target.files[0];
      if (!file) return;
      const reader = new FileReader();
      reader.onload = (e) => {
        const img = document.getElementById("avatarPreview");
        if (img) img.src = e.target.result;
      };
      reader.readAsDataURL(file);
    });
  }
  function goToLinkedAccount() {
    // Chuyển hướng sang trang tài khoản liên kết
    window.location.href = "linkAccount.jsp";
  }
});
