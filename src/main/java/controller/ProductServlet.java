<div class="product-grid">
    <c:forEach var="p" items="${products}">
        <div class="product-item">
            <a href="${pageContext.request.contextPath}/san-pham/${p.slug}">
                <img src="${p.imageUrl}" alt="${p.name}">
<h3>${p.name}</h3>
                <p class="price">
                    <%-- Định dạng tiền tệ VNĐ --%>
                    <fmt:formatNumber value="${p.displayPrice}" type="currency" currencySymbol="₫" />
                </p>
            </a>
            <c:if test="${p.soldCount > 50}">
                <span class="badge">Bán chạy</span>
            </c:if>
        </div>
    </c:forEach>

    <c:if test="${empty products}">
<p>Không tìm thấy sản phẩm nào.</p>
    </c:if>
</div>