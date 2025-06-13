# 📝 更新日志

本文档记录了害虫识别系统的所有重要变更。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
并且本项目遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [未发布]

### 计划新增
- 移动端响应式适配
- 批量图片识别功能
- 用户账户系统
- 识别结果导出功能
- 多语言支持（英文）
- 害虫分布地图可视化

### 计划改进
- 优化AI模型识别准确率
- 改进用户界面交互体验
- 增强API文档
- 性能优化

## [1.0.0] - 2025-01-XX

### 新增
- 🎉 **首次发布**
- 🤖 **AI害虫识别功能**
  - 支持上传图片进行害虫识别
  - 基于DJL + ONNX Runtime的深度学习模型
  - 支持多种常见农业害虫识别
  - 实时识别结果展示

- 🗃️ **害虫信息管理**
  - 完整的害虫信息数据库
  - 害虫详细信息展示（中英文名称、分类、危害等级等）
  - 防治方法和危害症状说明
  - 害虫图片展示

- 📱 **用户界面**
  - 现代化的Vue.js前端界面
  - 响应式设计，支持桌面和平板设备
  - Element Plus组件库，提供优秀的用户体验
  - 直观的导航和操作流程

- 📊 **识别历史**
  - 识别历史记录保存
  - 历史记录查看和管理
  - 识别结果统计

- 🔧 **系统功能**
  - RESTful API设计
  - 文件上传和管理
  - 数据库持久化存储
  - 错误处理和日志记录

### 技术栈
- **后端**: Spring Boot 3.2.1, Java 17
- **前端**: Vue.js 3.4.15, Element Plus 2.4.4
- **数据库**: MySQL 8.0+
- **AI框架**: DJL (Deep Java Library)
- **模型运行时**: ONNX Runtime
- **构建工具**: Maven 3.6+, npm/yarn

### 支持的害虫类型
- 稻纵卷叶螟 (Cnaphalocrocis medinalis)
- 二化螟 (Chilo suppressalis)
- 三化螟 (Scirpophaga incertulas)
- 大螟 (Sesamia inferens)
- 稻飞虱 (Nilaparvata lugens)
- 稻叶蝉 (Nephotettix cincticeps)
- 稻蓟马 (Stenchaetothrips biformis)
- 稻象甲 (Lissorhoptrus oryzophilus)
- 稻水象甲 (Lissorhoptrus oryzophilus)
- 稻螟蛉 (Nymphula depunctalis)

### 系统要求
- **服务器**: 
  - Java 17+
  - MySQL 8.0+
  - 内存: 4GB+
  - 存储: 10GB+
- **客户端**: 
  - 现代浏览器（Chrome 90+, Firefox 88+, Safari 14+, Edge 90+）
  - JavaScript支持

### 安全特性
- 文件上传安全验证
- SQL注入防护
- XSS攻击防护
- CORS跨域配置
- 错误信息过滤

### 文档
- 📖 完整的README文档
- 🚀 详细的部署指南
- 🤝 贡献者指南
- 🔒 安全策略
- 📜 行为准则
- 📋 API文档（Swagger UI）

---

## 版本说明

### 版本号格式

本项目使用 [语义化版本](https://semver.org/lang/zh-CN/) 格式：`主版本号.次版本号.修订号`

- **主版本号**: 不兼容的API修改
- **次版本号**: 向下兼容的功能性新增
- **修订号**: 向下兼容的问题修正

### 变更类型

- `新增` - 新功能
- `变更` - 对现有功能的变更
- `弃用` - 即将移除的功能
- `移除` - 已移除的功能
- `修复` - 问题修复
- `安全` - 安全相关的修复

### 发布周期

- **主版本**: 根据需要发布
- **次版本**: 每季度发布
- **修订版**: 根据bug修复需要发布
- **安全更新**: 立即发布

---

## 贡献

如果您想为项目做出贡献，请查看我们的 [贡献指南](CONTRIBUTING.md)。

## 支持

如果您遇到问题或有建议，请：

1. 查看 [FAQ](docs/FAQ.md)
2. 搜索 [已有Issues](https://github.com/your-username/pest-recognition-system/issues)
3. 创建 [新Issue](https://github.com/your-username/pest-recognition-system/issues/new)

---

**注意**: 此更新日志从v1.0.0开始维护。早期开发版本的变更未在此记录。