<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="address-container">
<h2>Sổ địa chỉ của tôi</h2>

    <%-- Kiểm tra nếu danh sách trống --%>
    <c:if test="${empty addressList}">
<p>Bạn chưa có địa chỉ nào được lưu.</p>
    </c:if>

    <%-- Duyệt danh sách địa chỉ --%>
    <c:forEach var="addr" items="${addressList}">
        <div class="address-item ${addr.default ? 'border-primary' : ''}">
            <div class="info">
<strong>${addr.receiverName}</strong>
                <c:if test="${addr.default}">
                    <span class="badge bg-success">Mặc định</span>
                </c:if>
                <br>
                <span>SĐT: ${addr.phone}</span><br>
<span>Địa chỉ: ${addr.addressDetail}, ${addr.ward}, ${addr.district}, ${addr.province}</span>

                <c:if test="${not empty addr.note}">
                    <p><small>Ghi chú: ${addr.note}</small></p>
                </c:if>
            </div>

            <div class="actions">
                <%-- Nút Sửa --%>
                <a href="address/edit?id=${addr.id}" class="btn btn-sm btn-outline-info">Sửa</a>

                <%-- Nút Xóa (Dùng form hoặc link tùy logic của bạn) --%>
                <a href="address/delete/${addr.id}"
onclick="return confirm('Xác nhận xóa địa chỉ này?')"
class="btn btn-sm btn-outline-danger">Xóa</a>

                <%-- Nút Đặt mặc định --%>
                <c:if test="${!addr.default}">
                    <a href="address/set-default/${addr.id}" class="btn btn-sm btn-link">Đặt mặc định</a>
                </c:if>
            </div>
        </div>
        <hr>
    </c:forEach>

    <div class="mt-3">
        <a href="address/add" class="btn btn-primary">Thêm địa chỉ mới</a>
    </div>
</div>