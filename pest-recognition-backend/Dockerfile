# 使用官方OpenJDK 17作为基础镜像
FROM openjdk:17-jdk-slim as builder

# 设置工作目录
WORKDIR /app

# 安装Maven
RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

# 复制Maven配置文件
COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .
COPY mvnw.cmd .

# 下载依赖（利用Docker缓存层）
RUN mvn dependency:go-offline -B

# 复制源代码
COPY src src

# 构建应用
RUN mvn clean package -DskipTests

# 运行时镜像
FROM openjdk:17-jdk-slim

# 设置时区
RUN apt-get update && \
    apt-get install -y tzdata curl && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' > /etc/timezone && \
    rm -rf /var/lib/apt/lists/*

# 创建应用用户
RUN groupadd -r pestapp && useradd -r -g pestapp pestapp

# 设置工作目录
WORKDIR /app

# 创建必要的目录
RUN mkdir -p /app/uploads /app/logs /app/models && \
    chown -R pestapp:pestapp /app

# 从构建阶段复制JAR文件
COPY --from=builder /app/target/*.jar app.jar

# 复制启动脚本
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# 切换到应用用户
USER pestapp

# 暴露端口
EXPOSE 8080

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/actuator/health || exit 1

# 设置JVM参数
ENV JAVA_OPTS="-Xms512m -Xmx1024m -XX:+UseG1GC -XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"

# 启动应用
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["java", "-jar", "app.jar"]