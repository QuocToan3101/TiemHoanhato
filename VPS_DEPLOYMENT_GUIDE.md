## Deploying Flower Store Web App to VPS (Ubuntu 22.04 LTS)

This guide documents the complete setup, configurations, and scripts used to successfully deploy the **Flower Store** Java Web Application and MySQL database on a bare-metal VPS, and outlines how to easily reuse or migrate this setup to a new domain or host in the future.

---

## 🏗️ Architecture Overview

The deployed application stack consists of:
1. **Nginx**: Serving as a high-performance reverse proxy on port 80, routing requests to the Tomcat backend and handling domain binding (`tiemhoanhato.site`).
2. **Apache Tomcat 9**: Hosting the Java Servlet application deployed under the `/flowerstore` context path.
3. **OpenJDK 21 (JRE Headless)**: Powering the Java 21-compiled WAR file.
4. **MySQL Server**: Hosting the relational database initialized with all structured tables, performance indexes, and demo seed data.

---

## 🛠️ Step-by-Step Deployment Flow

### 1. Database Configuration Security
To run securely under Tomcat, the application uses a dedicated MySQL user rather than the default administrative `root` account.
- **Configured Files**: [application.properties](file:///d:/Study/flowerStore/TiemHoanhato/src/main/resources/application.properties) & [context.xml](file:///d:/Study/flowerStore/TiemHoanhato/src/main/webapp/META-INF/context.xml)
- **Settings**:
  - Database URL: `jdbc:mysql://localhost:3306/flowerStore?useSSL=false&serverTimezone=Asia/Ho_Chi_Minh&allowPublicKeyRetrieval=true&characterEncoding=UTF-8`
  - Username: `FlowerStore`
  - Password: `12345`

### 2. Automated Database Setup (`vps-db-setup.sh`)
This bash script runs on the VPS to:
- Install `mysql-server` if missing and enable the service.
- Create the `flowerStore` database with UTF-8 support.
- Provision the secure `FlowerStore` DB user and grant all local privileges.
- Import the complete SQL schema and seed data from `/tmp/database.sql` (mapped from [flowerstore-complete.sql](file:///d:/Study/flowerStore/TiemHoanhato/database/flowerstore-complete.sql)).

> [!NOTE]
> All index creation commands inside the SQL file are optimized to use standard `CREATE INDEX` syntax instead of `CREATE INDEX IF NOT EXISTS` to ensure backward-compatibility with all MySQL 8.0 versions.

### 3. Passwordless SSH Key Automation
To bypass manual password prompts during script uploads and remote commands:
- A secure SSH key is generated locally: `ssh-keygen -t ed25519 -N "" -f "$env:USERPROFILE\.ssh\id_ed25519"`
- The public key (`id_ed25519.pub`) is appended to the VPS `/root/.ssh/authorized_keys`.
- All subsequent deployments use this key automatically.

### 4. Self-Healing Tomcat Java 21 Configuration
Tomcat 9 on older Ubuntu builds does not automatically recognize OpenJDK 21. The deployment script resolves this by automatically appending the JDK location to `/etc/default/tomcat9`:
```bash
echo "JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64" >> /etc/default/tomcat9
```

### 5. Context Path & Nginx Reverse Proxy
The application is deployed under the `/flowerstore` context path (by uploading as `flowerstore.war`).
Nginx is configured to:
- Map traffic for the domain `tiemhoanhato.site` and `www.tiemhoanhato.site`.
- Redirect root visits (`http://tiemhoanhato.site/`) automatically to the subpath (`http://tiemhoanhato.site/flowerstore/`).
- Forward all `/flowerstore/` requests to Tomcat's backend at `http://127.0.0.1:8080/flowerstore/`.

---

## 🚀 Reusability & Migration Manual
*(Use these steps to migrate the application to a new VPS or bind a new Domain Name)*

### Case A: Changing the Domain Name
If you buy a new domain (e.g., `newstore.site`):

1. **Update DNS Records**:
   - Go to your domain registrar (Namecheap, GoDaddy, etc.) and add an **A Record** pointing to your VPS IP (`180.93.165.99`):
     - `Host: @` -> `Value: 180.93.165.99`
     - `Host: www` -> `Value: 180.93.165.99`

2. **Modify Nginx Configuration in Script**:
   - Open [deploy-vps.ps1](file:///d:/Study/flowerStore/TiemHoanhato/deploy-vps.ps1).
   - Locate the `server_name` parameter inside the Nginx block (around line 150):
     ```nginx
     server_name newstore.site www.newstore.site _;
     ```
   - Save the file and run `.\deploy-vps.ps1`. The script will reconfigure Nginx on the VPS automatically!

3. **Update Google OAuth Settings**:
   - Go to [Google Cloud Console](https://console.cloud.google.com/apis/credentials).
   - Edit your Client ID and add the new redirect URI:
     ```text
     http://newstore.site/flowerstore/oauth/google/callback
     ```

---

### Case B: Deploying to a New VPS Host
If you rent a new VPS server (e.g., IP: `192.168.1.100`, password: `NewPassword`):

1. **Authorize your local SSH Key on the New VPS**:
   - Read your local public key:
     ```powershell
     $pubKey = Get-Content "$env:USERPROFILE\.ssh\id_ed25519.pub" -Raw
     ```
   - Run a single SSH command using the new password to register the key:
     ```powershell
     ssh -o StrictHostKeyChecking=no root@192.168.1.100 "mkdir -p ~/.ssh && chmod 700 ~/.ssh && echo '$pubKey' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
     ```

2. **Update script parameters**:
   - Open [deploy-vps.ps1](file:///d:/Study/flowerStore/TiemHoanhato/deploy-vps.ps1).
   - In the `param()` block at the top, change the default `$ServerIp`:
     ```powershell
     [string]$ServerIp = "192.168.1.100",
     ```

3. **Build and Deploy**:
   - Clean and build the local WAR:
     ```powershell
     .\gradlew clean war
     ```
   - Run the deployment:
     ```powershell
     .\deploy-vps.ps1
     ```
     *(The script will automatically configure Java 21, Tomcat 9, Nginx, MySQL, and restore the database on the new server with zero password prompts!)*

4. **Update Google Cloud Console**:
   - Add the callback URL for the new IP/domain in Google Developer Console:
     ```text
     http://192.168.1.100/flowerstore/oauth/google/callback
     ```

---