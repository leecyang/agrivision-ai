# 害虫识别系统后端开发任务分解

## 1. 后端项目结构设计

```
pest-recognition-backend/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── pestrecognition/
│   │   │           ├── PestRecognitionApplication.java
│   │   │           ├── config/
│   │   │           │   ├── WebMvcConfig.java
│   │   │           │   ├── SwaggerConfig.java
│   │   │           │   └── ModelConfig.java
│   │   │           ├── controller/
│   │   │           │   ├── RecognitionController.java
│   │   │           │   ├── PestController.java
│   │   │           │   └── HistoryController.java
│   │   │           ├── service/
│   │   │           │   ├── RecognitionService.java
│   │   │           │   ├── PestService.java
│   │   │           │   ├── HistoryService.java
│   │   │           │   └── impl/
│   │   │           │       ├── RecognitionServiceImpl.java
│   │   │           │       ├── PestServiceImpl.java
│   │   │           │       └── HistoryServiceImpl.java
│   │   │           ├── dao/
│   │   │           │   ├── PestMapper.java
│   │   │           │   └── HistoryMapper.java
│   │   │           ├── model/
│   │   │           │   ├── entity/
│   │   │           │   │   ├── Pest.java
│   │   │           │   │   └── RecognitionHistory.java
│   │   │           │   ├── dto/
│   │   │           │   │   ├── RecognitionRequest.java
│   │   │           │   │   └── RecognitionResponse.java
│   │   │           │   └── vo/
│   │   │           │       ├── PestVO.java
│   │   │           │       └── HistoryVO.java
│   │   │           ├── util/
│   │   │           │   ├── FileUtil.java
│   │   │           │   ├── ImageUtil.java
│   │   │           │   └── ResultUtil.java
│   │   │           └── ml/
│   │   │               ├── ModelService.java
│   │   │               ├── DJLModelServiceImpl.java
│   │   │               └── PythonModelServiceImpl.java
│   │   └── resources/
│   │       ├── application.yml
│   │       ├── application-dev.yml
│   │       ├── application-prod.yml
│   │       ├── mapper/
│   │       │   ├── PestMapper.xml
│   │       │   └── HistoryMapper.xml
│   │       ├── static/
│   │       │   └── images/
│   │       └── model/
│   │           └── pest_recognition_model.onnx
│   └── test/
│       └── java/
│           └── com/
│               └── pestrecognition/
│                   ├── controller/
│                   ├── service/
│                   └── ml/
├── pom.xml
└── README.md
```

## 2. 核心功能模块设计

### 2.1 图片上传与预处理模块

**功能：**
- 接收前端上传的图片
- 验证图片格式和大小
- 图片预处理（调整大小、归一化等）
- 保存原始图片和预处理后的图片

**关键类：**
- `RecognitionController`: 处理图片上传请求
- `FileUtil`: 文件操作工具类
- `ImageUtil`: 图片处理工具类

**示例代码：**
```java
// RecognitionController.java
@RestController
@RequestMapping("/api")
public class RecognitionController {
    
    @Autowired
    private RecognitionService recognitionService;
    
    @PostMapping("/recognition")
    public ResponseEntity<?> recognizePest(@RequestParam("file") MultipartFile file) {
        // 验证文件
        if (file.isEmpty()) {
            return ResponseEntity.badRequest().body("请上传图片文件");
        }
        
        // 验证文件类型
        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            return ResponseEntity.badRequest().body("只支持图片文件");
        }
        
        try {
            // 调用识别服务
            RecognitionResponse result = recognitionService.recognizePest(file);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("识别过程中发生错误: " + e.getMessage());
        }
    }
}
```

### 2.2 模型服务模块

**功能：**
- 加载预训练的害虫识别模型
- 处理图片输入
- 执行模型推理
- 返回识别结果

**关键类：**
- `ModelService`: 模型服务接口
- `DJLModelServiceImpl`: 使用DJL实现的模型服务
- `PythonModelServiceImpl`: 使用Python脚本实现的模型服务

**DJL实现示例：**
```java
// DJLModelServiceImpl.java
@Service
@ConditionalOnProperty(name = "model.type", havingValue = "djl")
public class DJLModelServiceImpl implements ModelService {
    
    private Predictor<Image, Classifications> predictor;
    
    @PostConstruct
    public void init() throws ModelException, IOException {
        // 加载模型
        Criteria<Image, Classifications> criteria = Criteria.builder()
                .setTypes(Image.class, Classifications.class)
                .optModelPath(Paths.get("src/main/resources/model/pest_recognition_model.onnx"))
                .optEngine("OnnxRuntime")
                .build();
        
        ZooModel<Image, Classifications> model = ModelZoo.loadModel(criteria);
        predictor = model.newPredictor();
    }
    
    @Override
    public List<ClassificationResult> predict(BufferedImage image) throws Exception {
        // 转换为DJL图像格式
        Image djlImage = ImageFactory.getInstance().fromImage(image);
        
        // 执行预测
        Classifications classifications = predictor.predict(djlImage);
        
        // 转换结果
        return classifications.items().stream()
                .map(item -> new ClassificationResult(item.getClassName(), item.getProbability()))
                .collect(Collectors.toList());
    }
}
```

**Python脚本实现示例：**
```java
// PythonModelServiceImpl.java
@Service
@ConditionalOnProperty(name = "model.type", havingValue = "python")
public class PythonModelServiceImpl implements ModelService {
    
    @Value("${model.python.script}")
    private String pythonScript;
    
    @Value("${model.python.executable}")
    private String pythonExecutable;
    
    @Override
    public List<ClassificationResult> predict(BufferedImage image) throws Exception {
        // 保存图像到临时文件
        File tempFile = File.createTempFile("pest_image_", ".jpg");
        ImageIO.write(image, "jpg", tempFile);
        
        // 构建Python命令
        ProcessBuilder pb = new ProcessBuilder(
                pythonExecutable,
                pythonScript,
                tempFile.getAbsolutePath()
        );
        
        // 执行Python脚本
        Process process = pb.start();
        
        // 读取输出
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(process.getInputStream()))) {
            
            String line = reader.readLine();
            // 解析JSON结果
            ObjectMapper mapper = new ObjectMapper();
            List<ClassificationResult> results = mapper.readValue(
                    line, 
                    new TypeReference<List<ClassificationResult>>() {}
            );
            
            // 删除临时文件
            tempFile.delete();
            
            return results;
        }
    }
}
```

### 2.3 数据库交互模块

**功能：**
- 存储害虫信息
- 记录识别历史
- 查询害虫详情
- 查询历史记录

**关键类：**
- `PestMapper`: 害虫信息数据访问接口
- `HistoryMapper`: 识别历史数据访问接口
- `PestService`: 害虫信息服务
- `HistoryService`: 识别历史服务

**示例代码：**
```java
// PestMapper.java
@Mapper
public interface PestMapper {
    
    @Select("SELECT * FROM pest_info WHERE id = #{id}")
    Pest selectById(Long id);
    
    @Select("SELECT * FROM pest_info WHERE name_zh = #{name} OR name_en = #{name}")
    Pest selectByName(String name);
    
    @Select("SELECT * FROM pest_info")
    List<Pest> selectAll();
}

// HistoryMapper.java
@Mapper
public interface HistoryMapper {
    
    @Insert("INSERT INTO recognition_history(image_path, pest_id, confidence, create_time) " +
            "VALUES(#{imagePath}, #{pestId}, #{confidence}, #{createTime})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(RecognitionHistory history);
    
    @Select("SELECT * FROM recognition_history ORDER BY create_time DESC LIMIT #{offset}, #{limit}")
    List<RecognitionHistory> selectPage(int offset, int limit);
    
    @Select("SELECT COUNT(*) FROM recognition_history")
    int count();
}
```

### 2.4 业务逻辑服务模块

**功能：**
- 协调各模块工作
- 实现业务逻辑
- 数据转换和封装

**关键类：**
- `RecognitionService`: 识别服务接口
- `RecognitionServiceImpl`: 识别服务实现

**示例代码：**
```java
// RecognitionServiceImpl.java
@Service
public class RecognitionServiceImpl implements RecognitionService {
    
    @Autowired
    private ModelService modelService;
    
    @Autowired
    private PestService pestService;
    
    @Autowired
    private HistoryService historyService;
    
    @Value("${upload.path}")
    private String uploadPath;
    
    @Override
    public RecognitionResponse recognizePest(MultipartFile file) throws Exception {
        // 保存上传的图片
        String originalFilename = file.getOriginalFilename();
        String extension = FilenameUtils.getExtension(originalFilename);
        String newFilename = UUID.randomUUID().toString() + "." + extension;
        String imagePath = uploadPath + "/" + newFilename;
        
        File destFile = new File(imagePath);
        if (!destFile.getParentFile().exists()) {
            destFile.getParentFile().mkdirs();
        }
        file.transferTo(destFile);
        
        // 读取图片并预处理
        BufferedImage image = ImageIO.read(destFile);
        BufferedImage processedImage = ImageUtil.preprocess(image);
        
        // 调用模型服务进行预测
        List<ClassificationResult> results = modelService.predict(processedImage);
        
        if (results.isEmpty()) {
            throw new RuntimeException("无法识别图片中的害虫");
        }
        
        // 获取最可能的结果
        ClassificationResult topResult = results.get(0);
        
        // 查询害虫信息
        Pest pest = pestService.getByName(topResult.getClassName());
        
        // 保存识别历史
        RecognitionHistory history = new RecognitionHistory();
        history.setImagePath(imagePath);
        history.setPestId(pest.getId());
        history.setConfidence(topResult.getProbability());
        history.setCreateTime(new Date());
        historyService.saveHistory(history);
        
        // 构建响应
        RecognitionResponse response = new RecognitionResponse();
        response.setPestId(pest.getId());
        response.setPestName(pest.getNameZh());
        response.setPestNameEn(pest.getNameEn());
        response.setConfidence(topResult.getProbability());
        response.setDescription(pest.getDescription());
        response.setImageUrl("/api/images/" + newFilename);
        
        return response;
    }
}
```

## 3. API设计

### 3.1 识别API

**端点：** `POST /api/recognition`

**请求：**
- Content-Type: multipart/form-data
- 参数：file（图片文件）

**响应：**
```json
{
  "pestId": 1,
  "pestName": "稻飞虱",
  "pestNameEn": "Rice planthopper",
  "confidence": 0.95,
  "description": "稻飞虱是水稻的主要害虫之一...",
  "imageUrl": "/api/images/abc123.jpg",
  "harmLevel": 3,
  "preventionMethods": "可使用杀虫剂防治..."
}
```

### 3.2 害虫信息API

**端点：** `GET /api/pests/{pestId}`

**请求：**
- 路径参数：pestId（害虫ID）

**响应：**
```json
{
  "id": 1,
  "nameZh": "稻飞虱",
  "nameEn": "Rice planthopper",
  "description": "稻飞虱是水稻的主要害虫之一...",
  "category": "同翅目",
  "harmLevel": 3,
  "symptoms": "被害植株叶片发黄、枯萎...",
  "preventionMethods": "可使用杀虫剂防治...",
  "imageUrl": "/api/images/pests/rice_planthopper.jpg"
}
```

### 3.3 历史记录API

**端点：** `GET /api/history`

**请求：**
- 查询参数：page（页码，默认1）
- 查询参数：size（每页大小，默认10）

**响应：**
```json
{
  "total": 100,
  "pages": 10,
  "current": 1,
  "records": [
    {
      "id": 1,
      "pestId": 1,
      "pestName": "稻飞虱",
      "confidence": 0.95,
      "imageUrl": "/api/images/abc123.jpg",
      "createTime": "2025-05-22T10:00:00"
    },
    // ...更多记录
  ]
}
```

## 4. 模型部署流程

### 4.1 方案A：使用DJL (Deep Java Library)

**优点：**
- 直接在Java中加载和使用模型，无需额外进程
- 简化部署流程，减少依赖
- 性能较好，适合生产环境

**步骤：**

1. **准备ONNX模型**
   - 将训练好的TensorFlow/PyTorch模型转换为ONNX格式
   - 使用工具如`tf2onnx`或PyTorch的`torch.onnx.export`

2. **添加DJL依赖**
   ```xml
   <!-- pom.xml -->
   <dependencies>
       <!-- DJL API -->
       <dependency>
           <groupId>ai.djl</groupId>
           <artifactId>api</artifactId>
           <version>0.20.0</version>
       </dependency>
       
       <!-- ONNX Runtime引擎 -->
       <dependency>
           <groupId>ai.djl.onnxruntime</groupId>
           <artifactId>onnxruntime-engine</artifactId>
           <version>0.20.0</version>
       </dependency>
   </dependencies>
   ```

3. **配置模型路径**
   ```yaml
   # application.yml
   model:
     type: djl
     path: classpath:model/pest_recognition_model.onnx
   ```

4. **实现模型服务**
   - 创建`DJLModelServiceImpl`类（如前面示例）
   - 实现模型加载、预处理和推理逻辑

5. **测试模型服务**
   - 编写单元测试验证模型加载和推理功能
   - 使用测试图片验证识别结果

### 4.2 方案B：使用Python脚本

**优点：**
- 可直接使用原始模型，无需转换
- 利用Python生态系统的丰富工具
- 适合复杂模型或特殊预处理需求

**步骤：**

1. **准备Python环境**
   - 安装Python（建议3.8+）
   - 安装必要的库：TensorFlow/PyTorch, NumPy, Pillow等

2. **创建Python推理脚本**
   ```python
   # predict.py
   import sys
   import json
   import numpy as np
   from PIL import Image
   import tensorflow as tf  # 或 import torch
   
   # 加载模型
   model = tf.keras.models.load_model('model/pest_recognition_model.h5')
   
   # 类别映射
   class_names = ['稻飞虱', '蚜虫', '粘虫', ...]
   
   def preprocess_image(image_path):
       img = Image.open(image_path)
       img = img.resize((224, 224))
       img_array = np.array(img) / 255.0
       img_array = np.expand_dims(img_array, axis=0)
       return img_array
   
   def predict(image_path):
       # 预处理图像
       img_array = preprocess_image(image_path)
       
       # 执行预测
       predictions = model.predict(img_array)
       
       # 处理结果
       results = []
       for i in range(min(3, len(class_names))):
           idx = np.argsort(predictions[0])[-i-1]
           results.append({
               "className": class_names[idx],
               "probability": float(predictions[0][idx])
           })
       
       return results
   
   if __name__ == "__main__":
       if len(sys.argv) < 2:
           print("Usage: python predict.py <image_path>")
           sys.exit(1)
       
       image_path = sys.argv[1]
       results = predict(image_path)
       print(json.dumps(results))
   ```

3. **配置Java后端调用Python**
   ```yaml
   # application.yml
   model:
     type: python
     python:
       executable: python  # 或指定完整路径
       script: ${user.dir}/scripts/predict.py
   ```

4. **实现模型服务**
   - 创建`PythonModelServiceImpl`类（如前面示例）
   - 实现Java与Python的进程间通信

5. **测试模型服务**
   - 验证Python脚本独立运行
   - 测试Java调用Python的集成

### 4.3 方案C：使用TensorFlow Lite

**优点：**
- 模型体积小，推理速度快
- 适合资源受限环境
- 可通过JNI在Java中直接调用

**步骤：**

1. **转换模型为TensorFlow Lite格式**
   ```python
   import tensorflow as tf
   
   # 加载原始模型
   model = tf.keras.models.load_model('model/pest_recognition_model.h5')
   
   # 转换为TFLite
   converter = tf.lite.TFLiteConverter.from_keras_model(model)
   tflite_model = converter.convert()
   
   # 保存模型
   with open('model/pest_recognition_model.tflite', 'wb') as f:
       f.write(tflite_model)
   ```

2. **添加TensorFlow Lite依赖**
   ```xml
   <!-- pom.xml -->
   <dependencies>
       <dependency>
           <groupId>org.tensorflow</groupId>
           <artifactId>tensorflow-lite</artifactId>
           <version>2.8.0</version>
       </dependency>
   </dependencies>
   ```

3. **实现TFLite模型服务**
   ```java
   @Service
   @ConditionalOnProperty(name = "model.type", havingValue = "tflite")
   public class TFLiteModelServiceImpl implements ModelService {
       
       private MappedByteBuffer tfliteModel;
       private Interpreter interpreter;
       private List<String> labels;
       
       @PostConstruct
       public void init() throws IOException {
           // 加载模型
           File modelFile = new File("model/pest_recognition_model.tflite");
           tfliteModel = FileChannel.open(modelFile.toPath(), StandardOpenOption.READ)
                   .map(FileChannel.MapMode.READ_ONLY, 0, modelFile.length());
           
           // 创建解释器
           Interpreter.Options options = new Interpreter.Options();
           interpreter = new Interpreter(tfliteModel, options);
           
           // 加载标签
           labels = Files.readAllLines(Paths.get("model/labels.txt"));
       }
       
       @Override
       public List<ClassificationResult> predict(BufferedImage image) throws Exception {
           // 预处理图像
           ByteBuffer inputBuffer = preprocessImage(image);
           
           // 输出缓冲区
           float[][] outputBuff
(Content truncated due to size limit. Use line ranges to read in chunks)