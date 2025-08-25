import { createStore } from 'vuex';
import history from './modules/history';
import commonPests from './modules/commonPests'; // Import the new module
import { recognitionService } from '@/services/recognition'; // Keep recognitionService for global actions if needed



export default createStore({
  state: {
    // 当前上传的图片
    currentImage: null,
    // 识别结果
    recognitionResult: null,
    // 识别加载状态
    recognitionLoading: false,
    // 识别错误信息
    recognitionError: null,
    // commonPests state is now in the module
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
    // SET_COMMON_PESTS mutation is now in the module
  },
  
  actions: {
    // 设置当前图片
    setCurrentImage({ commit }, image) {
      commit('SET_CURRENT_IMAGE', image);
    },
    
    // 上传图片并识别
    async recognizePest({ commit }, imageFile) {
      commit('SET_RECOGNITION_LOADING', true);
      commit('SET_RECOGNITION_ERROR', null);
      
      try {
        const result = await recognitionService.recognizePest(imageFile);
        // 确保在成功时更新识别结果状态
        commit('SET_RECOGNITION_RESULT', result);
        return result;
      } catch (error) {
        const errorMsg = error.response?.data?.message || '识别失败，请重试';
        commit('SET_RECOGNITION_ERROR', errorMsg);
        throw error;
      } finally {
        commit('SET_RECOGNITION_LOADING', false);
      }
    },

    // 开始识别任务
    async startRecognition({ commit }, taskId) {
      try {
        const result = await recognitionService.startRecognition(taskId);
        return result;
      } catch (error) {
        const errorMsg = error.response?.data?.message || '启动识别任务失败';
        commit('SET_RECOGNITION_ERROR', errorMsg);
        throw error;
      }
    },

    // 获取识别任务状态
    async getRecognitionStatus({ commit }, taskId) {
      try {
        const result = await recognitionService.getRecognitionStatus(taskId);
        return result;
      } catch (error) {
        const errorMsg = error.response?.data?.message || '获取识别状态失败';
        commit('SET_RECOGNITION_ERROR', errorMsg);
        throw error;
      }
    },

    // 获取识别结果
    async getRecognitionResult({ commit }, taskId) {
      try {
        const result = await recognitionService.getRecognitionResult(taskId);
        commit('SET_RECOGNITION_RESULT', result);
        return result;
      } catch (error) {
        const errorMsg = error.response?.data?.message || '获取识别结果失败';
        commit('SET_RECOGNITION_ERROR', errorMsg);
        throw error;
      }
    },
    
    // 清除识别结果
    clearRecognitionResult({ commit }) {
      commit('SET_RECOGNITION_RESULT', null);
      commit('SET_RECOGNITION_ERROR', null);
    }
  },
  
  getters: {
    // 是否有识别结果
    hasRecognitionResult: state => !!state.recognitionResult,
    // 是否正在识别中
    isRecognizing: state => state.recognitionLoading,
    // 获取识别错误信息
    recognitionError: state => state.recognitionError,
    // commonPests getters are now in the module
  },
  modules: {
    history,
    commonPests, // Register the new module
    // other modules
  }
});