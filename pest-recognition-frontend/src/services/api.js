// API服务封装
import axios from 'axios';
import NProgress from 'nprogress';
import { ElMessage } from 'element-plus';

// 添加/api前缀到baseURL
const baseURL = process.env.VUE_APP_API_BASE_URL || 'http://localhost:8081';

const api = axios.create({
  baseURL,
  timeout: 30000,
});

// 请求拦截器
api.interceptors.request.use(
  config => {
    // 显示加载进度条
    NProgress.start();
    // 可添加token等认证信息
    // const token = localStorage.getItem('token');
    // if (token) {
    //   config.headers.Authorization = `Bearer ${token}`;
    // }
    return config;
  },
  error => {
    NProgress.done();
    ElMessage.error('请求发送失败');
    return Promise.reject(error);
  }
);

// 响应拦截器
api.interceptors.response.use(
  response => {
    NProgress.done();
    // 根据后端返回的code或status判断业务状态
    if (response.data && response.data.code !== 200) {
      ElMessage.error(response.data.message || '请求失败');
      return Promise.reject(new Error(response.data.message || '请求失败'));
    }
    return response.data.data; // 返回实际的数据部分
  },
  error => {
    NProgress.done();
    let message = '请求失败';
    if (error.response) {
      // 请求已发出，但服务器响应的状态码不在 2xx 范围内
      message = error.response.data.message || error.response.statusText || '服务器错误';
      if (error.response.status === 401) {
        // 处理认证失败，例如跳转到登录页
        // router.push('/login');
        message = '认证失败，请重新登录';
      }
    } else if (error.request) {
      // 请求已发出，但没有收到响应
      message = '服务器无响应';
    } else {
      // 在设置请求时发生了一些事情，触发了错误
      message = error.message || '请求配置错误';
    }
    ElMessage.error(message);
    return Promise.reject(error);
  }
);

// 害虫识别相关API
export const pestApi = {
  // 上传图片进行识别
  recognizePest(imageFile) {
    const formData = new FormData();
    formData.append('image', imageFile);
    
    return api.post('/recognition/upload', formData, { // 修改此处路径
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    });
  },
  
  // 获取识别历史记录
  getHistory(page = 1, size = 10) {
    return api.get('/recognition/history', { // 修改此处路径
      params: { page, size }
    });
  },
  
  // 获取害虫详细信息
  getPestInfo(pestId) {
    return api.get(`/pests/${pestId}`);
  },
  
  // 获取常见害虫列表
  getCommonPests: () => api.get('/pests/common'),

  // 开始识别任务
  startRecognition(taskId) {
    return api.post('/recognition/start', { taskId });
  },

  // 获取识别任务状态
  getRecognitionStatus(taskId) {
    return api.get(`/recognition/status/${taskId}`);
  },

  // 获取识别结果
  getRecognitionResult(taskId) {
    return api.get(`/recognition/result/${taskId}`);
  }
};

export default {
  pest: pestApi
};