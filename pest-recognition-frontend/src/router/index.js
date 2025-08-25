import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import Recognition from '../views/Recognition.vue'
import History from '../views/History.vue'
import About from '../views/About.vue'
import PestDetail from '../views/PestDetail.vue' // 引入害虫详情页面

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/recognition',
    name: 'Recognition',
    component: Recognition
  },
  {
    path: '/history',
    name: 'History',
    component: History
  },
  {
    path: '/about',
    name: 'About',
    component: About
  },
  {
    path: '/pest/:id',
    name: 'PestDetail',
    component: PestDetail,
    props: true // 允许将路由参数作为组件的props传递
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router