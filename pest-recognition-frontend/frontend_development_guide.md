# 害虫识别系统前端开发指南

本指南将帮助您在Windows环境下使用AI编程助手逐步搭建害虫识别系统的前端部分。

## 1. 环境准备与项目初始化

### 1.1 确认开发环境

首先，确认您的Node.js环境是否正确安装。打开命令提示符或PowerShell，执行以下命令：

```bash
node -v
# 应显示 v16.13.1 或类似版本

npm -v
# 确认npm已安装
```

如果npm未安装，请访问Node.js官网(https://nodejs.org/)下载并安装对应版本。

### 1.2 安装Vue CLI（如未安装）

```bash
npm install -g @vue/cli
```

安装完成后，验证Vue CLI是否正确安装：

```bash
vue --version
```

### 1.3 创建Vue项目

使用AI编程助手，您可以通过以下步骤创建项目：

1. **向AI编程助手描述需求**：
   ```
   请帮我创建一个名为pest-recognition-frontend的Vue项目，使用Vue 2，包含Vue Router和Vuex，使用npm作为包管理器。
   ```

2. **AI助手将生成命令**：
   ```bash
   vue create pest-recognition-frontend
   ```
   
   在交互式选择中：
   - 选择"Manually select features"
   - 勾选：Babel, Router, Vuex, CSS Pre-processors, Linter
   - 选择Vue版本2.x
   - 选择history模式的路由
   - 选择Sass/SCSS作为CSS预处理器
   - 选择ESLint + Prettier配置
   - 选择Lint on save
   - 将配置保存在package.json中
   - 不保存为预设

3. **进入项目目录**：
   ```bash
   cd pest-recognition-frontend
   ```

### 1.4 安装必要的依赖

向AI编程助手请求安装以下依赖：

```
请帮我安装Element UI、Axios和其他必要的依赖。
```

AI助手将生成如下命令：

```bash
npm install element-ui axios nprogress
```

## 2. 项目结构设置

### 2.1 创建基本目录结构

向AI编程助手请求：

```
请帮我创建前端项目的基本目录结构，包括assets、components、views、services、utils等文件夹，并设置基本的文件。
```

AI助手将帮您创建如下结构：

```
src/
├── assets/
│   ├── images/
│   └── styles/
├── components/
│   ├── common/
│   │   ├── Header.vue
│   │   ├── Footer.vue
│   │   └── Loading.vue
│   └── recognition/
│       ├── ImageUploader.vue
│       ├── RecognitionResult.vue
│       └── PestInfo.vue
├── views/
│   ├── Home.vue
│   ├── Recognition.vue
│   ├── History.vue
│   └── About.vue
├── router/
│   └── index.js
├── store/
│   └── index.js
├── services/
│   ├── api.js
│   └── recognition.js
└── utils/
    ├── request.js
    └── imageProcess.js
```

### 2.2 配置环境变量

向AI编程助手请求：

```
请帮我创建开发和生产环境的配置文件，设置API基础URL。
```

AI助手将帮您创建以下文件：

**.env.development**
```
VUE_APP_API_BASE_URL=http://localhost:8080/api
```

**.env.production**
```
VUE_APP_API_BASE_URL=/api
```

## 3. 核心组件开发

### 3.1 开发图片上传组件

向AI编程助手请求：

```
请帮我开发一个图片上传组件(ImageUploader.vue)，支持拖拽上传和点击上传，并能预览图片。
```

AI助手将生成类似以下的代码：

```vue
<template>
  <div class="image-uploader">
    <el-upload
      class="uploader"
      drag
      action="#"
      :http-request="handleUpload"
      :show-file-list="false"
      :before-upload="beforeUpload"
      :on-change="handleChange"
    >
      <i v-if="!imageUrl && !loading" class="el-icon-upload"></i>
      <div v-if="!imageUrl && !loading" class="el-upload__text">
        拖拽图片到此处，或 <em>点击上传</em>
      </div>
      <div v-if="loading" class="loading-container">
        <el-progress type="circle" :percentage="uploadProgress"></el-progress>
        <div class="loading-text">正在上传...</div>
      </div>
      <img v-if="imageUrl && !loading" :src="imageUrl" class="preview-image" />
    </el-upload>
    
    <div class="upload-tips">
      <p>支持JPG、PNG格式，最大5MB</p>
    </div>
    
    <div v-if="imageUrl && !loading" class="upload-actions">
      <el-button type="primary" @click="$emit('submit', imageFile)">开始识别</el-button>
      <el-button @click="resetUpload">重新上传</el-button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ImageUploader',
  data() {
    return {
      imageUrl: '',
      imageFile: null,
      loading: false,
      uploadProgress: 0
    }
  },
  methods: {
    beforeUpload(file) {
      const isImage = file.type === 'image/jpeg' || file.type === 'image/png';
      const isLt5M = file.size / 1024 / 1024 < 5;

      if (!isImage) {
        this.$message.error('只能上传JPG或PNG格式的图片!');
      }
      if (!isLt5M) {
        this.$message.error('图片大小不能超过5MB!');
      }
      
      return isImage && isLt5M;
    },
    handleChange(file) {
      this.imageFile = file.raw;
      this.imageUrl = URL.createObjectURL(file.raw);
    },
    handleUpload(options) {
      this.loading = true;
      
      // 模拟上传进度
      const timer = setInterval(() => {
        if (this.uploadProgress < 99) {
          this.uploadProgress += 10;
        } else {
          clearInterval(timer);
          this.uploadProgress = 100;
          this.loading = false;
        }
      }, 100);
      
      // 实际项目中，这里不需要真正上传，而是在点击"开始识别"时才发送到后端
    },
    resetUpload() {
      this.imageUrl = '';
      this.imageFile = null;
      this.uploadProgress = 0;
    }
  }
}
</script>

<style scoped lang="scss">
.image-uploader {
  width: 100%;
  max-width: 500px;
  margin: 0 auto;
  
  .uploader {
    width: 100%;
    
    .el-upload {
      width: 100%;
      
      .el-upload-dragger {
        width: 100%;
        height: 300px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
      }
    }
  }
  
  .preview-image {
    width: 100%;
    max-height: 300px;
    object-fit: contain;
  }
  
  .loading-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    
    .loading-text {
      margin-top: 15px;
      color: #909399;
    }
  }
  
  .upload-tips {
    margin-top: 10px;
    color: #909399;
    font-size: 12px;
    text-align: center;
  }
  
  .upload-actions {
    margin-top: 20px;
    display: flex;
    justify-content: center;
    gap: 10px;
  }
}
</style>
```

### 3.2 开发识别结果组件

向AI编程助手请求：

```
请帮我开发一个识别结果展示组件(RecognitionResult.vue)，用于展示害虫识别结果，包括害虫名称、置信度和基本信息。
```

AI助手将生成类似以下的代码：

```vue
<template>
  <div class="recognition-result" v-loading="loading">
    <div v-if="result" class="result-container">
      <div class="result-header">
        <h2>识别结果</h2>
        <el-tag type="success" size="medium">识别成功</el-tag>
      </div>
      
      <div class="pest-info">
        <div class="pest-name">
          <h3>{{ result.pestName }}</h3>
          <div class="pest-name-en">{{ result.pestNameEn }}</div>
        </div>
        
        <div class="confidence">
          <span class="label">置信度：</span>
          <el-progress 
            :percentage="Math.round(result.confidence * 100)" 
            :color="confidenceColor"
          ></el-progress>
        </div>
        
        <div class="description">
          <p>{{ result.description }}</p>
        </div>
        
        <div class="harm-level">
          <span class="label">危害等级：</span>
          <el-rate
            v-model="result.harmLevel"
            disabled
            show-score
            text-color="#ff9900"
          ></el-rate>
        </div>
        
        <div class="actions">
          <el-button type="primary" @click="$emit('view-details', result.pestId)">
            查看详情
          </el-button>
          <el-button @click="$emit('retry')">重新识别</el-button>
        </div>
      </div>
    </div>
    
    <div v-else-if="!loading" class="no-result">
      <i class="el-icon-warning-outline"></i>
      <p>暂无识别结果，请上传害虫图片</p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'RecognitionResult',
  props: {
    result: {
      type: Object,
      default: null
    },
    loading: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    confidenceColor() {
      const confidence = this.result ? this.result.confidence : 0;
      if (confidence >= 0.8) return '#67C23A';
      if (confidence >= 0.6) return '#E6A23C';
      return '#F56C6C';
    }
  }
}
</script>

<style scoped lang="scss">
.recognition-result {
  width: 100%;
  max-width: 500px;
  margin: 0 auto;
  padding: 20px;
  
  .result-container {
    border-radius: 8px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    padding: 20px;
    
    .result-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
      
      h2 {
        margin: 0;
        color: #303133;
      }
    }
    
    .pest-info {
      .pest-name {
        margin-bottom: 15px;
        
        h3 {
          margin: 0 0 5px 0;
          font-size: 24px;
          color: #303133;
        }
        
        .pest-name-en {
          color: #909399;
          font-size: 14px;
        }
      }
      
      .confidence {
        margin-bottom: 15px;
        
        .label {
          display: block;
          margin-bottom: 5px;
          font-weight: bold;
          color: #606266;
        }
      }
      
      .description {
        margin-bottom: 15px;
        color: #606266;
        line-height: 1.6;
      }
      
      .harm-level {
        margin-bottom: 20px;
        
        .label {
          display: block;
          margin-bottom: 5px;
          font-weight: bold;
          color: #606266;
        }
      }
      
      .actions {
        display: flex;
        gap: 10px;
      }
    }
  }
  
  .no-result {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 200px;
    color: #909399;
    
    i {
      font-size: 48px;
      margin-bottom: 10px;
    }
    
    p {
      font-size: 16px;
    }
  }
}
</style>
```

### 3.3 开发害虫详情组件

向AI编程助手请求：

```
请帮我开发一个害虫详情组件(PestInfo.vue)，用于展示害虫的详细信息，包括分类、危害、防治方法等。
```

AI助手将生成类似以下的代码：

```vue
<template>
  <div class="pest-info-container" v-loading="loading">
    <div v-if="pestInfo" class="pest-detail">
      <div class="pest-header">
        <div class="pest-title">
          <h2>{{ pestInfo.nameZh }}</h2>
          <div class="pest-name-en">{{ pestInfo.nameEn }}</div>
        </div>
        <el-tag size="medium">{{ pestInfo.category }}</el-tag>
      </div>
      
      <div class="pest-image" v-if="pestInfo.imageUrl">
        <img :src="pestInfo.imageUrl" alt="害虫图片">
      </div>
      
      <el-divider content-position="left">基本信息</el-divider>
      
      <div class="info-section">
        <div class="harm-level">
          <span class="label">危害等级：</span>
          <el-rate
            v-model="pestInfo.harmLevel"
            disabled
            show-score
            text-color="#ff9900"
          ></el-rate>
        </div>
        
        <div class="description">
          <h4>描述</h4>
          <p>{{ pestInfo.description }}</p>
        </div>
      </div>
      
      <el-divider content-position="left">危害症状</el-divider>
      
      <div class="info-section">
        <p>{{ pestInfo.symptoms }}</p>
      </div>
      
      <el-divider content-position="left">防治方法</el-divider>
      
      <div class="info-section">
        <p>{{ pestInfo.preventionMethods }}</p>
      </div>
      
      <div class="actions">
        <el-button @click="$emit('back')">返回</el-button>
      </div>
    </div>
    
    <div v-else-if="!loading" class="no-data">
      <i class="el-icon-warning-outline"></i>
      <p>未找到害虫信息</p>
      <el-button @click="$emit('back')">返回</el-button>
    </div>
  </div>
</template>

<script>
import { recognitionService } from '@/services/recognition';

export default {
  name: 'PestInfo',
  props: {
    pestId: {
      type: [Number, String],
      required: true
    }
  },
  data() {
    return {
      pestInfo: null,
      loading: true
    }
  },
  created() {
    this.fetchPestInfo();
  },
  methods: {
    async fetchPestInfo() {
      this.loading = true;
      try {
        this.pestInfo = await recognitionService.getPestInfo(this.pestId);
      } catch (error) {
        this.$message.error('获取害虫信息失败');
        console.error(error);
      } finally {
        this.loading = false;
      }
    }
  }
}
</script>

<style scoped lang="scss">
.pest-info-container {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
  
  .pest-detail {
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    padding: 20px;
    
    .pest-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 20px;
      
      .pest-title {
        h2 {
          margin: 0 0 5px 0;
          font-size: 28px;
          color: #303133;
        }
        
        .pest-name-en {
          color: #909399;
          font-size: 16px;
        }
      }
    }
    
    .pest-image {
      width: 100%;
      margin-bottom: 20px;
      text-align: center;
      
      img {
        max-width: 100%;
        max-height: 400px;
        border-radius: 4px;
      }
    }
    
    .info-section {
      margin-bottom: 20px;
      
      .harm-level {
        margin-bottom: 15px;
        
        .label {
          display: inline-block;
          margin-right: 10px;
          font-weight: bold;
          color: #606266;
        }
      }
      
      .description {
        h4 {
          margin: 0 0 10px 0;
          color: #303133;
        }
        
        p {
          color: #606266;
          line-height: 1.6;
          margin: 0;
        }
      }
      
      p {
        color: #606266;
        line-height: 1.6;
        margin: 0;
      }
    }
    
    .actions {
      margin-top: 30px;
      display: flex;
      justify-content: center;
    }
  }
  
  .no-data {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 300px;
    color: #909399;
    
    i {
      font-size: 48px;
      margin-bottom: 10px;
    }
    
    p {
      font-size: 16px;
      margin-bottom: 20px;
    }
  }
}
</style>
```

## 4. 页面开发

### 4.1 开发首页

向AI编程助手请求：

```
请帮我开发首页(Home.vue)，包含欢迎信息和进入识别页面的入口。
```

AI助手将生成类似以下的代码：

```vue
<template>
  <div class="home-container">
    <div class="hero-section">
      <h1>害虫识别系统</h1>
      <p class="subtitle">快速、准确地识别农作物害虫，获取防治建议</p>
      
      <el-button type="primary" size="large" @click="goToRecognition">
        开始识别
        <i class="el-icon-arrow-right el-icon--right"></i>
      </el-button>
    </div>
    
    <div class="features-section">
      <el-row :gutter="20">
        <el-col :xs="24" :sm="8">
          <div class="feature-card">
            <i class="el-icon-picture-outline-round"></i>
            <h3>快速识别</h3>
            <p>上传害虫图片，系统秒级识别害虫种类</p>
          </div>
        </el-col>
        
        <el-col :xs="24" :sm="8">
          <div class="feature-card">
            <i class="el-icon-info"></i>
            <h3>详细信息</h3>
            <p>提供害虫详细信息、危害症状及防治方法</p>
          </div>
        </el-col>
        
        <el-col :xs="24" :sm="8">
          <div class="feature-card">
            <i class="el-icon-time"></i>
            <h3>历史记录</h3>
            <p>保存识别历史，方便后续查询和对比</p>
          </div>
        </el-col>
      </el-row>
    </div>
    
    <div class="common-pests-section">
      <h2>常见农作物害虫</h2>
      <p>以下是一些常见的农作物害虫，您可以直接点击进入识别页面上传图片进行识别</p>
      
      <el-row :gutter="20">
        <el-col :xs="24" :sm="12" :md="8" v-for="pest in commonPests" :key="pest.id">
          <div class="pest-card" @click="goToRecognition">
            <div class="pest-image">
              <img :src="pest.imageUrl" :alt="pest.name">
            </div>
            <div class="pest-info">
              <h3>{{ pest.name }}</h3>
              <p>{{ pest.description }}</p>
            </div>
          </div>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Home',
  data() {
    return {
      commonPests: [
        {
          id: 1,
          name: '稻飞虱',
          description: '水稻主要害虫，可导致水稻减产甚至绝收',
          imageUrl: require('@/assets/images/placeholder.jpg')
        },
        {
          id: 2,
          name: '蚜虫',
          description: '多种农作物常见害虫，繁殖速度快',
          imageUrl: require('@/assets/images/placeholder.jpg')
        },
        {
          id: 3,
          name: '粘虫',
          description: '禾本科作物的重要害虫，有集群迁飞特性',
          imageUrl: require('@/assets/images/placeholder.jpg')
        }
      ]
    }
  },
  methods: {
    goToRecognition() {
      this.$router.push('/recognition');
    }
  }
}
</script>

<style scoped lang="scss">
.home-container {
  padding: 20px;
  
  .hero-section {
    text-align: center;
    padding: 60px 20px;
    background-color: #f5f7fa;
    border-radius: 8px;
    margin-bottom: 40px;
    
    h1 {
      font-size: 36px;
      color: #303133;
      margin-bottom: 15px;
    }
    
    
(Content truncated due to size limit. Use line ranges to read in chunks)