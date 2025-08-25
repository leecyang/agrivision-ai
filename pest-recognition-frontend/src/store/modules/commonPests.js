import { recognitionService } from '../../services/recognition'; // Adjust the path if necessary

const state = {
  commonPests: [],
  loading: false,
  error: null,
};

const mutations = {
  SET_COMMON_PESTS(state, pests) {
    state.commonPests = pests;
  },
  SET_LOADING(state, isLoading) {
    state.loading = isLoading;
  },
  SET_ERROR(state, error) {
    state.error = error;
  },
};

const actions = {
  async fetchCommonPests({ commit }) {
    console.log('recognitionService:', recognitionService);
    commit('SET_LOADING', true);
    commit('SET_ERROR', null);
    try {
      const response = await recognitionService.getCommonPests();
      if (response && Array.isArray(response)) {
        commit('SET_COMMON_PESTS', response);
      } else {
        console.error('API response for common pests is not an array:', response);
        commit('SET_COMMON_PESTS', []);
        commit('SET_ERROR', new Error('Invalid data received from server'));
      }
    } catch (error) {
      console.error('Error fetching common pests:', error);
      commit('SET_ERROR', error);
      commit('SET_COMMON_PESTS', []); // 确保在错误时返回空数组
      // 不再抛出错误，而是静默处理
    } finally {
      commit('SET_LOADING', false);
    }
  },
};

const getters = {
  // Optional: Add getters if needed, e.g., to filter or transform the list
  // getPestById: (state) => (id) => {
  //   return state.commonPests.find(pest => pest.id === id);
  // }
};

export default {
  namespaced: true, // Use namespaced module
  state,
  mutations,
  actions,
  getters,
};