<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<table class="table">
    <thead>
        <tr>
<th>Sản phẩm</th>
<th>Số lượng</th>
<th>Hành động</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="item" items="${cart.items}">
            <tr>
<td>${item.product.name}</td>
                <td>
                    <button onclick="updateQuantity(${item.product.id}, -1, ${item.quantity})">-</button>

<span>${item.quantity}</span>

                    <button onclick="updateQuantity(${item.product.id}, 1, ${item.quantity})">+</button>
                </td>
                <td>
                    <button class="btn-delete" onclick="confirmDelete(${item.product.id})">
Xóa
        </button>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>

<script>
    // Hàm xử lý khi nhấn nút Xóa trực tiếp
function confirmDelete(productId) {
    if (confirm("Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?")) {
        window.location.href = "cart?action=delete&productId=" + productId;
    }
}

// Hàm xử lý tăng/giảm số lượng
function updateQuantity(productId, delta, currentQty) {
    let newQty = currentQty + delta;

    if (newQty < 1) {
        // Khi giảm xuống < 1, gọi lại hàm xác nhận xóa
        confirmDelete(productId);
    } else {
        // Nếu > 0 thì cập nhật số lượng bình thường
        window.location.href = "cart?action=update&productId=" + productId + "&quantity=" + newQty;
    }
}
</script>