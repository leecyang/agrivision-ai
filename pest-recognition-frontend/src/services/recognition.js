import api from '@/services/api';

export const recognitionService = {
  /**
   * 上传图片并识别害虫
   * @param {File} imageFile - 用户上传的图片文件
   * @returns {Promise<Object>} - 识别结果数据
   */
  recognizePest(imageFile) {
    return api.pest.recognizePest(imageFile);
  },
  
  /**
   * 获取害虫详细信息
   * @param {string|number} pestId - 害虫ID
   * @returns {Promise<Object>} - 害虫详细信息数据
   */
  getPestInfo(pestId) {
    return api.pest.getPestInfo(pestId);
  },
  
  /**
   * 获取识别历史记录
   * @param {number} [page=1] - 页码
   * @param {number} [size=10] - 每页数量
   * @returns {Promise<Object>} - 历史记录数据，包含记录列表和总数
   */
  getHistory(page = 1, size = 10) {
    return api.pest.getHistory(page, size);
  },

  /**
   * 获取常见害虫列表
   * @returns {Promise<Array<Object>>} - 常见害虫列表数据
   */
  getCommonPests() {
    return api.pest.getCommonPests();
  },

  /**
   * 开始识别任务
   * @param {string} taskId - 任务ID
   * @returns {Promise<Object>} - 任务启动结果
   */
  startRecognition(taskId) {
    return api.pest.startRecognition(taskId);
  },

  /**
   * 获取识别任务状态
   * @param {string} taskId - 任务ID
   * @returns {Promise<Object>} - 任务状态信息
   */
  getRecognitionStatus(taskId) {
    return api.pest.getRecognitionStatus(taskId);
  },

  /**
   * 获取识别结果
   * @param {string} taskId - 任务ID
   * @returns {Promise<Object>} - 识别结果数据
   */
  getRecognitionResult(taskId) {
    return api.pest.getRecognitionResult(taskId);
  }
};