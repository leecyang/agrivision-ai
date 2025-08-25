# 害虫识别系统前端开发任务分解

## 1. 前端项目结构设计

```
pest-recognition-frontend/
├── public/
│   ├── index.html
│   └── favicon.ico
├── src/
│   ├── assets/
│   │   ├── images/
│   │   └── styles/
│   ├── components/
│   │   ├── common/
│   │   │   ├── Header.vue
│   │   │   ├── Footer.vue
│   │   │   └── Loading.vue
│   │   └── recognition/
│   │       ├── ImageUploader.vue
│   │       ├── RecognitionResult.vue
│   │       └── PestInfo.vue
│   ├── views/
│   │   ├── Home.vue
│   │   ├── Recognition.vue
│   │   ├── History.vue
│   │   └── About.vue
│   ├── router/
│   │   └── index.js
│   ├── store/
│   │   └── index.js
│   ├── services/
│   │   ├── api.js
│   │   └── recognition.js
│   ├── utils/
│   │   ├── request.js
│   │   └── imageProcess.js
│   ├── App.vue
│   └── main.js
├── .env
├── .env.development
├── .env.production
├── package.json
└── vue.config.js
```

## 2. 页面设计与交互逻辑

### 2.1 首页 (Home.vue)

**设计要点：**
- 简洁美观的欢迎页面
- 系统功能简介
- 快速进入识别功能的入口按钮
- 展示常见害虫示例（可选）

**交互逻辑：**
1. 用户进入首页
2. 点击"开始识别"按钮跳转到识别页面
3. 可查看系统介绍和使用说明

### 2.2 识别页面 (Recognition.vue)

**设计要点：**
- 图片上传区域（支持拖拽和点击上传）
- 上传预览功能
- 识别结果展示区域
- 识别进度指示器
- 重新上传按钮

**交互逻辑：**
1. 用户上传害虫图片（拖拽或点击上传）
2. 前端展示上传预览，并进行基本的图片验证（格式、大小）
3. 用户确认上传，前端显示加载状态
4. 前端调用后端API，发送图片数据
5. 接收识别结果并展示（害虫名称、置信度、基本信息）
6. 提供"查看详情"按钮，显示更多害虫信息
7. 提供"重新识别"按钮，允许用户上传新图片

### 2.3 历史记录页面 (History.vue)

**设计要点：**
- 历史识别记录列表
- 分页功能
- 每条记录包含缩略图、识别结果、时间等信息
- 点击记录可查看详情

**交互逻辑：**
1. 用户进入历史记录页面
2. 前端请求后端API获取历史记录数据
3. 展示历史记录列表，支持分页浏览
4. 用户点击某条记录，跳转到详情页或弹出详情模态框

### 2.4 关于页面 (About.vue)

**设计要点：**
- 系统介绍
- 开发团队信息
- 使用说明
- 联系方式

## 3. 组件设计

### 3.1 ImageUploader.vue

**功能：**
- 图片上传区域组件
- 支持拖拽上传和点击上传
- 图片预览功能
- 基本的图片验证（格式、大小）

**属性：**
- `maxSize`: 最大文件大小
- `acceptTypes`: 接受的图片类型

**事件：**
- `@upload`: 图片上传事件
- `@preview`: 图片预览事件
- `@error`: 上传错误事件

### 3.2 RecognitionResult.vue

**功能：**
- 展示识别结果
- 显示害虫名称、置信度、基本描述
- 提供查看详情按钮

**属性：**
- `result`: 识别结果对象
- `loading`: 加载状态

**事件：**
- `@view-details`: 查看详情事件
- `@retry`: 重新识别事件

### 3.3 PestInfo.vue

**功能：**
- 展示害虫详细信息
- 包含害虫图片、名称、分类、危害、防治方法等

**属性：**
- `pestId`: 害虫ID
- `pestInfo`: 害虫信息对象

## 4. API服务设计

### 4.1 api.js

基础API请求封装，处理请求拦截、响应拦截、错误处理等。

```javascript
// 示例代码
import axios from 'axios';

const baseURL = process.env.VUE_APP_API_BASE_URL;

const api = axios.create({
  baseURL,
  timeout: 30000,
});

// 请求拦截器
api.interceptors.request.use(
  config => {
    // 可添加token等认证信息
    return config;
  },
  error => {
    return Promise.reject(error);
  }
);

// 响应拦截器
api.interceptors.response.use(
  response => {
    return response.data;
  },
  error => {
    // 统一错误处理
    return Promise.reject(error);
  }
);

export default api;
```

### 4.2 recognition.js

识别相关API服务。

```javascript
// 示例代码
import api from './api';

export const recognitionService = {
  // 上传图片并识别
  recognizePest(formData) {
    return api.post('/api/recognition', formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    });
  },
  
  // 获取害虫详情
  getPestInfo(pestId) {
    return api.get(`/api/pests/${pestId}`);
  },
  
  // 获取识别历史
  getHistory(page = 1, size = 10) {
    return api.get('/api/history', {
      params: { page, size }
    });
  }
};
```

## 5. 状态管理设计

### 5.1 Vuex Store 结构

```javascript
// 示例代码
import Vue from 'vue';
import Vuex from 'vuex';
import { recognitionService } from '@/services/recognition';

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    currentImage: null,
    recognitionResult: null,
    recognitionLoading: false,
    recognitionError: null,
    historyRecords: [],
    historyPagination: {
      page: 1,
      size: 10,
      total: 0
    }
  },
  
  mutations: {
    SET_CURRENT_IMAGE(state, image) {
      state.currentImage = image;
    },
    SET_RECOGNITION_RESULT(state, result) {
      state.recognitionResult = result;
    },
    SET_RECOGNITION_LOADING(state, loading) {
      state.recognitionLoading = loading;
    },
    SET_RECOGNITION_ERROR(state, error) {
      state.recognitionError = error;
    },
    SET_HISTORY_RECORDS(state, records) {
      state.historyRecords = records;
    },
    SET_HISTORY_PAGINATION(state, pagination) {
      state.historyPagination = {...state.historyPagination, ...pagination};
    }
  },
  
  actions: {
    // 上传图片并识别
    async recognizePest({ commit }, formData) {
      commit('SET_RECOGNITION_LOADING', true);
      commit('SET_RECOGNITION_ERROR', null);
      
      try {
        const result = await recognitionService.recognizePest(formData);
        commit('SET_RECOGNITION_RESULT', result);
        return result;
      } catch (error) {
        commit('SET_RECOGNITION_ERROR', error.message || '识别失败');
        throw error;
      } finally {
        commit('SET_RECOGNITION_LOADING', false);
      }
    },
    
    // 获取历史记录
    async fetchHistory({ commit, state }) {
      const { page, size } = state.historyPagination;
      
      try {
        const response = await recognitionService.getHistory(page, size);
        commit('SET_HISTORY_RECORDS', response.records);
        commit('SET_HISTORY_PAGINATION', {
          total: response.total
        });
        return response;
      } catch (error) {
        console.error('获取历史记录失败:', error);
        throw error;
      }
    }
  }
});
```

## 6. 路由设计

```javascript
// 示例代码
import Vue from 'vue';
import VueRouter from 'vue-router';
import Home from '@/views/Home.vue';
import Recognition from '@/views/Recognition.vue';
import History from '@/views/History.vue';
import About from '@/views/About.vue';

Vue.use(VueRouter);

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/recognition',
    name: 'Recognition',
    component: Recognition
  },
  {
    path: '/history',
    name: 'History',
    component: History
  },
  {
    path: '/about',
    name: 'About',
    component: About
  }
];

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
});

export default router;
```

## 7. UI设计要点

### 7.1 整体风格

- 简洁现代的设计风格
- 以白色为主色调，搭配绿色或蓝色作为强调色
- 响应式设计，适配桌面和移动设备
- 统一的字体和图标风格

### 7.2 关键页面UI设计

**识别页面布局：**
- 上部：导航栏
- 中部：左侧为图片上传区域，右侧为识别结果展示区域
- 下部：操作按钮（重新上传、查看详情等）

**识别结果展示：**
- 害虫名称（中英文）
- 识别置信度（百分比进度条）
- 害虫简要描述
- 害虫图片（参考图）
- 防治建议摘要

## 8. 前端开发任务清单

1. **项目初始化与配置**
   - 创建Vue项目
   - 配置项目结构
   - 安装必要依赖（Element UI, Axios等）
   - 配置环境变量

2. **公共组件开发**
   - 开发Header组件
   - 开发Footer组件
   - 开发Loading组件

3. **核心功能组件开发**
   - 开发ImageUploader组件
   - 开发RecognitionResult组件
   - 开发PestInfo组件

4. **页面开发**
   - 开发Home页面
   - 开发Recognition页面
   - 开发History页面
   - 开发About页面

5. **API服务与状态管理**
   - 实现API请求封装
   - 实现Vuex状态管理
   - 集成API服务与组件

6. **路由配置**
   - 配置页面路由
   - 实现导航逻辑

7. **样式与UI优化**
   - 实现响应式布局
   - 优化交互动效
   - 统一样式风格

8. **测试与调试**
   - 单元测试
   - 集成测试
   - 兼容性测试

9. **构建与部署准备**
   - 配置生产环境构建
   - 优化打包配置
   - 准备部署文件
