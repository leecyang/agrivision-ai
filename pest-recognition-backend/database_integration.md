# 害虫识别系统数据库对接与数据流转说明

本文档详细说明害虫识别系统中的数据库设计、数据流转过程以及前后端数据交互方式，帮助开发者理解系统中的数据流动路径。

## 1. 数据库设计

### 1.1 数据库表结构

系统主要包含两个核心表：害虫信息表和识别历史表。

**害虫信息表 (pest_info)**

```sql
CREATE TABLE pest_info (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name_zh VARCHAR(100) NOT NULL COMMENT '中文名称',
    name_en VARCHAR(100) NOT NULL COMMENT '英文名称',
    category VARCHAR(50) COMMENT '分类',
    description TEXT COMMENT '描述',
    harm_level INT COMMENT '危害等级：1-5',
    symptoms TEXT COMMENT '危害症状',
    prevention_methods TEXT COMMENT '防治方法',
    image_url VARCHAR(255) COMMENT '图片URL',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

**识别历史表 (recognition_history)**

```sql
CREATE TABLE recognition_history (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    image_path VARCHAR(255) NOT NULL COMMENT '图片路径',
    pest_id BIGINT COMMENT '识别出的害虫ID',
    confidence DOUBLE COMMENT '置信度',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pest_id) REFERENCES pest_info(id)
);
```

### 1.2 表关系说明

- **一对多关系**：一种害虫(pest_info)可以对应多条识别记录(recognition_history)
- **外键约束**：recognition_history表中的pest_id是对pest_info表id的引用
- **级联操作**：默认不设置级联删除，以保护历史数据完整性

### 1.3 索引设计

为提高查询性能，建议添加以下索引：

```sql
-- 害虫名称索引（支持按名称查询）
CREATE INDEX idx_pest_name_zh ON pest_info(name_zh);
CREATE INDEX idx_pest_name_en ON pest_info(name_en);

-- 识别历史的创建时间索引（支持按时间排序和查询）
CREATE INDEX idx_history_create_time ON recognition_history(create_time);

-- 识别历史的害虫ID索引（支持按害虫类型查询历史）
CREATE INDEX idx_history_pest_id ON recognition_history(pest_id);
```

## 2. 数据流转过程

### 2.1 整体数据流转图

```
+----------------+     +----------------+     +----------------+
|                |     |                |     |                |
|  前端应用      |---->|  后端服务      |---->|  数据库        |
|  (Vue.js)      |<----|  (Spring Boot) |<----|  (MySQL)       |
|                |     |                |     |                |
+----------------+     +----------------+     +----------------+
        |                      |
        |                      v
        |              +----------------+
        |              |                |
        +------------->|  深度学习模型  |
                       |  (ONNX/Python) |
                       |                |
                       +----------------+
```

### 2.2 主要数据流转路径

#### 2.2.1 害虫识别流程

1. **图片上传**：
   - 前端通过`ImageUploader`组件将图片文件打包为FormData
   - 调用`/api/recognition`接口发送图片到后端

2. **后端处理**：
   - `RecognitionController`接收图片并验证
   - `RecognitionService`保存图片到指定目录
   - 调用`ImageUtil`进行图像预处理
   - 调用`ModelService`执行模型推理
   - 根据推理结果查询`pest_info`表获取害虫信息
   - 创建识别记录并保存到`recognition_history`表
   - 构建响应结果返回给前端

3. **前端展示**：
   - `RecognitionResult`组件接收并展示识别结果
   - 显示害虫名称、置信度、基本信息等

#### 2.2.2 害虫详情查询流程

1. **前端请求**：
   - 用户点击"查看详情"按钮
   - 前端调用`/api/pests/{pestId}`接口

2. **后端处理**：
   - `PestController`接收请求
   - `PestService`查询`pest_info`表获取害虫详细信息
   - 返回害虫信息给前端

3. **前端展示**：
   - `PestInfo`组件接收并展示害虫详细信息
   - 显示分类、危害症状、防治方法等

#### 2.2.3 历史记录查询流程

1. **前端请求**：
   - 用户进入历史记录页面
   - 前端调用`/api/history`接口，带上分页参数

2. **后端处理**：
   - `HistoryController`接收请求
   - `HistoryService`查询`recognition_history`表，关联`pest_info`表
   - 返回分页结果给前端

3. **前端展示**：
   - `History`组件接收并展示历史记录列表
   - 支持分页浏览和查看详情

## 3. 前后端数据交互

### 3.1 API接口设计

#### 3.1.1 识别API

**请求**：
- 方法：POST
- URL：`/api/recognition`
- Content-Type：multipart/form-data
- 参数：file（图片文件）

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "pestId": 1,
    "pestName": "稻飞虱",
    "pestNameEn": "Rice planthopper",
    "confidence": 0.95,
    "description": "稻飞虱是水稻的主要害虫之一...",
    "imageUrl": "/images/abc123.jpg",
    "harmLevel": 4,
    "preventionMethods": "农业防治：合理密植，增施有机肥..."
  }
}
```

#### 3.1.2 害虫信息API

**请求**：
- 方法：GET
- URL：`/api/pests/{pestId}`
- 参数：pestId（路径参数）

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": 1,
    "nameZh": "稻飞虱",
    "nameEn": "Rice planthopper",
    "category": "同翅目",
    "description": "稻飞虱是水稻的主要害虫之一...",
    "harmLevel": 4,
    "symptoms": "被害植株叶片发黄、枯萎...",
    "preventionMethods": "农业防治：合理密植，增施有机肥...",
    "imageUrl": "/images/pests/rice_planthopper.jpg"
  }
}
```

#### 3.1.3 历史记录API

**请求**：
- 方法：GET
- URL：`/api/history`
- 参数：
  - page：页码（默认1）
  - size：每页大小（默认10）

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "records": [
      {
        "id": 1,
        "pestId": 1,
        "pestName": "稻飞虱",
        "confidence": 0.95,
        "imageUrl": "/images/abc123.jpg",
        "createTime": "2025-05-22T10:00:00"
      },
      // ...更多记录
    ],
    "total": 100,
    "page": 1,
    "size": 10,
    "pages": 10
  }
}
```

### 3.2 数据传输对象(DTO)设计

#### 3.2.1 请求DTO

**RecognitionRequest**：
- 识别请求通过MultipartFile直接接收，不需要专门的DTO

#### 3.2.2 响应DTO

**RecognitionResponse**：
```java
public class RecognitionResponse {
    private Long pestId;           // 害虫ID
    private String pestName;       // 害虫中文名称
    private String pestNameEn;     // 害虫英文名称
    private Double confidence;     // 置信度
    private String description;    // 描述
    private String imageUrl;       // 图片URL
    private Integer harmLevel;     // 危害等级
    private String preventionMethods; // 防治方法
}
```

**PestVO**：
```java
public class PestVO {
    private Long id;               // 害虫ID
    private String nameZh;         // 中文名称
    private String nameEn;         // 英文名称
    private String category;       // 分类
    private String description;    // 描述
    private Integer harmLevel;     // 危害等级
    private String symptoms;       // 危害症状
    private String preventionMethods; // 防治方法
    private String imageUrl;       // 图片URL
}
```

**HistoryVO**：
```java
public class HistoryVO {
    private Long id;               // 记录ID
    private Long pestId;           // 害虫ID
    private String pestName;       // 害虫名称
    private Double confidence;     // 置信度
    private String imageUrl;       // 图片URL
    private LocalDateTime createTime; // 创建时间
}
```

## 4. 数据库操作实现

### 4.1 数据访问层(DAO)实现

系统使用Spring Data JPA实现数据访问，主要包含以下Repository接口：

**PestRepository**：
```java
@Repository
public interface PestRepository extends JpaRepository<Pest, Long> {
    
    Optional<Pest> findByNameZh(String nameZh);
    
    Optional<Pest> findByNameEn(String nameEn);
    
    Optional<Pest> findByNameZhOrNameEn(String nameZh, String nameEn);
}
```

**HistoryRepository**：
```java
@Repository
public interface HistoryRepository extends JpaRepository<RecognitionHistory, Long> {
    
    @Query("SELECT h FROM RecognitionHistory h JOIN FETCH h.pest ORDER BY h.createTime DESC")
    Page<RecognitionHistory> findAllWithPest(Pageable pageable);
}
```

### 4.2 服务层数据处理

服务层负责业务逻辑处理和数据转换：

**PestService**：
- 根据ID查询害虫信息
- 根据名称查询害虫信息
- 查询所有害虫信息
- 将实体对象转换为VO对象

**HistoryService**：
- 保存识别历史记录
- 分页查询历史记录
- 将实体对象转换为VO对象

**RecognitionService**：
- 处理图片上传
- 调用模型服务进行识别
- 保存识别结果到数据库
- 构建识别响应对象

### 4.3 事务管理

系统使用Spring的声明式事务管理：

```java
@Service
@Transactional(readOnly = true)  // 默认只读事务
public class PestServiceImpl implements PestService {
    
    // 读操作使用默认的只读事务
    @Override
    public PestVO getById(Long id) {
        // ...
    }
    
    // 写操作需要单独声明事务属性
    @Override
    @Transactional(readOnly = false)
    public Pest save(Pest pest) {
        // ...
    }
}
```

## 5. 数据同步与缓存策略

### 5.1 数据初始化

系统启动时需要初始化基础害虫数据：

```java
@Component
public class DataInitializer implements CommandLineRunner {
    
    @Autowired
    private PestRepository pestRepository;
    
    @Override
    @Transactional
    public void run(String... args) throws Exception {
        // 检查数据库是否已有数据
        if (pestRepository.count() == 0) {
            // 初始化害虫数据
            List<Pest> pests = new ArrayList<>();
            
            Pest pest1 = new Pest();
            pest1.setNameZh("稻飞虱");
            pest1.setNameEn("Rice planthopper");
            pest1.setCategory("同翅目");
            pest1.setDescription("稻飞虱是水稻的主要害虫之一...");
            pest1.setHarmLevel(4);
            pest1.setSymptoms("被害植株叶片发黄、枯萎...");
            pest1.setPreventionMethods("农业防治：合理密植，增施有机肥...");
            pest1.setImageUrl("/images/pests/rice_planthopper.jpg");
            pests.add(pest1);
            
            // 添加更多害虫数据...
            
            pestRepository.saveAll(pests);
        }
    }
}
```

### 5.2 缓存策略

为提高系统性能，可以对频繁访问的数据进行缓存：

```java
@Service
@CacheConfig(cacheNames = "pests")
public class PestServiceImpl implements PestService {
    
    @Cacheable(key = "#id")
    @Override
    public PestVO getById(Long id) {
        // ...
    }
    
    @Cacheable(key = "#name")
    @Override
    public Pest getByName(String name) {
        // ...
    }
    
    @CacheEvict(allEntries = true)
    @Override
    @Transactional
    public Pest save(Pest pest) {
        // ...
    }
}
```

缓存配置：

```java
@Configuration
@EnableCaching
public class CacheConfig {
    
    @Bean
    public CacheManager cacheManager() {
        SimpleCacheManager cacheManager = new SimpleCacheManager();
        cacheManager.setCaches(Arrays.asList(
                new ConcurrentMapCache("pests"),
                new ConcurrentMapCache("history")
        ));
        return cacheManager;
    }
}
```

## 6. 数据安全与权限控制

### 6.1 SQL注入防护

系统使用JPA和参数化查询，自动防止SQL注入：

```java
// 安全的查询方式
@Query("SELECT p FROM Pest p WHERE p.nameZh = :name OR p.nameEn = :name")
Optional<Pest> findByName(@Param("name") String name);
```

### 6.2 数据验证

使用Bean Validation进行数据验证：

```java
@Entity
@Table(name = "pest_info")
public class Pest {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotBlank(message = "中文名称不能为空")
    @Size(max = 100, message = "中文名称长度不能超过100")
    @Column(name = "name_zh", nullable = false, length = 100)
    private String nameZh;
    
    // 其他字段验证...
}
```

控制器中进行验证：

```java
@PostMapping
public ResponseEntity<?> createPest(@Valid @RequestBody PestDTO pestDTO, BindingResult result) {
    if (result.hasErrors()) {
        // 处理验证错误
    }
    // 处理有效数据
}
```

### 6.3 敏感数据处理

对于敏感数据，可以使用加密存储：

```java
@Entity
public class User {
    
    @Column(name = "password", nullable = false)
    private String password;  // 存储加密后的密码
    
    // 密码加密方法
    public void setPassword(String password) {
        this.password = passwordEncoder.encode(password);
    }
}
```

## 7. 数据库性能优化

### 7.1 查询优化

1. **使用索引**：
   - 已在前面的索引设计中说明

2. **分页查询**：
   - 使用分页减少数据传输量
   ```java
   @GetMapping
   public Page<PestVO> getPests(
           @RequestParam(defaultValue = "0") int page,
           @RequestParam(defaultValue = "10") int size) {
       return pestService.getPests(PageRequest.of(page, size));
   }
   ```

3. **延迟加载**：
   - 使用JPA的延迟加载特性
   ```java
   @ManyToOne(fetch = FetchType.LAZY)
   @JoinColumn(name = "pest_id")
   private Pest pest;
   ```

### 7.2 连接池配置

在application.yml中配置数据库连接池：

```yaml
spring:
  datasource:
    hikari:
      maximum-pool-size: 10
      minimum-idle: 5
      idle-timeout: 30000
      connection-timeout: 30000
      max-lifetime: 1800000
```

### 7.3 批量操作

对于批量操作，使用批处理提高性能：

```java
@Transactional
public void batchSave(List<Pest> pests) {
    for (int i = 0; i < pests.size(); i++) {
        entityManager.persist(pests.get(i));
        if (i % 50 == 0) {
            entityManager.flush();
            entityManager.clear();
        }
    }
}
```

## 8. 数据库维护与备份

### 8.1 数据备份策略

1. **定期备份**：
   - 使用MySQL的备份工具
   ```bash
   mysqldump -u username -p pest_recognition > backup.sql
   ```

2. **自动备份脚本**：
   ```bash
   #!/bin/bash
   DATE=$(date +%Y%m%d)
   mysqldump -u username -p password pest_recognition > backup_$DATE.sql
   gzip backup_$DATE.sql
   ```

### 8.2 数据迁移

使用Flyway或Liquibase进行数据库版本控制和迁移：

```xml
<!-- pom.xml -->
<dependency>
    <groupId>org.flywaydb</groupId>
    <artifactId>flyway-core</artifactId>
</dependency>
```

```yaml
# application.yml
spring:
  flyway:
    enabled: true
    locations: classpath:db/migration
    baseline-on-migrate: true
```

迁移脚本：
```sql
-- V1__Create_pest_table.sql
CREATE TABLE pest_info (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name_zh VARCHAR(100) NOT NULL,
    -- 其他字段...
);

-- V2__Create_history_table.sql
CREATE TABLE recognition_history (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    -- 其他字段...
);
```

## 9. 前后端数据交互最佳实践

### 9.1 统一响应格式

使用统一的响应格式简化前端处理：

```java
public class ApiResponse<T> {
    private int code;
    private String message;
    private T data;
    
    // 成功响应
    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(200, "success", data);
    }
    
    // 错误响应
    public static <T> ApiResponse<T> error(int code, String message) {
        return new ApiResponse<>(code, message, null);
    }
}
```

### 9.2 错误处理

全局异常处理：

```java
@RestControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(EntityNotFoundException.class)
    public ResponseEntity<ApiResponse<Void>> handleEntityNotFound(EntityNotFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(ApiResponse.error(404, ex.getMessage()));
    }
    
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<Void>> handleGenericException(Exception ex) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(ApiResponse.error(500, "服务器内部错误"));
    }
}
```

### 9.3 数据验证反馈

将验证错误以友好方式返回给前端：

```java
@ExceptionHandler(MethodArgumentNotValidException.class)
public ResponseEntity<ApiResponse<Map<String, String>>> handleValidationExceptions(
        MethodArgumentNotValidException ex) {
    Map<String, String> errors = new HashMap<>();
    ex.getBindingResult().getAllErrors().forEach((error) -> {
        String fieldName = ((FieldError) error).getField();
        String errorMessage = error.getDefaultMessage();
        errors.put(fieldName, errorMessage);
    });
    return ResponseEntity.badRequest()
            .body(ApiResponse.error(400, "输入验证失败", errors));
}
```

## 10. 数据流转测试与验证

### 10.1 单元测试

测试数据访问层：

```java
@DataJpaTest
class PestRepositoryTest {
    
    @Autowired
    private PestRepository pestRepository;
    
    @Test
    void findByNameZhOrNameEn_ExistingName_ReturnsPest() {
        // 准备测试数据
        Pest pest = new Pest();
        pest.setNameZh("测试害虫");
        pest.setNameEn("Test Pest");
        pestRepository.save(pest);
        
        // 执行测试
        Optional<Pest> result1 = pestRepository.findByNameZhOrNameEn("测试害虫", "测试害虫");
        Optional<Pest> result2 = pestRepository.findByNameZhOrNameEn("Test Pest", "Test Pest");
        
        // 验证结果
        assertTrue(result1.isPresent());
        assertTrue(result2.isPresent());
        assertEquals("测试害虫", result1.get().getNameZh());
        assertEquals("Test Pest", result2.get().getNameEn());
    }
}
```

### 10.2 集成测试

测试完整的数据流转过程：

```java
@SpringBootTest
@AutoConfigureMockMvc
class RecognitionIntegrationTest {
    
    @Autowired
    private MockMvc mockMvc;
    
    @Autowired
    private PestRepository pestRepository;
    
    @Test
    void recognizePest_ValidImage_ReturnsCorrectResult() throws Exception {
        // 准备测试数据
        Pest pest = new Pest();
        pest.setNameZh("测试害虫");
        pest.setNameEn("Test Pest");
        pestRepository.save(pest);
        
        // 准备测试图片
        MockMultipartFile file = new MockMultipartFile(
                "file",
                "test.jpg",
                "image/jpeg",
                getClass().getResourceAsStream("/test-images/test.jpg")
        );
        
        // 执行测试
        mockMvc.perform(multipart("/api/recognition")
                .file(file))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(200))
                .andExpect(jsonPath("$.data.pestName").value("测试害虫"));
    }
}
```

### 10.3 端到端测试

使用Selenium或Cypress测试前后端数据流转：

```javascript
// Cypress测试示例
describe('害虫识别流程', () => {
  it('上传图片并查看识别结果', () => {
    cy.visit('/recognition');
    cy.get('input[type=file]').attachFile('test.jpg');
    cy.get
(Content truncated due to size limit. Use line ranges to read in chunks)