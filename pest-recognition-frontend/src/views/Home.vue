<template>
  <div class="home-container">
    <!-- 欢迎区域 -->
    <section class="welcome-section">
      <div class="welcome-content">
        <h1>欢迎使用害虫识别系统</h1>
        <p class="subtitle">快速、准确地识别农作物害虫，获取防治建议</p>
        <div class="action-buttons">
          <router-link to="/recognition" class="btn primary-btn">开始识别</router-link>
          <router-link to="/about" class="btn">了解更多</router-link>
        </div>
      </div>
      <div class="welcome-image">
        <img src="@/assets/logo.svg" alt="害虫识别系统" />
      </div>
    </section>

    <!-- 功能特点 -->
    <section class="features-section">
      <h2>系统特点</h2>
      <div class="features">
        <div class="feature">
          <div class="feature-icon">
            <i class="el-icon-view"></i>
          </div>
          <h3>快速识别</h3>
          <p>上传害虫图片，系统秒级识别害虫种类</p>
        </div>
        <div class="feature">
          <div class="feature-icon">
            <i class="el-icon-data-analysis"></i>
          </div>
          <h3>精准分析</h3>
          <p>基于深度学习模型，识别准确率高达95%以上</p>
        </div>
        <div class="feature">
          <div class="feature-icon">
            <i class="el-icon-document"></i>
          </div>
          <h3>防治建议</h3>
          <p>提供专业的害虫防治方法和建议</p>
        </div>
        <div class="feature">
          <div class="feature-icon">
            <i class="el-icon-time"></i>
          </div>
          <h3>历史记录</h3>
          <p>保存识别历史，方便随时查看和对比</p>
          <router-link to="/history" class="feature-link">查看历史</router-link>
        </div>
      </div>
    </section>

    <!-- 常见害虫 -->
    <section class="common-pests-section" v-if="commonPests.length > 0">
      <h2>常见害虫</h2>
      <div class="expand-toggle-container">
        <el-alert
          title="以下内容可能引起不适"
          type="warning"
          :closable="false"
          show-icon
          class="discomfort-alert"
        />
        <el-button 
          @click="showPests = !showPests"
          type="primary"
          plain
          round
          class="expand-toggle-btn"
        >
          {{ showPests ? '收起全部' : '展开全部' }}
        </el-button>
      </div>
      <div v-if="showPests" class="pest-list" v-loading="loading">
        <div 
          v-for="pest in filteredCommonPests" 
          :key="pest.id" 
          class="pest-card pest-card-hoverable"
          @click="toggleDetail(pest.id)"
          :style="{ cursor: 'pointer', boxShadow: activePest === pest.id ? '0 0 0 2px #409EFF' : '' }"
        >
          <div class="pest-image">
            <img :src="pest.imageUrl" :alt="pest.name" />
          </div>
          <p class="pest-name">{{ pest.nameZh }}</p>
          <div class="pest-info">
            <p class="pest-desc">{{ pest.shortDescription }}</p>
          </div>
          <transition name="fade">
            <div v-if="activePest === pest.id" class="pest-detail-expand">
              <p v-if="pest.description"><strong>详细描述：</strong>{{ pest.description }}</p>
              <p v-if="pest.hosts"><strong>寄主：</strong>{{ pest.hosts }}</p>
              <p v-if="pest.distribution"><strong>分布：</strong>{{ pest.distribution }}</p>
              <p v-if="pest.controlMethods"><strong>防治方法：</strong>{{ pest.controlMethods }}</p>
              <el-button type="primary" size="small" @click.stop="goToPestDetail(pest.id)">查看详情</el-button>
            </div>
          </transition>
        </div>
      </div>
    </section>

    <!-- 使用指南 -->
    <section class="guide-section">
      <h2>使用指南</h2>
      <el-steps :active="1" simple>
        <el-step title="上传图片">
          <template #icon><el-icon><Upload /></el-icon></template>
        </el-step>
        <el-step title="等待识别">
          <template #icon><el-icon><Loading /></el-icon></template>
        </el-step>
        <el-step title="查看结果">
          <template #icon><el-icon><Document /></el-icon></template>
        </el-step>
        <el-step title="保存记录">
          <template #icon><el-icon><Check /></el-icon></template>
        </el-step>
      </el-steps>
    </section>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex';
import { Upload, Loading, Document, Check } from '@element-plus/icons-vue';
import { ElAlert } from 'element-plus';

export default {
  name: 'HomePage',
  components: {
    Upload,
    Loading,
    Document,
    Check,
    ElAlert
  },
  data() {
    return {
      activePest: '', // 当前展开的害虫id
      showPests: false, // 是否显示所有害虫卡片,
    };
  },
  computed: {
    ...mapState('commonPests', [
      'commonPests',
      'loading' // Map the loading state from the module
    ]),
    filteredCommonPests() {
      return this.commonPests.filter(pest => pest.id !== 0);
    }
  },
  created() {
    // Fetch common pests when the component is created
    this.fetchCommonPests();
  },
  methods: {
    ...mapActions('commonPests', [ // Map actions from the namespaced module
      'fetchCommonPests' // Use the action name from the module
    ]),
    // fetchCommonPests method is now mapped from Vuex actions
    // async fetchCommonPests() {
    //   this.loading = true;
    //   try {
    //     await this.getCommonPests();
    //   } catch (error) {
    //     console.error('获取常见害虫列表失败:', error);
    //     this.$message.error('获取常见害虫列表失败');
    //   } finally {
    //     this.loading = false;
    //   } 
    // },

    goToPestDetail(pestId) {
      this.$router.push(`/pest/${pestId}`);
    },
    toggleDetail(pestId) {
      this.activePest = this.activePest === pestId ? '' : pestId;
    }
  }
};
</script>

<style scoped>
.home-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

/* 欢迎区域样式 */
.welcome-section {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 60px;
  min-height: 400px;
}

.expand-toggle-container {
  text-align: right;
  margin-bottom: 20px;
}

.expand-toggle-btn {
  font-size: 1.1em;
  font-weight: 500;
  color: #409EFF; /* Element UI Primary color */
}

.expand-toggle-btn:hover {
  color: #66b1ff;
}

.expand-toggle-btn i {
  margin-right: 5px;
}

.welcome-content {
  flex: 1;
  padding-right: 40px;
}

.welcome-content h1 {
  font-size: 2.5rem;
  margin-bottom: 20px;
  color: #2c3e50;
}

.subtitle {
  font-size: 1.2rem;
  color: #606266;
  margin-bottom: 30px;
}

.action-buttons {
  display: flex;
  gap: 15px;
}

.btn {
  display: inline-block;
  padding: 10px 24px;
  border-radius: 4px;
  text-decoration: none;
  font-weight: bold;
  transition: all 0.3s ease;
}

.primary-btn {
  background-color: #409EFF;
  color: white;
}

.primary-btn:hover {
  background-color: #66b1ff;
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.3);
}

.btn:not(.primary-btn) {
  border: 1px solid #dcdfe6;
  color: #606266;
}

.btn:not(.primary-btn):hover {
  color: #409EFF;
  border-color: #c6e2ff;
  background-color: #ecf5ff;
}

.welcome-image {
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: center;
}

.welcome-image img {
  max-width: 100%;
  max-height: 300px;
}

/* 功能特点样式 */
.features-section {
  margin-bottom: 60px;
}

.features-section h2,
.common-pests-section h2,
.guide-section h2 {
  text-align: center;
  font-size: 1.8rem;
  margin-bottom: 40px;
  color: #2c3e50;
}

.features {
  display: flex;
  justify-content: space-around;
  flex-wrap: wrap;
  margin-top: 30px;
}

.feature {
  width: 250px;
  padding: 25px;
  margin: 10px;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  text-align: center;
  transition: transform 0.3s, box-shadow 0.3s;
}

.feature:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
}

.feature-icon {
  font-size: 2.5rem;
  color: #409EFF;
  margin-bottom: 20px;
}

.feature h3 {
  font-size: 1.2rem;
  margin-bottom: 15px;
  color: #2c3e50;
}

.feature p {
  color: #606266;
  margin-bottom: 15px;
}

.feature-link {
  color: #409EFF;
  text-decoration: none;
  font-weight: bold;
  display: inline-block;
  margin-top: 10px;
}

.feature-link:hover {
  text-decoration: underline;
}

/* 常见害虫样式 */
.common-pests-section {
  margin-bottom: 60px;
}

.pest-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 30px;
}

.pest-card {
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s, box-shadow 0.3s;
  cursor: pointer;
}

.pest-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
}

.pest-image {
  height: 180px;
  overflow: hidden;
}

.pest-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s;
}

.pest-card:hover .pest-image img {
  transform: scale(1.05);
}

.pest-info {
  padding: 15px;
}

.pest-info h3 {
  font-size: 1.1rem;
  margin-bottom: 10px;
  color: #2c3e50;
}

.pest-danger {
  font-size: 0.9rem;
  margin-bottom: 10px;
  font-weight: bold;
}

.danger-level-1 {
  color: #67C23A; /* 低 - 绿色 */
}

.danger-level-2 {
  color: #E6A23C; /* 中 - 黄色 */
}

.danger-level-3 {
  color: #F56C6C; /* 高 - 红色 */
}

.danger-level-4 {
  color: #F56C6C;
  font-weight: bold; /* 极高 - 加粗红色 */
}

.pest-desc {
  font-size: 0.9rem;
  color: #606266;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* 使用指南样式 */
.guide-section {
  padding: 40px;
  background: #f8f9fa;
  border-radius: 12px;
  margin: 40px 0;
}

.guide-section h2 {
  text-align: center;
  margin-bottom: 30px;
  color: #2c3e50;
  font-size: 1.8rem;
}

:deep(.el-steps) {
  background: white;
  padding: 30px;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
  width: 100%;
  max-width: 100%;
}

:deep(.el-step) {
  flex: 1;
}

:deep(.el-step__title) {
  font-size: 1.1rem;
  font-weight: 600;
  color: #606266;
}

:deep(.el-step__title.is-process) {
  color: #409eff;
}

:deep(.el-step__title.is-success) {
  color: #67c23a;
}

:deep(.el-step__icon-inner) {
  font-size: 20px;
}

:deep(.el-step__line) {
  background-color: #e4e7ed;
}

:deep(.el-step.is-simple) {
  background: transparent;
}

:deep(.el-step__head.is-process) {
  color: #409eff;
  border-color: #409eff;
}

:deep(.el-step__head.is-success) {
  color: #67c23a;
  border-color: #67c23a;
}

@media (max-width: 768px) {
  .home-container {
    padding: 15px;
  }

  .welcome-section {
    flex-direction: column;
    text-align: center;
    min-height: auto;
    margin-bottom: 40px;
  }

  .welcome-content {
    padding-right: 0;
    margin-bottom: 30px;
  }

  .welcome-content h1 {
    font-size: 2rem;
  }

  .subtitle {
    font-size: 1rem;
  }

  .action-buttons {
    justify-content: center;
  }

  .welcome-image img {
    max-height: 200px;
  }

  .features {
    flex-direction: column;
    align-items: center;
  }

  .feature {
    width: 100%;
    max-width: 320px;
    margin: 10px 0;
  }

  .pest-list {
    grid-template-columns: 1fr;
    gap: 20px;
  }

  .pest-card {
    max-width: 400px;
    margin: 0 auto;
  }

  .guide-section {
    padding: 20px 15px;
    margin: 30px 0;
  }

  .guide-section h2 {
    font-size: 1.5rem;
    margin-bottom: 20px;
  }

  :deep(.el-steps) {
    padding: 15px 10px;
  }

  :deep(.el-step__title) {
    font-size: 0.9rem;
    margin-top: 8px;
  }

  :deep(.el-step__icon-inner) {
    font-size: 18px;
  }

  :deep(.el-step__line) {
    top: 15px;
    height: 1px;
  }
}

@media (max-width: 480px) {
  .welcome-content h1 {
    font-size: 1.8rem;
  }

  .btn {
    padding: 8px 16px;
    font-size: 0.9rem;
  }

  .feature-icon {
    font-size: 2rem;
  }

  .feature h3 {
    font-size: 1.1rem;
  }

  .pest-image {
    height: 150px;
  }

  :deep(.el-step__title) {
    font-size: 0.8rem;
  }

  :deep(.el-step__icon-inner) {
    font-size: 16px;
  }
}

.fade-enter-active, .fade-leave-active {
  transition: all 0.3s;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
  max-height: 0;
}
.fade-enter-to, .fade-leave-from {
  opacity: 1;
  max-height: 500px;
}

.expand-all-btn-wrapper {
  display: flex;
  justify-content: center;
  margin-bottom: 24px;
}
.expand-all-btn {
  font-size: 1.1em;
  padding: 10px 36px;
  background: linear-gradient(90deg, #409EFF 0%, #66b1ff 100%);
  color: #fff;
  border: none;
  border-radius: 25px; /* Added border-radius */
  box-shadow: 0 4px 16px rgba(64,158,255,0.25); /* Adjusted box-shadow */
  transition: background 0.3s, box-shadow 0.3s;
  display: flex;
  align-items: center;
  justify-content: center;
}
.expand-all-btn:hover {
  background: linear-gradient(90deg, #66b1ff 0%, #409EFF 100%);
  box-shadow: 0 8px 24px rgba(64,158,255,0.35); /* Adjusted box-shadow on hover */
}
.pest-card-hoverable:hover {
  box-shadow: 0 0 0 2px #409EFF;
}
.expand-toggle-container {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 20px;
  gap: 20px; 
}

.expand-toggle-btn {
  font-size: 16px;
  padding: 10px 20px;
}

.discomfort-alert {
  max-width: 300px; /* Limit width for better appearance */
}
.pest-card .pest-name {
  font-size: 1.2em; /* 稍微增大字体 */
  font-weight: bold; /* 加粗字体 */
  color: #333;
  margin-top: 10px;
  margin-bottom: 5px;
}
.pest-info {
  padding: 0 15px 15px;
  font-size: 0.9em;
  color: #666;
}

.pest-info p {
  margin-bottom: 5px;
}

.pest-info strong {
  color: #333;
}

.pest-detail-expand {
  padding: 15px;
  background-color: #f9f9f9;
  border-top: 1px solid #eee;
  margin-top: 10px;
}

.pest-detail-expand p {
  margin-bottom: 8px;
  line-height: 1.5;
}

.pest-detail-expand strong {
  color: #333;
}

.pest-detail-expand .el-button {
  margin-top: 10px;
}

.expand-toggle-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.discomfort-alert {
  flex-grow: 1;
  margin-right: 20px;
}

.expand-toggle-btn {
  white-space: nowrap;
}

/* 过渡动画 */
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.5s ease;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .welcome-section {
    flex-direction: column;
    text-align: center;
  }

  .welcome-image {
    margin-top: 30px;
  }

  .features {
    flex-direction: column;
  }

  .feature {
    margin-bottom: 30px;
  }

  .pest-list {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 480px) {
  .welcome-content h1 {
    font-size: 2em;
  }

  .welcome-content .subtitle {
    font-size: 1em;
  }

  .btn {
    padding: 8px 15px;
    font-size: 0.9em;
  }

  .features h2, .common-pests-section h2, .guide-section h2 {
    font-size: 1.8em;
  }

  .pest-card {
    width: 100%;
  }
}
</style>
