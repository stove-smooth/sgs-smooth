const utils = {
  namespaced: true,
  state: {
    clientX: 0,
    clientY: 0,
  },
  mutations: {
    setClientX(state, clientX) {
      state.clientX = clientX;
    },
    setClientY(state, clientY) {
      state.clientY = clientY;
    },
  },
};

export default utils;
