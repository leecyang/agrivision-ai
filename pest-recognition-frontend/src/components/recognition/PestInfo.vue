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