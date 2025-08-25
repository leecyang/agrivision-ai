<template>
  <div class="history-container">
    <h1>识别历史记录</h1>
    
    <el-table
      :data="historyRecords"
      v-loading="loading"
      style="width: 100%"
      class="history-table"
    >
      <el-table-column
        label="图片"
        width="100"
      >
        <template v-slot:default="scope">
          <img :src="'http://localhost:8081' + scope.row.imageUrl" alt="害虫图片" class="record-image">
        </template>
      </el-table-column>
      <el-table-column
        prop="pestName"
        label="识别结果"
        width="180"
      >
      </el-table-column>
      <el-table-column
        prop="confidence"
        label="置信度"
        width="120"
      >
        <template v-slot:default="scope">
          {{ (scope.row.confidence * 100).toFixed(2) }}%
        </template>
      </el-table-column>
      <el-table-column
        prop="recognitionTime"
        label="识别时间"
      >
        <template v-slot:default="scope">
          {{ formatDate(scope.row.recognitionTime) }}
        </template>
      </el-table-column>
      <el-table-column
        label="操作"
        width="100"
      >
        <template v-slot:default="scope">
          <el-button @click="viewDetails(scope.row.pestId)" type="text" size="small">查看详情</el-button>
        </template>
      </el-table-column>
    </el-table>
    
    <el-pagination
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
      :current-page="pagination.page"
      :page-sizes="[10, 20, 50, 100]"
      :page-size="pagination.size"
      layout="total, sizes, prev, pager, next, jumper"
      :total="pagination.total"
      class="pagination"
    >
    </el-pagination>
  </div>
</template>

<script>
import { mapState, mapActions } from 'vuex';

export default {
  name: 'RecognitionHistory',
  data() {
    return {
      loading: false
    };
  },
  computed: {
    ...mapState('history', { // 假设历史记录模块在store中命名为'history'
      historyRecords: state => state.records,
      pagination: state => state.pagination
    })
  },
  created() {
    this.fetchHistoryRecords();
  },
  methods: {
    ...mapActions('history', ['fetchHistory']),
    
    async fetchHistoryRecords() {
      this.loading = true;
      try {
        await this.fetchHistory();
      } catch (error) {
        this.$message.error('获取历史记录失败');
      } finally {
        this.loading = false;
      }
    },
    
    handleSizeChange(newSize) {
      // 更新store中的分页大小并重新获取数据
      this.$store.commit('history/SET_HISTORY_PAGINATION', { size: newSize });
      this.fetchHistoryRecords();
    },
    
    handleCurrentChange(newPage) {
      // 更新store中的当前页码并重新获取数据
      this.$store.commit('history/SET_HISTORY_PAGINATION', { page: newPage });
      this.fetchHistoryRecords();
    },
    
    viewDetails(pestId) {
      // 跳转到害虫详情页面
      this.$router.push({ name: 'PestDetail', params: { id: pestId } });
    },
    
    formatDate(timestamp) {
      if (!timestamp) return '';
      const date = new Date(timestamp);
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0');
      const day = String(date.getDate()).padStart(2, '0');
      const hours = String(date.getHours()).padStart(2, '0');
      const minutes = String(date.getMinutes()).padStart(2, '0');
      const seconds = String(date.getSeconds()).padStart(2, '0');
      return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    }
  }
};
</script>

<style scoped lang="scss">
.history-container {
  padding: 20px;
  
  h1 {
    text-align: center;
    margin-bottom: 30px;
    color: #303133;
  }
  
  .history-table {
    margin-bottom: 20px;
    
    .record-image {
      width: 80px;
      height: 80px;
      object-fit: cover;
      border-radius: 4px;
    }
  }
  
  .pagination {
    text-align: center;
  }
}
</style>