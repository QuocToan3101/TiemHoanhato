# 🔑 Google OAuth Setup Guide

Để sử dụng đăng nhập bằng Google, bạn cần cấu hình Google OAuth Credentials. Hướng dẫn dưới đây:

---

## **Bước 1: Tạo Google Cloud Project**

1. Truy cập: https://console.cloud.google.com/
2. Đăng nhập bằng tài khoản Google
3. Click **"Select a Project"** → **"New Project"**
4. Nhập tên: `FlowerStore` → Click **Create**
5. Đợi project được tạo (khoảng 1-2 phút)

---

## **Bước 2: Enable Google+ API**

1. Trên trang Google Cloud Console, click **Menu** (icon 3 dòng)
2. Chọn **APIs & Services** → **Library**
3. Tìm **Google+ API** (hoặc tìm "people")
4. Click **Google+ API** → **Enable**

---

## **Bước 3: Tạo OAuth Credentials**

1. Từ menu, chọn **APIs & Services** → **Credentials**
2. Click **+ Create Credentials** → Chọn **OAuth 2.0 Client ID**
3. Nếu được hỏi, setup **OAuth consent screen** trước:
   - Chọn **External** → Click **Create**
   - Nhập:
     - **App name**: `FlowerStore`
     - **User support email**: `duongquoctoan3101@gmail.com`
     - **Developer contact**: `duongquoctoan3101@gmail.com`
   - Click **Save and Continue**
   - Chọn **Add or Remove Scopes** → Thêm:
     - `openid`
     - `email`
     - `profile`
   - Click **Save and Continue** → **Back to Dashboard**

4. Quay lại **Credentials**, click **+ Create Credentials** → **OAuth 2.0 Client ID**
5. Chọn **Web application**
6. Nhập tên: `FlowerStore`
7. Thêm **Authorized redirect URIs**:
   ```
   http://localhost:8080/flowerstore/oauth/google/callback
   http://localhost:8080/flowerstore/view/login_1.jsp
   ```
8. Click **Create**
9. Sẽ có popup với **Client ID** và **Client Secret** → **Copy both**

---

## **Bước 4: Set Environment Variables (Windows)**

### **Cách 1: Permanent (Recommended)**

1. Mở **System Properties**:
   - Press `Win + X` → chọn **System**
   - Click **Advanced system settings** (bên trái)
   - Click **Environment Variables**

2. Nhấn **New** (dưới User variables for...)
   - **Variable name**: `GOOGLE_CLIENT_ID`
   - **Variable value**: `[Paste your Client ID from step 9]`
   - Click **OK**

3. Nhấn **New** lại
   - **Variable name**: `GOOGLE_CLIENT_SECRET`
   - **Variable value**: `[Paste your Client Secret from step 9]`
   - Click **OK**

4. Click **OK** → **OK** để đóng

5. **Restart VS Code** hoặc Terminal để apply variables mới

### **Cách 2: Temporary (For Testing)**

Mở PowerShell từ project root:

```powershell
$env:GOOGLE_CLIENT_ID = "your_client_id_here"
$env:GOOGLE_CLIENT_SECRET = "your_client_secret_here"
.\gradlew.bat deployToTomcat
```

---

## **Bước 5: Restart Tomcat & Test**

1. Restart Tomcat từ XAMPP Control Panel (hoặc `startup.bat`)
2. Truy cập: **http://localhost:8080/flowerstore/view/login_1.jsp**
3. Click **"Đăng nhập với Google"**
4. Nếu thành công, bạn sẽ được redirect tới Google login

---

## **Troubleshooting**

### **❌ Lỗi: "Invalid redirect_uri"**
- Kiểm tra URI bạn set trên Google Console có đúng không
- Format phải là: `http://localhost:8080/flowerstore/oauth/google/callback`

### **❌ Lỗi: "Client ID undefined"**
- Kiểm tra environment variables đã được set chưa
- Mở PowerShell mới (sau khi restart) và kiểm tra:
  ```powershell
  $env:GOOGLE_CLIENT_ID
  ```
- Nếu rỗng, set lại theo **Cách 2** ở trên

### **❌ Lỗi: "OAuth not configured"**
- Có nghĩa `GOOGLE_CLIENT_ID` hoặc `GOOGLE_CLIENT_SECRET` chưa được set
- Làm theo **Bước 4** đặc biệt là restart Tomcat/Terminal

---

## **Quick Check**

Mở PowerShell và chạy:

```powershell
$env:GOOGLE_CLIENT_ID
$env:GOOGLE_CLIENT_SECRET
```

Nếu thấy kết quả, environment variables đã được set ✅

---

**Cần giúp? Hỏi tôi!** 🚀
