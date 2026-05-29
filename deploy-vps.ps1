param(
    [string]$ServerIp = "180.93.165.99",
    [string]$ServerUser = "root",
    [string]$WarPath = ".\build\libs\flowerstore.war",
    [string]$RemoteWarName = "flowerstore.war",
    [string]$DatabaseSqlPath = ".\database\flowerstore-complete.sql",
    [string]$DbSetupScriptPath = ".\vps-db-setup.sh",
    [string]$IdentityFile = "$env:USERPROFILE\.ssh\id_ed25519"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $WarPath)) {
    Write-Error "WAR file not found: $WarPath"
    exit 1
}

if (-not (Test-Path $DatabaseSqlPath)) {
    Write-Error "Database SQL file not found: $DatabaseSqlPath"
    exit 1
}

if (-not (Test-Path $DbSetupScriptPath)) {
    Write-Error "DB setup script not found: $DbSetupScriptPath"
    exit 1
}

$sshScpCommonArgs = @(
    "-o", "ServerAliveInterval=30",
    "-o", "ServerAliveCountMax=8",
    "-o", "ConnectTimeout=20"
)
if (-not [string]::IsNullOrWhiteSpace($IdentityFile)) {
    if (-not (Test-Path $IdentityFile)) {
        Write-Error "SSH identity file not found: $IdentityFile"
        exit 1
    }

    $resolvedIdentityFile = (Resolve-Path $IdentityFile).Path
    $sshScpCommonArgs += @("-i", $resolvedIdentityFile)
    Write-Host "==> Using SSH key: $resolvedIdentityFile"
}

Write-Host "==> Upload WAR to VPS"
& scp @sshScpCommonArgs $WarPath "$ServerUser@$ServerIp`:/tmp/$RemoteWarName"
if ($LASTEXITCODE -ne 0) {
    Write-Error "SCP failed"
    exit 1
}

Write-Host "==> Upload database setup files"
& scp @sshScpCommonArgs $DatabaseSqlPath "$ServerUser@$ServerIp`:/tmp/database.sql"
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to upload database.sql"
    exit 1
}

# Convert vps-db-setup.sh to Unix line endings
$dbSetupContent = Get-Content $DbSetupScriptPath -Raw
$dbSetupContentUnix = $dbSetupContent -replace "`r", ""
$tempDbSetup = Join-Path $env:TEMP "vps-db-setup.sh"
[System.IO.File]::WriteAllText($tempDbSetup, $dbSetupContentUnix, (New-Object System.Text.UTF8Encoding($false)))

& scp @sshScpCommonArgs $tempDbSetup "$ServerUser@$ServerIp`:/tmp/vps-db-setup.sh"
Remove-Item -Path $tempDbSetup -Force -ErrorAction SilentlyContinue
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to upload vps-db-setup.sh"
    exit 1
}

$remoteScript = @'
set -e
export DEBIAN_FRONTEND=noninteractive
if ! command -v apt-get >/dev/null 2>&1; then
    echo "Only apt-based Linux distributions are supported by this script."
    exit 1
fi

retry_apt() {
    local attempts=20
    local wait_seconds=15
    local count=1

    while true; do
        if "$@"; then
            return 0
        fi

        if [ "$count" -ge "$attempts" ]; then
            echo "APT command failed after ${attempts} attempts: $*"
            return 1
        fi

        echo "APT is busy or failed (attempt ${count}/${attempts}). Retrying in ${wait_seconds}s..."
        sleep "$wait_seconds"
        count=$((count + 1))
    done
}

retry_apt apt-get update -y

if apt-cache show tomcat10 >/dev/null 2>&1; then
    TOMCAT_PKG="tomcat10"
    WEBAPPS_DIR="/var/lib/tomcat10/webapps"
elif apt-cache show tomcat9 >/dev/null 2>&1; then
    TOMCAT_PKG="tomcat9"
    WEBAPPS_DIR="/var/lib/tomcat9/webapps"
else
    echo "Cannot find tomcat9 or tomcat10 package in apt repository."
    exit 1
fi

if apt-cache show openjdk-21-jre-headless >/dev/null 2>&1; then
    JAVA_PKG="openjdk-21-jre-headless"
elif apt-cache show openjdk-17-jre-headless >/dev/null 2>&1; then
    JAVA_PKG="openjdk-17-jre-headless"
else
    JAVA_PKG="default-jre-headless"
fi

retry_apt apt-get install -y nginx "$TOMCAT_PKG" "$JAVA_PKG"
systemctl enable "$TOMCAT_PKG" nginx

# Automatically configure JAVA_HOME for Tomcat to use the installed Java 21 JRE
if [ -f "/etc/default/$TOMCAT_PKG" ]; then
    if ! grep -q "JAVA_HOME" "/etc/default/$TOMCAT_PKG"; then
        echo "JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64" >> "/etc/default/$TOMCAT_PKG"
    fi
fi

systemctl stop "$TOMCAT_PKG" || true

# Remove old ROOT deployment to avoid double-deploying
rm -rf "$WEBAPPS_DIR/ROOT" "$WEBAPPS_DIR/ROOT.war"
if [ -d "/var/lib/tomcat10" ]; then
    rm -rf "/var/lib/tomcat10/webapps-javaee/ROOT.war"
fi

if [ "$TOMCAT_PKG" = "tomcat10" ]; then
    JAVAEE_DIR="/var/lib/tomcat10/webapps-javaee"
    mkdir -p "$JAVAEE_DIR"
    rm -rf "$WEBAPPS_DIR/flowerstore" "$WEBAPPS_DIR/flowerstore.war" "$JAVAEE_DIR/flowerstore.war"
    cp /tmp/flowerstore.war "$JAVAEE_DIR/flowerstore.war"
    if id tomcat >/dev/null 2>&1; then
        chown tomcat:tomcat "$JAVAEE_DIR/flowerstore.war"
    fi
else
    rm -rf "$WEBAPPS_DIR/flowerstore" "$WEBAPPS_DIR/flowerstore.war"
    cp /tmp/flowerstore.war "$WEBAPPS_DIR/flowerstore.war"
    if id tomcat >/dev/null 2>&1; then
        chown tomcat:tomcat "$WEBAPPS_DIR/flowerstore.war"
    fi
fi

systemctl start "$TOMCAT_PKG"

cat >/etc/nginx/sites-available/flowerstore <<EOF
server {
    listen 80;
    server_name tiemhoanhato.site www.tiemhoanhato.site _;

    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_min_length 1024;
    gzip_types text/plain text/css application/json application/javascript application/xml+rss application/xml image/svg+xml;

    location = / {
        return 301 http://\$host/flowerstore/;
    }

    location /flowerstore/ {
        proxy_pass http://127.0.0.1:8080/flowerstore/;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header X-Forwarded-Host \$host;
        proxy_set_header X-Forwarded-Port \$server_port;
        proxy_connect_timeout 30s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
        proxy_buffering on;
        proxy_buffers 16 16k;
        proxy_buffer_size 8k;
    }
}
EOF

ln -sf /etc/nginx/sites-available/flowerstore /etc/nginx/sites-enabled/flowerstore
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl restart nginx
ufw allow OpenSSH || true
ufw allow 80/tcp || true
ufw allow 443/tcp || true
echo "Deployment completed"

chmod +x /tmp/vps-db-setup.sh
bash /tmp/vps-db-setup.sh
echo "Database setup completed"
'@

$remoteScriptUnix = $remoteScript -replace "`r", ""
$tempScript = Join-Path $env:TEMP "flowerstore-deploy.sh"
[System.IO.File]::WriteAllText($tempScript, $remoteScriptUnix, (New-Object System.Text.UTF8Encoding($false)))

Write-Host "==> Upload remote deploy script"
& scp @sshScpCommonArgs $tempScript "$ServerUser@$ServerIp`:/tmp/flowerstore-deploy.sh"
if ($LASTEXITCODE -ne 0) {
    Remove-Item -Path $tempScript -Force -ErrorAction SilentlyContinue
    Write-Error "Failed to upload remote deploy script"
    exit 1
}

Write-Host "==> Run remote deploy steps"
& ssh @sshScpCommonArgs "$ServerUser@$ServerIp" "bash /tmp/flowerstore-deploy.sh"
Remove-Item -Path $tempScript -Force -ErrorAction SilentlyContinue
if ($LASTEXITCODE -ne 0) {
    Write-Error "Remote deploy failed"
    exit 1
}

Write-Host "==> Done. Open: http://$ServerIp"
