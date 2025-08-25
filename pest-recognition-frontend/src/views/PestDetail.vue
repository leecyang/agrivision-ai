<template>
  <div class="pest-detail-container">
    <div v-if="loading" class="loading-container">
      <el-skeleton :rows="10" animated />
    </div>
    
    <div v-else-if="error" class="error-container">
      <el-result
        icon="error"
        title="加载失败"
        :sub-title="error"
      >
        <template v-slot:extra>
          <el-button type="primary" @click="fetchPestDetail">重试</el-button>
          <el-button @click="$router.push('/home')">返回首页</el-button>
        </template>
      </el-result>
    </div>
    
    <div v-else-if="pestDetail" class="pest-detail-content">
      <!-- 返回按钮 -->
      <div class="back-link">
        <el-button @click="$router.back()" link>
          <el-icon><ArrowLeft /></el-icon>返回
        </el-button>
      </div>
      
      <!-- 害虫基本信息 -->
      <div class="pest-header">
        <div class="pest-image">
          <img :src="pestDetail.imageUrl" :alt="pestDetail.name" />
        </div>
        <div class="pest-basic-info">
          <h1>{{ pestDetail.nameZh }}</h1>
          <div class="pest-meta">
            <span class="pest-category">{{ pestDetail.category }}</span>
            <span 
              class="pest-danger-level" 
              :class="'danger-level-' + pestDetail.harmLevel"
            >
              危害等级: {{ getDangerLevelText(pestDetail.harmLevel) }}
            </span>
          </div>
          <div class="pest-taxonomy">
            <p><strong>科属：</strong>{{ pestDetail.family }}</p>
            <p><strong>分布：</strong>{{ pestDetail.distribution }}</p>
            <p><strong>寄主：</strong>{{ pestDetail.host }}</p>
          </div>
          <div class="pest-description">
            <p>{{ pestDetail.description }}</p>
          </div>
        </div>
      </div>
      
      <!-- 害虫详细信息 -->
      <div class="pest-details">
        <el-tabs type="border-card">
          <el-tab-pane label="形态特征">
            <div class="tab-content">
              <h3>形态特征</h3>
              <div v-html="pestDetail.morphology"></div>
            </div>
          </el-tab-pane>
          
          <el-tab-pane label="生活习性">
            <div class="tab-content">
              <h3>生活习性</h3>
              <div v-html="pestDetail.habits"></div>
            </div>
          </el-tab-pane>
          
          <el-tab-pane label="危害症状">
            <div class="tab-content">
              <h3>危害症状</h3>
              <div v-html="pestDetail.symptoms"></div>
              
              <div class="damage-images" v-if="pestDetail.damageImages && pestDetail.damageImages.length">
                <h4>危害图片</h4>
                <div class="image-gallery">
                  <div 
                    v-for="(image, index) in pestDetail.damageImages" 
                    :key="index"
                    class="gallery-item"
                    @click="showImagePreview(image)"
                  >
                    <img :src="image" :alt="`${pestDetail.name}危害图${index + 1}`" />
                  </div>
                </div>
              </div>
            </div>
          </el-tab-pane>
          
          <el-tab-pane label="防治方法">
            <div class="tab-content">
              <h3>防治方法</h3>
              <div v-html="pestDetail.preventionMethods"></div>
            </div>
          </el-tab-pane>
        </el-tabs>
      </div>
      
      <!-- 相关害虫 -->
      <div class="related-pests" v-if="relatedPests.length > 0">
        <h2>相关害虫</h2>
        <div class="related-pest-list">
          <div 
            v-for="pest in relatedPests" 
            :key="pest.id"
            class="related-pest-item"
            @click="goToPestDetail(pest.id)"
          >
            <div class="related-pest-image">
              <img :src="pest.imageUrl" :alt="pest.name" />
            </div>
            <div class="related-pest-info">
              <h3>{{ pest.name }}</h3>
              <p>{{ pest.shortDescription }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <div v-else class="empty-container">
      <el-empty description="未找到害虫信息">
        <el-button @click="$router.push('/home')">返回首页</el-button>
      </el-empty>
    </div>
    
    <!-- 图片预览 -->
    <el-dialog
      :visible="previewVisible" @update:visible="val => previewVisible = val"
      :append-to-body="true"
      width="80%"
      class="image-preview-dialog"
    >
      <img :src="previewImage" alt="预览图片" class="preview-image" />
    </el-dialog>
  </div>
</template>

<script>
import { ArrowLeft } from '@element-plus/icons-vue';
import { pestApi } from '@/services/api'; // 修改导入方式

export default {
  name: 'PestDetail',

  components: {
    ArrowLeft
  },

  data() {
    return {
      pestId: null,
      pestDetail: null,
      relatedPests: [],
      loading: true,
      error: null,
      previewVisible: false,
      previewImage: ''
    };
  },
  created() {
    this.pestId = this.$route.params.id;
    this.fetchPestDetail();
  },
  watch: {
    // 监听路由参数变化，以便在直接访问不同的害虫详情页时更新数据
    '$route.params.id': function(newId) {
      if (newId !== this.pestId) {
        this.pestId = newId;
        this.fetchPestDetail();
      }
    }
  },
  methods: {
    formatMarkdownList(text) {
      if (!text) return '';

      // 首先将所有换行符替换为统一的 \n
      let formattedText = text.replace(/\r\n|\r/g, '\n');

      // 匹配以 '- ' 开头的行，并将其转换为 <li> 标签
      // 使用 (?:\n(?!- ).*)* 来匹配多行列表项，直到遇到下一个列表项或文本结束
      formattedText = formattedText.replace(/^- (.+?)(?:\n(?!- ).*)*/gm, (match, p1) => {
        // 移除多余的换行符，并替换为 <br>，但保留列表项内部的换行
        const content = p1.replace(/\n/g, '<br>');
        return `<li>${content}</li>`;
      });

      // 如果存在 <li> 标签，则用 <ul> 包裹
      if (formattedText.includes('<li>')) {
        formattedText = `<ul>${formattedText}</ul>`;
      }

      // 将剩余的换行符转换为 <br>，这会处理非列表部分的换行
      formattedText = formattedText.replace(/\n/g, '<br>');

      return formattedText;
    },
    async fetchPestDetail() {
      this.loading = true;
      this.error = null;
      
      try {
        // 获取害虫详情
        const response = await pestApi.getPestInfo(this.pestId); // 修改调用方式
        this.pestDetail = response;
        // 处理多行文本，将 \n 替换为 <br>
        if (this.pestDetail.morphology) {
          this.pestDetail.morphology = this.formatMarkdownList(this.pestDetail.morphology);
        }
        if (this.pestDetail.habits) {
          this.pestDetail.habits = this.formatMarkdownList(this.pestDetail.habits);
        }
        if (this.pestDetail.symptoms) {
          this.pestDetail.symptoms = this.formatMarkdownList(this.pestDetail.symptoms);
        }
        if (this.pestDetail.preventionMethods) {
          this.pestDetail.preventionMethods = this.formatMarkdownList(this.pestDetail.preventionMethods);
        }
        
        // 获取相关害虫 (暂时注释掉，因为api.js中没有getRelatedPests方法)
        // if (this.pestDetail) {
        //   this.fetchRelatedPests();
        // }
      } catch (error) {
        console.error('获取害虫详情失败:', error);
        this.error = '获取害虫详情失败，请重试';
      } finally {
        this.loading = false;
      }
    },
    // async fetchRelatedPests() { // 暂时注释掉
    //   try {
    //     const response = await getRelatedPests(this.pestId);
    //     this.relatedPests = response || [];
    //   } catch (error) {
    //     console.error('获取相关害虫失败:', error);
    //     // 不显示错误，因为这是次要功能
    //     this.relatedPests = [];
    //   }
    // },
    // 根据危害等级返回文本描述
    getDangerLevelText(level) {
      switch (level) {
        case 1:
          return '轻微';
        case 2:
          return '中等';
        case 3:
          return '较高';
        case 4:
          return '严重';
        case 5:
          return '非常严重';
        default:
          return '未知';
      }
    },
    showImagePreview(image) {
      this.previewImage = image;
      this.previewVisible = true;
    }
  }
};
</script>

<style scoped lang="scss">
.pest-detail-container {
  max-width: 1200px;
  margin: 20px auto;
  padding: 20px;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.loading-container,
.error-container,
.empty-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 400px;
}

.back-link {
  margin-bottom: 20px;
}

.pest-header {
  display: flex;
  gap: 30px;
  margin-bottom: 30px;
  align-items: flex-start;

  @media (max-width: 768px) {
    flex-direction: column;
    align-items: center;
    text-align: center;
  }
}

.pest-image {
  flex-shrink: 0;
  width: 300px;
  height: 300px;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);

  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  @media (max-width: 768px) {
    width: 80%;
    height: auto;
  }
}

.pest-basic-info {
  flex-grow: 1;

  h1 {
    font-size: 2.5em;
    color: #333;
    margin-top: 0;
    margin-bottom: 10px;
  }
}

.pest-meta {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
  flex-wrap: wrap;
  gap: 15px;

  .pest-category {
    background-color: #e0f7fa;
    color: #00796b;
    padding: 5px 10px;
    border-radius: 4px;
    font-size: 0.9em;
  }

  .pest-danger-level {
    padding: 5px 10px;
    border-radius: 4px;
    font-size: 0.9em;
    color: #fff;
    font-weight: bold;

    &.danger-level-1 {
      background-color: #4CAF50; // Green
    }
    &.danger-level-2 {
      background-color: #FFC107; // Amber
    }
    &.danger-level-3 {
      background-color: #FF9800; // Orange
    }
    &.danger-level-4 {
      background-color: #FF5722; // Deep Orange
    }
    &.danger-level-5 {
      background-color: #F44336; // Red
    }
  }
}

.pest-taxonomy {
  margin-bottom: 20px;

  p {
    margin: 5px 0;
    color: #555;
  }
}

.pest-description {
  line-height: 1.8;
  color: #444;
  text-align: justify;
}

.pest-details {
  margin-bottom: 30px;

  .tab-content {
    padding: 20px;

    h3 {
      color: #333;
      margin-top: 0;
      margin-bottom: 15px;
      border-bottom: 2px solid #eee;
      padding-bottom: 10px;
    }

    div {
      line-height: 1.8;
      color: #444;

      // Markdown list styling
      ul {
        list-style-type: disc;
        padding-left: 20px;
        margin-top: 10px;
      }

      li {
        margin-bottom: 5px;
      }
    }
  }
}

.damage-images {
  margin-top: 30px;

  h4 {
    color: #333;
    margin-bottom: 15px;
  }

  .image-gallery {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
    gap: 15px;

    .gallery-item {
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      cursor: pointer;
      transition: transform 0.2s ease-in-out;

      &:hover {
        transform: translateY(-5px);
      }

      img {
        width: 100%;
        height: 150px;
        object-fit: cover;
      }
    }
  }
}

.related-pests {
  h2 {
    font-size: 1.8em;
    color: #333;
    margin-bottom: 20px;
    text-align: center;
  }

  .related-pest-list {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 20px;

    .related-pest-item {
      background-color: #f9f9f9;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      cursor: pointer;
      transition: transform 0.2s ease-in-out;

      &:hover {
        transform: translateY(-5px);
      }

      .related-pest-image {
        width: 100%;
        height: 180px;
        overflow: hidden;

        img {
          width: 100%;
          height: 100%;
          object-fit: cover;
        }
      }

      .related-pest-info {
        padding: 15px;

        h3 {
          font-size: 1.2em;
          color: #333;
          margin-top: 0;
          margin-bottom: 5px;
        }

        p {
          font-size: 0.9em;
          color: #666;
          line-height: 1.5;
          display: -webkit-box;
          -webkit-line-clamp: 3;
          -webkit-box-orient: vertical;
          overflow: hidden;
          text-overflow: ellipsis;
        }
      }
    }
  }
}

.image-preview-dialog {
  .preview-image {
    max-width: 100%;
    max-height: 80vh;
    display: block;
    margin: 0 auto;
  }
}
</style>