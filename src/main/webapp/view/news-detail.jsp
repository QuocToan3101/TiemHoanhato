<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${news.title} - Tiệm Hoa nhà tớ</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            line-height: 1.6;
            color: #333;
            background: #f8f9fa;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        /* Header */
        .header {
            background: white;
            padding: 20px 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 40px;
        }
        
        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .logo {
            font-family: 'Playfair Display', serif;
            font-size: 24px;
            font-weight: 700;
            color: #c99366;
            text-decoration: none;
        }
        
        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            background: #f0f0f0;
            color: #333;
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s;
        }
        
        .back-btn:hover {
            background: #e0e0e0;
        }
        
        /* Main Content */
        .news-detail {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 20px rgba(0,0,0,0.08);
            margin-bottom: 40px;
        }
        
        .news-header {
            padding: 40px;
            border-bottom: 1px solid #eee;
        }
        
        .news-category {
            display: inline-block;
            padding: 6px 16px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 16px;
        }
        
        .news-title {
            font-family: 'Playfair Display', serif;
            font-size: 36px;
            font-weight: 700;
            line-height: 1.3;
            margin-bottom: 20px;
            color: #2c3e50;
        }
        
        .news-meta {
            display: flex;
            gap: 30px;
            color: #666;
            font-size: 14px;
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .news-featured-image {
            width: 100%;
            height: 500px;
            object-fit: cover;
        }
        
        .news-body {
            padding: 40px;
        }
        
        .news-excerpt {
            font-size: 18px;
            line-height: 1.8;
            color: #555;
            margin-bottom: 30px;
            padding: 20px;
            background: #f8f9fa;
            border-left: 4px solid #c99366;
            border-radius: 4px;
        }
        
        .news-content {
            font-size: 16px;
            line-height: 1.8;
            color: #444;
        }
        
        .news-content h3 {
            font-family: 'Playfair Display', serif;
            font-size: 24px;
            font-weight: 600;
            margin: 30px 0 15px;
            color: #2c3e50;
        }
        
        .news-content p {
            margin-bottom: 20px;
        }
        
        .news-content ul, .news-content ol {
            margin: 20px 0;
            padding-left: 30px;
        }
        
        .news-content li {
            margin-bottom: 10px;
        }
        
        .news-content strong {
            color: #2c3e50;
            font-weight: 600;
        }
        
        /* Related News */
        .related-news {
            margin-top: 60px;
        }
        
        .section-title {
            font-family: 'Playfair Display', serif;
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 30px;
            text-align: center;
            color: #2c3e50;
        }
        
        .related-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 30px;
        }
        
        .related-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 15px rgba(0,0,0,0.08);
            transition: transform 0.3s, box-shadow 0.3s;
            text-decoration: none;
            color: inherit;
        }
        
        .related-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 25px rgba(0,0,0,0.15);
        }
        
        .related-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }
        
        .related-content {
            padding: 20px;
        }
        
        .related-title {
            font-weight: 600;
            font-size: 16px;
            line-height: 1.4;
            margin-bottom: 10px;
            color: #2c3e50;
        }
        
        .related-date {
            font-size: 14px;
            color: #999;
        }
        
        /* Footer */
        .footer {
            background: #2c3e50;
            color: white;
            padding: 40px 0;
            text-align: center;
            margin-top: 60px;
        }
        
        @media (max-width: 768px) {
            .news-title {
                font-size: 28px;
            }
            
            .news-featured-image {
                height: 300px;
            }
            
            .news-header, .news-body {
                padding: 20px;
            }
            
            .related-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <a href="${pageContext.request.contextPath}/" class="logo">Tiệm Hoa nhà tớ</a>
                <a href="${pageContext.request.contextPath}/news" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
            </div>
        </div>
    </header>
    
    <!-- Main Content -->
    <div class="container">
        <c:if test="${not empty news}">
            <article class="news-detail">
                <div class="news-header">
                    <span class="news-category">${news.categoryName}</span>
                    <h1 class="news-title">${news.title}</h1>
                    <div class="news-meta">
                        <div class="meta-item">
                            <i class="far fa-calendar"></i>
                            <fmt:formatDate value="${news.publishedDate}" pattern="dd/MM/yyyy" />
                        </div>
                        <div class="meta-item">
                            <i class="far fa-user"></i>
                            ${news.author != null ? news.author : 'Admin'}
                        </div>
                        <div class="meta-item">
                            <i class="far fa-eye"></i>
                            ${news.views} lượt xem
                        </div>
                    </div>
                </div>
                
                <c:if test="${not empty news.imageUrl}">
                    <img src="${news.imageUrl}" alt="${news.title}" class="news-featured-image" onerror="this.style.display='none'" />
                </c:if>
                
                <div class="news-body">
                    <c:if test="${not empty news.excerpt}">
                        <div class="news-excerpt">${news.excerpt}</div>
                    </c:if>
                    
                    <div class="news-content">
                        ${news.content}
                    </div>
                </div>
            </article>
            
            <!-- Related News -->
            <c:if test="${not empty relatedNews}">
                <section class="related-news">
                    <h2 class="section-title">Bài viết liên quan</h2>
                    <div class="related-grid">
                        <c:forEach var="related" items="${relatedNews}">
                            <a href="${pageContext.request.contextPath}/news/${related.slug}" class="related-card">
                                <img src="${related.imageUrl}" alt="${related.title}" class="related-image" onerror="this.src='https://via.placeholder.com/300x200?text=No+Image'" />
                                <div class="related-content">
                                    <h3 class="related-title">${related.title}</h3>
                                    <div class="related-date">
                                        <fmt:formatDate value="${related.publishedDate}" pattern="dd/MM/yyyy" />
                                    </div>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </section>
            </c:if>
        </c:if>
        
        <c:if test="${empty news}">
            <div style="text-align: center; padding: 100px 20px;">
                <i class="fas fa-newspaper" style="font-size: 64px; color: #ddd; margin-bottom: 20px;"></i>
                <h2>Không tìm thấy bài viết</h2>
                <p style="color: #999; margin-top: 10px;">Bài viết này không tồn tại hoặc đã bị xóa</p>
                <a href="${pageContext.request.contextPath}/news" style="margin-top: 20px; display: inline-block; padding: 12px 30px; background: #c99366; color: white; text-decoration: none; border-radius: 8px;">
                    Về trang tin tức
                </a>
            </div>
        </c:if>
    </div>
    
    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <p>&copy; 2026 Tiệm Hoa nhà tớ. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
