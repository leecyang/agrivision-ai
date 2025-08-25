<template>
  <div class="about">
    <h2>关于害虫识别系统</h2>
    <div class="about-content">
      <section class="section">
        <h3>系统介绍</h3>
        <p>害虫识别系统是一个基于深度学习的图像识别应用，旨在帮助农业工作者和研究人员快速识别常见农业害虫，提供害虫信息和防治建议。</p>
      </section>
      
      <section class="section">
        <h3>功能特点</h3>
        <ul>
          <li>快速准确的害虫图像识别</li>
          <li>详细的害虫信息和防治方法</li>
          <li>历史识别记录查询</li>
          <li>用户友好的界面设计</li>
        </ul>
      </section>
      
      <section class="section">
        <h3>常见害虫</h3>
        <div class="pest-list">
          <div v-for="(pest, index) in commonPests" :key="index" class="pest-item">
            <h4>{{ pest.name }}</h4>
            <p>{{ pest.description }}</p>
          </div>
        </div>
      </section>
      
      <section class="section">
        <h3>联系我们</h3>
        <p>如有任何问题或建议，请联系我们：</p>
        <p>邮箱：3439550021@qq.com 李承阳</p>
      </section>
    </div>
  </div>
</template>

<script>
export default {
  name: 'AboutPage',
  data() {
    return {
      commonPests: [
        {
          name: '稻飞虱',
          description: '水稻主要害虫，通过吸食水稻汁液危害水稻，可传播病毒病。'
        },
        {
          name: '蚜虫',
          description: '常见农业害虫，危害多种作物，可传播植物病毒病。'
        },
        {
          name: '粘虫',
          description: '主要危害禾本科作物，幼虫食量大，繁殖快，危害严重。'
        }
      ]
    }
  }
}
</script>

<style scoped>
.about {
  padding: 20px;
}

.about-content {
  margin-top: 20px;
}

.section {
  margin-bottom: 30px;
}

.section h3 {
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 1px solid #ebeef5;
}

ul {
  padding-left: 20px;
}

li {
  margin-bottom: 8px;
}

.pest-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
  margin-top: 15px;
}

.pest-item {
  padding: 15px;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.pest-item h4 {
  margin-bottom: 10px;
}
</style>