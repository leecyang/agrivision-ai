<template>
  <header class="app-header">
    <div class="container">
      <div class="logo">
        <router-link to="/">
          <img v-if="logoUrl" :src="logoUrl" alt="害虫识别系统" class="logo-image">
          <span v-else class="logo-text">害虫识别系统</span>
        </router-link>
      </div>
      <nav class="nav-menu">
        <router-link to="/" class="nav-item" exact>首页</router-link>
        <router-link to="/recognition" class="nav-item">识别</router-link>
        <router-link to="/history" class="nav-item">历史记录</router-link>
        <router-link to="/about" class="nav-item">关于</router-link>
      </nav>
    </div>
  </header>
</template>

<script>
export default {
  name: 'AppHeader',
  data() {
    return {
      logoUrl: require('@/assets/logo.svg')
    }
  }
}
</script>

<style scoped>
.app-header {
  background-color: #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 15px 0;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 15px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.logo a {
  display: flex;
  align-items: center;
  text-decoration: none;
}

.logo-image {
  height: 40px;
  width: auto;
}

.logo-text {
  font-size: 1.5rem;
  font-weight: bold;
  color: #409EFF;
}

.nav-menu {
  display: flex;
  gap: 20px;
}

.nav-item {
  color: #606266;
  text-decoration: none;
  padding: 5px 0;
  position: relative;
  transition: color 0.3s;
}

.nav-item:hover, .nav-item.router-link-active {
  color: #409EFF;
}

.nav-item.router-link-active:after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 2px;
  background-color: #409EFF;
}

@media (max-width: 768px) {
  .container {
    flex-direction: column;
    gap: 15px;
  }
  
  .nav-menu {
    width: 100%;
    justify-content: space-around;
  }
}
</style>