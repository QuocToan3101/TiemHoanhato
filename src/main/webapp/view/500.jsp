<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Lỗi máy chủ</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #333;
        }
        
        .error-container {
            text-align: center;
            padding: 40px 20px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            max-width: 600px;
            animation: fadeIn 0.5s ease-in;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .error-code {
            font-size: 120px;
            font-weight: bold;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            line-height: 1;
            margin-bottom: 20px;
        }
        
        .error-title {
            font-size: 32px;
            color: #333;
            margin-bottom: 15px;
            font-weight: 600;
        }
        
        .error-message {
            font-size: 18px;
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .btn-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 15px 30px;
            text-decoration: none;
            border-radius: 50px;
            font-size: 16px;
            font-weight: 600;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        
        .btn-home {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(245, 87, 108, 0.4);
        }
        
        .btn-home:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(245, 87, 108, 0.6);
        }
        
        .btn-back {
            background: #f0f0f0;
            color: #333;
        }
        
        .btn-back:hover {
            background: #e0e0e0;
            transform: translateY(-2px);
        }
        
        .flower-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }
        
        .error-details {
            margin-top: 30px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
            text-align: left;
            font-size: 14px;
            color: #666;
            max-height: 200px;
            overflow-y: auto;
        }
        
        .error-details h3 {
            margin-bottom: 10px;
            color: #333;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="flower-icon">⚠️</div>
        <div class="error-code">500</div>
        <h1 class="error-title">Lỗi máy chủ</h1>
        <p class="error-message">
            Xin lỗi, đã có lỗi xảy ra trên máy chủ.<br>
            Chúng tôi đang khắc phục sự cố này. Vui lòng thử lại sau.
        </p>
        
        <div class="btn-group">
            <a href="javascript:history.back()" class="btn btn-back">
                ← Quay lại
            </a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-home">
                Về Trang Chủ
            </a>
        </div>
        
        <% if (exception != null && request.getAttribute("showDetails") != null) { %>
        <div class="error-details">
            <h3>Chi tiết lỗi (Development mode):</h3>
            <pre><%= exception.getMessage() %></pre>
        </div>
        <% } %>
    </div>
</body>
</html>
