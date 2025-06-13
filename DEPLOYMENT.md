# 🚀 部署指南

本文档详细说明了如何在不同环境中部署害虫识别系统。

## 📋 部署前准备

### 系统要求

- **操作系统**: Windows 10/11, Ubuntu 18.04+, CentOS 7+
- **Java**: JDK 17 或更高版本
- **Node.js**: 16.13.1 或更高版本
- **MySQL**: 8.0 或更高版本
- **内存**: 最少 4GB RAM（推荐 8GB+）
- **存储**: 最少 10GB 可用空间

### 环境检查

```bash
# 检查Java版本
java -version

# 检查Node.js版本
node -v
npm -v

# 检查MySQL版本
mysql --version
```

## 🗄️ 数据库配置

### 1. 创建数据库

```sql
-- 登录MySQL
mysql -u root -p

-- 创建数据库
CREATE DATABASE pest_recognition CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 创建用户（可选）
CREATE USER 'pest_user'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON pest_recognition.* TO 'pest_user'@'localhost';
FLUSH PRIVILEGES;
```

### 2. 导入数据

```bash
# 导入基础数据
mysql -u root -p pest_recognition < pest.sql

# 如果有额外的数据文件
mysql -u root -p pest_recognition < pest_ifo.sql
```

## ⚙️ 后端部署

### 1. 配置文件设置

复制示例配置文件并修改：

```bash
cd pest-recognition-backend/src/main/resources
cp application.properties.example application.properties
```

编辑 `application.properties`：

```properties
# 数据库配置
spring.datasource.url=jdbc:mysql://localhost:3306/pest_recognition?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai
spring.datasource.username=pest_user
spring.datasource.password=your_secure_password

# 文件上传路径（确保目录存在且有写权限）
file.upload-dir=/path/to/uploads

# 生产环境配置
spring.profiles.active=production
logging.level.com.example.pestrecognition=WARN
```

### 2. 构建和运行

#### 开发环境

```bash
cd pest-recognition-backend
mvn clean install
mvn spring-boot:run
```

#### 生产环境

```bash
# 构建JAR包
cd pest-recognition-backend
mvn clean package -Dmaven.test.skip=true

# 运行
java -jar target/pest-recognition-backend-0.0.1-SNAPSHOT.jar

# 后台运行
nohup java -jar target/pest-recognition-backend-0.0.1-SNAPSHOT.jar > app.log 2>&1 &
```

### 3. 服务管理（Linux）

创建systemd服务文件 `/etc/systemd/system/pest-recognition.service`：

```ini
[Unit]
Description=Pest Recognition Backend
After=network.target

[Service]
Type=simple
User=pest
WorkingDirectory=/opt/pest-recognition
ExecStart=/usr/bin/java -jar /opt/pest-recognition/pest-recognition-backend.jar
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

启动服务：

```bash
sudo systemctl daemon-reload
sudo systemctl enable pest-recognition
sudo systemctl start pest-recognition
sudo systemctl status pest-recognition
```

## 🎨 前端部署

### 1. 环境配置

编辑环境配置文件：

**开发环境** (`.env.development`)：
```env
VUE_APP_API_BASE_URL=http://localhost:8080/api
VUE_APP_UPLOAD_URL=http://localhost:8080
```

**生产环境** (`.env.production`)：
```env
VUE_APP_API_BASE_URL=https://your-domain.com/api
VUE_APP_UPLOAD_URL=https://your-domain.com
```

### 2. 构建和部署

#### 开发环境

```bash
cd pest-recognition-frontend
npm install
npm run serve
```

#### 生产环境构建

```bash
cd pest-recognition-frontend
npm install
npm run build
```

### 3. Web服务器配置

#### Nginx配置

创建配置文件 `/etc/nginx/sites-available/pest-recognition`：

```nginx
server {
    listen 80;
    server_name your-domain.com;
    
    # 前端静态文件
    location / {
        root /var/www/pest-recognition/dist;
        try_files $uri $uri/ /index.html;
        index index.html;
    }
    
    # 后端API代理
    location /api/ {
        proxy_pass http://localhost:8080/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    
    # 上传文件访问
    location /uploads/ {
        alias /path/to/uploads/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # 启用gzip压缩
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
}
```

启用站点：

```bash
sudo ln -s /etc/nginx/sites-available/pest-recognition /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

#### Apache配置

创建虚拟主机配置：

```apache
<VirtualHost *:80>
    ServerName your-domain.com
    DocumentRoot /var/www/pest-recognition/dist
    
    <Directory /var/www/pest-recognition/dist>
        AllowOverride All
        Require all granted
        
        # SPA路由支持
        RewriteEngine On
        RewriteBase /
        RewriteRule ^index\.html$ - [L]
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule . /index.html [L]
    </Directory>
    
    # API代理
    ProxyPass /api/ http://localhost:8080/api/
    ProxyPassReverse /api/ http://localhost:8080/api/
    
    # 上传文件
    Alias /uploads /path/to/uploads
    <Directory /path/to/uploads>
        Require all granted
    </Directory>
</VirtualHost>
```

## 🐳 Docker部署

### 1. 后端Dockerfile

创建 `pest-recognition-backend/Dockerfile`：

```dockerfile
FROM openjdk:17-jdk-slim

WORKDIR /app

COPY target/pest-recognition-backend-0.0.1-SNAPSHOT.jar app.jar
COPY src/main/resources/application.properties application.properties

RUN mkdir -p uploads

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
```

### 2. 前端Dockerfile

创建 `pest-recognition-frontend/Dockerfile`：

```dockerfile
# 构建阶段
FROM node:16-alpine as build-stage

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# 生产阶段
FROM nginx:alpine as production-stage

COPY --from=build-stage /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

### 3. Docker Compose

创建 `docker-compose.yml`：

```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: pest_recognition
      MYSQL_USER: pest_user
      MYSQL_PASSWORD: pestpassword
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
      - ./pest.sql:/docker-entrypoint-initdb.d/pest.sql
    
  backend:
    build: ./pest-recognition-backend
    ports:
      - "8080:8080"
    depends_on:
      - mysql
    environment:
      SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/pest_recognition
      SPRING_DATASOURCE_USERNAME: pest_user
      SPRING_DATASOURCE_PASSWORD: pestpassword
    volumes:
      - uploads_data:/app/uploads
      
  frontend:
    build: ./pest-recognition-frontend
    ports:
      - "80:80"
    depends_on:
      - backend

volumes:
  mysql_data:
  uploads_data:
```

运行：

```bash
docker-compose up -d
```

## 🔒 安全配置

### 1. 防火墙设置

```bash
# Ubuntu/Debian
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable

# CentOS/RHEL
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

### 2. SSL证书配置

使用Let's Encrypt：

```bash
# 安装certbot
sudo apt install certbot python3-certbot-nginx

# 获取证书
sudo certbot --nginx -d your-domain.com

# 自动续期
sudo crontab -e
# 添加：0 12 * * * /usr/bin/certbot renew --quiet
```

### 3. 数据库安全

```bash
# 运行MySQL安全脚本
sudo mysql_secure_installation

# 限制远程访问
# 编辑 /etc/mysql/mysql.conf.d/mysqld.cnf
bind-address = 127.0.0.1
```

## 📊 监控和日志

### 1. 应用监控

添加健康检查端点到后端：

```properties
# application.properties
management.endpoints.web.exposure.include=health,info,metrics
management.endpoint.health.show-details=always
```

### 2. 日志管理

配置logback（`src/main/resources/logback-spring.xml`）：

```xml
<configuration>
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>logs/pest-recognition.log</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>logs/pest-recognition.%d{yyyy-MM-dd}.log</fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>
    
    <root level="INFO">
        <appender-ref ref="FILE" />
    </root>
</configuration>
```

## 🔧 故障排除

### 常见问题

1. **数据库连接失败**
   - 检查数据库服务是否运行
   - 验证连接字符串和凭据
   - 检查防火墙设置

2. **文件上传失败**
   - 检查上传目录权限
   - 验证文件大小限制
   - 检查磁盘空间

3. **前端无法访问后端**
   - 检查CORS配置
   - 验证API URL配置
   - 检查网络连接

### 日志查看

```bash
# 查看应用日志
tail -f logs/pest-recognition.log

# 查看系统服务日志
sudo journalctl -u pest-recognition -f

# 查看Nginx日志
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

## 📈 性能优化

### 1. JVM调优

```bash
java -Xms2g -Xmx4g -XX:+UseG1GC -jar pest-recognition-backend.jar
```

### 2. 数据库优化

```sql
-- 添加索引
CREATE INDEX idx_pest_category ON pest_info(category);
CREATE INDEX idx_recognition_time ON recognition_history(recognition_time);

-- 优化查询
ANALYZE TABLE pest_info;
ANALYZE TABLE recognition_history;
```

### 3. 缓存配置

在后端添加Redis缓存：

```properties
spring.redis.host=localhost
spring.redis.port=6379
spring.cache.type=redis
```

---

## 📞 技术支持

如果在部署过程中遇到问题，请：

1. 查看相关日志文件
2. 检查系统资源使用情况
3. 验证配置文件设置
4. 参考故障排除部分

更多技术支持，请联系项目维护者。