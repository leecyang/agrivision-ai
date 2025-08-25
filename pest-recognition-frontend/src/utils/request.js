import axios from 'axios';
import { ElMessage } from 'element-plus';
import NProgress from 'nprogress';
import 'nprogress/nprogress.css';

// NProgress配置
NProgress.configure({ showSpinner: false });

// 创建axios实例
const service = axios.create({
  baseURL: process.env.VUE_APP_API_BASE_URL || '/api',
  timeout: 30000 // 请求超时时间
});

// 请求拦截器
service.interceptors.request.use(
  config => {
    // 开始进度条
    NProgress.start();
    
    // 可以在这里添加认证信息，例如token
    // const token = localStorage.getItem('token');
    // if (token) {
    //   config.headers['Authorization'] = `Bearer ${token}`;
    // }
    
    return config;
  },
  error => {
    // 请求错误处理
    NProgress.done();
    console.error('请求错误:', error);
    return Promise.reject(error);
  }
);

// 响应拦截器
service.interceptors.response.use(
  response => {
    // 结束进度条
    NProgress.done();
    
    // 如果后端返回的数据有统一的格式，可以在这里处理
    const res = response.data;
    
    // 假设后端返回的数据格式为 { code: 200, data: xxx, message: 'success' }
    if (res.code && res.code !== 200) {
      ElMessage({
        message: res.message || '请求失败',
        type: 'error',
        duration: 5 * 1000
      });
      
      // 特定错误码处理，例如未授权或token过期
      if (res.code === 401 || res.code === 403) {
        // 可以在这里处理登出逻辑
        // store.dispatch('user/logout');
      }
      
      return Promise.reject(new Error(res.message || '请求失败'));
    } else {
      // 如果后端返回的是标准格式，直接返回data部分
      return res.data !== undefined ? res.data : res;
    }
  },
  error => {
    // 结束进度条
    NProgress.done();
    
    // 处理HTTP错误状态
    let message = '请求失败';
    if (error.response) {
      const status = error.response.status;
      switch (status) {
        case 400:
          message = '请求错误';
          break;
        case 401:
          message = '未授权，请登录';
          // 可以在这里处理登出逻辑
          // store.dispatch('user/logout');
          break;
        case 403:
          message = '拒绝访问';
          break;
        case 404:
          message = '请求地址出错';
          break;
        case 408:
          message = '请求超时';
          break;
        case 500:
          message = '服务器内部错误';
          break;
        case 501:
          message = '服务未实现';
          break;
        case 502:
          message = '网关错误';
          break;
        case 503:
          message = '服务不可用';
          break;
        case 504:
          message = '网关超时';
          break;
        case 505:
          message = 'HTTP版本不受支持';
          break;
        default:
          message = `未知错误(${status})`;
      }
    } else if (error.request) {
      message = '网络异常，服务器未响应';
    } else {
      message = error.message;
    }
    
    ElMessage({
      message,
      type: 'error',
      duration: 5 * 1000
    });
    
    return Promise.reject(error);
  }
);

export default service;