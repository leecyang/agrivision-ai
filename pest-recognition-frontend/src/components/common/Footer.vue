<template>
  <footer class="app-footer">
    <div class="container">
      <div class="footer-content">
        <div class="footer-logo">
          <img v-if="logoUrl" :src="logoUrl" alt="害虫识别系统" class="logo-image">
          <span v-else class="logo-text">害虫识别系统</span>
          <p class="slogan">快速、准确地识别农作物害虫</p>
        </div>
        
        <div class="footer-links">
          <div class="link-group">
            <h4>快速链接</h4>
            <ul>
              <li><router-link to="/">首页</router-link></li>
              <li><router-link to="/recognition">识别</router-link></li>
              <li><router-link to="/history">历史记录</router-link></li>
              <li><router-link to="/about">关于</router-link></li>
            </ul>
          </div>
          
          <div class="link-group">
            <h4>帮助</h4>
            <ul>
              <li><a href="javascript:void(0)">使用指南</a></li>
              <li><a href="javascript:void(0)">常见问题</a></li>
              <li><a href="javascript:void(0)">联系我们</a></li>
            </ul>
          </div>
        </div>
      </div>
      
      <div class="footer-bottom">
        <p>李承阳2025 害虫识别系统 - 版权所有</p>
      </div>
    </div>
  </footer>
</template>

<script>
export default {
  name: 'AppFooter',
  data() {
    return {
      logoUrl: require('@/assets/logo.svg')
    }
  },
  computed: {
    currentYear() {
      return new Date().getFullYear();
    }
  }
}
</script>

<style scoped>
.app-footer {
  background-color: #f5f7fa;
  padding: 40px 0 20px;
  color: #606266;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 15px;
}

.footer-content {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  margin-bottom: 30px;
}

.footer-logo {
  flex: 1;
  min-width: 200px;
  margin-bottom: 20px;
}

.logo-image {
  height: 40px;
  width: auto;
  margin-bottom: 10px;
}

.logo-text {
  font-size: 1.5rem;
  font-weight: bold;
  color: #409EFF;
  display: block;
  margin-bottom: 10px;
}

.slogan {
  color: #909399;
  font-size: 14px;
}

.footer-links {
  display: flex;
  flex-wrap: wrap;
  gap: 40px;
}

.link-group {
  min-width: 120px;
}

.link-group h4 {
  font-size: 16px;
  margin-bottom: 15px;
  color: #303133;
}

.link-group ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.link-group li {
  margin-bottom: 8px;
}

.link-group a {
  color: #606266;
  text-decoration: none;
  transition: color 0.3s;
}

.link-group a:hover {
  color: #409EFF;
}

.footer-bottom {
  text-align: center;
  padding-top: 20px;
  border-top: 1px solid #e4e7ed;
  color: #909399;
  font-size: 14px;
}

@media (max-width: 768px) {
  .footer-content {
    flex-direction: column;
  }
  
  .footer-logo {
    text-align: center;
    margin-bottom: 30px;
  }
  
  .footer-links {
    justify-content: space-around;
  }
}
</style>