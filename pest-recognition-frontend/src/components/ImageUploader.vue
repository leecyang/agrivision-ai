<template>
  <div class="image-uploader">
    <div 
      class="upload-area"
      :class="{ 'is-dragover': isDragover }"
      @dragover.prevent="onDragover"
      @dragleave.prevent="onDragleave"
      @drop.prevent="onDrop"
    >
      <input 
        type="file" 
        ref="fileInput" 
        class="file-input" 
        accept="image/*"
        @change="onFileChange"
      />
      <div v-if="!imageUrl" class="upload-placeholder">
        <i class="el-icon-upload"></i>
        <div class="upload-text">拖拽图片到此处或点击上传</div>
        <button class="select-btn" @click="triggerFileInput">选择图片</button>
      </div>
      <div v-else class="image-preview">
        <img :src="imageUrl" alt="预览图" />
        <div class="preview-actions">
          <button class="action-btn" @click="removeImage">重新选择</button>
          <button class="action-btn primary" @click="$emit('submit', imageFile)">开始识别</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ImageUploader',
  data() {
    return {
      imageUrl: '',
      imageFile: null,
      isDragover: false
    }
  },
  methods: {
    triggerFileInput() {
      this.$refs.fileInput.click();
    },
    onFileChange(e) {
      const file = e.target.files[0];
      if (!file) return;
      
      this.processFile(file);
    },
    onDragover(e) {
      this.isDragover = true;
    },
    onDragleave(e) {
      this.isDragover = false;
    },
    onDrop(e) {
      this.isDragover = false;
      const file = e.dataTransfer.files[0];
      if (!file) return;
      
      this.processFile(file);
    },
    processFile(file) {
      // 检查文件类型
      if (!file.type.match('image.*')) {
        this.$emit('error', '请上传图片文件');
        return;
      }
      
      // 检查文件大小（限制为5MB）
      if (file.size > 5 * 1024 * 1024) {
        this.$emit('error', '图片大小不能超过5MB');
        return;
      }
      
      this.imageFile = file;
      this.imageUrl = URL.createObjectURL(file);
      this.$emit('change', file);
    },
    removeImage() {
      this.imageUrl = '';
      this.imageFile = null;
      this.$refs.fileInput.value = '';
      this.$emit('change', null);
    }
  }
}
</script>

<style scoped>
.image-uploader {
  width: 100%;
}

.upload-area {
  border: 2px dashed #dcdfe6;
  border-radius: 6px;
  padding: 20px;
  text-align: center;
  transition: all 0.3s;
}

.upload-area.is-dragover {
  border-color: #409EFF;
  background-color: rgba(64, 158, 255, 0.06);
}

.file-input {
  display: none;
}

.upload-placeholder {
  padding: 30px 0;
}

.upload-text {
  margin: 10px 0;
  color: #606266;
}

.select-btn {
  padding: 8px 20px;
  background-color: #409EFF;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  margin-top: 10px;
}

.image-preview {
  position: relative;
}

.image-preview img {
  max-width: 100%;
  max-height: 300px;
  border-radius: 4px;
}

.preview-actions {
  margin-top: 15px;
  display: flex;
  justify-content: center;
  gap: 10px;
}

.action-btn {
  padding: 6px 15px;
  background-color: #f4f4f5;
  color: #606266;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.action-btn.primary {
  background-color: #409EFF;
  color: white;
}
</style>