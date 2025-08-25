<template>
  <div class="recognition-result">
    <div v-if="loading" class="loading">
      <div class="spinner"></div>
      <p>正在识别中，请稍候...</p>
    </div>
    
    <div v-else-if="result" class="result-card">
      <h3>识别结果</h3>
      
      <div class="result-info">
        <div class="result-header">
          <span class="pest-name">{{ result.name }}</span>
          <span class="confidence">置信度: {{ formatConfidence(result.confidence) }}%</span>
        </div>
        
        <div class="result-body">
          <div class="pest-image" v-if="result.imageUrl">
            <img :src="result.imageUrl" alt="害虫图片" />
          </div>
          
          <div class="pest-details">
            <p class="description">{{ result.description }}</p>
            
            <div class="pest-meta" v-if="result.meta">
              <div class="meta-item" v-if="result.meta.family">
                <span class="label">科属:</span>
                <span class="value">{{ result.meta.family }}</span>
              </div>
              <div class="meta-item" v-if="result.meta.habitat">
                <span class="label">栖息地:</span>
                <span class="value">{{ result.meta.habitat }}</span>
              </div>
              <div class="meta-item" v-if="result.meta.harmfulTo">
                <span class="label">危害作物:</span>
                <span class="value">{{ result.meta.harmfulTo }}</span>
              </div>
            </div>
          </div>
        </div>
        
        <div class="prevention-methods" v-if="result.preventionMethods && result.preventionMethods.length">
          <h4>防治方法</h4>
          <ul>
            <li v-for="(method, index) in result.preventionMethods" :key="index">
              {{ method }}
            </li>
          </ul>
        </div>
      </div>
      
      <div class="result-actions">
        <button class="action-btn" @click="$emit('save-result', result)">保存结果</button>
        <button class="action-btn" @click="$emit('new-recognition')">新的识别</button>
      </div>
    </div>
    
    <div v-else-if="error" class="error-message">
      <i class="el-icon-warning"></i>
      <p>{{ error }}</p>
      <button class="retry-btn" @click="$emit('retry')">重试</button>
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
    },
    error: {
      type: String,
      default: ''
    }
  },
  methods: {
    formatConfidence(value) {
      if (typeof value !== 'number') return '0.00';
      return value.toFixed(2);
    }
  }
}
</script>

<style scoped>
.recognition-result {
  width: 100%;
}

.loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40px 0;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid rgba(0, 0, 0, 0.1);
  border-radius: 50%;
  border-top-color: #409EFF;
  animation: spin 1s ease-in-out infinite;
  margin-bottom: 15px;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.result-card {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  padding: 20px;
}

.result-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 1px solid #ebeef5;
}

.pest-name {
  font-size: 1.2rem;
  font-weight: 500;
  color: #303133;
}

.confidence {
  background-color: #f0f9eb;
  color: #67c23a;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 0.9rem;
}

.result-body {
  display: flex;
  margin-bottom: 20px;
}

.pest-image {
  width: 120px;
  height: 120px;
  margin-right: 20px;
  border-radius: 4px;
  overflow: hidden;
}

.pest-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.pest-details {
  flex: 1;
}

.description {
  margin-bottom: 15px;
  line-height: 1.6;
}

.pest-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.meta-item {
  background-color: #f5f7fa;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 0.9rem;
}

.label {
  color: #909399;
  margin-right: 5px;
}

.prevention-methods {
  margin-top: 20px;
}

.prevention-methods h4 {
  margin-bottom: 10px;
}

.prevention-methods ul {
  padding-left: 20px;
}

.prevention-methods li {
  margin-bottom: 5px;
}

.result-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 20px;
}

.action-btn {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  background-color: #409EFF;
  color: white;
  cursor: pointer;
}

.error-message {
  text-align: center;
  padding: 30px;
  color: #f56c6c;
}

.retry-btn {
  margin-top: 15px;
  padding: 6px 15px;
  background-color: #f56c6c;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

@media (max-width: 768px) {
  .result-body {
    flex-direction: column;
  }
  
  .pest-image {
    width: 100%;
    height: auto;
    margin-right: 0;
    margin-bottom: 15px;
  }
}
</style>