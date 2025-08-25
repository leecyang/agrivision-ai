<template>
  <div class="recognition">
    <h2>害虫识别</h2>
    <div class="recognition-layout">
      <div class="left-panel">
        <div class="upload-container">
          <div class="uploader">
            <div v-if="!imageUrl" class="upload-box" :class="{ 'is-loading': loading }">
              <input type="file" @change="handleFileChange" accept="image/*" id="file-input" class="file-input" />
              <label for="file-input" class="upload-label">
                <el-icon class="upload-icon"><upload-filled /></el-icon>
                <div class="upload-text">点击上传图片或拖拽图片到此处</div>
              </label>
            </div>
            <div v-else class="preview">
              <img :src="imageUrl" alt="预览图" />
              <div class="button-group">
                <el-button 
                  type="primary" 
                  @click="submitImage" 
                  :loading="loading" 
                  class="submit-btn"
                >
                  {{ loading ? '正在识别中...' : '开始识别' }}
                </el-button>
                <el-button 
                  type="info" 
                  @click="handleReupload" 
                  class="reupload-btn"
                >
                  重新上传
                </el-button>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="right-panel">
        <div v-if="recognitionResult || loading" class="result">
          <h3>识别结果</h3>
          <div v-if="loading" class="loading-container">
            <el-progress type="circle" :percentage="0" status="exception">
              <template #default>
                <span class="progress-text">识别中...</span>
              </template>
            </el-progress>
          </div>
          <div v-else class="result-content">
            <el-card class="pest-result-card">
              <template #header>
                <div class="card-header">
                  <span>识别到的害虫</span>
                </div>
              </template>
              <div class="pest-info">
                <div class="info-item">
                  <span class="label">害虫名称:</span>
                  <span class="value">{{ recognitionResult.name }}</span>
                </div>
                <div class="info-item">
                  <span class="label">置信度:</span>
                  <div class="value confidence-value">
                    <el-progress 
                      :percentage="Number(recognitionResult.confidence)" 
                      :status="getConfidenceStatus(recognitionResult.confidence)"
                      :text-inside="true"
                      :stroke-width="20"
                    />
                    <span class="confidence-text">{{ recognitionResult.confidence.toFixed(2) }}%</span>
                  </div>
                </div>
                <div class="info-item">
                  <span class="label">描述:</span>
                  <span class="value">{{ recognitionResult.description }}</span>
                </div>
              </div>
            </el-card>
          </div>
        </div>
        <div v-else class="result-placeholder">
          <h3>识别结果</h3>
          <p>请在左侧上传图片，然后点击"开始识别"按钮。</p>
        </div>
      </div>
    </div>
    <!-- 识别提示 --> 
    <div class="recognition-tips">
      <h3>识别提示</h3>
      <ul>
        <li>拍摄时请确保害虫在图片中清晰可见</li>
        <li>尽量在光线充足的环境下拍摄</li>
        <li>避免过度模糊或过度曝光的图片</li>
        <li>如果一次识别不准确，可以尝试不同角度的图片</li>
      </ul>
    </div>
  </div>
</template>

<script>
import { UploadFilled } from '@element-plus/icons-vue';

export default {
  name: 'PestRecognition',
  components: {
    UploadFilled
  },
  data() {
    return {
      imageUrl: '',
      imageFile: null,
      recognitionResult: null,
      loading: false,
      errorMessage: null
    };
  },
  methods: {
    getConfidenceStatus(confidence) {
      const conf = Number(confidence);
      if (conf >= 90) return 'success';
      if (conf >= 70) return '';
      if (conf >= 50) return 'warning';
      return 'exception';
    },
    handleFileChange(e) {
      const file = e.target.files[0];
      if (!file) {
        return;
      }
      this.imageFile = file;
      this.imageUrl = URL.createObjectURL(file);
      this.recognitionResult = null;
    },
    handleReupload() {
      this.imageUrl = '';
      this.imageFile = null;
      this.recognitionResult = null;
      this.loading = false;
      this.errorMessage = null;
      // Optionally reset the file input to allow selecting the same file again
      const fileInput = document.getElementById('file-input');
      if (fileInput) {
        fileInput.value = '';
      }
    },
    async submitImage() {
      console.log('submitImage method called');
      if (!this.imageFile) {
        console.log('No image file selected.');
        this.$message.warning('请先选择要识别的图片');
        return;
      }
      console.log('Image file selected, proceeding with recognition.');
      this.loading = true;
      this.recognitionResult = null; // 清除之前的结果
      this.errorMessage = null; // 清除之前的错误
      try {
        console.log('Dispatching recognizePest action...');
        // 直接上传图片并获取识别结果 (api.js 已经处理了错误和返回数据结构)
        const resultData = await this.$store.dispatch('recognizePest', this.imageFile);
        console.log('recognizePest result data:', resultData);
        
        // 使用从后端获取的数据更新识别结果
        this.recognitionResult = {
            name: resultData.pestName,
            confidence: resultData.confidence * 100, // 将置信度转换为百分比
            description: resultData.description
        };
        this.loading = false;
      } catch (error) {
        console.error('Recognition process failed:', error);
        this.$message.error(error.message || '识别失败，请重试');
        this.errorMessage = error.message || '识别失败，请重试';
        this.loading = false; // 确保在出错时也设置 loading 为 false
      }
    }
  }
}
</script>

<style scoped>
.recognition {
  padding: 20px;
  background-color: #f8f8f8; /* Subtle background */
  min-height: calc(100vh - 120px); /* Adjust based on header/footer height */
}

h2 {
  text-align: center;
  color: #333;
  margin-bottom: 30px;
}

.recognition-layout {
  display: flex;
  gap: 40px; /* Adjust gap as needed */
  margin-top: 20px;
}

.left-panel, .right-panel {
  flex: 1;
  min-width: 300px; /* Ensure minimum width */
  background-color: #fff;
  padding: 25px;
  border-radius: 8px;
  /* box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08); */ /* Remove box-shadow */
}

.upload-container {
  display: flex;
  justify-content: center; /* Center uploader content */
  align-items: center;
  flex-direction: column;
}

.uploader {
  width: 100%; /* Uploader takes full width of its panel */
  text-align: center;
}

.upload-box {
  border: 2px dashed #dcdfe6;
  border-radius: 8px; /* Slightly larger border radius */
  padding: 40px 20px;
  text-align: center;
  cursor: pointer;
  transition: border-color 0.3s, box-shadow 0.3s; /* Add box-shadow transition */
  background-color: #fafafa; /* Light background for upload box */
}

.upload-box:hover {
  border-color: #409EFF;
  box-shadow: 0 0 10px rgba(64, 158, 255, 0.2); /* Subtle hover shadow */
}

.file-input {
  display: none;
}

.upload-label {
  display: block;
  cursor: pointer;
  color: #606266;
}

.upload-icon {
  font-size: 40px; /* Larger icon */
  color: #c0c4cc; /* Lighter icon color */
  margin-bottom: 15px; /* More space below icon */
}

.upload-text {
  margin-top: 0; /* Remove margin-top */
  font-size: 1.1em; /* Slightly larger text */
}

.preview {
  margin-top: 20px;
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.preview img {
  max-width: 100%;
  max-height: 300px; /* Limit image height */
  object-fit: contain;
  border-radius: 6px;
  margin-bottom: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.button-group {
  display: flex;
  gap: 15px; /* Space between buttons */
  margin-top: 10px;
}

.submit-btn,
.reupload-btn {
  width: 120px; /* Fixed width for consistency */
  font-size: 16px;
  padding: 10px 0;
}

.submit-btn {
  background-color: #409eff; /* El-button primary color */
  border-color: #409eff;
}

.reupload-btn {
  background-color: #909399; /* El-button info color */
  border-color: #909399;
}

.reupload-btn:hover,
.reupload-btn:focus {
  background-color: #a6a9ad; /* Darker hover for info button */
  border-color: #a6a9ad;
}

.result {
  padding: 20px;
  /* border-radius: 8px; */ /* Remove border-radius */
  /* box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1); */ /* Remove box-shadow */
  background-color: #fff; /* Ensure white background */
}

.result h3 {
  margin-top: 0;
  color: #303133;
  font-size: 1.2em; /* Slightly larger heading */
  margin-bottom: 20px; /* More space below heading */
  border-bottom: 1px solid #eee; /* Add a separator */
  padding-bottom: 10px;
}

.loading-container {
  text-align: center;
  margin-top: 30px; /* More space above loading */
  min-height: 200px; /* Ensure loading container has height */
  display: flex;
  justify-content: center;
  align-items: center;
}

.progress-text {
  font-size: 16px; /* Larger progress text */
  color: #606266;
}

.result-content {
  margin-top: 20px;
}

.pest-result-card {
  width: 100%;
  max-width: 600px; /* Limit card width for better readability */
  margin: 0 auto; /* Center the card */
}

.card-header {
  font-size: 1.1em;
  font-weight: bold;
  color: #303133;
}

.pest-info {
  display: flex;
  flex-direction: column;
  gap: 15px; /* Space between info items */
}

.info-item {
  display: flex;
  align-items: center; /* Align items vertically */
}

.info-item .label {
  font-weight: bold;
  color: #606266;
  margin-right: 10px; /* Space between label and value */
  min-width: 80px; /* Ensure labels have minimum width */
}

.info-item .value {
  flex-grow: 1; /* Allow value to take remaining space */
  color: #303133;
}

.confidence-value {
  display: flex;
  align-items: center;
  gap: 10px; /* Space between progress bar and text */
}

.confidence-value .el-progress {
  flex-grow: 1; /* Allow progress bar to take space */
  max-width: 200px; /* Limit progress bar width */
}

.confidence-text {
  font-weight: bold;
  color: #303133;
}

.result-placeholder {
  padding: 20px;
  /* border-radius: 8px; */ /* Remove border-radius */
  /* box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1); */ /* Remove box-shadow */
  text-align: center;
  color: #606266;
  background-color: #fff; /* Ensure white background */
  min-height: 300px; /* Give placeholder some height */
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.result-placeholder h3 {
  margin-top: 0;
  color: #303133;
  font-size: 1.2em; /* Consistent heading size */
  margin-bottom: 15px;
}

.recognition-tips {
  margin-top: 30px; /* Space above the tips section */
  padding: 20px;
  border: 1px solid #ebeef5;
  border-radius: 8px; /* Consistent border radius */
  background-color: #fff; /* White background for tips */
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05); /* Subtle shadow for tips */
}

.recognition-tips h3 {
  margin-top: 0;
  color: #303133;
  font-size: 1.1em;
  margin-bottom: 15px;
  border-bottom: 1px solid #eee; /* Add a separator */
  padding-bottom: 10px;
}

.recognition-tips ul {
  padding-left: 20px;
  margin: 0;
}

.recognition-tips li {
  margin-bottom: 10px;
  color: #606266;
  line-height: 1.6;
}

@media (max-width: 768px) {
  .recognition-layout {
    flex-direction: column;
    gap: 20px;
  }

  .left-panel, .right-panel {
    min-width: auto;
    padding: 15px; /* Adjust padding for smaller screens */
  }

  .upload-box {
    padding: 30px 15px; /* Adjust padding for smaller screens */
  }

  .preview img {
    max-height: 250px; /* Adjust max height for smaller screens */
  }

  .result-placeholder {
    min-height: 200px; /* Adjust placeholder height for smaller screens */
  }

  .pest-result-card {
    max-width: 100%; /* Allow card to take full width on small screens */
  }

  .info-item {
    flex-direction: column; /* Stack label and value on small screens */
    align-items: flex-start; /* Align items to the start */
  }

  .info-item .label {
    margin-right: 0;
    margin-bottom: 5px; /* Add space below label */
  }

  .confidence-value {
    flex-direction: column; /* Stack progress bar and text */
    align-items: flex-start;
    gap: 5px;
  }

  .confidence-value .el-progress {
    max-width: 100%; /* Allow progress bar to take full width */
  }
}
</style>