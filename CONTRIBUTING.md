# 🤝 贡献指南

感谢您对害虫识别系统项目的关注！我们欢迎所有形式的贡献，包括但不限于代码、文档、测试、反馈和建议。

## 📋 贡献方式

### 🐛 报告Bug

如果您发现了bug，请通过以下步骤报告：

1. 在[Issues](https://github.com/your-username/pest-recognition-system/issues)中搜索是否已有相关问题
2. 如果没有，请创建新的Issue，包含以下信息：
   - 清晰的标题和描述
   - 重现步骤
   - 预期行为和实际行为
   - 环境信息（操作系统、浏览器、Java版本等）
   - 相关的错误日志或截图

### 💡 功能建议

我们欢迎新功能的建议：

1. 在Issues中创建Feature Request
2. 详细描述功能需求和使用场景
3. 如果可能，提供设计草图或原型

### 📝 改进文档

文档改进包括：
- 修复错别字或语法错误
- 改进现有文档的清晰度
- 添加缺失的文档
- 翻译文档到其他语言

### 💻 代码贡献

#### 开发环境设置

1. **Fork项目**
   ```bash
   git clone https://github.com/your-username/pest-recognition-system.git
   cd pest-recognition-system
   ```

2. **安装依赖**
   ```bash
   # 后端
   cd pest-recognition-backend
   mvn clean install
   
   # 前端
   cd ../pest-recognition-frontend
   npm install
   ```

3. **配置数据库**
   ```bash
   mysql -u root -p
   CREATE DATABASE pest_recognition_dev;
   mysql -u root -p pest_recognition_dev < pest.sql
   ```

4. **创建分支**
   ```bash
   git checkout -b feature/your-feature-name
   ```

#### 代码规范

##### Java后端代码规范

1. **命名约定**
   - 类名：PascalCase（如：`PestController`）
   - 方法名：camelCase（如：`getPestById`）
   - 常量：UPPER_SNAKE_CASE（如：`MAX_FILE_SIZE`）
   - 包名：小写，用点分隔（如：`com.example.pestrecognition`）

2. **代码格式**
   - 使用4个空格缩进
   - 行长度不超过120字符
   - 大括号不换行
   ```java
   public class Example {
       public void method() {
           // 代码内容
       }
   }
   ```

3. **注释规范**
   ```java
   /**
    * 获取害虫详细信息
    * @param id 害虫ID
    * @return 害虫信息
    * @throws EntityNotFoundException 当害虫不存在时抛出
    */
   public PestVO getPestById(Long id) {
       // 实现代码
   }
   ```

4. **异常处理**
   ```java
   try {
       // 业务逻辑
   } catch (SpecificException e) {
       log.error("具体错误描述: {}", e.getMessage(), e);
       throw new BusinessException("用户友好的错误信息");
   }
   ```

##### Vue.js前端代码规范

1. **组件命名**
   - 组件文件：PascalCase（如：`PestDetail.vue`）
   - 组件名称：PascalCase（如：`PestDetail`）

2. **代码格式**
   - 使用2个空格缩进
   - 使用单引号
   - 行末不加分号
   ```javascript
   export default {
     name: 'PestDetail',
     data() {
       return {
         pestInfo: null
       }
     }
   }
   ```

3. **Vue组件结构**
   ```vue
   <template>
     <!-- 模板内容 -->
   </template>
   
   <script>
   export default {
     name: 'ComponentName',
     props: {
       // props定义
     },
     data() {
       return {
         // 数据定义
       }
     },
     computed: {
       // 计算属性
     },
     methods: {
       // 方法定义
     }
   }
   </script>
   
   <style scoped>
   /* 样式定义 */
   </style>
   ```

4. **API调用**
   ```javascript
   async fetchPestDetail(id) {
     try {
       const response = await pestApi.getPestById(id)
       this.pestDetail = response.data
     } catch (error) {
       console.error('获取害虫详情失败:', error)
       this.$message.error('获取害虫详情失败')
     }
   }
   ```

#### 提交规范

使用[Conventional Commits](https://www.conventionalcommits.org/)规范：

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**类型说明：**
- `feat`: 新功能
- `fix`: 修复bug
- `docs`: 文档更新
- `style`: 代码格式调整（不影响功能）
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建过程或辅助工具的变动

**示例：**
```bash
git commit -m "feat(recognition): 添加害虫识别置信度显示功能"
git commit -m "fix(api): 修复文件上传大小限制问题"
git commit -m "docs(readme): 更新安装说明"
```

#### 测试要求

1. **后端测试**
   ```java
   @Test
   public void testGetPestById() {
       // Given
       Long pestId = 1L;
       
       // When
       PestVO result = pestService.getPestById(pestId);
       
       // Then
       assertThat(result).isNotNull();
       assertThat(result.getId()).isEqualTo(pestId);
   }
   ```

2. **前端测试**
   ```javascript
   describe('PestDetail.vue', () => {
     it('should render pest information correctly', () => {
       const wrapper = mount(PestDetail, {
         propsData: {
           pestId: 1
         }
       })
       expect(wrapper.find('.pest-name').text()).toBe('稻纵卷叶螟')
     })
   })
   ```

3. **运行测试**
   ```bash
   # 后端测试
   cd pest-recognition-backend
   mvn test
   
   # 前端测试
   cd pest-recognition-frontend
   npm run test
   ```

## 🔄 Pull Request流程

1. **确保代码质量**
   - 所有测试通过
   - 代码符合规范
   - 没有编译警告

2. **创建Pull Request**
   - 提供清晰的标题和描述
   - 关联相关的Issue
   - 添加适当的标签

3. **PR模板**
   ```markdown
   ## 变更类型
   - [ ] Bug修复
   - [ ] 新功能
   - [ ] 文档更新
   - [ ] 代码重构
   - [ ] 性能优化
   
   ## 变更描述
   简要描述此次变更的内容和原因。
   
   ## 测试
   - [ ] 单元测试通过
   - [ ] 集成测试通过
   - [ ] 手动测试通过
   
   ## 相关Issue
   Closes #issue_number
   
   ## 截图（如适用）
   添加相关截图来说明变更。
   ```

4. **代码审查**
   - 响应审查意见
   - 及时修复问题
   - 保持讨论的专业性

## 🏗️ 项目结构

```
pest_recognize_system/
├── pest-recognition-backend/     # Spring Boot后端
│   ├── src/main/java/
│   │   └── com/example/pestrecognition/
│   │       ├── controller/       # 控制器层
│   │       ├── service/          # 服务层
│   │       ├── dao/              # 数据访问层
│   │       ├── model/            # 数据模型
│   │       ├── config/           # 配置类
│   │       └── util/             # 工具类
│   └── src/test/java/            # 测试代码
├── pest-recognition-frontend/    # Vue.js前端
│   ├── src/
│   │   ├── components/           # 可复用组件
│   │   ├── views/                # 页面组件
│   │   ├── router/               # 路由配置
│   │   ├── store/                # Vuex状态管理
│   │   ├── services/             # API服务
│   │   └── utils/                # 工具函数
│   └── tests/                    # 测试代码
├── docs/                         # 项目文档
└── scripts/                      # 构建和部署脚本
```

## 🎯 开发重点

### 当前优先级

1. **高优先级**
   - 提高识别准确率
   - 优化用户体验
   - 修复已知bug

2. **中优先级**
   - 添加新的害虫类型
   - 性能优化
   - 移动端适配

3. **低优先级**
   - 国际化支持
   - 高级统计功能
   - 第三方集成

### 技术债务

- [ ] 重构文件上传逻辑
- [ ] 优化数据库查询性能
- [ ] 改进错误处理机制
- [ ] 增加API文档

## 📚 学习资源

### 技术栈学习

- [Spring Boot官方文档](https://spring.io/projects/spring-boot)
- [Vue.js官方文档](https://vuejs.org/)
- [Element Plus组件库](https://element-plus.org/)
- [MySQL官方文档](https://dev.mysql.com/doc/)

### 最佳实践

- [Java编码规范](https://google.github.io/styleguide/javaguide.html)
- [Vue.js风格指南](https://vuejs.org/style-guide/)
- [RESTful API设计](https://restfulapi.net/)
- [Git工作流](https://www.atlassian.com/git/tutorials/comparing-workflows)

## 🏆 贡献者认可

我们重视每一位贡献者的努力：

- 贡献者将被添加到项目的贡献者列表中
- 重大贡献将在发布说明中特别提及
- 活跃贡献者可能被邀请成为项目维护者

## 📞 联系方式

如果您有任何问题或需要帮助：

- 📧 Email: [your-email@example.com]
- 💬 讨论: [GitHub Discussions](https://github.com/your-username/pest-recognition-system/discussions)
- 🐛 问题: [GitHub Issues](https://github.com/your-username/pest-recognition-system/issues)

## 📄 行为准则

请遵守我们的[行为准则](CODE_OF_CONDUCT.md)，确保社区环境友好和包容。

---

再次感谢您的贡献！让我们一起构建更好的害虫识别系统！ 🌾🐛