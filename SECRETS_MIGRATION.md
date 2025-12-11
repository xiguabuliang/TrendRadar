# 🔐 Secrets 迁移指南

## 概述
为了提高安全性，将敏感信息（webhook URL、token等）从代码中移除，使用GitHub Repository Secrets进行管理。

## 📋 需要配置的Secrets

在GitHub仓库的 `Settings > Secrets and variables > Actions` 中添加以下secrets：

### 通知渠道配置
```
DINGTALK_WEBHOOK_URL=https://oapi.dingtalk.com/robot/send?access_token=your_token_here
FEISHU_WEBHOOK_URL=https://open.feishu.cn/open-apis/bot/v2/hook/your_hook_here
TELEGRAM_BOT_TOKEN=your_bot_token_here
TELEGRAM_CHAT_ID=your_chat_id_here
WEWORK_WEBHOOK_URL=https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=your_key_here
```

### 邮件配置
```
EMAIL_PASSWORD=your_email_password_here
EMAIL_FROM=your_email@example.com
EMAIL_TO=recipient@example.com
```

### 其他通知渠道
```
NTFY_TOKEN=your_ntfy_token_here
BARK_URL=your_bark_url_here
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/your/webhook/here
```

## 🚀 部署方式选择

### 方式一：本地Docker部署（推荐）

1. **设置环境变量**
```bash
# 复制环境变量模板
cp docker/.env.example docker/.env

# 编辑.env文件，填入你的secrets
vim docker/.env
```

2. **运行容器**
```bash
cd docker
docker-compose up -d
```

### 方式二：GitHub Actions + Docker

1. **配置Repository Secrets**（如上所述）

2. **修改工作流**（`.github/workflows/deploy.yml`）
```yaml
- name: Deploy to Docker Hub
  uses: docker/build-push-action@v5
  with:
    context: .
    file: ./docker/Dockerfile
    push: true
    tags: wantcat/trendradar:latest
    build-args: |
      DINGTALK_WEBHOOK_URL=${{ secrets.DINGTALK_WEBHOOK_URL }}
      # 其他secrets...
```

## 🔧 本地开发环境配置

创建 `.env.local` 文件：
```bash
# 钉钉配置
DINGTALK_WEBHOOK_URL=https://oapi.dingtalk.com/robot/send?access_token=your_real_token

# 推送时间窗口
PUSH_WINDOW_ENABLED=true
PUSH_WINDOW_START=08:00
PUSH_WINDOW_END=10:00
ENABLE_NOTIFICATION=true
```

## ✅ 验证配置

运行测试命令验证配置：
```bash
python3 main.py --help
```

检查日志输出是否显示正确的配置加载信息。

## 🛡️ 安全建议

1. **定期更新Token**：定期更换webhook token
2. **限制权限**：为机器人设置最小必要权限
3. **监控使用**：关注异常的使用情况
4. **备份配置**：安全地备份secrets配置

## 🔍 故障排除

如果推送不工作：
1. 检查secrets是否正确配置
2. 验证webhook URL是否有效
3. 查看容器日志：`docker logs trend-radar`
4. 确认推送时间窗口设置