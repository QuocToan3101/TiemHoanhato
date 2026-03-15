<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <title>${pageTitle != null ? pageTitle : 'Sản phẩm'} - Tiệm Hoa nhà tớ</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    
    <!-- CSRF Token -->
    <meta name="csrf-token" content="${csrfToken}">
    <script>window.csrfToken = '${csrfToken}';</script>
    
    <link rel="shortcut icon" href="//cdn.hstatic.net/themes/200000846175/1001403720/14/favicon.png?v=245" type="image/x-icon" />
    
    <!-- Font -->
    <link href="https://fonts.googleapis.com/css2?family=Crimson+Text:wght@400;600;700&display=swap" rel="stylesheet" />
    
    <!-- CSS theme -->
    <link href="//cdn.hstatic.net/themes/200000846175/1001403720/14/plugin-style.css?v=245" rel="stylesheet" />
    <link href="//cdn.hstatic.net/themes/200000846175/1001403720/14/styles-new.scss.css?v=245" rel="stylesheet" />
    
    <!-- Font Awesome - load sau theme để override -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    
    <style>
        /* Fix Font Awesome icons */
        .fas, .far, .fab, .fa-solid, .fa-regular, .fa-brands {
            font-family: "Font Awesome 6 Free" !important;
            font-weight: 900;
        }
        .far, .fa-regular {
            font-weight: 400;
        }
        
        :root {
            --bg-page: #faf5ef;
            --brown-main: #3c2922;
            --brown-soft: #6c5845;
            --accent: #c99366;
            --accent-dark: #aa6a3f;
            --header-height: 72px;
        }
        
        /* Reset and base */
        *, *::before, *::after {
            box-sizing: border-box;
        }
        
        body {
            background: linear-gradient(
            135deg,
            rgba(201, 147, 102, 0.95) 0%,
            rgba(170, 106, 63, 0.95) 100%
            ),
            url("https://images.unsplash.com/photo-1487070183336-b863922373d4?w=1200")
            center/cover;
            font-family: 'Crimson Text', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
        }
        
        /* Fix for fixed header */
        main {
            padding-top: var(--header-height);
            min-height: calc(100vh - var(--header-height));
        }
        
        /* Ensure header is fixed */
        #header, .site-header {
            position: fixed !important;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            background: #fff;
        }
        
        /* HERO */
        .product-hero {
            background: linear-gradient(
            135deg,
            rgba(201, 147, 102, 0.95) 0%,
            rgba(170, 106, 63, 0.95) 100%
            ),
            url("https://images.unsplash.com/photo-1487070183336-b863922373d4?w=1200")
            center/cover;
            color: #fff;
            padding: 4rem 1.5rem 3rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .product-hero::before {
            content: "";
            position: absolute;
            top: -50%;
            right: -8%;
            width: 420px;
            height: 420px;
            background: radial-gradient(circle, rgba(255,255,255,0.15) 0%, transparent 70%);
            border-radius: 50%;
        }
        
        .product-hero-inner {
            position: relative;
            z-index: 1;
            max-width: 780px;
            margin: 0 auto;
        }
        
        .product-title {
            font-size: 2.7rem;
            font-weight: 700;
            letter-spacing: -0.02em;
            margin: 0.5rem 0 0.75rem;
            text-shadow: 0 2px 12px rgba(0,0,0,0.18);
        }
        
        .product-subtitle {
            font-size: 1.1rem;
            opacity: 0.96;
            font-style: italic;
        }
        
        /* Breadcrumb */
        .breadcrumb-section {
            background: #fff;
            padding: 1rem 0;
            border-bottom: 1px solid #e8ddd4;
        }
        
        .breadcrumb {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.9rem;
        }
        
        .breadcrumb a {
            color: var(--brown-soft);
            text-decoration: none;
        }
        
        .breadcrumb a:hover {
            color: var(--accent-dark);
        }
        
        .breadcrumb span {
            color: var(--brown-main);
        }
        
        /* WRAPPER */
        .product-wrapper {
            max-width: 1400px;
            margin: -2.5rem auto 3.5rem;
            padding: 1.8rem 1.5rem 2.5rem;
            background: #ffffff;
            border-radius: 22px;
            box-shadow: 0 14px 40px rgba(0,0,0,0.08);
            position: relative;
            z-index: 5;
        }
        
        /* Collection Head */
        .collection-head {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 1.5rem;
            margin-bottom: 1.2rem;
            flex-wrap: wrap;
        }
        
        .collection-head-left h2 {
            font-size: 1.4rem;
            font-weight: 700;
            color: var(--brown-main);
            margin-bottom: 0.25rem;
        }
        
        .collection-head-left p {
            font-size: 0.95rem;
            color: var(--brown-soft);
        }
        
        /* Collection Tabs */
        .collection-tabs {
            display: flex;
            flex-wrap: nowrap;
            gap: 0.5rem;
            padding: 0.3rem;
            background: #faf3ea;
            border-radius: 999px;
            border: 1px solid rgba(210,180,160,0.7);
            overflow-x: auto;
            max-width: 100%;
        }
        
        .tab-btn {
            border-radius: 999px;
            border: none;
            padding: 7px 16px;
            font-size: 0.86rem;
            white-space: nowrap;
            cursor: pointer;
            background: transparent;
            color: #7a5a44;
            font-weight: 600;
            transition: 0.18s ease;
            text-decoration: none;
        }
        
        .tab-btn.active {
            background: linear-gradient(135deg, var(--accent), var(--accent-dark));
            color: #fff;
            box-shadow: 0 8px 20px rgba(170,106,63,0.3);
        }
        
        .tab-btn:not(.active):hover {
            background: rgba(255,255,255,0.9);
        }
        
        /* FILTER BAR */
        .filter-bar {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 18px;
            padding: 12px 18px;
            background: #fbf1e4;
            border-radius: 16px;
            box-shadow: 0 4px 14px rgba(160,130,100,0.12);
            border: 1px solid rgba(210,180,160,0.5);
        }
        
        .filter-label-main {
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            color: var(--brown-soft);
            font-weight: 600;
            white-space: nowrap;
        }
        
        .filter-controls {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }
        
        .filter-select {
            min-width: 150px;
            border-radius: 999px;
            border: 1px solid rgba(198,149,112,0.7);
            padding: 6px 12px;
            font-size: 0.85rem;
            color: #634638;
            background: #fff;
            outline: none;
        }
        
        .filter-select:focus {
            border-color: var(--accent-dark);
            box-shadow: 0 0 0 1px rgba(201,147,102,0.4);
        }
        
        /* Reset Filter Button */
        .filter-reset {
            background: #e74c3c;
            color: #fff;
            border: none;
            padding: 6px 14px;
            border-radius: 999px;
            font-size: 0.85rem;
            cursor: pointer;
            transition: 0.2s;
            font-weight: 500;
        }
        
        .filter-reset:hover {
            background: #c0392b;
        }
        
        /* Search Box */
        .search-box {
            display: flex;
            gap: 8px;
        }
        
        .search-input {
            min-width: 200px;
            border-radius: 999px;
            border: 1px solid rgba(198,149,112,0.7);
            padding: 6px 16px;
            font-size: 0.85rem;
            outline: none;
        }
        
        .search-btn {
            background: var(--accent);
            color: #fff;
            border: none;
            padding: 6px 16px;
            border-radius: 999px;
            cursor: pointer;
            font-size: 0.85rem;
        }
        
        .search-btn:hover {
            background: var(--accent-dark);
        }
        
        /* GRID */
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 8px;
        }
        
        /* Product Card */
        .product-card {
            display: flex;
            flex-direction: column;
            background: #ffffff;
            border-radius: 18px;
            overflow: hidden;
            box-shadow: 0 6px 20px rgba(160,130,100,0.18);
            border: 1px solid rgba(210,180,160,0.4);
            transition: transform 0.18s ease, box-shadow 0.18s ease, border-color 0.18s ease;
        }
        
        .product-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 28px rgba(150,120,90,0.26);
            border-color: rgba(201,147,102,0.9);
        }
        
        .product-card > a {
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        
        .product-image-wrap {
            position: relative;
            width: 100%;
            aspect-ratio: 1 / 1;
            overflow: hidden;
        }
        
        .product-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
            transition: transform 0.3s ease;
        }
        
        .product-card:hover .product-image {
            transform: scale(1.05);
        }
        
        .product-badge {
            position: absolute;
            top: 12px;
            left: 12px;
            background: #e74c3c;
            color: #fff;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        
        .product-badge.featured {
            background: var(--accent);
        }
        
        .product-body {
            padding: 14px 16px 16px;
            display: flex;
            flex-direction: column;
            gap: 8px;
            flex: 1;
        }
        
        .product-category {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--accent);
            font-weight: 600;
        }
        
        .product-name {
            font-size: 1.05rem;
            font-weight: 700;
            color: var(--brown-main);
            line-height: 1.3;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .product-price-wrap {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-top: auto;
        }
        
        .product-price {
            font-size: 1.1rem;
            color: var(--accent-dark);
            font-weight: 700;
        }
        
        .product-original-price {
            font-size: 0.9rem;
            color: #999;
            text-decoration: line-through;
        }
        
        .product-actions {
            display: flex;
            gap: 8px;
            margin-top: 8px;
        }
        
        .btn-add-cart {
            flex: 1;
            background: linear-gradient(135deg, var(--accent), var(--accent-dark));
            color: #fff;
            border: none;
            padding: 8px 12px;
            border-radius: 999px;
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .btn-add-cart:hover {
            transform: scale(1.02);
            box-shadow: 0 4px 12px rgba(170,106,63,0.4);
        }
        
        .btn-wishlist {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            border: 1px solid rgba(210,180,160,0.6);
            background: #fff;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--brown-soft);
            transition: all 0.2s;
        }
        
        .btn-wishlist:hover {
            background: #faf3ea;
            color: #e74c3c;
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--brown-soft);
        }
        
        .empty-state i {
            font-size: 4rem;
            color: var(--accent);
            margin-bottom: 20px;
        }
        
        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 10px;
            color: var(--brown-main);
        }
        
        .empty-state p {
            margin-bottom: 20px;
        }
        
        .empty-state a {
            display: inline-block;
            background: var(--accent);
            color: #fff;
            padding: 10px 24px;
            border-radius: 999px;
            text-decoration: none;
            font-weight: 600;
        }
        
        /* PAGINATION */
        .pagination-container {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 6px;
            margin-top: 40px;
        }
        
        .page-btn {
            background: #f4e1d1;
            border: 1px solid #d8c1b0;
            padding: 8px 14px;
            border-radius: 10px;
            cursor: pointer;
            color: #6c5845;
            font-weight: 600;
            transition: 0.2s;
            text-decoration: none;
        }
        
        .page-btn:hover {
            background: #e9d2bd;
        }
        
        .page-btn.disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        .page-number {
            padding: 8px 14px;
            background: #fff;
            border: 1px solid #d8c1b0;
            border-radius: 10px;
            cursor: pointer;
            color: #6c5845;
            transition: 0.2s;
            font-size: 0.9rem;
            text-decoration: none;
        }
        
        .page-number.active {
            background: var(--accent-dark);
            color: #fff;
            border-color: var(--accent-dark);
        }
        
        /* Sidebar */
        .product-layout {
            display: grid;
            grid-template-columns: 250px 1fr;
            gap: 30px;
        }
        
        @media (max-width: 992px) {
            .product-layout {
                grid-template-columns: 1fr;
            }
            .sidebar {
                display: none;
            }
        }
        
        .sidebar {
            position: sticky;
            top: 100px;
            height: fit-content;
        }
        
        .sidebar-widget {
            background: #fff;
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.06);
        }
        
        .sidebar-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--brown-main);
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--accent);
        }
        
        .category-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .category-list li {
            margin-bottom: 8px;
        }
        
        .category-list a {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 12px;
            border-radius: 8px;
            color: var(--brown-soft);
            text-decoration: none;
            transition: all 0.2s;
        }
        
        .category-list a:hover,
        .category-list a.active {
            background: #faf3ea;
            color: var(--accent-dark);
        }
        
        .category-count {
            background: #f4e1d1;
            padding: 2px 8px;
            border-radius: 999px;
            font-size: 0.75rem;
        }
        
        /* Price Filter */
        .price-range {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
        }
        
        .price-input {
            flex: 1;
            padding: 8px;
            border: 1px solid #d8c1b0;
            border-radius: 8px;
            font-size: 0.85rem;
        }
        
        .btn-filter {
            width: 100%;
            background: var(--accent);
            color: #fff;
            border: none;
            padding: 10px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
        }
        
        @media (max-width: 640px) {
            .product-title {
                font-size: 2.1rem;
            }
            .product-wrapper {
                margin: -2rem 1rem 3rem;
                padding: 1.5rem 1.1rem 2rem;
            }
            .filter-bar {
                flex-direction: column;
                align-items: stretch;
                border-radius: 16px;
                padding: 12px;
                gap: 10px;
            }
            .filter-controls {
                flex-direction: column;
                width: 100%;
            }
            .search-box {
                width: 100%;
            }
            .search-input {
                flex: 1;
                min-width: auto;
            }
            .filter-select {
                width: 100%;
            }
            .products-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 12px;
            }
            .product-card .product-body {
                padding: 10px 12px 12px;
            }
            .product-card .product-name {
                font-size: 0.95rem;
            }
            .product-card .btn-add-cart {
                padding: 6px 10px;
                font-size: 0.8rem;
            }
            .collection-head {
                flex-direction: column;
                align-items: flex-start;
            }
            .collection-tabs {
                width: 100%;
                justify-content: flex-start;
            }
        }
    </style>
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
    
    <!-- CSRF Token Helper -->
    <script src="${pageContext.request.contextPath}/fileJS/csrf-token.js"></script>
</head>

<body id="wandave-theme" class="index">
    <!-- HEADER -->
    <%@ include file="partials/header.jsp" %>
    
    <main>
        <!-- HERO -->
        <section class="product-hero">
            <div class="product-hero-inner">
                <h1 class="product-title">${pageTitle != null ? pageTitle : 'Bộ sưu tập'}</h1>
                <p class="product-subtitle">
                    <c:choose>
                        <c:when test="${searchKeyword != null}">
                            Kết quả tìm kiếm cho "${searchKeyword}"
                        </c:when>
                        <c:when test="${category != null}">
                            ${category.description != null ? category.description : 'Khám phá những bó hoa đẹp nhất'}
                        </c:when>
                        <c:otherwise>
                            Những bó hoa "trend" nhất của nhà tớ
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>
        </section>
        
        <!-- Breadcrumb -->
        <div class="breadcrumb-section">
            <nav class="breadcrumb">
                <a href="${pageContext.request.contextPath}/view/home.jsp">Trang chủ</a>
                <span>/</span>
                <c:choose>
                    <c:when test="${category != null}">
                        <a href="${pageContext.request.contextPath}/products">Sản phẩm</a>
                        <span>/</span>
                        <span>${category.name}</span>
                    </c:when>
                    <c:otherwise>
                        <span>Sản phẩm</span>
                    </c:otherwise>
                </c:choose>
            </nav>
        </div>
        
        <div class="product-wrapper">
            <!-- Collection Tabs -->
            <div class="collection-head">
                <div class="collection-head-left">
                    <h2>
                        <c:choose>
                            <c:when test="${category != null}">${category.name}</c:when>
                            <c:when test="${searchKeyword != null}">Kết quả tìm kiếm</c:when>
                            <c:otherwise>Tất cả sản phẩm</c:otherwise>
                        </c:choose>
                    </h2>
                    <p>Tìm thấy ${totalProducts != null ? totalProducts : (products != null ? products.size() : 0)} sản phẩm</p>
                </div>
                
                <div class="collection-tabs">
                    <a href="${pageContext.request.contextPath}/products" class="tab-btn ${category == null && searchKeyword == null ? 'active' : ''}">
                        Tất cả
                    </a>
                    <c:if test="${not empty parentCategories}">
                    <c:forEach var="parentCat" items="${parentCategories}">
                        <a href="${pageContext.request.contextPath}/products/category/${parentCat.slug}" 
                           class="tab-btn ${not empty category && category.id eq parentCat.id ? 'active' : ''}">
                            ${parentCat.name}
                        </a>
                    </c:forEach>
                    </c:if>
                </div>
            </div>
            
            <!-- FILTER BAR -->
            <div class="filter-bar">
                <div class="filter-label-main">
                    <i class="fas fa-filter"></i> Bộ lọc
                </div>
                
                <div class="filter-controls">
                    <form action="${pageContext.request.contextPath}/search" method="get" class="search-box">
                        <input type="text" name="q" class="search-input" placeholder="Tìm kiếm sản phẩm..." 
                               value="${searchKeyword != null ? searchKeyword : ''}">
                        <button type="submit" class="search-btn">
                            <i class="fas fa-search"></i>
                        </button>
                    </form>
                    
                    <select id="sortFilter" class="filter-select" onchange="applySort(this.value)">
                        <option value="">Sắp xếp</option>
                        <option value="price-asc" ${param.sort == 'price-asc' ? 'selected' : ''}>Giá: Thấp đến Cao</option>
                        <option value="price-desc" ${param.sort == 'price-desc' ? 'selected' : ''}>Giá: Cao đến Thấp</option>
                        <option value="newest" ${param.sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                        <option value="bestselling" ${param.sort == 'bestselling' ? 'selected' : ''}>Bán chạy</option>
                        <option value="name-asc" ${param.sort == 'name-asc' ? 'selected' : ''}>Tên: A-Z</option>
                    </select>
                    
                    <select id="priceFilter" class="filter-select" onchange="applyPriceFilter(this.value)">
                        <option value="">Khoảng giá</option>
                        <option value="0-500000" ${param.minPrice == '0' && param.maxPrice == '500000' ? 'selected' : ''}>Dưới 500.000đ</option>
                        <option value="500000-1000000" ${param.minPrice == '500000' && param.maxPrice == '1000000' ? 'selected' : ''}>500.000đ - 1.000.000đ</option>
                        <option value="1000000-2000000" ${param.minPrice == '1000000' && param.maxPrice == '2000000' ? 'selected' : ''}>1.000.000đ - 2.000.000đ</option>
                        <option value="2000000-9999999999" ${param.minPrice == '2000000' ? 'selected' : ''}>Trên 2.000.000đ</option>
                    </select>
                    
                    <c:if test="${param.minPrice != null || param.sort != null}">
                        <button type="button" class="filter-reset" onclick="resetFilters()">
                            <i class="fas fa-times"></i> Xóa bộ lọc
                        </button>
                    </c:if>
                </div>
            </div>
            
            <!-- PRODUCTS GRID -->
            <c:choose>
                <c:when test="${empty products}">
                    <div class="empty-state">
                        <i class="fas fa-search"></i>
                        <h3>Không tìm thấy sản phẩm</h3>
                        <p>Hãy thử tìm kiếm với từ khóa khác hoặc xem tất cả sản phẩm</p>
                        <a href="${pageContext.request.contextPath}/products">Xem tất cả sản phẩm</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="products-grid">
                        <c:forEach var="product" items="${products}">
                            <article class="product-card">
                                <a href="${pageContext.request.contextPath}/products/${product.slug}" style="text-decoration: none; color: inherit; display: block;">
                                    <div class="product-image-wrap">
                                        <img class="product-image" 
                                             src="${product.image != null ? product.image : 'https://via.placeholder.com/300x300?text=No+Image'}" 
                                             alt="${product.name}"
                                             onerror="this.src='https://via.placeholder.com/300x300?text=No+Image'" />
                                        
                                        <c:if test="${product.onSale}">
                                            <span class="product-badge">-${product.discountPercent}%</span>
                                        </c:if>
                                        <c:if test="${product.featured && !product.onSale}">
                                            <span class="product-badge featured">Nổi bật</span>
                                        </c:if>
                                    </div>
                                    
                                    <div class="product-body">
                                        <c:if test="${product.category != null}">
                                            <div class="product-category">${product.category.name}</div>
                                        </c:if>
                                        
                                        <h3 class="product-name">${product.name}</h3>
                                        
                                        <div class="product-price-wrap">
                                            <c:choose>
                                                <c:when test="${product.displayPrice != null}">
                                                    <span class="product-price">
                                                        <fmt:formatNumber value="${product.displayPrice}" pattern="#,###"/> ₫
                                                    </span>
                                                </c:when>
                                                <c:when test="${product.price != null}">
                                                    <span class="product-price">
                                                        <fmt:formatNumber value="${product.price}" pattern="#,###"/> ₫
                                                    </span>
                                                </c:when>
                                            </c:choose>
                                            <c:if test="${product.onSale && product.price != null && product.displayPrice != null}">
                                                <span class="product-original-price">
                                                    <fmt:formatNumber value="${product.price}" pattern="#,###"/> ₫
                                                </span>
                                            </c:if>
                                        </div>
                                    </div>
                                </a>
                                
                                <div class="product-actions" style="padding: 0 16px 16px;">
                                    <button class="btn-add-cart" data-product-id="${product.id}" onclick="event.preventDefault(); addToCart('${product.id}', 1);">
                                        <i class="fas fa-shopping-cart"></i> Thêm vào giỏ
                                    </button>
                                    <button class="btn-wishlist" data-product-id="${product.id}" onclick="event.preventDefault(); toggleWishlist('${product.id}');">
                                        <i class="far fa-heart"></i>
                                    </button>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                    
                    <!-- PAGINATION -->
                    <c:if test="${totalPages != null && totalPages > 1}">
                        <div class="pagination-container" id="pagination">
                            <c:set var="prevPage" value="${currentPage - 1}" />
                            <c:set var="nextPage" value="${currentPage + 1}" />
                            <c:if test="${currentPage > 1}">
                                <a href="#" onclick="loadPage(${prevPage}); return false;" class="page-btn">
                                    <i class="fas fa-chevron-left"></i> Trước
                                </a>
                            </c:if>
                            
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <a href="#" onclick="loadPage(${i}); return false;" 
                                   class="page-number ${currentPage == i ? 'active' : ''}">${i}</a>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages}">
                                <a href="#" onclick="loadPage(${nextPage}); return false;" class="page-btn">
                                    Sau <i class="fas fa-chevron-right"></i>
                                </a>
                            </c:if>
                        </div>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
    
    <!-- FOOTER -->
    <%@ include file="partials/footer.jsp" %>
    
    <!-- Toast Notification -->
    <div id="toast" style="display:none; position:fixed; bottom:30px; right:30px; background:#27ae60; color:#fff; padding:15px 25px; border-radius:10px; box-shadow:0 4px 15px rgba(0,0,0,0.2); z-index:9999; font-weight:600;">
        <i class="fas fa-check-circle"></i> <span id="toastMessage"></span>
    </div>
    
    <script>
        // Context path và các biến từ server
        const contextPath = '${pageContext.request.contextPath}';
        <c:choose>
            <c:when test="${currentPage != null}">
                let currentPage = ${currentPage};
            </c:when>
            <c:otherwise>
                let currentPage = 1;
            </c:otherwise>
        </c:choose>
        <c:choose>
            <c:when test="${param.sort != null}">
                let currentSort = '${param.sort}';
            </c:when>
            <c:otherwise>
                let currentSort = '';
            </c:otherwise>
        </c:choose>
        <c:choose>
            <c:when test="${param.category != null}">
                let currentCategory = '${param.category}';
            </c:when>
            <c:otherwise>
                let currentCategory = '';
            </c:otherwise>
        </c:choose>
        
        /**
         * Load trang mới bằng AJAX
         */
        function loadPage(page) {
            // Hiển thị loading
            const productsGrid = document.querySelector('.products-grid');
            if (productsGrid) {
                productsGrid.style.opacity = '0.5';
                productsGrid.style.pointerEvents = 'none';
            }
            
            // Tạo URL với params
            const params = new URLSearchParams();
            params.append('ajax', 'true');
            params.append('page', page);
            if (currentSort) params.append('sort', currentSort);
            if (currentCategory) params.append('category', currentCategory);
            
            // Gọi AJAX
            fetch(contextPath + '/products?' + params.toString())
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Cập nhật sản phẩm
                        renderProducts(data.products);
                        
                        // Cập nhật pagination
                        renderPagination(data.currentPage, data.totalPages);
                        
                        // Cập nhật current page
                        currentPage = data.currentPage;
                        
                        // Scroll to top
                        window.scrollTo({ top: 0, behavior: 'smooth' });
                    } else {
                        showToast('Lỗi tải dữ liệu: ' + data.error, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showToast('Có lỗi xảy ra khi tải trang!', 'error');
                })
                .finally(() => {
                    // Ẩn loading
                    if (productsGrid) {
                        productsGrid.style.opacity = '1';
                        productsGrid.style.pointerEvents = 'auto';
                    }
                });
        }
        
        /**
         * Escape HTML để tránh XSS
         */
        function escapeHtml(text) {
            const map = {
                '&': '&amp;',
                '<': '&lt;',
                '>': '&gt;',
                '"': '&quot;',
                "'": '&#039;'
            };
            return text.replace(/[&<>"']/g, function(m) { return map[m]; });
        }
        
        /**
         * Render danh sách sản phẩm
         */
        function renderProducts(products) {
            const productsGrid = document.querySelector('.products-grid');
            if (!productsGrid) return;
            
            let html = '';
            products.forEach(product => {
                const productName = escapeHtml(product.name);
                const productSlug = escapeHtml(product.slug);
                const productImage = product.image || 'https://via.placeholder.com/300x300?text=No+Image';
                
                // Tạo HTML cho giá
                let priceHtml = '';
                if (product.salePrice && product.salePrice > 0) {
                    // Có giá sale
                    priceHtml = '<div class="product-price-wrap">' +
                        '<span class="product-price">' + formatPrice(product.salePrice) + ' ₫</span>' +
                        '<span class="product-original-price">' + formatPrice(product.price) + ' ₫</span>' +
                    '</div>';
                } else {
                    // Giá bình thường
                    priceHtml = '<div class="product-price-wrap">' +
                        '<span class="product-price">' + formatPrice(product.price) + ' ₫</span>' +
                    '</div>';
                }
                
                html += '<article class="product-card">' +
                    '<a href="' + contextPath + '/products/' + productSlug + '" style="text-decoration: none; color: inherit; display: block;">' +
                        '<div class="product-image-wrap">' +
                            '<img class="product-image" ' +
                                 'src="' + productImage + '" ' +
                                 'alt="' + productName + '" ' +
                                 'onerror="this.src=\'https://via.placeholder.com/300x300?text=No+Image\'" />' +
                        '</div>' +
                        '<div class="product-body">' +
                            '<h3 class="product-name">' + productName + '</h3>' +
                            priceHtml +
                        '</div>' +
                    '</a>' +
                    '<div class="product-actions" style="padding: 0 16px 16px;">' +
                        '<button class="btn-add-cart" data-product-id="' + product.id + '" ' +
                                'onclick="event.preventDefault(); addToCart(' + product.id + ', 1);">' +
                            '<i class="fas fa-shopping-cart"></i> Thêm vào giỏ' +
                        '</button>' +
                        '<button class="btn-wishlist" data-product-id="' + product.id + '" ' +
                                'onclick="event.preventDefault(); toggleWishlist(' + product.id + ');">' +
                            '<i class="far fa-heart"></i>' +
                        '</button>' +
                    '</div>' +
                '</article>';
            });
            
            productsGrid.innerHTML = html;
        }
        
        /**
         * Render pagination
         */
        function renderPagination(currentPage, totalPages) {
            const paginationContainer = document.getElementById('pagination');
            if (!paginationContainer || totalPages <= 1) {
                if (paginationContainer) paginationContainer.style.display = 'none';
                return;
            }
            
            paginationContainer.style.display = 'flex';
            
            let html = '';
            
            // Nút Previous
            if (currentPage > 1) {
                html += '<a href="#" onclick="loadPage(' + (currentPage - 1) + '); return false;" class="page-btn">' +
                    '<i class="fas fa-chevron-left"></i> Trước' +
                '</a>';
            }
            
            // Các số trang
            for (let i = 1; i <= totalPages; i++) {
                const activeClass = currentPage === i ? 'active' : '';
                html += '<a href="#" ' +
                            'onclick="loadPage(' + i + '); return false;" ' +
                            'class="page-number ' + activeClass + '">' + i + '</a>';
            }
            
            // Nút Next
            if (currentPage < totalPages) {
                html += '<a href="#" onclick="loadPage(' + (currentPage + 1) + '); return false;" class="page-btn">' +
                    'Sau <i class="fas fa-chevron-right"></i>' +
                '</a>';
            }
            
            paginationContainer.innerHTML = html;
        }
        
        /**
         * Format giá tiền
         */
        function formatPrice(price) {
            return new Intl.NumberFormat('vi-VN').format(price);
        }
        
        // Sort products
        function applySort(sortValue) {
            if (sortValue) {
                currentSort = sortValue;
                loadPage(1); // Load lại trang 1 với sort mới
            }
        }
        
        // Price filter
        function applyPriceFilter(range) {
            if (range) {
                const [min, max] = range.split('-');
                const url = new URL(window.location.href);
                url.searchParams.set('minPrice', min);
                url.searchParams.set('maxPrice', max);
                window.location.href = url.toString();
            }
        }
        
        // Reset all filters
        function resetFilters() {
            const url = new URL(window.location.href);
            url.searchParams.delete('minPrice');
            url.searchParams.delete('maxPrice');
            url.searchParams.delete('sort');
            url.searchParams.delete('page');
            window.location.href = url.toString();
        }
        
        // Add to cart
        function addToCart(productId, quantity) {
            fetch(contextPath + '/api/cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'productId=' + productId + '&quantity=' + quantity
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast('Đã thêm vào giỏ hàng!');
                    // Update cart count in header if exists
                    const cartCount = document.querySelector('.cart-count');
                    if (cartCount && data.cartCount) {
                        cartCount.textContent = data.cartCount;
                    }
                } else {
                    if (data.message.includes('đăng nhập')) {
                        window.location.href = contextPath + '/login';
                    } else {
                        showToast(data.message, 'error');
                    }
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('Có lỗi xảy ra!', 'error');
            });
        }
        
        // Toggle wishlist
        async function toggleWishlist(productId) {
            try {
                const response = await fetch(contextPath + '/api/wishlist', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        action: 'toggle',
                        productId: parseInt(productId)
                    })
                });
                
                const result = await response.json();
                
                if (result.success) {
                    const btn = document.querySelector('.btn-wishlist[data-product-id="' + productId + '"]');
                    const icon = btn.querySelector('i');
                    
                    if (result.inWishlist) {
                        icon.className = 'fas fa-heart';
                        btn.style.color = '#e74c3c';
                        showToast('Đã thêm vào yêu thích', 'success');
                    } else {
                        icon.className = 'far fa-heart';
                        btn.style.color = '';
                        showToast('Đã xóa khỏi yêu thích', 'info');
                    }
                } else {
                    showToast(result.message || 'Vui lòng đăng nhập', 'error');
                }
            } catch (error) {
                console.error('Error toggling wishlist:', error);
                showToast('Có lỗi xảy ra', 'error');
            }
        }
        
        // Show toast notification
        function showToast(message, type = 'success') {
            const toast = document.getElementById('toast');
            const toastMessage = document.getElementById('toastMessage');
            
            toast.style.background = type === 'error' ? '#e74c3c' : (type === 'info' ? '#3498db' : '#27ae60');
            toastMessage.textContent = message;
            toast.style.display = 'block';
            
            setTimeout(() => {
                toast.style.display = 'none';
            }, 3000);
        }
    </script>
</body>
</html>
