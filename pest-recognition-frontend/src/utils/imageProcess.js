/**
 * 图片处理工具函数
 */

/**
 * 将File对象转换为Base64字符串
 * @param {File} file - 文件对象
 * @returns {Promise<string>} - 返回Base64字符串
 */
export function fileToBase64(file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = () => resolve(reader.result);
    reader.onerror = error => reject(error);
  });
}

/**
 * 压缩图片
 * @param {File} file - 图片文件
 * @param {Object} options - 压缩选项
 * @param {Number} options.maxWidth - 最大宽度
 * @param {Number} options.maxHeight - 最大高度
 * @param {Number} options.quality - 图片质量(0-1)
 * @returns {Promise<Blob>} - 返回压缩后的图片Blob对象
 */
export function compressImage(file, options = {}) {
  const { maxWidth = 1024, maxHeight = 1024, quality = 0.8 } = options;
  
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = (event) => {
      const img = new Image();
      img.src = event.target.result;
      
      img.onload = () => {
        // 计算缩放比例
        let width = img.width;
        let height = img.height;
        
        if (width > maxWidth) {
          height = Math.round((height * maxWidth) / width);
          width = maxWidth;
        }
        
        if (height > maxHeight) {
          width = Math.round((width * maxHeight) / height);
          height = maxHeight;
        }
        
        // 创建Canvas并绘制图片
        const canvas = document.createElement('canvas');
        canvas.width = width;
        canvas.height = height;
        
        const ctx = canvas.getContext('2d');
        ctx.drawImage(img, 0, 0, width, height);
        
        // 转换为Blob
        canvas.toBlob(
          (blob) => {
            if (blob) {
              resolve(blob);
            } else {
              reject(new Error('图片压缩失败'));
            }
          },
          file.type,
          quality
        );
      };
      
      img.onerror = () => {
        reject(new Error('图片加载失败'));
      };
    };
    
    reader.onerror = () => {
      reject(new Error('文件读取失败'));
    };
  });
}

/**
 * 验证图片类型
 * @param {File} file - 图片文件
 * @param {Array<string>} acceptTypes - 接受的图片类型数组，例如 ['image/jpeg', 'image/png']
 * @returns {boolean} - 返回是否为有效的图片类型
 */
export function validateImageType(file, acceptTypes = ['image/jpeg', 'image/png', 'image/gif']) {
  return acceptTypes.includes(file.type);
}

/**
 * 验证图片大小
 * @param {File} file - 图片文件
 * @param {Number} maxSize - 最大文件大小(MB)
 * @returns {boolean} - 返回是否为有效的图片大小
 */
export function validateImageSize(file, maxSize = 5) {
  // 转换为MB
  const fileSizeMB = file.size / (1024 * 1024);
  return fileSizeMB <= maxSize;
}

/**
 * 获取图片的尺寸信息
 * @param {File} file - 图片文件
 * @returns {Promise<{width: number, height: number}>} - 返回图片的宽高信息
 */
export function getImageDimensions(file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = (event) => {
      const img = new Image();
      img.src = event.target.result;
      
      img.onload = () => {
        resolve({
          width: img.width,
          height: img.height
        });
      };
      
      img.onerror = () => {
        reject(new Error('图片加载失败'));
      };
    };
    
    reader.onerror = () => {
      reject(new Error('文件读取失败'));
    };
  });
}

/**
 * 创建图片缩略图
 * @param {File} file - 图片文件
 * @param {Number} width - 缩略图宽度
 * @param {Number} height - 缩略图高度
 * @returns {Promise<string>} - 返回缩略图的Base64字符串
 */
export function createThumbnail(file, width = 200, height = 200) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = (event) => {
      const img = new Image();
      img.src = event.target.result;
      
      img.onload = () => {
        // 计算缩放比例，保持宽高比
        let targetWidth = width;
        let targetHeight = height;
        const ratio = img.width / img.height;
        
        if (ratio > 1) {
          // 宽图
          targetHeight = width / ratio;
        } else {
          // 高图
          targetWidth = height * ratio;
        }
        
        // 创建Canvas并绘制图片
        const canvas = document.createElement('canvas');
        canvas.width = targetWidth;
        canvas.height = targetHeight;
        
        const ctx = canvas.getContext('2d');
        ctx.drawImage(img, 0, 0, targetWidth, targetHeight);
        
        // 转换为Base64
        const dataURL = canvas.toDataURL(file.type);
        resolve(dataURL);
      };
      
      img.onerror = () => {
        reject(new Error('图片加载失败'));
      };
    };
    
    reader.onerror = () => {
      reject(new Error('文件读取失败'));
    };
  });
}