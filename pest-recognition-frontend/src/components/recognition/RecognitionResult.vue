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
            :value="result.harmLevel"
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
      <el-icon><Warning /></el-icon>
      <p>暂无识别结果，请上传害虫图片</p>
    </div>
  </div>
</template>

<script>
import { Warning } from '@element-plus/icons-vue';

export default {
  name: 'RecognitionResult',
  components: {
    Warning
  },
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