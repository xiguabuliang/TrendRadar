#!/bin/bash

# TrendRadar 生产环境启动脚本

echo "🚀 启动 TrendRadar 生产环境..."

# 进入docker目录
cd "$(dirname "$0")/docker"

# 检查docker-compose.yml是否存在
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ 错误: docker-compose.yml 文件不存在"
    exit 1
fi

# 拉取最新镜像
echo "📦 拉取最新镜像..."
docker-compose pull

# 启动服务
echo "🚀 启动服务..."
docker-compose up -d

# 等待服务启动
echo "⏳ 等待服务启动..."
sleep 10

# 检查服务状态
echo "📊 检查服务状态..."
docker-compose ps

# 显示日志
echo "📋 最近日志 (最后20行):"
docker-compose logs --tail=20 trend-radar

echo "✅ 启动完成!"
echo ""
echo "📱 服务状态查看:"
echo "  - 容器状态: docker-compose ps"
echo "  - 实时日志: docker-compose logs -f trend-radar"
echo "  - 管理工具: docker exec -it trend-radar python manage.py"
echo ""
echo "🌐 访问地址:"
echo "  - Web报告: http://localhost:8080"
echo "  - MCP服务: http://localhost:3333"