<template>
  <div class="image-uploader">
    <el-upload
      class="uploader"
      drag
      action="#"
      :http-request="handleUpload"
      :show-file-list="false"
      :before-upload="beforeUpload"
      :on-change="handleChange"
    >
      <el-icon v-if="!imageUrl && !loading"><Upload /></el-icon>
      <div v-if="!imageUrl && !loading" class="el-upload__text">
        拖拽图片到此处，或 <em>点击上传</em>
      </div>
      <div v-if="loading" class="loading-container">
        <el-progress type="circle" :percentage="uploadProgress"></el-progress>
        <div class="loading-text">正在上传...</div>
      </div>
      <img v-if="imageUrl && !loading" :src="imageUrl" class="preview-image" />
    </el-upload>
    
    <div class="upload-tips">
      <p>支持JPG、PNG格式，最大5MB</p>
    </div>
    
    <div v-if="imageUrl && !loading" class="upload-actions">
      <el-button type="primary" @click="$emit('submit', imageFile)">开始识别</el-button>
      <el-button @click="resetUpload">重新上传</el-button>
    </div>
  </div>
</template>

<script>
import { Upload } from '@element-plus/icons-vue';

export default {
  name: 'ImageUploader',
  components: {
    Upload
  },
  data() {
    return {
      imageUrl: '',
      imageFile: null,
      loading: false,
      uploadProgress: 0
    }
  },
  methods: {
    beforeUpload(file) {
      const isImage = file.type === 'image/jpeg' || file.type === 'image/png';
      const isLt5M = file.size / 1024 / 1024 < 5;

      if (!isImage) {
        this.$message.error('只能上传JPG或PNG格式的图片!');
      }
      if (!isLt5M) {
        this.$message.error('图片大小不能超过5MB!');
      }
      
      return isImage && isLt5M;
    },
    handleChange(file) {
      this.imageFile = file.raw;
      this.imageUrl = URL.createObjectURL(file.raw);
    },
    handleUpload() {
      this.loading = true;
      
      // 模拟上传进度
      const timer = setInterval(() => {
        if (this.uploadProgress < 99) {
          this.uploadProgress += 10;
        } else {
          clearInterval(timer);
          this.uploadProgress = 100;
          this.loading = false;
        }
      }, 100);
      
      // 实际项目中，这里不需要真正上传，而是在点击"开始识别"时才发送到后端
    },
    resetUpload() {
      this.imageUrl = '';
      this.imageFile = null;
      this.uploadProgress = 0;
    }
  }
}
</script>

<style scoped lang="scss">
.image-uploader {
  width: 100%;
  max-width: 500px;
  margin: 0 auto;
  
  .uploader {
    width: 100%;
    
    .el-upload {
      width: 100%;
      
      .el-upload-dragger {
        width: 100%;
        height: 300px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
      }
    }
  }
  
  .preview-image {
    width: 100%;
    max-height: 300px;
    object-fit: contain;
  }
  
  .loading-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    
    .loading-text {
      margin-top: 15px;
      color: #909399;
    }
  }
  
  .upload-tips {
    margin-top: 10px;
    color: #909399;
    font-size: 12px;
    text-align: center;
  }
  
  .upload-actions {
    margin-top: 20px;
    display: flex;
    justify-content: center;
    gap: 10px;
  }
}
</style>