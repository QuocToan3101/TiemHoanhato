<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>403 - Truy cập bị từ chối</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
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
            background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
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
            background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
            color: #333;
            box-shadow: 0 4px 15px rgba(252, 182, 159, 0.4);
        }
        
        .btn-home:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(252, 182, 159, 0.6);
        }
        
        .btn-login {
            background: #333;
            color: white;
        }
        
        .btn-login:hover {
            background: #555;
            transform: translateY(-2px);
        }
        
        .flower-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="flower-icon">🚫</div>
        <div class="error-code">403</div>
        <h1 class="error-title">Truy cập bị từ chối</h1>
        <p class="error-message">
            Bạn không có quyền truy cập trang này.<br>
            Vui lòng đăng nhập với tài khoản có quyền phù hợp.
        </p>
        
        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-login">
                Đăng nhập
            </a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-home">
                Về Trang Chủ
            </a>
        </div>
    </div>
</body>
</html>
