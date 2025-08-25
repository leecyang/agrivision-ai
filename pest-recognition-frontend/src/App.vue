<template>
  <div id="app">
    <header class="app-header">
      <div class="container">
        <div class="logo">
          <router-link to="/">害虫识别系统</router-link>
        </div>
        <nav class="nav-menu">
          <router-link to="/" class="nav-item">首页</router-link>
          <router-link to="/recognition" class="nav-item">识别</router-link>
          <router-link to="/history" class="nav-item">历史记录</router-link>
          <router-link to="/about" class="nav-item">关于</router-link>
        </nav>
      </div>
    </header>
    
    <main class="app-content">
      <div class="container">
        <router-view/>
      </div>
    </main>
    
    <footer class="app-footer">
      <div class="container">
        <p>&copy; 2025 害虫识别系统by@lcy - 版权所有</p>
      </div>
    </footer>
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>

<style>
@import './assets/css/main.css';

#app {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.app-header {
  background-color: #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 15px 0;
}

.app-header .container {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.logo a {
  font-size: 1.5rem;
  font-weight: bold;
  color: #409EFF;
  text-decoration: none;
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

.app-content {
  flex: 1;
  padding: 30px 0;
}

.app-footer {
  background-color: #f5f7fa;
  padding: 20px 0;
  text-align: center;
  color: #909399;
}

@media (max-width: 768px) {
  .app-header .container {
    flex-direction: column;
    gap: 15px;
  }
  
  .nav-menu {
    width: 100%;
    justify-content: space-around;
  }
}
</style>
