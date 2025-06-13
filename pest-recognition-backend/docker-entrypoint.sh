#!/bin/bash
set -e

# 等待数据库启动的函数
wait_for_db() {
    echo "Waiting for database to be ready..."
    
    # 从SPRING_DATASOURCE_URL中提取主机和端口
    DB_HOST=$(echo $SPRING_DATASOURCE_URL | sed -n 's/.*\/\/\([^:]*\):.*/\1/p')
    DB_PORT=$(echo $SPRING_DATASOURCE_URL | sed -n 's/.*:\([0-9]*\)\/.*/\1/p')
    
    if [ -z "$DB_HOST" ]; then
        DB_HOST="mysql"
    fi
    
    if [ -z "$DB_PORT" ]; then
        DB_PORT="3306"
    fi
    
    echo "Checking database connection to $DB_HOST:$DB_PORT"
    
    # 等待数据库可用
    timeout=60
    while ! nc -z $DB_HOST $DB_PORT; do
        timeout=$((timeout - 1))
        if [ $timeout -eq 0 ]; then
            echo "Database connection timeout!"
            exit 1
        fi
        echo "Database not ready, waiting... ($timeout seconds left)"
        sleep 1
    done
    
    echo "Database is ready!"
}

# 创建必要的目录
echo "Creating necessary directories..."
mkdir -p /app/uploads /app/logs /app/models

# 设置环境变量默认值
export SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE:-docker}
export JAVA_OPTS=${JAVA_OPTS:-"-Xms512m -Xmx1024m -XX:+UseG1GC"}

# 如果设置了数据库URL，等待数据库启动
if [ ! -z "$SPRING_DATASOURCE_URL" ]; then
    # 安装netcat用于检查端口
    if ! command -v nc &> /dev/null; then
        echo "Installing netcat..."
        apt-get update && apt-get install -y netcat && rm -rf /var/lib/apt/lists/*
    fi
    wait_for_db
fi

# 打印启动信息
echo "=========================================="
echo "Starting Pest Recognition Backend"
echo "Profile: $SPRING_PROFILES_ACTIVE"
echo "Java Options: $JAVA_OPTS"
echo "Upload Directory: /app/uploads"
echo "Log Directory: /app/logs"
echo "Model Directory: /app/models"
echo "=========================================="

# 执行传入的命令
exec "$@"