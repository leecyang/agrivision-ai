const { defineConfig } = require('@vue/cli-service')
const webpack = require('webpack');
module.exports = defineConfig({
  transpileDependencies: true,
  
  // 部署应用包时的基本URL
  publicPath: process.env.NODE_ENV === 'production' ? '/' : '/',
  
  // 输出文件目录
  outputDir: 'dist',
  
  // 静态资源目录
  assetsDir: 'static',
  
  // 生产环境是否生成 sourceMap 文件
  productionSourceMap: false,
  
  // 开发服务器配置
  devServer: {
    // 端口号
    port: 8080, // 将前端开发服务器端口改为 8080
    
    // 配置代理，解决开发环境下的跨域问题
    proxy: {
      '/api': {
        target: 'http://localhost:8081', // 将代理目标端口修改为后端服务运行的端口
        changeOrigin: true,
        pathRewrite: { '^/api': '/api' }
      }
    }
  },
  
  // CSS相关配置
  css: {
    // 是否使用css分离插件 ExtractTextPlugin
    extract: process.env.NODE_ENV === 'production',
    // 开启 CSS source maps?
    sourceMap: false
  },
  
  // 配置webpack
  configureWebpack: {
    // 性能提示
    performance: {
      hints: false
    },
    // 优化配置
    optimization: {
      splitChunks: {
        chunks: 'all'
      }
    },
    plugins: [
      new webpack.DefinePlugin({
        __VUE_PROD_HYDRATION_MISMATCH_DETAILS__: JSON.stringify(false)
      })
    ]
  }
})
