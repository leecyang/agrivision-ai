import { recognitionService } from '@/services/recognition';

const state = () => ({
  records: [],
  pagination: {
    page: 1,
    size: 10,
    total: 0
  },
  loading: false,
  error: null
});

const mutations = {
  SET_HISTORY_RECORDS(state, records) {
    state.records = records;
  },
  SET_HISTORY_PAGINATION(state, pagination) {
    state.pagination = { ...state.pagination, ...pagination };
  },
  SET_LOADING(state, loading) {
    state.loading = loading;
  },
  SET_ERROR(state, error) {
    state.error = error;
  }
};

const actions = {
  async fetchHistory({ commit, state }) {
    commit('SET_LOADING', true);
    commit('SET_ERROR', null);
    try {
      const response = await recognitionService.getHistory(state.pagination.page, state.pagination.size);
      commit('SET_HISTORY_RECORDS', response.records || []);
      commit('SET_HISTORY_PAGINATION', { total: response.total || 0 });
      return response;
    } catch (error) {
      commit('SET_ERROR', error.message || '获取历史记录失败');
      console.error('获取历史记录失败:', error);
      throw error; // Re-throw to allow component to catch if needed
    } finally {
      commit('SET_LOADING', false);
    }
  },
  
  // Action to update pagination and fetch history
  updatePaginationAndFetch({ commit, dispatch }, pagination) {
    commit('SET_HISTORY_PAGINATION', pagination);
    dispatch('fetchHistory');
  }
};

const getters = {
  // Add any necessary getters here
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
};